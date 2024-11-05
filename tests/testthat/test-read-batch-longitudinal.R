library(testthat)

credential          <- retrieve_credential_testing("longitudinal")
project             <- redcap_project$new(redcap_uri=credential$redcap_uri, token=credential$token)
update_expectation  <- FALSE

if (credential$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
  testthat::skip("Skipping tests with lots of consecutive new lines on non-dev server")
}

test_that("smoke", {
  testthat::skip_on_cran()

  #Static method w/ default batch size
  returned_object <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  # #Static method w/ tiny batch size
  # expect_message(
  #   returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, batch_size=2)
  # )

  #Instance method w/ default batch size
  returned_object <- project$read(verbose = FALSE)
  expect_type(returned_object, "list")

  #Instance method w/ tiny batch size
  returned_object <- project$read(batch_size = 2, verbose = FALSE)
  expect_type(returned_object, "list")
})

test_that("so-example-data-frame-retrieval", {
  path_expected <- "test-data/projects/longitudinal/expected/so-example-data-frame-retrieval.R"

  actual <- tibble::tibble(a=1:5, b=6:10)

  if (update_expectation) save_expected(actual, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(actual, expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE)
  expect_s3_class(actual, "tbl")
})

test_that("default", {
  testthat::skip_on_cran()
  path_expected <- "test-data/projects/longitudinal/expected/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  returned_object1 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object1$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(nchar(returned_object1$filter_logic)==0L, "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object1$data, "tbl")

  ###########################
  ## Tiny Batch size
  returned_object2 <-
    redcap_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      batch_size  = 8,
      verbose     = FALSE
    )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(nchar(returned_object2$filter_logic)==0L, "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object2$data, "tbl")
})

test_that("filter-numeric", {
  testthat::skip_on_cran()
  path_expected <- "test-data/projects/longitudinal/expected/filter-numeric.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  filter <- "[bmi] > 25"

  ###########################
  ## Default Batch size
  returned_object1 <-
    redcap_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      filter_logic  = filter,
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object1$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object1$filter_logic, filter)
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)

  expect_s3_class(returned_object1$data, "tbl")

  ###########################
  ## Tiny Batch size
  returned_object2 <-
    redcap_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      batch_size    = 8,
      filter_logic  = filter,
      verbose       = FALSE
    )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object1$filter_logic, filter)
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object2$data, "tbl")
})

test_that("filter-character", {
  testthat::skip_on_cran()
  path_expected <- "test-data/projects/longitudinal/expected/filter-character.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  filter <- "[email] = 'zlehnox@gmail.com'"

  ###########################
  ## Default Batch size
  returned_object1 <-
    redcap_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      filter_logic  = filter,
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object1$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object1$filter_logic, filter)
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object1$data, "tbl")

  ###########################
  ## Tiny Batch size
  returned_object2 <-
    redcap_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      batch_size    = 8,
      filter_logic  = filter,
      verbose       = FALSE
    )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object2$filter_logic, filter)
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object2$data, "tbl")
})

rm(credential, project, update_expectation)
