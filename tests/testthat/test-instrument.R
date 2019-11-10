library(testthat)

# Since the project data is wiped clean at the start of each function,
# the upload & download calls are tested by one function.

delay_after_download_file <- 1.0 #In seconds

test_that("default-name", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=FALSE)
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "Preparing to download the file `.+`."

  tryCatch({
    expect_message(
      returned_object <- redcap_download_instrument(redcap_uri=project$redcap_uri, token=project$token),
      regexp = expected_outcome_message
    )
  }, finally = base::unlink(returned_object$file_name)
  )

  # start_time <- Sys.time() - lubridate::seconds(1) #Knock off a second in case there's small time imprecisions
  start_time <- Sys.time() - 10 #Knock off ten seconds in case there are small time imprecisions.
  expected_outcome_message <- "text/html; charset=UTF-8 successfully downloaded in .+? seconds, and saved as instruments\\.pdf\\."

  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(length(returned_object$record_id), 0L)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, "instruments.pdf", label="The name of the downloaded file should be correct.")

  # #Test the values of the file.
  # expect_equal(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  # expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  # # expect_equal(as.character(info_actual$mode), expected=as.character(info_expected$mode), label="The mode/permissions of the downloaded file should match.")
  # expect_true(start_time <= info_actual$mtime, label="The downloaded file's modification time should not precede this function's start time.")
  # expect_true(start_time <= info_actual$ctime, label="The downloaded file's last change time should not precede this function's start time.")
  # expect_true(start_time <= info_actual$atime, label="The downloaded file's last access time should not precede this function's start time.")
})


