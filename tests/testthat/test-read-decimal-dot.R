library(testthat)
update_expectation  <- FALSE

test_that("default-mismatched", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing("decimal-comma-and-dot")

  path_expected <- "test-data/projects/decimal-comma-and-dot/redcapr-specific/default-mismatched.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("locale-comma-oneshot", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing("decimal-comma")
  locale      <- readr::locale(decimal_mark = ",")

  path_expected <- "test-data/projects/decimal-comma/redcapr-specific/set-locale.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      locale      = locale,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("locale-comma-batch", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing("decimal-comma")
  locale      <- readr::locale(decimal_mark = ",")

  path_expected <- "test-data/projects/decimal-comma/redcapr-specific/set-locale.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      locale      = locale,
      verbose     = FALSE
    )

  # Saved w/ the oneshot test
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
