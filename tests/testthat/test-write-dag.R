library(testthat)
update_expectation  <- FALSE
credential_admin    <- retrieve_credential_testing("dag-write", username = "admin")
credential_user     <- retrieve_credential_testing("dag-write", username = "user-dag1")
url                 <- credential_admin$redcap_uri

testthat::expect_equal(url,  credential_user$redcap_uri)

test_that("Smoke Test", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  start_clean_result <-
    REDCapR:::clean_start_dag_write(
      batch   = FALSE,
      verbose = FALSE
    )
  project <- start_clean_result$redcap_project

  expect_type(start_clean_result, "list")
})

test_that("default", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  path_expected_before <- "test-data/specific-redcapr/write-dag/before.R"
  path_expected_after  <- "test-data/specific-redcapr/write-dag/after.R"
  start_clean_result <-
    REDCapR:::clean_start_dag_write(
      batch   = FALSE,
      verbose = FALSE
    )
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = url,
      token       = credential_user$token,
      verbose     = FALSE
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

  redcap_write_oneshot(
    ds          = ds_updated,
    redcap_uri  = url,
    token       = credential_user$token,
    verbose     = FALSE
  )
  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = url,
      token       = credential_admin$token,
      verbose     = FALSE
    )

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

test_that("default w/ batching", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  path_expected_before <- "test-data/specific-redcapr/write-dag/before.R"
  path_expected_after  <- "test-data/specific-redcapr/write-dag/after.R"
  start_clean_result <- REDCapR:::clean_start_dag_write(batch = TRUE)
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = url,
      token       = credential_user$token,
      verbose     = FALSE
    )

  # Use the same as the non-batched test
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

  redcap_write_oneshot(
    ds          = ds_updated,
    redcap_uri  = url,
    token       = credential_user$token,
    verbose     = FALSE
  )
  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = url,
      token       = credential_admin$token,
      verbose     = FALSE
    )

  # Use the same as the non-batched test
  expected_data_frame <- retrieve_expected(path_expected_after)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object$data$bmi<-NULL; returned_object$data$age<-NULL;dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("reassign subject to a different dag", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  # Step 1: Initialize the project
  start_clean_result <-
    REDCapR:::clean_start_dag_write(
      batch   = FALSE,
      verbose = FALSE
    )
  # url                <- start_clean_result$redcap_project$redcap_uri
  # token_for_admin    <- start_clean_result$redcap_project$token
  # token_for_dag_user <- "C79DB3836373478986928303B52E74DF"

  # Step 2a: Retrieve the dataset as admin.  The 3 subjects' DAGs are 'daga', 'daga', & 'dagb'
  ds_admin_1  <-
    redcap_read_oneshot(
      redcap_uri                = url,
      token                     = credential_admin$token,
      export_data_access_groups = TRUE,
      verbose                   = FALSE
    )$data
  expect_equal(nrow(ds_admin_1), 3L)
  expect_equal(ds_admin_1$record_id               , c("331-1", "331-2", "332-3"))
  expect_equal(ds_admin_1$redcap_data_access_group, c("daga", "daga", "dagb"   ))

  # Step 2b: Retrieve the dataset as user. Only the first two subjects are visible to DAG-A users initially.
  ds_user_1   <-
    redcap_read_oneshot(
      redcap_uri  = url,
      token       = credential_user$token,
      verbose     = FALSE
    )$data
  expect_equal(nrow(ds_user_1), 2L)
  expect_equal(ds_user_1$record_id, c("331-1", "331-2"))

  #Step 3: Reassign the 2nd subject and upload to server
  ds_admin_1$redcap_data_access_group[2] <- "dagb"
  redcap_write_oneshot(
    ds          = ds_admin_1,
    redcap_uri  = url,
    token       = credential_admin$token,
    verbose     = FALSE
  )

  # Step 4a: Retrieve the dataset as admin.  Should the 2nd row automatically change from '331-2' to '332-2'?
  ds_admin_2  <-
    redcap_read_oneshot(
      redcap_uri                = url,
      token                     = credential_admin$token,
      export_data_access_groups = TRUE,
      verbose                   = FALSE
    )$data
  expect_equal(nrow(ds_admin_2), 3L)
  expect_equal(ds_admin_2$record_id               , c("331-1", "331-2", "332-3"))
  # expect_equal(ds_admin_2$record_id               , c("331-1", "332-2", "332-3"))
  expect_equal(ds_admin_2$redcap_data_access_group, c("daga", "dagb", "dagb"   ))

  # Step 4b: Retrieve the dataset as user. Now only one subject is visible to DAG-A users.
  ds_user_2   <-
    redcap_read_oneshot(
      redcap_uri  = url,
      token       = credential_user$token,
      verbose     = FALSE
    )$data
  expect_equal(nrow(ds_user_2), 1L)
  expect_equal(ds_user_2$record_id, c("331-1"))
})

rm(update_expectation, credential_admin, credential_user, url)
