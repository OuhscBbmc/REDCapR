library(testthat)

credential  <- retrieve_credential_testing(2634L)
update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()
  expect_warning(
    redcap_metadata_coltypes(credential$redcap_uri, credential$token)
  )
})

test_that("simple", {
  testthat::skip_on_cran()
  credential_simple        <- retrieve_credential_testing()
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/simple.R"
  expected_outcome_message <- "col_types <- readr::cols"

  expect_message(
    regexp          = expected_outcome_message,
    returned_object <- redcap_metadata_coltypes(credential_simple$redcap_uri, credential_simple$token)
  )

  if (update_expectation) save_expected(returned_object$col_types, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(returned_object$col_types, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(returned_object$col_types, "col_spec")
  expect_equal(returned_object$status_code, expected=200L)
  expect_true(returned_object$success)
})

test_that("longitudinal", {
  testthat::skip_on_cran()
  credential_simple        <- retrieve_credential_testing(212L)
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/longitudinal.R"
  expected_outcome_message <- "col_types <- readr::cols"

  expect_message(
    regexp          = expected_outcome_message,
    returned_object <- redcap_metadata_coltypes(credential_simple$redcap_uri, credential_simple$token)
  )

  if (update_expectation) save_expected(returned_object$col_types, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(returned_object$col_types, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(returned_object$col_types, "col_spec")
  expect_equal(returned_object$status_code, expected=200L)
  expect_true(returned_object$success)
})

rm(credential)
