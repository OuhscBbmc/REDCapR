library(testthat)

credential  <- retrieve_credential_testing()
update_expectation  <- FALSE

path_expected_2020_08 <- "test-data/specific-redcapr/log-read/2020-08-10.R"

test_that("smoke test", {
  testthat::skip_on_cran()
  expect_message({
    returned <-
      redcap_log_read(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        verbose       = TRUE
      )
  })
  expect_type(returned, "list")
})

test_that("2020-08-10", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ rows were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR::redcap_log_read(
      redcap_uri     = credential$redcap_uri,
      token          = credential$token,
      log_begin_date = as.Date("2020-08-10"),
      log_end_date   = as.Date("2020-08-10"),
      verbose        = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected_2020_08)
  expected_data_frame <- retrieve_expected(path_expected_2020_08)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})

test_that("2020-08-10-api-export", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ rows were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR::redcap_log_read(
      redcap_uri     = credential$redcap_uri,
      token          = credential$token,
      log_begin_date = as.Date("2020-08-10"),
      log_end_date   = as.Date("2020-08-10"),
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected_2020_08)
  expected_data_frame <- retrieve_expected(path_expected_2020_08)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})
test_that("2021-07-11-record3-user", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/log-read/2021-07-11-record3-user.R"
  expected_outcome_message <- "\\d+ rows were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR::redcap_log_read(
      redcap_uri     = credential$redcap_uri,
      token          = credential$token,
      log_begin_date = as.Date("2021-07-11"),
      log_end_date   = as.Date("2021-07-11"),
      record         = as.character(3),
      user           = "unittestphifree",
      verbose        = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})

rm(credential)
