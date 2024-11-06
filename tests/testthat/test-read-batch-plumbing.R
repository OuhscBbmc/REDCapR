# This file test that `redcap_read()` includes the appropriate plumbing variables.
library(testthat)
update_expectation  <- FALSE
credential    <- retrieve_credential_testing()

if (credential$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
  testthat::skip("Skipping tests with lots of consecutive new lines on non-dev server")
}

test_that("simple", {
  testthat::skip_on_cran()

  path_expected <- "test-data/specific-redcapr/read-batch-plumbing/simple.R"
  desired_forms <- c("race_and_ethnicity") # Doesn't include the initial "demographics" form.
  expected_outcome_message <- "\\d+ records and 10 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read(
      batch_size  = 2,
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      forms       = desired_forms,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_equal(returned_object$fields_collapsed, "record_id")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("longitudinal", {
  testthat::skip_on_cran()

  credential    <- retrieve_credential_testing("longitudinal")
  path_expected <- "test-data/specific-redcapr/read-batch-plumbing/longitudinal.R"
  desired_forms <- c("visit_observed_behavior") # Doesn't include the initial "demographics" form.
  expected_outcome_message <- "\\d+ records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read(
      batch_size  = 2,
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      forms       = desired_forms,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_equal(returned_object$fields_collapsed, "study_id")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("repeated", {
  testthat::skip_on_cran()

  credential    <- retrieve_credential_testing("vignette-repeating")
  path_expected <- "test-data/specific-redcapr/read-batch-plumbing/repeated.R"
  # desired_forms <- c("visit_observed_behavior") # Doesn't include the initial "demographics" form.
  desired_forms <- c("blood_pressure", "laboratory") # Doesn't include the initial "demographics" form.
  expected_outcome_message <- "\\d+ records and 15 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read(
      batch_size  = 2,
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      # forms       = desired_forms,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_equal(returned_object$fields_collapsed, "")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})

rm(credential)
