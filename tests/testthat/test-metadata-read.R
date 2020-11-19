library(testthat)

credential            <- retrieve_credential_testing()
credential_super_wide <- retrieve_credential_testing(753L)
credential_problem    <- retrieve_credential_testing(1425L)
update_expectation    <- FALSE

test_that("Metadata Read Smoke Test", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <- redcap_metadata_read(redcap_uri=credential$redcap_uri, token=credential$token)
  )
})


test_that("Super-wide", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The data dictionary describing 3,001 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."
  expected_row_count    <- 3001L
  expected_column_count <- 18L
  expected_na_cells     <- 42014L

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_metadata_read(redcap_uri=credential_super_wide$redcap_uri, token=credential_super_wide$token)
  )

  expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
  expect_equal(ncol(returned_object$data), expected=expected_column_count)
  expect_equal(sum(is.na(returned_object$data)), expected=expected_na_cells)
})

test_that("Problematic Dictionary", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The data dictionary describing 6 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."
  expected_row_count    <- 6L
  expected_column_count <- 18L
  expected_na_cells     <- 76L

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_metadata_read(redcap_uri=credential_problem$redcap_uri, token=credential_problem$token)
  )

  expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
  expect_equal(ncol(returned_object$data), expected=expected_column_count)
  expect_equal(sum(is.na(returned_object$data)), expected=expected_na_cells)
})

test_that("normal", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/metadata-read/normal.R"
  expected_outcome_message <- "The data dictionary describing \\d+ fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  expect_message(
    returned_object <- redcap_metadata_read(redcap_uri=credential$redcap_uri, token=credential$token),
    regexp = expected_outcome_message
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  # datapasta::tribble_paste(returned_object$data)
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$forms_collapsed=="", "A subset of forms was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

rm(credential           )
rm(credential_super_wide)
rm(credential_problem   )
rm(update_expectation)
