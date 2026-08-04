library(testthat)

credential  <- retrieve_credential_testing()
update_expectation  <- FALSE
path_expected_default <- "test-data/specific-redcapr/read-oneshot/default.R"

test_that("comma", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  returned_object1 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      delimiter   = ",",
      verbose     = FALSE
    )

  # if (update_expectation) save_expected(returned_object1$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object1$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object1$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object1$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object1$data, "tbl")

  ###########################
  ## Tiny Batch size
  returned_object2 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      batch_size  = 2,
      delimiter   = ",",
      verbose     = FALSE
    )

  expect_identical(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object2$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object2$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object2$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object2$data, "tbl")
})
test_that("semi-colon", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  returned_object1 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      delimiter   = ";",
      verbose     = FALSE
    )

  # if (update_expectation) save_expected(returned_object1$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object1$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object1$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object1$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object1$data, "tbl")

  ###########################
  ## Tiny Batch size
  returned_object2 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      batch_size  = 2,
      delimiter   = ";",
      verbose     = FALSE
    )

  expect_identical(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object2$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object2$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object2$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object2$data, "tbl")
})
test_that("pipe", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  returned_object1 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      delimiter   = "|",
      verbose     = FALSE
    )

  # if (update_expectation) save_expected(returned_object1$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object1$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object1$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object1$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object1$data, "tbl")

  ###########################
  ## Tiny Batch size
  returned_object2 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      batch_size  = 2,
      delimiter   = "|",
      verbose     = FALSE
    )

  expect_identical(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object2$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object2$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object2$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object2$data, "tbl")
})
test_that("carat", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  returned_object1 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      delimiter   = "^",
      verbose     = FALSE
    )

  # if (update_expectation) save_expected(returned_object1$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object1$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object1$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object1$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object1$data, "tbl")

  ###########################
  ## Tiny Batch size
  returned_object2 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      batch_size  = 2,
      delimiter   = "^",
      verbose     = FALSE
    )

  expect_identical(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object2$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object2$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object2$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object2$data, "tbl")
})
test_that("tab", {
  testthat::skip_on_cran()
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  returned_object1 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      delimiter   = "tab",
      verbose     = FALSE
    )

  # if (update_expectation) save_expected(returned_object1$data, path_expected_default)
  expected_data_frame <- retrieve_expected(path_expected_default)

  expect_identical(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object1$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object1$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object1$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object1$data, "tbl")

  ###########################
  ## Tiny Batch size
  returned_object2 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      batch_size  = 2,
      delimiter   = "tab",
      verbose     = FALSE
    )

  expect_identical(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_identical(returned_object2$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object2$fields_collapsed, "", "A subset of fields was not requested.")
  expect_identical(returned_object2$filter_logic, "", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object2$data, "tbl")
})


rm(credential)
