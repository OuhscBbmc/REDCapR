library(testthat)

credential_1  <- retrieve_credential_testing(999L)
credential_2  <- retrieve_credential_testing()
update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()
  expect_message({
    returned_object_1 <- redcap_users_export(redcap_uri=credential_1$redcap_uri, token=credential_1$token)
    returned_object_2 <- redcap_users_export(redcap_uri=credential_2$redcap_uri, token=credential_2$token)
  })
})

test_that("with-dags", {
  testthat::skip_on_cran()
  path_expected_user        <- "test-data/specific-redcapr/users-export/with-dags--user.R"
  path_expected_user_form   <- "test-data/specific-redcapr/users-export/with-dags--user_form.R"
  expected_outcome_message  <- "The REDCap users were successfully exported in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_users_export(redcap_uri=credential_1$redcap_uri, token=credential_1$token)
  )

  if (update_expectation) {
    save_expected(returned_object$data_user     , path_expected_user     )
    save_expected(returned_object$data_user_form, path_expected_user_form)
  }
  expected_data_user      <- retrieve_expected(path_expected_user     )
  expected_data_user_form <- retrieve_expected(path_expected_user_form)

  expect_equal(returned_object$data_user     , expected=expected_data_user     , label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data_user);
  expect_equal(returned_object$data_user_form, expected=expected_data_user_form, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data_user_form)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("without DAGs", {
  testthat::skip_on_cran()
  path_expected_user        <- "test-data/specific-redcapr/users-export/without-dags--user.R"
  path_expected_user_form   <- "test-data/specific-redcapr/users-export/without-dags--user_form.R"
  expected_outcome_message  <- "The REDCap users were successfully exported in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_users_export(redcap_uri=credential_2$redcap_uri, token=credential_2$token)
  )

  if (update_expectation) {
    save_expected(returned_object$data_user     , path_expected_user     )
    save_expected(returned_object$data_user_form, path_expected_user_form)
  }
  expected_data_user      <- retrieve_expected(path_expected_user     )
  expected_data_user_form <- retrieve_expected(path_expected_user_form)

  expect_equal(returned_object$data_user     , expected=expected_data_user     , label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data_user);
  expect_equal(returned_object$data_user_form, expected=expected_data_user_form, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data_user_form)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "ERROR: You do not have permissions to use the API"

  testthat::expect_message(
    returned_object <-
      REDCapR::redcap_users_export(
        redcap_uri  = credential_2$redcap_uri,
        token       = "BAD00000000000000000000000000000"
      ),
    expected_outcome_message
  )

  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$raw_text, expected_outcome_message)
})

rm(credential_1, credential_2)
