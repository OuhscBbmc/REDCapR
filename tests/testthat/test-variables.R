library(testthat)

credential  <- retrieve_credential_testing()

test_that("Smoke Test", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <- redcap_variables(redcap_uri=credential$redcap_uri, token=credential$token)
  )
})
test_that("All Records -Default", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(original_field_name = c("record_id", "name_first",
    "name_last", "address", "telephone", "email", "dob", "age", "sex",
    "demographics_complete", "height", "weight", "bmi", "comments",
    "health_complete", "race", "race", "race", "race", "race", "race",
    "ethnicity", "race_and_ethnicity_complete"), choice_value = c(NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 1, 2,
    3, 4, 5, 6, NA, NA), export_field_name = c("record_id", "name_first",
    "name_last", "address", "telephone", "email", "dob", "age", "sex",
    "demographics_complete", "height", "weight", "bmi", "comments",
    "health_complete", "race___1", "race___2", "race___3", "race___4",
    "race___5", "race___6", "ethnicity", "race_and_ethnicity_complete"
    )), .Names = c("original_field_name", "choice_value", "export_field_name"
    ), row.names = c(NA, -23L), class = c("tbl_df", "tbl", "data.frame"
    ), spec = structure(list(cols = structure(list(original_field_name = structure(list(), class = c("collector_character",
    "collector")), choice_value = structure(list(), class = c("collector_double",
    "collector")), export_field_name = structure(list(), class = c("collector_character",
    "collector"))), .Names = c("original_field_name", "choice_value",
    "export_field_name")), default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )

  expected_outcome_message <- "23 variable metadata records were read from REDCap in \\d\\.\\d seconds\\.  The http status code was 200\\.(\\n)?"

  expect_message(
    returned_object <- redcap_variables(redcap_uri=credential$redcap_uri, token=credential$token),
    regexp = expected_outcome_message
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})


test_that("Bad URI", {
  testthat::skip_on_cran()
  bad_uri <- "https://aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com"
  expected_data_frame <- structure(list(), .Names = character(0), row.names = integer(0), class = "data.frame")

  # Windows gives a different message than Travis/Linux
  expected_outcome_message <- "(https://aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com|Couldn't resolve host 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com')"
  # "The REDCapR variable retrieval was not successful\\..+?Error 405 \\(Method Not Allowed\\).+"
   # expected_outcome_message <- "(?s)The REDCapR variable retrieval was not successful\\..+?.+"

  expect_error(
    returned_object <- redcap_variables(
      redcap_uri  = bad_uri,
      token       = credential$token
      )#,
    # regexp = expected_outcome_message
  )

  # Now thean error is thrown with a bad URI.
  # expected_outcome_message <- paste0("(?s)", expected_outcome_message)
  #
  # expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  # expect_equal(returned_object$status_code, expected=405L)
  # # expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  # expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  # expect_false(returned_object$success)
})
test_that("bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "ERROR: You do not have permissions to use the API"

  testthat::expect_message(
    returned_object <-
      redcap_variables(
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
