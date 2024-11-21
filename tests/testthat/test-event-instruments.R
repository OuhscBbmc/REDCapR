library(testthat)

update_expectation  <- FALSE
credential_longitudinal    <- retrieve_credential_testing("longitudinal")

test_that("Smoke Test", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <-
      redcap_event_instruments(
        redcap_uri  = credential_longitudinal$redcap_uri,
        token       = credential_longitudinal$token
      )
  )
})
test_that("1-arm", {
  testthat::skip_on_cran()
  credential    <- retrieve_credential_testing("arm-single-longitudinal")
  path_expected <- "test-data/specific-redcapr/event-instruments/1-arm.R"
  expected_outcome_message <- "\\d+ event instrument metadata records were read from REDCap in \\d\\.\\d seconds\\.  The http status code was 200\\.(\\n)?"

  returned_object <-
    redcap_event_instruments(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      arms        = "2",
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
test_that("2-arms-retrieve-both-arms", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/event-instruments/2-arms-retrieve-both-arms.R"
  expected_outcome_message <- "\\d+ event instrument metadata records were read from REDCap in \\d\\.\\d seconds\\.  The http status code was 200\\.(\\n)?"

  returned_object_explicit <-
    redcap_event_instruments(
      redcap_uri  = credential_longitudinal$redcap_uri,
      token       = credential_longitudinal$token,
      arms        = c("1", "2"),
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
test_that("2-arms-retrieve-only-arm-1", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/event-instruments/2-arms-retrieve-only-arm-1.R"
  expected_outcome_message <- "\\d+ event instrument metadata records were read from REDCap in \\d\\.\\d seconds\\.  The http status code was 200\\.(\\n)?"

  returned_object <-
    redcap_event_instruments(
      redcap_uri  = credential_longitudinal$redcap_uri,
      token       = credential_longitudinal$token,
      arms        = "1",
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
test_that("2-arms-retrieve-only-arm-2", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/event-instruments/2-arms-retrieve-only-arm-2.R"
  expected_outcome_message <- "\\d+ event instrument metadata records were read from REDCap in \\d\\.\\d seconds\\.  The http status code was 200\\.(\\n)?"

  returned_object <-
    redcap_event_instruments(
      redcap_uri  = credential_longitudinal$redcap_uri,
      token       = credential_longitudinal$token,
      arms        = "2",
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
    returned_object <- redcap_event_instruments(
      redcap_uri  = bad_uri,
      token       = credential_longitudinal$token,
      verbose     = FALSE
    )
  # )

  expect_false(returned_object$success)
  expect_equal(returned_object$status_code, 403L)
  expect_match(returned_object$outcome_message, "The REDCapR instrument retrieval was not successful.+")
})
test_that("no-arms", {
  testthat::skip_on_cran()
  credential    <- retrieve_credential_testing()
  path_expected <- "test-data/specific-redcapr/event-instruments/no-arms.R"
  expected_outcome_message <- "You cannot export form/event mappings for classic projects(\\n)?"

  returned_object <-
    redcap_event_instruments(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      arms        = "2",
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=400L)
  expect_equal(returned_object$raw_text, expected="ERROR: You cannot export form/event mappings for classic projects", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_false(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "ERROR: You do not have permissions to use the API"

  returned_object <-
    redcap_event_instruments(
      redcap_uri  = credential_longitudinal$redcap_uri,
      token       = "BAD00000000000000000000000000000",
      verbose     = FALSE
    )

  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$raw_text, expected_outcome_message)
})

rm(credential_longitudinal)
