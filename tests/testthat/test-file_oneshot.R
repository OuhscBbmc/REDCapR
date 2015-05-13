library(testthat)
##
## Since the project data is wiped clean at the start of each function, 
## the upload & download calls are tested by one function.

###########
context("FileOneshot")
###########
# uri <- "https://bbmc.ouhsc.edu/redcap/api/"
# token <- "D70F9ACD1EDD6F151C6EA78683944E98" #For `UnitTestPhiFree` account on pid=213.

delay_after_download_file <- 1.0 #In seconds

test_that("NameComesFromREDCap", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=FALSE)
  project <- start_clean_result$redcap_project
  
  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
    
#   start_time <- Sys.time() - lubridate::seconds(1) #Knock off a second inc ase there's small time imprecisions
  start_time <- Sys.time() - 1 #Knock off a second in case there are small time imprecisions
  path_of_expected <- base::file.path(devtools::inst(name="REDCapR"), "test_data/mugshot_1.jpg")
  info_expected <- file.info(path_of_expected)
  record <- 1
  field <- "mugshot"
  
  expected_outcome_message <- 'image/jpeg; name="mugshot_1\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as mugshot_1.jpg'
  # image/jpeg; name="mugshot_1.jpg" successfully downloaded in 0.7 seconds, and saved as mugshot_1.jpg
  
  tryCatch({
    expect_message(
      returned_object <- redcap_download_file_oneshot(record=record, field=field, redcap_uri=start_clean_result$redcap_project$redcap_uri, token=start_clean_result$redcap_project$token),
      regexp = expected_outcome_message
    )
    Sys.sleep(delay_after_download_file)
    
    info_actual <- file.info(returned_object$file_name)
    expect_true(file.exists(returned_object$file_name), "The downloaded file should exist.")
    }, finally = base::unlink(returned_object$file_name)
  )
  
  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 1L)
  expect_equal(returned_object$affected_ids, 1L)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")  
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, "mugshot_1.jpg", label="The name of the downloaded file should be correct.")
  
  #Test the values of the file.  
  expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_more_than(info_actual$mtime, expected=start_time, label="The downloaded file's modification time should not precede this function's start time.")
  expect_more_than(info_actual$ctime, expected=start_time, label="The downloaded file's last change time should not precede this function's start time.")
  expect_more_than(info_actual$atime, expected=start_time, label="The downloaded file's last access time should not precede this function's start time.")
})

test_that("FullPathSpecified", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=FALSE)
  project <- start_clean_result$redcap_project
  
  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  
  start_time <- Sys.time() - 1 #Knock off a second in case there are small time imprecisions
  path_of_expected <- base::file.path(devtools::inst(name="REDCapR"), "test_data/mugshot_2.jpg")
  info_expected <- file.info(path_of_expected)
  record <- 2
  field <- "mugshot"
  
  expected_outcome_message <- 'image/jpeg; name="mugshot_2\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as .+\\.jpg'
  
  (full_name <- base::tempfile(pattern="mugshot", fileext=".jpg"))
  tryCatch({
    expect_message(
      returned_object <- redcap_download_file_oneshot(file_name=full_name, record=record, field=field, redcap_uri=start_clean_result$redcap_project$redcap_uri, token=start_clean_result$redcap_project$token),
      regexp = expected_outcome_message
    )
    Sys.sleep(delay_after_download_file)
    
    info_actual <- file.info(full_name)
    expect_true(file.exists(full_name), "The downloaded file should exist.")
  }, finally = base::unlink(full_name)
  )
  
  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 1L)
  expect_equal(returned_object$affected_ids, 2L)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")  
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, full_name, label="The name of the downloaded file should be correct.")
  
  #Test the values of the file.  
  expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_more_than(info_actual$mtime, expected=start_time, label="The downloaded file's modification time should not precede this function's start time.")
  expect_more_than(info_actual$ctime, expected=start_time, label="The downloaded file's last change time should not precede this function's start time.")
  expect_more_than(info_actual$atime, expected=start_time, label="The downloaded file's last access time should not precede this function's start time.")
})

test_that("RelativePath", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=FALSE)
  project <- start_clean_result$redcap_project
  
  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  
  start_time <- Sys.time() - 1 #Knock off a second in case there are small time imprecisions
  path_of_expected <- base::file.path(devtools::inst(name="REDCapR"), "test_data/mugshot_3.jpg")
  info_expected <- file.info(path_of_expected)
  record <- 3
  field <- "mugshot"
  
  expected_outcome_message <- 'image/jpeg; name="mugshot_3\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as .+\\.jpg'
  
  (relative_name <- "ssss.jpg")
  tryCatch({
    expect_message(
      returned_object <- redcap_download_file_oneshot(file_name=relative_name, record=record, field=field, redcap_uri=start_clean_result$redcap_project$redcap_uri, token=start_clean_result$redcap_project$token),
      regexp = expected_outcome_message
    )
    Sys.sleep(delay_after_download_file)
    
    info_actual <- file.info(relative_name)
    expect_true(file.exists(relative_name), "The downloaded file should exist.")
  }, finally = base::unlink(relative_name)
  )
  
  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 1L)
  expect_equal(returned_object$affected_ids, 3L)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")  
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, relative_name, label="The name of the downloaded file should be correct.")
  
  #Test the values of the file.  
  expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_more_than(info_actual$mtime, expected=start_time, label="The downloaded file's modification time should not precede this function's start time.")
  expect_more_than(info_actual$ctime, expected=start_time, label="The downloaded file's last change time should not precede this function's start time.")
  expect_more_than(info_actual$atime, expected=start_time, label="The downloaded file's last access time should not precede this function's start time.")
})

test_that("Full Directory Specific", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=FALSE)
  project <- start_clean_result$redcap_project
  
  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  
  start_time <- Sys.time() - 1 #Knock off a second in case there are small time imprecisions
  path_of_expected <- base::file.path(devtools::inst(name="REDCapR"), "test_data/mugshot_3.jpg")
  directory <- getwd()#  base::tempfile()
  info_expected <- file.info(path_of_expected)
  record <- 3
  field <- "mugshot"
  
  expected_outcome_message <- 'image/jpeg; name="mugshot_3\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as .+\\.jpg'
  
  tryCatch({
    expect_message(
      returned_object <- redcap_download_file_oneshot(directory=directory, record=record, field=field, redcap_uri=start_clean_result$redcap_project$redcap_uri, token=start_clean_result$redcap_project$token),
      # returned_object <- redcap_download_file_oneshot(record=record, field=field, redcap_uri=start_clean_result$redcap_project$redcap_uri, token=start_clean_result$redcap_project$token),
      regexp = expected_outcome_message
    )
    Sys.sleep(delay_after_download_file)
    
    info_actual <- file.info(returned_object$file_name)
    expect_true(file.exists(returned_object$file_name), "The downloaded file should exist.")
  }, finally = base::unlink(returned_object$file_path)
  )
  
  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 1L)
  expect_equal(returned_object$affected_ids, 3L)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")  
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, returned_object$file_name, label="The name of the downloaded file should be correct.")
  
  #Test the values of the file.  
  expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_more_than(info_actual$mtime, expected=start_time, label="The downloaded file's modification time should not precede this function's start time.")
  expect_more_than(info_actual$ctime, expected=start_time, label="The downloaded file's last change time should not precede this function's start time.")
  expect_more_than(info_actual$atime, expected=start_time, label="The downloaded file's last access time should not precede this function's start time.")
})
