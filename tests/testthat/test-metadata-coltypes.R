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

  ds <- redcap_read_oneshot(credential$redcap_uri, credential$token)$data
  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
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

  ds <- redcap_read_oneshot(credential$redcap_uri, credential$token)$data
  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})

test_that("superwide", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing(753L)
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/superwide.R"
  expected_outcome_message <- "col_types <- readr::cols"

  expect_message(
    regexp  = expected_outcome_message,
    actual  <- redcap_metadata_coltypes(credential$redcap_uri, credential$token)
  )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")

  ds <- redcap_read_oneshot(credential$redcap_uri, credential$token)$data
  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})

test_that("repeating-instruments", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing(1400L)
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/repeating-instruments.R"
  expected_outcome_message <- "col_types <- readr::cols"

  expect_message(
    regexp  = expected_outcome_message,
    actual  <- redcap_metadata_coltypes(credential$redcap_uri, credential$token)
  )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")

  ds <- redcap_read_oneshot(credential$redcap_uri, credential$token)$data
  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})

test_that("problematic-dictionary", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing(1425L)
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/problematic-dictionary.R"
  expected_outcome_message <- "col_types <- readr::cols"

  expect_message(
    regexp  = expected_outcome_message,
    actual  <- redcap_metadata_coltypes(credential$redcap_uri, credential$token)
  )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")

  # ds <- redcap_read_oneshot(credential$redcap_uri, credential$token)$data
  # col_metadata <- names(actual[[1]])
  # col_data     <- colnames(ds)
  #
  # expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})

test_that("validation-types", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing(2634L)
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/validation-types.R"
  # expected_outcome_message <- "col_types <- readr::cols"
  expected_warning_message <- "at least one field that specifies a comma for a decimal"

  expect_warning(
    regexp  = expected_warning_message,
    actual  <- redcap_metadata_coltypes(credential$redcap_uri, credential$token)
  )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")

  ds <- redcap_read_oneshot(credential$redcap_uri, credential$token)$data
  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})
