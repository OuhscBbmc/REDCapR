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
test_that("first-subdirectory", {
  testthat::skip_on_cran()

  if (credential$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
    testthat::skip("The `folder_id` will be different on different servers.")
  }

  expected_message <- "The file repository structure describing 1 elements was read from REDCap in [0-9.]+ seconds\\.  The http status code was 200\\."

  path_expected <- "test-data/specific-redcapr/file-repo-list-oneshot/first-subdirectory.R"

  suppressMessages({
    expect_message(
      returned_object <-
        redcap_file_repo_list_oneshot(
          redcap_uri  = credential$redcap_uri,
          token       = credential$token,
          folder_id   = 1
        ),
      expected_message
    )
  })

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  #Test the values of the returned object.
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)

  expect_equal(nrow(returned_object$data), expected=1L)
  expect_equal(returned_object$data$name, expected_data_frame$name)
  expect_equal(class(returned_object$data$folder_id), "integer")
  expect_equal(class(returned_object$data$doc_id   ), "integer")
  expect_equal(
    !is.na(returned_object$data$folder_id),
    c(FALSE)
  )
  expect_equal(
    !is.na(returned_object$data$doc_id),
    c(TRUE)
  )

  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_message, perl=TRUE)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
})
test_that("bad-folder-id", {
  testthat::skip_on_cran()
  expected_message <- "ERROR: The File Repository folder folder_id=99 does not exist or else you do not have permission to that folder because it is DAG-restricted or Role-restricted."

  path_expected <- "test-data/specific-redcapr/file-repo-list-oneshot/bad-folder-id.R"

  suppressMessages({
    expect_message(
      returned_object <-
        redcap_file_repo_list_oneshot(
          redcap_uri  = credential$redcap_uri,
          token       = credential$token,
          folder_id   = 99
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

  expect_equal(nrow(returned_object$data), expected=0L)

  expect_false(returned_object$success)
  expect_equal(returned_object$status_code, expected=400L)
  expect_match(returned_object$outcome_message, regexp=expected_message, perl=TRUE)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equal(returned_object$raw_text, expected=expected_message, ignore_attr = TRUE) # dput(returned_object$raw_text)
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
