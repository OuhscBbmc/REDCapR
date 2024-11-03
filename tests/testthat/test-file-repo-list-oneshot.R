library(testthat)

credential <- retrieve_credential_testing("file-repo")
update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()
  expected_message <- "The file repository structure describing 6 elements was read from REDCap in [0-9.]+ seconds\\.  The http status code was 200\\."

  suppressMessages({
    expect_message(
      redcap_file_repo_list_oneshot(
        redcap_uri  = credential$redcap_uri,
        token       = credential$token
      ),
      expected_message
    )
  })
})
test_that("default", {
  testthat::skip_on_cran()
  expected_message <- "The file repository structure describing 6 elements was read from REDCap in [0-9.]+ seconds\\.  The http status code was 200\\."

  path_expected <- "test-data/specific-redcapr/file-repo-list-oneshot/default.R"

  suppressMessages({
    expect_message(
      returned_object <-
        redcap_file_repo_list_oneshot(
          redcap_uri  = credential$redcap_uri,
          token       = credential$token
        ),
      expected_message
    )
  })

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  #Test the values of the returned object.
  if (credential$redcap_uri == "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
    expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  }

  expect_equal(nrow(returned_object$data), expected=6L)
  expect_equal(returned_object$data$name, expected_data_frame$name)
  expect_equal(class(returned_object$data$folder_id), "integer")
  expect_equal(class(returned_object$data$doc_id   ), "integer")
  expect_equal(
    !is.na(returned_object$data$folder_id),
    c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE)
  )
  expect_equal(
    !is.na(returned_object$data$doc_id),
    c(FALSE, TRUE, TRUE, TRUE, TRUE, TRUE)
  )

  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_message, perl=TRUE)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
})

test_that("download w/ bad token -Error", {
  testthat::skip_on_cran()

  returned_object <-
    redcap_file_repo_list_oneshot(
      redcap_uri  = credential$redcap_uri,
      token       = "BAD00000000000000000000000000000",
      verbose     = FALSE
    )

  expected_data <- structure(list(), class = c("tbl_df", "tbl", "data.frame"), row.names = integer(0), names = character(0))
  testthat::expect_equal(returned_object$data, expected_data)

  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$raw_text, "ERROR: You do not have permissions to use the API")
})

rm(credential)
