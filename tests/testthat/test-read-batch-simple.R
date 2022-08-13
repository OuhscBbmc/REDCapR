library(testthat)

credential  <- retrieve_credential_testing()
project     <- redcap_project$new(redcap_uri=credential$redcap_uri, token=credential$token)
update_expectation  <- FALSE
path_expected_default <- "test-data/specific-redcapr/read-batch-simple/default.R"

test_that("smoke test", {
  testthat::skip_on_cran()

  #Static method w/ default batch size
  expect_message(
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token)
  )

  #Static method w/ tiny batch size
  expect_message(
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, batch_size=2)
  )

  #Instance method w/ default batch size
  expect_message(
    returned_object <- project$read()
  )

  #Instance method w/ tiny batch size
  expect_message(
    returned_object <- project$read(batch_size=2)
  )
})
test_that("default", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token)
  )

  if (update_expectation) save_expected(returned_object1$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)

  ###########################
  ## Tiny Batch size
  expect_message(
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, batch_size=2),
    regexp = expected_outcome_message
  )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object2$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("col_types", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/col_types.R"
  col_types <- readr::cols(
    record_id  = readr::col_integer(),
    race___1   = readr::col_logical(),
    race___2   = readr::col_logical(),
    race___3   = readr::col_logical(),
    race___4   = readr::col_logical(),
    race___5   = readr::col_logical(),
    race___6   = readr::col_logical()
  )

  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, col_types=col_types, batch_size=2)
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_true( returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true( returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true( returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true( returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("specify-records", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/specify-records.R"
  desired_records <- c(1L, 3L, 4L)
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, records=desired_records, batch_size=2)
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed==paste(desired_records, collapse=","))
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("specify-records-zero-length", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/specify-records-zero-length.R"
  desired_records <- c()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, records=desired_records, batch_size=2)
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed==paste(desired_records, collapse=","))
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("specify-fields", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/specify-fields.R"
  desired_fields <- c("record_id", "name_first", "name_last", "age")
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, fields=desired_fields, batch_size=2)
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed==paste(desired_fields, collapse=","))
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("specify-fields-zero-length", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/specify-fields-zero-length.R"
  desired_fields <- c()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, fields=desired_fields, batch_size=2)
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed==paste(desired_fields, collapse=","))
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("specify-records-and-fields-zero-length", {
  testthat::skip_on_cran()
  desired_records <- c()
  desired_fields <- c()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, records=desired_records, fields=desired_fields, batch_size=2)
  )

  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("specify-forms", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/specify-forms.R"
  desired_forms <- c("demographics", "race_and_ethnicity")
  expected_outcome_message <- "\\d+ records and 19 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, forms=desired_forms)
  )

  if (update_expectation) save_expected(returned_object1$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)

  ###########################
  ## Tiny Batch size
  expect_message(
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, forms=desired_forms, batch_size=2),
    regexp = expected_outcome_message
  )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object2$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("raw", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/raw.R"
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token)
  )

  if (update_expectation) save_expected(returned_object1$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)

  ###########################
  ## Tiny Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, batch_size=2)
  )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object2$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("raw-and-dag", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/raw-and-dag.R"
  expected_outcome_message <- "\\d+ records and 26 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", export_data_access_groups=TRUE)
  )

  if (update_expectation) save_expected(returned_object1$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)

  ###########################
  ## Tiny Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", export_data_access_groups=TRUE, batch_size=2)
  )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object2$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("label-and-dag-one-single-batch", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/label-and-dag-one-single-batch.R"

  expected_outcome_message <- "\\d+ records and 26 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=TRUE)
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("label-and-dag-three-tiny-batches", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/label-and-dag-three-tiny-batches.R"

  expected_outcome_message <- "\\d+ records and 26 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp            = expected_outcome_message,
    returned_object   <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=TRUE, batch_size=2)
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(as.data.frame(tibble::as_tibble(returned_object$data)), expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("label", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/label.R"
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1   <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=FALSE)
  )

  if (update_expectation) save_expected(returned_object1$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)

  ###########################
  ## Tiny Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=FALSE, batch_size=2)
  )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
# This test is removed because the vroom version adds digits to make the columns unique
# test_that("label-header", {
#   testthat::skip_on_cran()
#   path_expected <- "test-data/specific-redcapr/read-batch-simple/label-header.R"
#
#   expected_warning <- "Duplicated column names deduplicated: 'Complete\\?' => 'Complete\\?_1' \\[16\\], 'Complete\\?' => 'Complete\\?_2' \\[25\\]"
#   expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#
#   expect_warning(
#     regexp = expected_warning,
#     expect_message(
#       regexp           = expected_outcome_message,
#       returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label_headers="label")
#     )
#   )
#
#   if (update_expectation) save_expected(returned_object$data, path_expected)
#   expected_data_frame <- retrieve_expected(path_expected)
#
#   expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
#   expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
# })
test_that("export_checkbox_label", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/export_checkbox_label.R"
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1  <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_checkbox_label=TRUE)
  )

  if (update_expectation) save_expected(returned_object1$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)

  ###########################
  ## Tiny Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_checkbox_label=TRUE, batch_size=2)
  )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("filter-numeric", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/filter-numeric.R"
  expected_outcome_message <- "2 records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  filter <- "[age] >= 61"

  expect_message(
    regexp            = expected_outcome_message,
    returned_object   <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, filter_logic=filter)
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, filter)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("filter-character", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-simple/filter-character.R"
  expected_outcome_message <- "1 records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  filter <- "[name_first] = 'John Lee'"
  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, filter_logic=filter)
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, filter)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("date-range", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  start <- as.POSIXct(strptime("2018-08-01 03:00", "%Y-%m-%d %H:%M"))
  stop  <- Sys.time()
  expect_message(
    regexp           = expected_outcome_message,
    returned_object <-
      redcap_read(
        redcap_uri        = credential$redcap_uri,
        token             = credential$token,
        datetime_range_begin  = start,
        datetime_range_end    = stop
      )
  )

  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected="200")
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, "")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("error-bad-token", {
  testthat::skip_on_cran()

  expected_outcome_message <- "The REDCapR read/export operation was not successful\\."
  expect_message(
    regexp           = expected_outcome_message,
    redcap_read(
      redcap_uri    = credential$redcap_uri,
      token         = "BAD00000000000000000000000000000"
    )
  )
})
rm(credential, project)
rm(update_expectation)
