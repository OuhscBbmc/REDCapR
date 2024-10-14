library(testthat)
update_expectation  <- FALSE
credential  <- retrieve_credential_testing() # read-only

test_that("One Shot: writing with read-only privileges", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  # expect_message(
  #   returned_object1 <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw")
  # )
  #
  # #Remove the calculated fields
  # returned_object1$data$bmi <- NULL
  # returned_object1$data$age <- NULL

  expected_message    <- "The REDCapR write/import operation was not successful.  The error message was:\nERROR: You do not have API Import/Update privileges"
  expected_text       <- "ERROR: You do not have API Import/Update privileges"

  result <-
    REDCapR::redcap_write_oneshot(
      ds          = mtcars,
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  expect_false(result$success)
  expect_equal(result$status_code, expected=403L)
  expect_equal(result$outcome_message, expected_message)
  expect_true( is.na(result$records_affected_count))
  expect_equal(result$affected_ids, character(0))
  expect_equal(result$raw_text, expected_text, ignore_attr = TRUE)

  expect_null( result$data)
  expect_null( result$records_collapsed)
  expect_null( result$fields_collapsed)
})


test_that("Single Batch: writing with read-only privileges", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  expected_message    <- "The REDCapR write/import operation was not successful.  The error message was:\nERROR: You do not have API Import/Update privileges"
  expected_text       <- "ERROR: You do not have API Import/Update privileges"

  # if (exists("result")) rm(result)
  expect_error(
    result <-
      REDCapR::redcap_write(
        ds          = mtcars,
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        verbose     = FALSE
      )
  )

  # expect_false(exists("result"))

  # expect_error(
  #   a <- REDCapR::redcap_write(ds=returned_object1$data, redcap_uri=credential$redcap_uri, token=credential$token)
  # )
})

test_that("Many Batches: writing with read-only privileges", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  expected_message    <- "The REDCapR write/import operation was not successful.  The error message was:\nERROR: You do not have API Import/Update privileges"
  expected_text       <- "ERROR: You do not have API Import/Update privileges"

  expect_error(
    result <-
      REDCapR::redcap_write(
        ds          = mtcars,
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        batch_size  = 10,
        verbose     = FALSE
      )
  )

  # expect_false(exists("result"))

  # expect_error(
  #   a <- REDCapR::redcap_write(ds=returned_object1$data, redcap_uri=credential$redcap_uri, token=credential$token)
  # )
})

test_that("Single Batch: writing with read-only privileges --contiue on error", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  expected_message    <- "The REDCapR write/import operation was not successful.  The error message was:\nERROR: You do not have API Import/Update privileges"

  expect_warning(
    result <-
      REDCapR::redcap_write(
        ds                = mtcars,
        redcap_uri        = credential$redcap_uri,
        token             = credential$token,
        continue_on_error = TRUE,
        verbose           = FALSE
      )
  )

  expect_false(result$success)
  expect_equal(result$status_code, expected="403")
  expect_equal(result$outcome_message, expected_message)
  expect_equal( result$records_affected_count, 0L)
  expect_equal(result$affected_ids, character(0))

  expect_null( result$raw_text)
  expect_null( result$records_collapsed)
  expect_null( result$fields_collapsed)

})

test_that("Many Batches: writing with read-only privileges --contiue on error", {
  testthat::skip_on_cran()
  skip_if_onlyread()

  expected_message    <- "The REDCapR write/import operation was not successful.  The error message was:\nERROR: You do not have API Import/Update privileges"

  expect_warning(expect_warning(expect_warning(expect_warning(
    result <-
      REDCapR::redcap_write(
        ds                  = mtcars,
        redcap_uri          = credential$redcap_uri,
        token               = credential$token,
        continue_on_error   = TRUE,
        batch_size          = 10,
        verbose             = FALSE
      )
  ))))

  expect_false(result$success)
  expect_equal(result$status_code, expected="403; 403; 403; 403")
  expect_match(result$outcome_message, expected_message)
  expect_equal( result$records_affected_count, 0L)
  expect_equal(result$affected_ids, character(0))

  expect_null( result$raw_text)
  expect_null( result$records_collapsed)
  expect_null( result$fields_collapsed)
})

rm(credential)
