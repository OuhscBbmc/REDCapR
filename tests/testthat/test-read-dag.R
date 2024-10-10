library(testthat)

credential  <- retrieve_credential_testing("dag")
update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()
  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )
  expect_type(returned_object, "list")
})
test_that("default", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-dag/assigned-to-dag-a.R"
  expected_outcome_message <- "2 records and 16 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    redcap_read_oneshot(
      redcap_uri                = credential$redcap_uri,
      token                     = credential$token,
      guess_type                = FALSE,
      export_data_access_groups = TRUE,
      verbose                   = FALSE
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

rm(credential)
