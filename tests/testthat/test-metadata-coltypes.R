library(testthat)

update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing(2634L)
  expect_warning(
    redcap_metadata_coltypes(credential$redcap_uri, credential$token)
  )
})

test_that("simple", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing()
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/simple.R"
  expected_outcome_message <- "col_types <- readr::cols"

  expect_message(
    regexp  = expected_outcome_message,
    actual  <- redcap_metadata_coltypes(credential$redcap_uri, credential$token)
  )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")
})

test_that("longitudinal", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing(212L)
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/longitudinal.R"
  expected_outcome_message <- "col_types <- readr::cols"

  expect_message(
    regexp  = expected_outcome_message,
    actual  <- redcap_metadata_coltypes(credential$redcap_uri, credential$token)
  )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")
})
