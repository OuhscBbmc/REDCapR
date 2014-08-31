
populate_project_simple <- function( ) {
  #Declare the server & user information
  uri <- "https://bbmc.ouhsc.edu/redcap/api/"
  token <- "D70F9ACD1EDD6F151C6EA78683944E98" #For `UnitTestPhiFree` account and the simple project (pid 213)
  path_in_simple <- "./inst/tests/simple.csv"
  
  #Write the file to disk (necessary only when you wanted to change the data).  Don't uncomment; just run manually.
  # returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw")
  # write.csv(returned_object$data, file=path_in_simple, row.names=FALSE)
  
  #Read in the data in R's memory from a csv file.
  dsToWrite <- read.csv(file=path_in_simple, stringsAsFactors=FALSE)
  
  #Remove the calculated variables.
  dsToWrite$age <- NULL
  dsToWrite$bmi <- NULL
  
  #Import the data into the REDCap project
  expect_message(
    returned_object <- REDCapR:::redcap_write_oneshot(ds=dsToWrite, redcap_uri=uri, token=token, verbose=T)
  )
  
  #Print a message and return a boolean value
  message(sprintf("populate_project_simple success: %s.", returned_object$success))
  return( returned_object$success )
}
clear_project_simple <- function( ) {
  pathDeleteTestRecord <- "https://bbmc.ouhsc.edu/redcap/plugins/redcapr/delete_redcapr_simple.php"
  # httr::url_ok(pathDeleteTestRecord)
  
  #Returns a boolean value if successful
  (was_successful <- httr::url_success(pathDeleteTestRecord))
  
  #Print a message and return a boolean value
  message(sprintf("clear_project_simple success: %s.", was_successful))
  return( was_successful )
}

populate_project_simple()
# clear_project_simple()
