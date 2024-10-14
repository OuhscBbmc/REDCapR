library(testthat)

credential_1  <- retrieve_credential_testing("super-wide-1")
credential_2  <- retrieve_credential_testing("super-wide-2")
credential_3  <- retrieve_credential_testing("super-wide-3")

test_that("smoke test -superwide 1", {
  testthat::skip_on_cran()
  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = credential_1$redcap_uri,
      token       = credential_1$token,
      verbose     = FALSE
    )
  expect_type(returned_object, "list")
})
test_that("smoke test -superwide 2", {
  testthat::skip_on_cran()
  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = credential_2$redcap_uri,
      token       = credential_2$token,
      verbose     = FALSE
    )
  expect_type(returned_object, "list")
})
test_that("smoke test -superwide 3", {
  testthat::skip_on_cran()
  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = credential_3$redcap_uri,
      token       = credential_3$token,
      verbose     = FALSE
    )
  expect_type(returned_object, "list")
})

test_that("correct dimensions -superwide 1 -oneshot", {
  testthat::skip_on_cran()
  expected_outcome_message <- "2 records and 3,004 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expected_row_count <- 2L
  expected_column_count <- 3000L + 4L # 3,000 variables, plus `record_id` and three `form_q_complete`

  returned_object <-
    redcap_read_oneshot(
      redcap_uri  = credential_1$redcap_uri,
      token       = credential_1$token,
      verbose     = FALSE
    )

  expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
  expect_equal(ncol(returned_object$data), expected=expected_column_count)
  expect_false(any(is.na(returned_object$data)))

  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})
test_that("correct dimensions -superwide 1 -batch", {
  testthat::skip_on_cran()
  expected_outcome_message <- "2 records and 3,004 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expected_row_count <- 2L
  expected_column_count <- 3000L + 4L # 3,000 variables, plus `record_id` and three `form_q_complete`

  returned_object <-
    redcap_read(
      redcap_uri  = credential_1$redcap_uri,
      token       = credential_1$token,
      verbose     = FALSE
    )

  expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
  expect_equal(ncol(returned_object$data), expected=expected_column_count)
  expect_false(any(is.na(returned_object$data)))

  expect_true(  returned_object$success)
  expect_match( returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(  returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(  returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(  returned_object$filter_logic=="", "A filter was not specified.")
  expect_match( returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
  expect_s3_class(returned_object$data, "tbl")
})

# test_that("correct dimensions -superwide 3 -oneshot", {
#   testthat::skip_on_cran()
#
#   expected_outcome_message <- "20 records and 17,502 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#
#   expected_row_count <- 20L
#   expected_column_count <- 17502L
#
#   meta <- redcap_metadata_read(credential_3$redcap_uri, credential_3$token)
#   read <- redcap_read_oneshot( credential_3$redcap_uri, credential_3$token)
#
#
#   expect_message(
#     regexp           = expected_outcome_message,
#     returned_object <- redcap_read_oneshot(redcap_uri=credential_3$redcap_uri, token=credential_3$token)
#   )
#
#   expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
#   expect_equal(ncol(returned_object$data), expected=expected_column_count)
#   expect_false(any(is.na(returned_object$data)))
#
#   expect_equal(returned_object$status_code, expected=200L)
#   expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_true(returned_object$filter_logic=="", "A filter was not specified.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
# })
# test_that("correct dimensions -superwide 3 -batch", {
#   testthat::skip_on_cran()
#   expected_outcome_message <- "20 records and 17,502 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#
#   expected_row_count <- 20L
#   expected_column_count <- 17502L
#
#   expect_message(
#     regexp           = expected_outcome_message,
#     returned_object <- redcap_read(redcap_uri=credential_3$redcap_uri, token=credential_3$token)
#   )
#
#   expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
#   expect_equal(ncol(returned_object$data), expected=expected_column_count)
#   expect_false(any(is.na(returned_object$data)))
#
#   expect_true(  returned_object$success)
#   expect_match( returned_object$status_codes, regexp="200", perl=TRUE)
#   expect_true(  returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(  returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_true(  returned_object$filter_logic=="", "A filter was not specified.")
#   expect_match( returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
# })

rm(credential_1)
rm(credential_2)
rm(credential_3)
