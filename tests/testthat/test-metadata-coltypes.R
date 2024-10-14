library(testthat)
update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing()
  expect_message(
    redcap_metadata_coltypes(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      print_col_types_to_console = TRUE,
      verbose     = FALSE
    )
  )
})

test_that("simple", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing()
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/simple.R"
  expected_outcome_message <- "col_types <- readr::cols"

  actual  <-
    redcap_metadata_coltypes(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      print_col_types_to_console = FALSE,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")
  # Project has dags, so record_id should be a character
  expect_equal(actual$cols$record_id, readr::col_character())

  ds <-
    redcap_read_oneshot(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )$data
  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})

test_that("longitudinal", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing("longitudinal")
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/longitudinal.R"
  expected_outcome_message <- "col_types <- readr::cols"

  actual  <-
    redcap_metadata_coltypes(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      print_col_types_to_console = FALSE,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")
  # Project does not have auto-numbering enabled, so study_id should be a character
  expect_equal(actual$cols$study_id, readr::col_character())

  ds <-
    redcap_read_oneshot(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )$data
  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})

test_that("superwide", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing("super-wide-1")
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/superwide.R"
  expected_outcome_message <- "col_types <- readr::cols"

  actual  <-
    redcap_metadata_coltypes(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      print_col_types_to_console = FALSE,
      verbose     = FALSE
    )

  # if (update_expectation) save_expected(actual, path_expected)
  # expected <- retrieve_expected(path_expected)
  #
  # expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")
  # Project has auto-numbering enabled, and no dags, so record_id should be an integer
  expect_equal(actual$cols$record_id, readr::col_integer())

  ds <-
    redcap_read_oneshot(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )$data

  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})

test_that("repeating-instruments", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing("repeating-instruments")
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/repeating-instruments.R"
  expected_outcome_message <- "col_types <- readr::cols"

  actual  <-
    redcap_metadata_coltypes(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      print_col_types_to_console = FALSE,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")

  ds <-
    redcap_read_oneshot(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )$data
  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})

test_that("problematic-dictionary", {
  testthat::skip_on_cran()
  credential               <- retrieve_credential_testing("potentially-problematic-dictionary")
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/problematic-dictionary.R"
  expected_outcome_message <- "col_types <- readr::cols"

  actual  <-
    redcap_metadata_coltypes(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      print_col_types_to_console = FALSE,
      verbose     = FALSE
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
  credential               <- retrieve_credential_testing("validation-types-1")
  path_expected            <- "test-data/specific-redcapr/metadata-coltypes/validation-types.R"
  # expected_outcome_message <- "col_types <- readr::cols"
  expected_warning_message <- "at least one field that specifies a comma for a decimal"

  expect_warning(
    actual <-
      redcap_metadata_coltypes(
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        print_col_types_to_console = FALSE,
        verbose     = FALSE
      )
  )

  if (update_expectation) save_expected(actual, path_expected)
  expected <- retrieve_expected(path_expected)

  expect_equal(actual, expected=expected, label="The returned col_types should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_s3_class(actual, "col_spec")

  ds <-
    redcap_read_oneshot(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )$data
  col_metadata <- names(actual[[1]])
  col_data     <- colnames(ds)

  expect_setequal(col_metadata, col_data)

  # setdiff(col_data, col_metadata)
  # setdiff(col_metadata, col_data)
})
