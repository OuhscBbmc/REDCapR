library(testthat)
update_expectation  <- FALSE

test_that("Smoke Test", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_dag_write(batch=FALSE)
  project <- start_clean_result$redcap_project
})

test_that("default", {
  testthat::skip_on_cran()
  path_expected_before <- "test-data/specific-redcapr/write-dag/before.R"
  path_expected_after  <- "test-data/specific-redcapr/write-dag/after.R"
  start_clean_result <- REDCapR:::clean_start_dag_write(batch=FALSE)
  project <- start_clean_result$redcap_project
  token_for_dag_user <- "C79DB3836373478986928303B52E74DF"

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=token_for_dag_user),
    regexp = expected_outcome_message
  )

  if (update_expectation) save_expected(returned_object$data, path_expected_before)
  expected_data_frame <- retrieve_expected(path_expected_before)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object$data$bmi<-NULL; returned_object$data$age<-NULL;dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  ds_updated <- returned_object$data
  ds_updated$last_name <- paste("last name", seq_len(nrow(ds_updated)))
  ds_updated$demographics_complete <- REDCapR::constant("form_complete")
  # ds_updated$record_id <- sub("^\\d+-(\\d+)$", "\\1",  ds_updated$record_id)
  # ds_updated$redcap_data_access_group <- NULL

  redcap_write_oneshot(ds_updated, project$redcap_uri, token_for_dag_user)
  returned_object <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token)

  if (update_expectation) save_expected(returned_object$data, path_expected_after)
  expected_data_frame <- retrieve_expected(path_expected_after)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object$data$bmi<-NULL; returned_object$data$age<-NULL;dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
