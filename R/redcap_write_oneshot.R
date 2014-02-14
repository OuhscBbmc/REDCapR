
redcap_write_oneshot <- function( ds, redcap_uri, token, verbose=TRUE, cert_location=NULL ) {
  #TODO: automatically convert boolean/logical class to integer/bit class
  start_time <- Sys.time()
  csvElements <- NULL #This prevents the R CHECK NOTE: 'No visible binding for global variable Note in R CMD check';  Also see  if( getRversion() >= "2.15.1" )    utils::globalVariables(names=c("csvElements")) #http://stackoverflow.com/questions/8096313/no-visible-binding-for-global-variable-note-in-r-cmd-check; http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
  
  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_write_oneshot()`.")
  
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_write_oneshot()`.")     
  
  if( missing( cert_location ) | is.null(cert_location) ) 
    cert_location <- file.path(devtools::inst("REDCapR"), "ssl_certs", "mozilla_2013_12_05.crt")
  #     curl_options <- RCurl::curlOptions(ssl.verifypeer = FALSE)
  
  if( !base::file.exists(cert_location) )
    stop(paste0("The file specified by `cert_location`, (", cert_location, ") could not be found."))
  
  curl_options <- RCurl::curlOptions(cainfo = cert_location)
  
  con <-  base::textConnection(object='csvElements', open='w', local=TRUE)
  write.csv(ds, con, row.names = FALSE, na="")  
  close(con)
  
  csv <- paste(csvElements, collapse="\n")
  rm(csvElements, con)
  
  returnContent <- RCurl::postForm(
    uri = redcap_uri, 
    token = token,
    content = 'record',
    format = 'csv', 
    type = 'flat', 
    returnContent = "ids",
    overwriteBehavior = 'overwrite', #overwriteBehavior: *normal* - blank/empty values will be ignored [default]; *overwrite* - blank/empty values are valid and will overwrite data
    data = csv,
    .opts = curl_options
  )
  elapsed_seconds <- as.numeric(difftime( Sys.time(), start_time,units="secs"))    
  
  isValidIDList <- grepl(pattern="^id\\n.{1,}", x=returnContent, perl=TRUE) #example: x="id\n5835\n5836\n5837\n5838\n5839"
  if( isValidIDList ) {
    elements <- unlist(strsplit(returnContent, split="\\n"))
    affectedIDs <- elements[-1]  
    recordsAffectedCount <- length(affectedIDs)
    status_message <- paste0(format(recordsAffectedCount, big.mark = ",", scientific = FALSE, trim = TRUE), " records were written to REDCap in ", round(elapsed_seconds, 2), " seconds.")
  } 
  else { #If the returned content wasn't recognized as valid IDs, then
    affectedIDs <- numeric() #Pass an empty array
    recordsAffectedCount <- NA
    status_message <- "The content returned during the write operation was not recognized.  Please see the `returnContent` element for more information." 
  }
  if( verbose ) 
    message(status_message)
  
  return( list(
    records_affected_count = recordsAffectedCount,
    affected_ids = affectedIDs,
    elapsed_seconds = elapsed_seconds, 
    status_message = status_message, 
    return_content = returnContent, 
    success = isValidIDList
  ))
}

# result <- redcap_read_oneshot(redcap_uri="https://bbmc.ouhsc.edu/redcap/api/", token = "9A81268476645C4E5F03428B8AC3AA7B")
# dput(result$data)
# dsToWrite <- structure(list(record_id = 1:5, first_name = c("Nutmeg", "Tumtum", 
#                                                             "Marcus", "Trudy", "John Lee"), last_name = c("Nutmouse", "Nutmouse", 
#                                                                                                           "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
#                                                                                                                                                 "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
#                                                                                                                                                 "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
#                                                                                                           ), telephone = c("(432) 456-4848", "(234) 234-2343", "(433) 435-9865", 
#                                                                                                                            "(987) 654-3210", "(333) 333-4444"), email = c("nutty@mouse.com", 
#                                                                                                                                                                           "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
#                                                                                                                            ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
#                                                                                                                                       "1955-04-15"), age = c(10L, 10L, 79L, 61L, 58L), ethnicity = c(1L, 
#                                                                                                                                                                                                      1L, 0L, 1L, 1L), race = c(2L, 6L, 4L, 4L, 4L), sex = c(0L, 1L, 
#                                                                                                                                                                                                                                                             1L, 0L, 1L), height = c(5, 6, 180, 165, 193.04), weight = c(1L, 
#                                                                                                                                                                                                                                                                                                                         1L, 80L, 54L, 104L), bmi = c(400, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
#                                                                                                                                                                                                                                                                                                                                                                                                  "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
#                                                                                                                                                                                                                                                                                                                                                                                                  "Had a hand for trouble and a eye for cash\nHe had a gold watch chain and a black mustache\n\nhttps://www.youtube.com/watch?v=DUESvITrvsI"
#                                                                                                                                                                                                                                                                                                                         ), demographics_complete = c(2L, 2L, 2L, 2L, 2L)), .Names = c("record_id", 
#                                                                                                                                                                                                                                                                                                                                                                                       "first_name", "last_name", "address", "telephone", "email", "dob", 
#                                                                                                                                                                                                                                                                                                                                                                                       "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
#                                                                                                                                                                                                                                                                                                                                                                                       "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, 
#                                                                                                                                                                                                                                                                                                                                                                                                                                                                 -5L))
# dsToWrite <- dsToWrite[1:3, ]
# result <- REDCapR:::redcap_write_oneshot(ds=dsToWrite, redcap_uri="https://bbmc.ouhsc.edu/redcap/api/", token = "9A81268476645C4E5F03428B8AC3AA7B")
# str(result$affected_ids)


