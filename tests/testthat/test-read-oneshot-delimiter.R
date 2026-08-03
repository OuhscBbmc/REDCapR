library(testthat)

credential  <- retrieve_credential_testing()
update_expectation  <- FALSE
path_expected_default <- "test-data/specific-redcapr/read-oneshot/default.R"

test_that("default", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read_oneshot(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_identical(returned_object$status_code, expected=200L)
  expect_identical(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_identical(returned_object$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})

test_that("comma", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read_oneshot(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      delimiter     = ",",
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_identical(returned_object$status_code, expected=200L)
  expect_identical(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_identical(returned_object$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})

test_that("semi-colon", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read_oneshot(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      delimiter     = ";",
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_identical(returned_object$status_code, expected=200L)
  expect_identical(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_identical(returned_object$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})

test_that("pipe", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read_oneshot(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      delimiter     = "|",
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_identical(returned_object$status_code, expected=200L)
  expect_identical(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_identical(returned_object$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})

test_that("caret", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read_oneshot(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      delimiter     = "^",
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_identical(returned_object$status_code, expected=200L)
  expect_identical(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_identical(returned_object$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})

test_that("tab", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read_oneshot(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      delimiter     = ",",
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_identical(returned_object$status_code, expected=200L)
  expect_identical(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_identical(returned_object$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})

rm(credential)
