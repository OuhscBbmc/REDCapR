library(testthat)

credential  <- retrieve_credential_testing()
update_expectation  <- FALSE

if (credential$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
  testthat::skip("Skipping EAV test on non-dev server")
}

test_that("smoke test", {
  testthat::skip_on_cran()
  suppressMessages({
    returned_object <-
      REDCapR:::redcap_read_oneshot_eav(
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        verbose     = TRUE
      )
  })
  expect_type(returned_object, "list")
})
test_that("default", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("specify-forms", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/specify-forms.R"
  desired_forms <- c("demographics", "race_and_ethnicity")
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      forms       = desired_forms,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("raw", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/raw.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      raw_or_label  = "raw",
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("raw-and-dag", {
  testthat::skip("Temporarily turning off DAG on experimental function")
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/raw-and-dag.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri                = credential$redcap_uri,
      token                     = credential$token,
      raw_or_label              = "raw",
      export_data_access_groups = TRUE,
      verbose                   = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("label-and-dag", {
  testthat::skip("Temporarily turning off DAG on experimental function")
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/label-and-dag.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri                  = credential$redcap_uri,
      token                       = credential$token,
      raw_or_label                = "label",
      export_data_access_groups   = TRUE,
      verbose                     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("label-header", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/label-header.R"

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri            = credential$redcap_uri,
      token                 = credential$token,
      raw_or_label_headers  = "label",
      verbose               = FALSE
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
test_that("filter-numeric", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/filter-numeric.R"

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  filter <- "[age] >= 61"
  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      filter_logic  = filter,
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, filter)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("filter-character", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/filter-character.R"

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  filter <- "[name_first] = 'John Lee'"
  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      filter_logic  = filter,
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, filter)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("blank-for-gray-status-true", {
  testthat::skip_on_cran()
  credential_blank_for_gray  <- retrieve_credential_testing("blank-for-gray-status")
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/blank-for-gray-true.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri                  = credential_blank_for_gray$redcap_uri,
      token                       = credential_blank_for_gray$token,
      blank_for_gray_form_status  = TRUE,
      verbose                     = FALSE
    )

  d <-
    returned_object$data |>
    dplyr::select(
      -mugshot # Don't compare file IDs across servers.
    )

  if (update_expectation) save_expected(d, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(d, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("blank-for-gray-status-false", {
  testthat::skip_on_cran()
  credential_blank_for_gray  <- retrieve_credential_testing("blank-for-gray-status")
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/blank-for-gray-false.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri                  = credential_blank_for_gray$redcap_uri,
      token                       = credential_blank_for_gray$token,
      blank_for_gray_form_status  = FALSE,
      verbose                     = FALSE
    )

  d <-
    returned_object$data |>
    dplyr::select(
      -mugshot # Don't compare file IDs across servers.
    )

  if (update_expectation) save_expected(d, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(d, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("date-range", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  start <- as.POSIXct(strptime("2018-08-01 03:00", "%Y-%m-%d %H:%M"))
  stop  <- Sys.time()

  returned_object <-
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri            = credential$redcap_uri,
      token                 = credential$token,
      datetime_range_begin  = start,
      datetime_range_end    = stop,
      verbose               = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, "")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("bad token -Error", {
  testthat::skip_on_cran()

  expected_outcome_message <- "The REDCapR record export operation was not successful\\."
  expect_error(
    regexp           = expected_outcome_message,
    REDCapR:::redcap_read_oneshot_eav(
      redcap_uri    = credential$redcap_uri,
      token         = "BAD00000000000000000000000000000"
    )
  )
})

rm(credential)
