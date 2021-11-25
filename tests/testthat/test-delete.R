library(testthat)
update_expectation  <- FALSE

test_that("single-arm-four-records", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  path_expected <- "test-data/specific-redcapr/delete/single-arm-four-records.R"
  start_clean_result <- REDCapR:::clean_start_delete_single_arm()
  project <- start_clean_result$redcap_project

  records_to_delete <- c(102, 103, 105, 120)

  expected_outcome_message <- "\\d+ records were deleted from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object1 <-
      redcap_delete(
        redcap_uri        = project$redcap_uri,
        token             = project$token,
        records_to_delete = records_to_delete
      ),
    regexp = expected_outcome_message
  )

  expect_equal(returned_object1$status_code, expected=200L)
  expect_equal(returned_object1$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object1$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object1$records_affected_count, length(records_to_delete))
  expect_true( returned_object1$success)

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object2 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token),
    regexp = expected_outcome_message
  )

  if (update_expectation) save_expected(returned_object2$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected=200L)
  expect_equal(returned_object2$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
})

test_that("multiple-arm-four-records", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  path_expected <- "test-data/specific-redcapr/delete/multiple-arm-four-records.R"
  start_clean_result <- REDCapR:::clean_start_delete_multiple_arm()
  project <- start_clean_result$redcap_project

  arm <- 2L
  records_to_delete <- c(102, 103, 105, 120)

  expected_outcome_message <- "\\d+ records were deleted from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object1 <-
      redcap_delete(
        redcap_uri        = project$redcap_uri,
        token             = project$token,
        records_to_delete = records_to_delete,
        arm_of_records_to_delete = arm
      ),
    regexp = expected_outcome_message
  )

  expect_equal(returned_object1$status_code, expected=200L)
  expect_equal(returned_object1$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object1$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(returned_object1$records_affected_count, length(records_to_delete))
  expect_true( returned_object1$success)

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object2 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token),
    regexp = expected_outcome_message
  )

  if (update_expectation) save_expected(returned_object2$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected=200L)
  expect_equal(returned_object2$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
})

test_that("no-delete-permissions", {
  testthat::skip_on_cran()
  skip_if_onlyread()
  credential  <- retrieve_credential_testing(213L) # Write-project, but  no privileges for deleting records

  records_to_delete <- 1

  expected_outcome_message <- "The REDCapR delete operation was not successful.  The error message was:.+You do not have Delete Record privileges"
  expect_error(
    returned_object1 <-
      redcap_delete(
        redcap_uri        = credential$redcap_uri,
        token             = credential$token,
        records_to_delete = records_to_delete
      ),
    regexp = expected_outcome_message
  )
})
