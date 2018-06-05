# These functions are not exported.

populate_project_simple <- function( batch = FALSE ) {
  checkmate::assert_logical(batch, any.missing=F, len=1)

  if( !requireNamespace("testthat") ) stop("The function REDCapR:::populate_project_simple() cannot run if the `testthat` package is not installed.  Please install it and try again.")

  #Declare the server & user information
  # uri <- "https://www.redcapplugins.org/api/"
  uri <- "https://bbmc.ouhsc.edu/redcap/api/"

  # token <- "D96029BFCE8FFE76737BFC33C2BCC72E" #For `UnitTestPhiFree` account and the simple project (pid 27) on Vandy's test server.
  # token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `UnitTestPhiFree` account and the simple project (pid 153)
  token <- "D70F9ACD1EDD6F151C6EA78683944E98" #For `UnitTestPhiFree` account and the simple project (pid 213)

  project <- REDCapR::redcap_project$new(redcap_uri=uri, token=token)
  path_in_simple <- system.file("test-data/project-simple/simple-data.csv", package="REDCapR")

  # Write the file to disk (necessary only when you wanted to change the data).  Don't uncomment; just run manually.
  # returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw")
  # utils::write.csv(returned_object$data, file="./inst/test-data/project-simple/simple-data.csv", row.names=FALSE)
  # returned_object_metadata <- redcap_metadata_read(redcap_uri=uri, token=token)
  # utils::write.csv(returned_object_metadata$data, file="./inst/test-data/project-simple/simple-metadata.csv", row.names=FALSE)

  #Read in the data in R's memory from a csv file.
  dsToWrite <- readr::read_csv(path_in_simple)
  # dsToWrite <- utils::read.csv(file="./inst/test-data/project-simple/simple-data.csv", stringsAsFactors=FALSE)

  #Remove the calculated variables.
  dsToWrite$age <- NULL
  dsToWrite$bmi <- NULL

  # Import the data into the REDCap project
  testthat::expect_message(
    returned_object <- if( batch ) {
      REDCapR::redcap_write(        ds=dsToWrite, redcap_uri=uri, token=token, verbose=TRUE)
    } else {
      REDCapR::redcap_write_oneshot(ds=dsToWrite, redcap_uri=uri, token=token, verbose=TRUE)
    }
  )
  # For internal inspection: REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token, verbose=TRUE)

  #If uploading the data was successful, then upload the image files.
  if( returned_object$success) {
    upload_file_simple(redcap_uri=uri, token=token)
  }

  #Print a message and return a boolean value
  base::message(base::sprintf("populate_project_simple success: %s.", returned_object$success))
  return( list(is_success=returned_object$success, redcap_project=project) )
}
clear_project_simple <- function( verbose = TRUE ) {
  if( !requireNamespace("testthat") ) stop("The function REDCapR:::populate_project_simple() cannot run if the `testthat` package is not installed.  Please install it and try again.")
  pathDeleteTestRecord <- "https://bbmc.ouhsc.edu/redcap/plugins/redcapr/delete_redcapr_simple.php"

  # httr::url_ok(pathDeleteTestRecord)

  #Returns a boolean value if successful
  (was_successful <- !httr::http_error(pathDeleteTestRecord))#, config=config_options))

  #Print a message and return a boolean value
  if( verbose )
    base::message(base::sprintf("clear_project_simple success: %s.", was_successful))
  return( was_successful )
}

clean_start_simple <- function( batch = FALSE, delay_in_seconds = 1 ) {
  checkmate::assert_logical( batch            , any.missing=F, len=1)
  checkmate::assert_numeric( delay_in_seconds , any.missing=F, len=1, lower=0)

  if( !requireNamespace("testthat") ) stop("The function REDCapR:::populate_project_simple() cannot run if the `testthat` package is not installed.  Please install it and try again.")
  testthat::expect_message(
    clear_result <- clear_project_simple(),
    regexp = "clear_project_simple success: TRUE."
  )
  testthat::expect_true(clear_result, "Clearing the results from the simple project should be successful.")
  base::Sys.sleep(delay_in_seconds) #Pause after deleting records.

  testthat::expect_message(
    populate_result <- populate_project_simple(batch=batch),
    regexp = "populate_project_simple success: TRUE."
  )
  testthat::expect_true(populate_result$is_success, "Population the the simple project should be successful.")
  base::Sys.sleep(delay_in_seconds) #Pause after writing records.

  return( populate_result )
}

upload_file_simple <- function( redcap_uri, token=token ) {
  checkmate::assert_character(redcap_uri, any.missing=F, len=1, min.chars = 5)
  checkmate::assert_character(token     , any.missing=F, len=1, pattern="^\\w{32}$")

  records <- 1:5
  file_paths <- system.file(paste0("test-data/mugshot-", records, ".jpg"), package="REDCapR")

  field <- "mugshot"
  event <- "" # only for longitudinal events

  token <- sanitize_token(token)

  for( i in seq_along(records) ) {
    record    <- records[i]
    file_path <- file_paths[i]
    redcap_upload_file_oneshot(file_name=file_path, record=record, field=field, redcap_uri=redcap_uri, token=token)
  }
}

# populate_project_simple()
# populate_project_simple(batch=TRUE)
# clear_project_simple()
# clean_start_simple()
# clean_start_simple(batch=TRUE)
