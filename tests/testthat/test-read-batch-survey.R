library(testthat)

credential          <- retrieve_credential_testing("survey")
project             <- redcap_project$new(redcap_uri=credential$redcap_uri, token=credential$token)
update_expectation  <- FALSE

test_that("smoke", {
  testthat::skip_on_cran()

  #Static method w/ default batch size
  returned_object <-
    redcap_read(
      redcap_uri           = credential$redcap_uri,
      token                = credential$token,
      export_survey_fields = TRUE,
      verbose              = FALSE
    )
  expect_type(returned_object, "list")

  #Instance method w/ default batch size
  returned_object <-
    project$read(
      export_survey_fields  = TRUE,
      verbose               = FALSE
    )
  expect_type(returned_object, "list")

  #Instance method w/ tiny batch size
  returned_object <-
    project$read(
      batch_size            = 2,
      export_survey_fields  = TRUE,
      verbose               = FALSE
    )
  expect_type(returned_object, "list")
})

test_that("so-example-data-frame-retrieval", {
  path_expected <- "test-data/projects/survey/expected/so-example-data-frame-retrieval.R"

  actual <- tibble::tibble(a=1:5, b=6:10) # saveRDS(actual, file.path("./inst", directory_relative, file_name))

  if (update_expectation) save_expected(actual, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(actual, expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE)
  expect_s3_class(actual, "tbl")
})

test_that("default", {
  testthat::skip_on_cran()
  path_expected <- "test-data/projects/survey/expected/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  returned_object1 <-
    redcap_read(
      redcap_uri            = credential$redcap_uri,
      token                 = credential$token,
      export_survey_fields  = TRUE,
      verbose               = FALSE
    )

  expect_true(all(!is.na(returned_object1$data$prescreening_survey_timestamp)))
  expect_s3_class(returned_object1$data$prescreening_survey_timestamp, "POSIXct")
  d1 <-
    returned_object1$data |>
    dplyr::select(
      -prescreening_survey_timestamp
    )

  if (update_expectation) save_expected(d1, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(d1, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object1$data)
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
      redcap_uri            = credential$redcap_uri,
      token                 = credential$token,
      export_survey_fields  = TRUE,
      batch_size            = 8,
      verbose               = FALSE
    )

  expect_true(all(!is.na(returned_object2$data$prescreening_survey_timestamp)))
  expect_s3_class(returned_object2$data$prescreening_survey_timestamp, "POSIXct")
  d2 <-
    returned_object2$data |>
    dplyr::select(
      -prescreening_survey_timestamp
    )

  expect_equal(d2, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(nchar(returned_object2$filter_logic)==0L, "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object2$data, "tbl")
})

rm(credential, update_expectation)
