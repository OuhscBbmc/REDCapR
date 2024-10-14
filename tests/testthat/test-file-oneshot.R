library(testthat)

credential <- retrieve_credential_testing()
delay_after_download_file <- 0.5 # In seconds

test_that("NameComesFromREDCap", {
  testthat::skip_on_cran()
  on.exit(base::unlink(returned_object$file_name))

  # start_time <- Sys.time() - lubridate::seconds(1) #Knock off a second in case there's small time imprecisions
  start_time <- Sys.time() - 10 #Knock off ten seconds in case there are small time imprecisions.
  path_of_expected <- system.file("test-data/mugshot-1.jpg", package="REDCapR")
  info_expected <- file.info(path_of_expected)
  record <- 1
  field <- "mugshot"

  expected_outcome_message <- '^(Preparing to download the file `mugshot-1.jpg`\\.|.+; name="mugshot-1\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as mugshot-1.jpg)'

  # expected_outcome_message <- ".+"
  suppressMessages({
    returned_object <-
      redcap_file_download_oneshot(
        record        = record,
        field         = field,
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        verbose       = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual <- file.info(returned_object$file_name)
  expect_true(file.exists(returned_object$file_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 1L)
  expect_equal(returned_object$affected_ids, "1")
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, "mugshot-1.jpg", label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  # expect_true(start_time <= info_actual$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual$atime, label="The downloaded file's last access time should not precede this function's start time.")
})

test_that("FullPathSpecified", {
  testthat::skip_on_cran()
  on.exit(base::unlink(returned_object$file_name))

  start_time <- Sys.time() - 10 #Knock off ten seconds in case there are small time imprecisions.
  path_of_expected <- system.file("test-data/mugshot-2.jpg", package="REDCapR")
  info_expected <- file.info(path_of_expected)
  record <- 2
  field <- "mugshot"

  expected_outcome_message <- '; name="mugshot-2\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as .+\\.jpg'

  full_name <- base::tempfile(pattern="mugshot", fileext=".jpg")
  suppressMessages({
    returned_object <-
      redcap_file_download_oneshot(
        file_name     = full_name,
        record        = record,
        field         = field,
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        verbose       = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual <- file.info(full_name)
  expect_true(file.exists(full_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 1L)
  expect_equal(returned_object$affected_ids, "2")
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, full_name, label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  expect_true(start_time <= info_actual$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual$atime, label="The downloaded file's last access time should not precede this function's start time.")
})

test_that("RelativePath", {
  testthat::skip_on_cran()
  on.exit(base::unlink(returned_object$file_name))

  start_time <- Sys.time() - 10 #Knock off ten seconds in case there are small time imprecisions.
  path_of_expected <- system.file("test-data/mugshot-3.jpg", package="REDCapR")
  info_expected <- file.info(path_of_expected)
  record <- 3
  field <- "mugshot"

  expected_outcome_message <- '; name="mugshot-3\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as .+\\.jpg'

  (relative_name <- "ssss.jpg")
  suppressMessages({
    returned_object <-
      redcap_file_download_oneshot(
        file_name   = relative_name,
        record      = record,
        field       = field,
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        verbose     = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual <- file.info(relative_name)
  expect_true(file.exists(relative_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 1L)
  expect_equal(returned_object$affected_ids, "3")
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, relative_name, label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  expect_true(start_time <= info_actual$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual$atime, label="The downloaded file's last access time should not precede this function's start time.")
})

test_that("Full Directory Specific", {
  testthat::skip_on_cran()
  on.exit(base::unlink(returned_object$file_name))

  start_time <- Sys.time() - 10 #Knock off ten seconds in case there are small time imprecisions.
  path_of_expected <- system.file("test-data/mugshot-3.jpg", package="REDCapR")
  directory <- getwd()#  base::tempfile()
  info_expected <- file.info(path_of_expected)
  record <- 3
  field <- "mugshot"

  expected_outcome_message <- '; name="mugshot-3\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as .+\\.jpg'

  suppressMessages({
    returned_object <-
      redcap_file_download_oneshot(
        directory   = directory,
        record      = record,
        field       = field,
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        verbose     = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual <- file.info(returned_object$file_name)
  expect_true(file.exists(returned_object$file_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 1L)
  expect_equal(returned_object$affected_ids, "3")
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, returned_object$file_name, label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  expect_true(start_time <= info_actual$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual$atime, label="The downloaded file's last access time should not precede this function's start time.")
})

test_that("file in longitudinal event", {
  testthat::skip_on_cran()
  credential_longitudinal <- retrieve_credential_testing("arm-single-longitudinal")
  on.exit({
    base::unlink(returned_object_1_1$file_name)
    base::unlink(returned_object_1_2$file_name)
    base::unlink(returned_object_2_2$file_name)
  })

  # start_time <- Sys.time() - lubridate::seconds(1) #Knock off a second in case there's small time imprecisions
  start_time <- Sys.time() - 10 #Knock off ten seconds in case there are small time imprecisions.
  path_of_expected_1_1 <- system.file("test-data/mugshot-1.jpg", package="REDCapR")
  path_of_expected_1_2 <- system.file("test-data/mugshot-2.jpg", package="REDCapR")
  path_of_expected_2_2 <- system.file("test-data/mugshot-5.jpg", package="REDCapR")
  info_expected_1_1 <- file.info(path_of_expected_1_1)
  info_expected_1_2 <- file.info(path_of_expected_1_2)
  info_expected_2_2 <- file.info(path_of_expected_2_2)
  # record <- 1
  field <- "image_profile"

  expected_outcome_message <- '^(Preparing to download the file `.+\\.jpg`\\.|.+; name=".+\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as .+\\.jpg)'
  # expected_outcome_message <- ".+"

  # ---- first record, first event --------------------------
  suppressMessages({
    returned_object_1_1 <-
      redcap_file_download_oneshot(
        record        = 1L,
        event         = "intake_arm_1",
        field         = field,
        redcap_uri    = credential_longitudinal$redcap_uri,
        token         = credential_longitudinal$token,
        verbose       = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual_1_1 <- file.info(returned_object_1_1$file_name)
  expect_true(file.exists(returned_object_1_1$file_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object_1_1$success)
  expect_equal(returned_object_1_1$status_code, expected=200L)
  expect_match(returned_object_1_1$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object_1_1$records_affected_count, 1L)
  expect_equal(returned_object_1_1$affected_ids, "1")
  expect_true(returned_object_1_1$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object_1_1$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object_1$raw_text)
  expect_equal(returned_object_1_1$file_name, "mugshot-1.jpg", label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual_1_1$size, expected=info_expected_1_1$size, label="The size of the downloaded file should match.")
  expect_false(info_actual_1_1$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual_1_1$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual_1_1$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  # expect_true(start_time <= info_actual_1_1$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual_1_1$atime, label="The downloaded file's last access time should not precede this function's start time.")

  # ---- first record, second event --------------------------
  suppressMessages({
    returned_object_1_2 <-
      redcap_file_download_oneshot(
        record        = 1L,
        event         = "dischage_arm_1",
        field         = field,
        redcap_uri    = credential_longitudinal$redcap_uri,
        token         = credential_longitudinal$token,
        verbose       = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual_1_2 <- file.info(returned_object_1_2$file_name)
  expect_true(file.exists(returned_object_1_2$file_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object_1_2$success)
  expect_equal(returned_object_1_2$status_code, expected=200L)
  expect_match(returned_object_1_2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object_1_2$records_affected_count, 1L)
  expect_equal(returned_object_1_2$affected_ids, "1")
  expect_true(returned_object_1_2$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object_1_2$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object_1$raw_text)
  expect_equal(returned_object_1_2$file_name, "mugshot-2.jpg", label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual_1_2$size, expected=info_expected_1_2$size, label="The size of the downloaded file should match.")
  expect_false(info_actual_1_2$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual_1_2$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual_1_2$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  # expect_true(start_time <= info_actual_1_2$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual_1_2$atime, label="The downloaded file's last access time should not precede this function's start time.")

  # ---- second record, second event --------------------------
  suppressMessages({
    returned_object_2_2 <-
      redcap_file_download_oneshot(
        record        = 2L,
        event         = "dischage_arm_1",
        field         = field,
        redcap_uri    = credential_longitudinal$redcap_uri,
        token         = credential_longitudinal$token,
        verbose       = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual_2_2 <- file.info(returned_object_2_2$file_name)
  expect_true(file.exists(returned_object_2_2$file_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object_2_2$success)
  expect_equal(returned_object_2_2$status_code, expected=200L)
  expect_match(returned_object_2_2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object_2_2$records_affected_count, 1L)
  expect_equal(returned_object_2_2$affected_ids, "2")
  expect_true(returned_object_2_2$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object_2_2$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object_1$raw_text)
  expect_equal(returned_object_2_2$file_name, "mugshot-5.jpg", label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual_2_2$size, expected=info_expected_2_2$size, label="The size of the downloaded file should match.")
  expect_false(info_actual_2_2$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual_2_2$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual_2_2$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  # expect_true(start_time <= info_actual_2_2$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual_2_2$atime, label="The downloaded file's last access time should not precede this function's start time.")

})

test_that("file in repeating instrument", {
  testthat::skip_on_cran()
  credential_repeating <- retrieve_credential_testing("vignette-repeating")
  on.exit({
    base::unlink(returned_object_1_1$file_name)
    base::unlink(returned_object_1_2$file_name)
    base::unlink(returned_object_2_1$file_name)
  })

  # start_time <- Sys.time() - lubridate::seconds(1) #Knock off a second in case there's small time imprecisions
  start_time <- Sys.time() - 10 #Knock off ten seconds in case there are small time imprecisions.
  path_of_expected_1_1 <- system.file("test-data/levon-and-barry.jpg", package="REDCapR")
  path_of_expected_1_2 <- system.file("test-data/mugshot-1.jpg", package="REDCapR")
  path_of_expected_2_1 <- system.file("test-data/mugshot-2.jpg", package="REDCapR")
  info_expected_1_1 <- file.info(path_of_expected_1_1)
  info_expected_1_2 <- file.info(path_of_expected_1_2)
  info_expected_2_1 <- file.info(path_of_expected_2_1)
  field <- "image_profile"

  expected_outcome_message <- '^(Preparing to download the file `.+\\.jpg`\\.|.+; name=".+\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as .+\\.jpg)'
  # expected_outcome_message <- ".+"

  # ---- first record, first instance --------------------------
  suppressMessages({
    returned_object_1_1 <-
      redcap_file_download_oneshot(
        record        = 1L,
        field         = field,
        repeat_instance = "1",
        redcap_uri    = credential_repeating$redcap_uri,
        token         = credential_repeating$token,
        verbose       = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual_1_1 <- file.info(returned_object_1_1$file_name)
  expect_true(file.exists(returned_object_1_1$file_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object_1_1$success)
  expect_equal(returned_object_1_1$status_code, expected=200L)
  expect_match(returned_object_1_1$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object_1_1$records_affected_count, 1L)
  expect_equal(returned_object_1_1$affected_ids, "1")
  expect_true(returned_object_1_1$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object_1_1$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object_1$raw_text)
  expect_equal(returned_object_1_1$file_name, "levon-and-barry.jpg", label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual_1_1$size, expected=info_expected_1_1$size, label="The size of the downloaded file should match.")
  expect_false(info_actual_1_1$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual_1_1$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  # expect_true(start_time <= info_actual_1_1$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual_1_1$atime, label="The downloaded file's last access time should not precede this function's start time.")

  # ---- first record, second instance --------------------------
  suppressMessages({
    returned_object_1_2 <-
      redcap_file_download_oneshot(
        record        = 1L,
        field         = field,
        repeat_instance = "2",
        redcap_uri    = credential_repeating$redcap_uri,
        token         = credential_repeating$token,
        verbose       = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual_1_2 <- file.info(returned_object_1_2$file_name)
  expect_true(file.exists(returned_object_1_2$file_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object_1_2$success)
  expect_equal(returned_object_1_2$status_code, expected=200L)
  expect_match(returned_object_1_2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object_1_2$records_affected_count, 1L)
  expect_equal(returned_object_1_2$affected_ids, "1")
  expect_true(returned_object_1_2$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object_1_2$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object_1$raw_text)
  expect_equal(returned_object_1_2$file_name, "mugshot-1.jpg", label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual_1_2$size, expected=info_expected_1_2$size, label="The size of the downloaded file should match.")
  expect_false(info_actual_1_2$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual_1_2$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual_1_2$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  # expect_true(start_time <= info_actual_1_2$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual_1_2$atime, label="The downloaded file's last access time should not precede this function's start time.")

  # ---- second record, first instance --------------------------
  suppressMessages({
    returned_object_2_1 <-
      redcap_file_download_oneshot(
        record        = 2L,
        field         = field,
        repeat_instance = "1",
        redcap_uri    = credential_repeating$redcap_uri,
        token         = credential_repeating$token,
        verbose       = TRUE
      )
  })

  Sys.sleep(delay_after_download_file)
  info_actual_2_1 <- file.info(returned_object_2_1$file_name)
  expect_true(file.exists(returned_object_2_1$file_name), "The downloaded file should exist.")

  #Test the values of the returned object.
  expect_true(returned_object_2_1$success)
  expect_equal(returned_object_2_1$status_code, expected=200L)
  expect_match(returned_object_2_1$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object_2_1$records_affected_count, 1L)
  expect_equal(returned_object_2_1$affected_ids, "2")
  expect_true(returned_object_2_1$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object_2_1$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object_1$raw_text)
  expect_equal(returned_object_2_1$file_name, "mugshot-2.jpg", label="The name of the downloaded file should be correct.")

  #Test the values of the file.
  expect_equal(info_actual_2_1$size, expected=info_expected_2_1$size, label="The size of the downloaded file should match.")
  expect_false(info_actual_2_1$isdir, "The downloaded file should not be a directory.")
  # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  expect_true(start_time <= info_actual_2_1$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  # expect_true(start_time <= info_actual_2_1$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  expect_true(start_time <= info_actual_2_1$atime, label="The downloaded file's last access time should not precede this function's start time.")
})

test_that("download file conflict -Error", {
  testthat::skip_on_cran()
  on.exit(base::unlink(returned_object_1$file_name))

  record <- 2
  field <- "mugshot"

  expected_outcome_message_1  <- '; name="mugshot-2\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as mugshot-2.jpg'
  expected_outcome_message_2  <- "The operation was halted because the file `mugshot-2\\.jpg` already exists and `overwrite` is FALSE\\.  Please check the directory if you believe this is a mistake\\."

  # The first run should work.
  returned_object_1 <-
    redcap_file_download_oneshot(
      record        = record,
      field         = field,
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      verbose       = FALSE
    )

  Sys.sleep(delay_after_download_file)
  #Test the values of the returned object.
  expect_true(returned_object_1$success)
  expect_equal(returned_object_1$status_code, expected=200L)

  # The second run should fail (b/c the file already exists).
  expect_error(
    returned_object_2 <-
      redcap_file_download_oneshot(
        record        = record,
        field         = field,
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        overwrite     = FALSE,
        verbose       = FALSE
      ),
    regexp = expected_outcome_message_2
  )
  Sys.sleep(delay_after_download_file)

  expect_false(exists("returned_object_2"))
})

test_that("Download Error --bad field name", {
  testthat::skip_on_cran()
  on.exit(base::unlink(returned_object$file_name))

  start_time <- Sys.time() - 10 #Knock off ten seconds in case there are small time imprecisions.
  path_of_expected <- system.file("test-data/mugshot-3.jpg", package="REDCapR")
  directory <- getwd()#  base::tempfile()
  info_expected <- file.info(path_of_expected)
  record <- 3
  field <- "mugshotttttt"

  expected_outcome_message <- "file NOT downloaded"
  expected_raw_text        <- "ERROR: The field 'mugshotttttt' does not exist or is not a 'file' field"

  suppressMessages({
    returned_object <-
      redcap_file_download_oneshot(
        directory     = directory,
        record        = record,
        field         = field,
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        verbose       = FALSE
      )
  })

  Sys.sleep(delay_after_download_file)
  expect_null(returned_object$file_name)

  #Test the values of the returned object.
  expect_false(returned_object$success)
  expect_equal(returned_object$status_code, expected=400L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object$records_affected_count, 0L)
  expect_equal(returned_object$affected_ids, character(0))
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object$raw_text, expected=expected_raw_text, ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_null(returned_object$file_name, label="The name of the downloaded file should be correct.")
})

test_that("download w/ bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "file NOT downloaded."

  returned_object <-
    redcap_file_download_oneshot(
      record      = 1,
      field       = "mugshot",
      redcap_uri  = credential$redcap_uri,
      token       = "BAD00000000000000000000000000000",
      verbose     = FALSE
    )

  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$raw_text, "ERROR: You do not have permissions to use the API")
})

test_that("upload w/ bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "file NOT uploaded."

  credential_upload <- retrieve_credential_testing("simple-write")

  file_path <- system.file(
    "test-data/mugshot-5.jpg",
    package = "REDCapR"
  )

  returned_object <-
    redcap_file_upload_oneshot(
      file_name   = file_path,
      record      = 1,
      field       = "mugshot",
      redcap_uri  = credential_upload$redcap_uri,
      token       = "BAD00000000000000000000000000000",
      verbose     = FALSE
    )

  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$raw_text, "ERROR: You do not have permissions to use the API")
})

rm(credential)
