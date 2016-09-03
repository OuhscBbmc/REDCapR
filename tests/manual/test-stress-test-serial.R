library(testthat)

###########
context("Stress Test - Serial")
###########
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `UnitTestPhiFree` account on pid=153.

read_count <- 2000L
file_count <- 200L

# Read ---------------------------------------------------
message("\n========\nRead")
expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum", 
  "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse", 
  "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
  "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
  "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
  ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333", 
  "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com", 
  "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
  ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
  "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L, 
  1L, 1L, 0L, 1L), demographics_complete = c(2L, 2L, 2L, 2L, 2L
  ), height = c(7, 6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 
  54L, 104L), bmi = c(204.1, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
  "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
  "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
  ), mugshot = c("[document]", "[document]", "[document]", "[document]", 
  "[document]"), health_complete = c(1L, 0L, 2L, 2L, 0L), race___1 = c(0L, 
  0L, 0L, 0L, 1L), race___2 = c(0L, 0L, 0L, 1L, 0L), race___3 = c(0L, 
  1L, 0L, 0L, 0L), race___4 = c(0L, 0L, 1L, 0L, 0L), race___5 = c(1L, 
  1L, 1L, 1L, 0L), race___6 = c(0L, 0L, 0L, 0L, 1L), ethnicity = c(1L, 
  1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L, 0L, 2L, 2L, 
  2L)), .Names = c("record_id", "name_first", "name_last", "address", 
  "telephone", "email", "dob", "age", "sex", "demographics_complete", 
  "height", "weight", "bmi", "comments", "mugshot", "health_complete", 
  "race___1", "race___2", "race___3", "race___4", "race___5", 
  "race___6", "ethnicity", "race_and_ethnicity_complete"), class = "data.frame", row.names = c(NA, 
  -5L))

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

for( i in seq_len(read_count) ) {
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
    regexp = expected_outcome_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  message(i, ": ", returned_object$elapsed_seconds)
}



# File ---------------------------------------------------
message("\n========\nFile")
for( i in seq_len(file_count) ) {
  start_clean_result <- REDCapR:::clean_start_simple(batch=FALSE)
  project <- start_clean_result$redcap_project
  
  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
    
#   start_time <- Sys.time() - lubridate::seconds(1) #Knock off a second inc ase there's small time imprecisions
  start_time <- Sys.time() - 25 #Knock off a second in case there are small time imprecisions
  path_of_expected <- base::file.path(devtools::inst(name="REDCapR"), "test-data/mugshot-1.jpg")
  info_expected <- file.info(path_of_expected)
  record <- 1
  field <- "mugshot"
  
  expected_outcome_message <- 'image/jpeg; name="mugshot-1\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as mugshot-1.jpg'
  # image/jpeg; name="mugshot-1.jpg" successfully downloaded in 0.7 seconds, and saved as mugshot-1.jpg
  
  tryCatch({
    expect_message(
      returned_object <- redcap_download_file_oneshot(record=record, field=field, redcap_uri=start_clean_result$redcap_project$redcap_uri, token=start_clean_result$redcap_project$token),
      regexp = expected_outcome_message
    )
    info_actual <- file.info(returned_object$file_name)
    expect_true(file.exists(returned_object$file_name), "The downloaded file should exist.")
    }, finally = base::unlink("mugshot-1.jpg")
  )
  
  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 1L)
  expect_equal(returned_object$affected_ids, 1L)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")  
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, "mugshot-1.jpg", label="The name of the downloaded file should be correct.")
  
  #Test the values of the file.  
  expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  expect_equal(info_actual$mode, expected=info_expected$mode, label="The mode/permissions of the downloaded file should match.")
  expect_more_than(info_actual$mtime, expected=start_time, label="The downloaded file's modification time should not precede this function's start time.")
  expect_more_than(info_actual$ctime, expected=start_time, label="The downloaded file's last change time should not precede this function's start time.")
  expect_more_than(info_actual$atime, expected=start_time, label="The downloaded file's last access time should not precede this function's start time.")
  message(i, ": ", returned_object$elapsed_seconds)
}
