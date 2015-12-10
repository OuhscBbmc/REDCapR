library(testthat)

###########
context("Estimate 'Could Not Connect' Rate")
###########
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
# uri <- "https://bbmc.ouhsc.edu/redcap/api/api2.php"
# uri <- "https://bbmc.ouhsc.edu/redcap/api/dx.php"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `UnitTestPhiFree` account on pid=153.

record_read_count <- 2000L
record_write_count <- 200L
file_read_count <- 200L
file_write_count <- 20L

# Record Read ---------------------------------------------------
message("\n========\nRecord Read")

record_read_error_count <- 0L
for( i in seq_len(record_read_count) ) {
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, verbose=FALSE)
  message(i, ": ", returned_object$elapsed_seconds, " -", returned_object$raw_text)
  
  if( any(grepl(pattern="combination could not connect to the MySQL server", returned_object$raw_text)) )
    record_read_error_count <- record_read_error_count + 1L
}
message("Record read error rate: ", record_read_error_count/record_read_count)
rm(i, returned_object, record_read_count, record_read_error_count)

# File Read ---------------------------------------------------
message("\n========\nFile Read")
if( file_read_count > 0 )
  start_clean_result <- REDCapR:::clean_start_simple(batch=FALSE)

file_read_error_count <- 0L
for( i in seq_len(file_read_count) ) {
  
  tryCatch({
    returned_object <- redcap_download_file_oneshot(record=1L, field="mugshot", verbose = FALSE,
                                                    redcap_uri=start_clean_result$redcap_project$redcap_uri, token=start_clean_result$redcap_project$token)
    
    expect_true(file.exists(returned_object$file_name), "The downloaded file should exist.")
    }, finally = base::unlink("mugshot-1.jpg")
  )
  
  message(i, ": ", returned_object$elapsed_seconds, " -", returned_object$raw_text)
  
  if( any(grepl(pattern="combination could not connect to the MySQL server", returned_object$raw_text)) )
    file_read_error_count <- file_read_error_count + 1L
}
message("File read error rate: ", file_read_error_count/file_read_count)
rm(i, returned_object, file_read_count, file_read_error_count)
