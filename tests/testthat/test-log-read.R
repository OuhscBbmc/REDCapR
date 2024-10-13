library(testthat)

credential  <- retrieve_credential_testing()
update_expectation  <- FALSE

path_expected_2024_10 <- "test-data/specific-redcapr/log-read/2024-10-11.R"

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

test_that("2024-10-11", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ rows were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  if (credential$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
    testthat::skip("Skipping logging test b/c a different server.")
  }

  returned_object <-
    REDCapR::redcap_log_read(
      redcap_uri     = credential$redcap_uri,
      token          = credential$token,
      log_begin_date = as.Date("2024-10-11"),
      log_end_date   = as.Date("2024-10-11"),
      verbose        = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected_2024_10)
  expected_data_frame <- retrieve_expected(path_expected_2024_10)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data, "tbl")
})

rm(credential)
