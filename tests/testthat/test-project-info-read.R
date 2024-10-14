library(testthat)

credential  <- retrieve_credential_testing()
update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()
  returned_object <-
    redcap_project_info_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      verbose       = FALSE
    )
  expect_type(returned_object, "list")
})

test_that("simple", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/project-info-read/simple.R"
  expected_outcome_message <- "\\d+ rows were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  if (credential$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
    testthat::skip("Skip when run a different server.")
  }

  returned_object <-
    redcap_project_info_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  # Don't compare the external modules, because they change so frequently.
  expected_data_frame$external_modules  <- NULL
  returned_object$data$external_modules <- NULL

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true( returned_object$success)
})

test_that("all-test-projects", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/project-info-read/all-test-projects.R"
  expected_outcome_message <- "\\d+ rows were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  if (credential$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
    testthat::skip("Skip when run a different server.")
  }
  server_locale <- readr::locale(tz = "America/Chicago")

  returned_object <-
    system.file("misc/dev-2.credentials", package = "REDCapR") %>%
    readr::read_csv(
      comment     = "#",
      col_select  = c(redcap_uri, token),
      col_types   = readr::cols(.default = readr::col_character()),
    ) %>%
    dplyr::filter(32L == nchar(token)) %>%
    purrr::pmap_dfr(
      REDCapR::redcap_project_info_read,
      locale  = server_locale,
      verbose = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  # Don't compare the external modules, because they change so frequently.
  expected_data_frame$external_modules  <- NULL
  returned_object$data$external_modules <- NULL

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_match(as.character(returned_object$status_code), regexp="200", perl=TRUE)
  expect_match(returned_object$raw_text, regexp="", perl=TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true( all(returned_object$success))
})

test_that("chicago", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/project-info-read/chicago.R"
  expected_outcome_message <- "\\d+ rows were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  if (credential$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
    testthat::skip("Skip when run a different server.")
  }

  server_locale <- readr::locale(tz = "America/Chicago")

  returned_object <-
    redcap_project_info_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      locale        = server_locale,
      verbose       = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  # Don't compare the external modules, because they change so frequently.
  expected_data_frame$external_modules  <- NULL
  returned_object$data$external_modules <- NULL

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true( returned_object$success)
})

rm(credential)
