library(testthat)

credential  <- retrieve_credential_testing()
update_expectation  <- FALSE

test_that("Smoke Test", {
  testthat::skip_on_cran()
  expect_message({
    returned_object <-
      redcap_variables(
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        verbose     = TRUE
      )
  })
  expect_type(returned_object, "list")
})
test_that("default", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/variables/default.R"
  expected_outcome_message <- "\\d+ variable metadata records were read from REDCap in \\d\\.\\d seconds\\.  The http status code was 200\\.(\\n)?"

  returned_object <-
    redcap_variables(
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

test_that("Bad Uri -wrong address (1 of 2)", {
  testthat::skip_on_cran()
  expected_message <- "The requested URL was not found on this server\\."

  expect_error(
    redcap_variables(
      redcap_uri    = "https://redcap-dev-2.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/", # Wrong url
      token         = credential$token
    ),
    expected_message
  )
})
test_that("Bad Uri -wrong address (2 of 2)", {
  testthat::skip_on_cran()
  bad_uri <- "https://aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com"
  expected_data_frame <- structure(list(), .Names = character(0), row.names = integer(0), class = "data.frame")

  # Windows gives a different message than Travis/Linux
  expected_outcome_message <- "(https://aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com|Couldn't resolve host 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com')"
  # "The REDCapR variable retrieval was not successful\\..+?Error 405 \\(Method Not Allowed\\).+"
  # expected_outcome_message <- "(?s)The REDCapR variable retrieval was not successful\\..+?.+"

  expect_error(
    redcap_variables(
      redcap_uri  = bad_uri,
      token       = credential$token
    )#,
    # regexp = expected_outcome_message
  )

  # Now the error is thrown with a bad URI.
  # expected_outcome_message <- paste0("(?s)", expected_outcome_message)
  #
  # expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  # expect_equal(returned_object$status_code, expected=405L)
  # # expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  # expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  # expect_false(returned_object$success)
})
test_that("bad token -Error", {
  testthat::skip_on_cran()
  expected_error_message <- "ERROR: You do not have permissions to use the API"

  expect_error(
    redcap_variables(
      redcap_uri  = credential$redcap_uri,
      token       = "BAD00000000000000000000000000000"
    ),
    expected_error_message
  )
})

rm(credential)
