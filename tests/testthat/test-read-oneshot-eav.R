library(testthat)

credential  <- retrieve_credential_testing()
update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()
  expect_message(
     returned_object <- REDCapR:::redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token)
  )
})
test_that("default", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- REDCapR:::redcap_read_oneshot_eav(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token
    )
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
})
test_that("specify-forms", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/specify-forms.R"
  desired_forms <- c("demographics", "race_and_ethnicity")
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- REDCapR:::redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, forms=desired_forms)
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
})
test_that("raw", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/raw.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- REDCapR:::redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw")
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
})
test_that("raw-and-dag", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/raw-and-dag.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- REDCapR:::redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", export_data_access_groups=TRUE)
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
})
test_that("label-and-dag", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/label-and-dag.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- REDCapR:::redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=TRUE)
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
})
test_that("label-header", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/label-header.R"

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- REDCapR:::redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label_headers="label")
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
})
test_that("filter-numeric", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/filter-numeric.R"

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  filter <- "[age] >= 61"
  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- REDCapR:::redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, filter_logic=filter)
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
})
test_that("filter-character", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/filter-character.R"

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  filter <- "[name_first] = 'John Lee'"
  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- REDCapR:::redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, filter_logic=filter)
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
})

test_that("date-range", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-oneshot-eav/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  start <- as.POSIXct(strptime("2018-08-01 03:00", "%Y-%m-%d %H:%M"))
  stop  <- Sys.time()
  expect_message(
    regexp           = expected_outcome_message,
    returned_object <-
      REDCapR:::redcap_read_oneshot_eav(
        redcap_uri        = credential$redcap_uri,
        token             = credential$token,
        datetime_range_begin  = start,
        datetime_range_end    = stop
      )
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
