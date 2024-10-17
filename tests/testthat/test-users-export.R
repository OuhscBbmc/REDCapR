library(testthat)

credential_1  <- retrieve_credential_testing("dag")
credential_2  <- retrieve_credential_testing()
update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()

  returned_object_1 <-
    redcap_users_export(
      redcap_uri  = credential_1$redcap_uri,
      token       = credential_1$token,
      verbose     = FALSE
    )
  expect_type(returned_object_1, "list")

  returned_object_2 <-
    redcap_users_export(
      redcap_uri  = credential_2$redcap_uri,
      token       = credential_2$token,
      verbose     = FALSE
    )
  expect_type(returned_object_2, "list")
})
test_that("with-dags", {
  testthat::skip_on_cran()
  path_expected_user        <- "test-data/specific-redcapr/users-export/with-dags--user.R"
  path_expected_user_form   <- "test-data/specific-redcapr/users-export/with-dags--user_form.R"
  expected_outcome_message  <- "The REDCap users were successfully exported in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."

  returned_object <-
    redcap_users_export(
      redcap_uri  = credential_1$redcap_uri,
      token       = credential_1$token,
      verbose     = FALSE
    )

  d_user <-
    returned_object$data_user |>
    dplyr::filter(username == "unittestphifree") |>
    dplyr::select(
      -email
    )

  # Check the group id exists
  expect_true(!is.na(d_user$data_access_group_id))

  # For these two specific servers, check the exact value of the id
  if (credential_1$redcap_uri == "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
    expect_equal(d_user$data_access_group_id, "20")
  } else if (credential_1$redcap_uri == "https://bbmc.ouhsc.edu/redcap/api/") {
    expect_equal(d_user$data_access_group_id, "331")
  }

  # Drop the ID because it won't match other servers
  d_user <-
    d_user |>
    dplyr::select(
      -data_access_group_id
    )

  d_user_form <-
    returned_object$data_user_form |>
    dplyr::filter(username == "unittestphifree")

  if (update_expectation) {
    save_expected(d_user     , path_expected_user     )
    save_expected(d_user_form, path_expected_user_form)
  }
  expected_data_user      <- retrieve_expected(path_expected_user     )
  expected_data_user_form <- retrieve_expected(path_expected_user_form)

  expect_equal(d_user     , expected=expected_data_user     , label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data_user);
  expect_equal(d_user_form, expected=expected_data_user_form, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data_user_form)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data_user       , "tbl")
  expect_s3_class(returned_object$data_user_form  , "tbl")
})
test_that("without DAGs", {
  testthat::skip_on_cran()
  path_expected_user        <- "test-data/specific-redcapr/users-export/without-dags--user.R"
  path_expected_user_form   <- "test-data/specific-redcapr/users-export/without-dags--user_form.R"
  expected_outcome_message  <- "The REDCap users were successfully exported in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."

  returned_object <-
    redcap_users_export(
      redcap_uri  = credential_2$redcap_uri,
      token       = credential_2$token,
      verbose     = FALSE
    )

  d_user <-
    returned_object$data_user |>
    dplyr::filter(username == "unittestphifree") |>
    dplyr::select(
      -email
    )

  d_user_form <-
    returned_object$data_user_form |>
    dplyr::filter(username == "unittestphifree")

  if (update_expectation) {
    save_expected(d_user     , path_expected_user     )
    save_expected(d_user_form, path_expected_user_form)
  }
  expected_data_user      <- retrieve_expected(path_expected_user     )
  expected_data_user_form <- retrieve_expected(path_expected_user_form)

  expect_equal(d_user     , expected=expected_data_user     , label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data_user);
  expect_equal(d_user_form, expected=expected_data_user_form, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data_user_form)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)

  expect_s3_class(returned_object$data_user       , "tbl")
  expect_s3_class(returned_object$data_user_form  , "tbl")
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
