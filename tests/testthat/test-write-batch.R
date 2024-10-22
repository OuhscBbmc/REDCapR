library(testthat)

update_expectation  <- FALSE

test_that("Smoke Test", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  suppressMessages({ # Multiple messages are thrown, but now testthat::expect_message catches only one.
    start_clean_result <-
      REDCapR:::clean_start_simple(
        batch   = TRUE,
        verbose = TRUE
      )
  })
  project <- start_clean_result$redcap_project
})

test_that("default", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  path_expected <- "test-data/specific-redcapr/write-batch/default.R"
  start_clean_result <-
    REDCapR:::clean_start_simple(
      batch   = TRUE,
      verbose = FALSE
    )
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object <-
    redcap_read_oneshot(
      redcap_uri      = project$redcap_uri,
      token           = project$token,
      raw_or_label    = "raw",
      verbose         = FALSE
    )

  #Remove the calculated fields
  returned_object$data$bmi <- NULL
  returned_object$data$age <- NULL

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object$data$bmi<-NULL; returned_object$data$age<-NULL;dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("update-one-field", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  path_expected <- "test-data/specific-redcapr/write-batch/update-one-field.R"
  start_clean_result <-
    REDCapR:::clean_start_simple(
      batch   = TRUE,
      verbose = FALSE
    )
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object1 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  #Remove the calculated fields
  returned_object1$data$bmi <- NULL
  returned_object1$data$age <- NULL

  #Change some values
  returned_object1$data$address <- 1000 + seq_len(nrow(returned_object1$data))
  REDCapR::redcap_write(
    ds_to_write = returned_object1$data,
    redcap_uri  = project$redcap_uri,
    token       = project$token,
    verbose     = FALSE
  )

  returned_object2 <-
    redcap_read_oneshot(
      redcap_uri    = project$redcap_uri,
      token         = project$token,
      raw_or_label  = "raw",
      verbose       = FALSE
    )

  #Remove the calculated fields
  returned_object2$data$bmi <- NULL
  returned_object2$data$age <- NULL

  if (update_expectation) save_expected(returned_object2$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected=200L)
  expect_equal(returned_object2$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
})

test_that("update-two-fields", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  path_expected <- "test-data/specific-redcapr/write-batch/update-two-fields.R"
  start_clean_result <-
    REDCapR:::clean_start_simple(
      batch   = TRUE,
      verbose = FALSE
    )
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object1 <-
    redcap_read_oneshot(
      redcap_uri    = project$redcap_uri,
      token         = project$token,
      raw_or_label  = "raw",
      verbose       = FALSE
    )

  #Remove the calculated fields
  returned_object1$data$bmi <- NULL
  returned_object1$data$age <- NULL

  #Change some values
  returned_object1$data$address <- 1000 + seq_len(nrow(returned_object1$data))
  returned_object1$data$telephone <- sprintf("(405) 321-%1$i%1$i%1$i%1$i", seq_len(nrow(returned_object1$data)))
  REDCapR::redcap_write(
    ds_to_write = returned_object1$data,
    redcap_uri  = project$redcap_uri,
    token       = project$token,
    verbose     = FALSE
  )

  returned_object2 <-
    redcap_read_oneshot(
      redcap_uri    = project$redcap_uri,
      token         = project$token,
      raw_or_label  = "raw",
      verbose       = FALSE
    )

  #Remove the calculated fields
  returned_object2$data$bmi <- NULL
  returned_object2$data$age <- NULL

  if (update_expectation) save_expected(returned_object2$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected=200L)
  expect_equal(returned_object2$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
})
test_that("Write Batch -Bad URI", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  bad_uri <- "google.com"
  start_clean_result <-
    REDCapR:::clean_start_simple(
      batch   = TRUE,
      verbose = FALSE
    )
  project <- start_clean_result$redcap_project

  expected_outcome_message_1 <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expected_outcome_message_2 <- "The REDCapR write/import operation was not successful."

  returned_object1 <-
    redcap_read_oneshot(
      redcap_uri    = project$redcap_uri,
      token         = project$token,
      raw_or_label  = "raw",
      verbose       = FALSE
    )

  #Remove the calculated fields
  returned_object1$data$bmi <- NULL
  returned_object1$data$age <- NULL

  #Change some values
  returned_object1$data$address <- 1000 + seq_len(nrow(returned_object1$data))
  returned_object1$data$telephone <- sprintf("(405) 321-%1$i%1$i%1$i%1$i", seq_len(nrow(returned_object1$data)))

  expect_error(
    REDCapR::redcap_write(
      ds_to_write = returned_object1$data,
      redcap_uri  = bad_uri,
      token       = project$token,
      verbose     = FALSE
    )
  )
})
rm(update_expectation)
