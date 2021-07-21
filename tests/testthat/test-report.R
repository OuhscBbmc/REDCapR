library(testthat)

credential          <- retrieve_credential_testing()
update_expectation  <- FALSE
report_id           <- 5980L

test_that("smoke test", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <-
      redcap_report(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        report_id     = report_id
      )
  )
})
test_that("default", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/report/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp          = expected_outcome_message,
    returned_object <- redcap_report(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      report_id     = report_id
    )
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("col_types", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/report/col_types.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  col_types <- readr::cols(
    record_id          = readr::col_integer(),
    height             = readr::col_double(),
    health_complete    = readr::col_integer(),
    address            = readr::col_character(),
    ethnicity          = readr::col_integer()
  )

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <-
        REDCapR::redcap_report(
          redcap_uri = credential$redcap_uri,
          token      = credential$token,
          report_id  = report_id,
          col_types  = col_types
        )
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("force-character-type", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/report/force-character-type.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <-
      redcap_report(
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        report_id   = report_id,
        guess_type  = FALSE
      )
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("raw", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/report/raw.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <-
      redcap_report(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        report_id     = report_id,
        raw_or_label  = "raw"
      )
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
# This test is removed because the vroom version adds digits to make the columns unique
# test_that("label-header", {
#   testthat::skip_on_cran()
#   path_expected <- "test-data/specific-redcapr/report/label-header.R"
#   expected_warning <- "Duplicated column names deduplicated: 'Complete\\?' => 'Complete\\?_1' \\[\\d+\\], 'Complete\\?' => 'Complete\\?_2' \\[\\d+\\]"
#   expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#
#   expect_warning(
#     regexp = expected_warning,
#     expect_message(
#       regexp           = expected_outcome_message,
#       returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label_headers="label")
#     )
#   )
#
#   if (update_expectation) save_expected(returned_object$data, path_expected)
#   expected_data_frame <- retrieve_expected(path_expected)
#
#   expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
#   expect_equal(returned_object$status_code, expected=200L)
#   expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_true(returned_object$filter_logic=="", "A filter was not specified.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
# })
test_that("export_checkbox_label", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/report/export_checkbox_label.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <-
      redcap_report(
        redcap_uri            = credential$redcap_uri,
        token                 = credential$token,
        report_id             = report_id,
        export_checkbox_label = TRUE,
        raw_or_label          = "label"
      )
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The REDCapR report operation was not successful\\."

  expect_message(
    returned_object <-
      redcap_report(
        redcap_uri    = credential$redcap_uri,
        token         = "BAD00000000000000000000000000000",
        report_id     = report_id
      ),
    expected_outcome_message
  )
  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$raw_text, "ERROR: You do not have permissions to use the API")
})
rm(credential)
