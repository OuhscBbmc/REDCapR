library(testthat)

credential  <- retrieve_credential_testing()
update_expectation  <- FALSE

test_that("Smoke Test", {
  testthat::skip_on_cran()
  returned <-
    redcap_instruments(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )
  expect_type(returned, "list")
})

test_that("default", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/instruments/default.R"
  expected_outcome_message <- "\\d+ instrument metadata records were read from REDCap in \\d\\.\\d seconds\\.  The http status code was 200\\.(\\n)?"

  returned_object <-
    redcap_instruments(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("Bad URI", {
  testthat::skip_on_cran()
  bad_uri <- "https://aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com"
  # expected_data_frame <- structure(list(), .Names = character(0), row.names = integer(0), class = "data.frame")

  # Windows gives a different message than Travis/Linux
  # expected_outcome_message <- "(https://aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com|Couldn't resolve host 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com')"
  # "The REDCapR variable retrieval was not successful\\..+?Error 405 \\(Method Not Allowed\\).+"
  # expected_outcome_message <- "(?s)The REDCapR variable retrieval was not successful\\..+?.+"

  # expect_error(
    returned_object <-
      redcap_instruments(
        redcap_uri  = bad_uri,
        token       = credential$token,
        verbose     = FALSE
      )
  # )
  expect_false(returned_object$success)
  expect_equal(returned_object$status_code, 403L)
  expect_match(returned_object$outcome_message, "The REDCapR instrument retrieval was not successful.+")
})

test_that("bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "ERROR: You do not have permissions to use the API"

  testthat::expect_message(
    returned_object <-
      redcap_instruments(
        redcap_uri  = credential$redcap_uri,
        token       = "BAD00000000000000000000000000000"
      ),
    expected_outcome_message
  )

  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$raw_text, expected_outcome_message)
})

rm(credential)
