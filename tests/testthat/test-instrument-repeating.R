library(testthat)

update_expectation  <- FALSE
credential_repeating    <- retrieve_credential_testing("repeating-instruments")

test_that("Smoke Test", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <-
      redcap_repeating_read(
        redcap_uri  = credential_repeating$redcap_uri,
        token       = credential_repeating$token
      )
  )
})
test_that("simple repeating", {
  testthat::skip_on_cran()
  path_expected <- ""
  expected_outcome_message <- "\\d+ repeating event-instrument metadata metadata records were read from REDCap in \\d\\.\\d seconds\\.  The http status code was 200\\.(\\n)?"

  returned_object <-
    redcap_repeating_read(
      redcap_uri  = credential_repeating$redcap_uri,
      token       = credential_repeating$token,
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
test_that("longitudinal repeating", {
  testthat::skip_on_cran()
  # Add credential for longitudinal project with repeating events here!
  credential    <- retrieve_credential_testing()
  path_expected <- ""
  expected_outcome_message <- "\\d+ repeating event-instrument metadata metadata records were read from REDCap in \\d\\.\\d seconds\\.  The http status code was 200\\.(\\n)?"

  returned_object_explicit <-
    redcap_repeating_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object_explicit$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(   returned_object_explicit$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(   returned_object_explicit$status_code, expected=200L)
  expect_equal(   returned_object_explicit$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(   returned_object_explicit$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(    returned_object_explicit$success)
  expect_s3_class(returned_object_explicit$data, "tbl")

  returned_object_default <-
    redcap_event_instruments(
      redcap_uri  = credential_longitudinal$redcap_uri,
      token       = credential_longitudinal$token,
      verbose     = FALSE
    )

  expect_equal(   returned_object_default$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(   returned_object_default$status_code, expected=200L)
  expect_equal(   returned_object_default$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(   returned_object_default$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(    returned_object_default$success)
  expect_s3_class(returned_object_default$data, "tbl")
})
test_that("Bad URI", {
  testthat::skip()
  testthat::skip_on_cran()
  bad_uri <- "https://aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com"
  # expected_data_frame <- structure(list(), .Names = character(0), row.names = integer(0), class = "data.frame")

  # Windows gives a different message than Travis/Linux
  # expected_outcome_message <- "(https://aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com|Couldn't resolve host 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com')"
  # "The REDCapR variable retrieval was not successful\\..+?Error 405 \\(Method Not Allowed\\).+"
  # expected_outcome_message <- "(?s)The REDCapR variable retrieval was not successful\\..+?.+"

  # expect_error(
    returned_object <- redcap_repeating_read(
      redcap_uri  = bad_uri,
      token       = credential_repeating$token,
      verbose     = FALSE
    )
  # )

  expect_false(returned_object$success)
  expect_equal(returned_object$status_code, 403L)
  expect_match(returned_object$outcome_message, "The REDCapR instrument retrieval was not successful.+")
})
test_that("no repeating", {
  testthat::skip_on_cran()
  credential    <- retrieve_credential_testing("simple")
  path_expected <- ""
  expected_outcome_message <- "You cannot export repeating instruments and events because the project does not contain any repeating instruments and events(\\n)?"

  returned_object <-
    redcap_repeating_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=400L)
  expect_equal(returned_object$raw_text, expected="ERROR: You cannot export repeating instruments and events because the project does not contain any repeating instruments and events", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_false(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "ERROR: You do not have permissions to use the API"

  returned_object <-
    redcap_repeating_read(
      redcap_uri  = credential_repeating$redcap_uri,
      token       = "BAD00000000000000000000000000000",
      verbose     = FALSE
    )

  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$raw_text, expected_outcome_message)
})

rm(credential_repeating)
