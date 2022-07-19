library(testthat)

credential  <- retrieve_credential_testing()

test_that("One Shot: Bad Uri -Not HTTPS", {
  testthat::skip_on_cran()
  testthat::skip("Temporarily skip testing responses to the bad urls.")
  expected_error <- "The url `http://bbmc.ouhsc.edu/redcap/api/` is not found or throws an error\\."
  # expected_message_411 <- "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\"http://www.w3.org/TR/html4/strict.dtd\">\n<HTML><HEAD><TITLE>Length Required</TITLE>\n<META HTTP-EQUIV=\"Content-Type\" Content=\"text/html; charset=us-ascii\"></HEAD>\n<BODY><h2>Length Required</h2>\n<hr><p>HTTP Error 411. The request must be chunked or have a content length.</p>\n</BODY></HTML>\n"
  # expected_message_501 <- "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><hash><error>The requested method is not implemented.</error></hash>"

  expect_error(
    redcap_read_oneshot(
      redcap_uri    = "http://bbmc.ouhsc.edu/redcap/api/", # Not HTTPS
      token         = credential$token
    ),
    regexp=
  )

  # expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  # expect_true(returned_object$status_code %in% c(411L, 501L))
  # expect_true(returned_object$raw_text %in% c(expected_message_411, expected_message_501))
  # # expect_equal(returned_object$raw_text, expected=expected_message)
  # expect_equal(returned_object$records_collapsed, "")
  # expect_equal(returned_object$fields_collapsed, "")
  # expect_false(returned_object$success)
})

test_that("One Shot: Bad Uri -wrong address", {
  testthat::skip_on_cran()
  testthat::skip("Temporarily skip testing responses to the bad urls.")
  expected_message <- "The url `https://bbmc.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/` is not found or throws an error\\."

  expect_error(
    redcap_read_oneshot(
      redcap_uri    = "https://bbmc.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/", # Wrong url
      token         = credential$token
    ),
    expected_message
  )

})

test_that("Batch: Bad Uri -Not HTTPS", {
  testthat::skip_on_cran()
  testthat::skip("Temporarily skip testing responses to the bad urls.")
  expected_error <- "The url `http://bbmc.ouhsc.edu/redcap/api/` is not found or throws an error\\."

  expect_error(
    redcap_read(
      redcap_uri    = "http://bbmc.ouhsc.edu/redcap/api/", # Not HTTPS
      token         = credential$token
    ),
    expected_error
  )

  # expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  # expect_true(returned_object$status_code %in% c(411L, 501L))
  # expect_equal(returned_object$records_collapsed, "failed in initial batch call")
  # expect_equal(returned_object$fields_collapsed, "failed in initial batch call")
  # expect_match(returned_object$outcome_messages, expected_outcome_message)
  # expect_false(returned_object$success)
})

test_that("Batch: Bad Uri -wrong address", {
  testthat::skip_on_cran()
  testthat::skip("Temporarily skip testing responses to the bad urls.")
  expected_error <- "The url `https://bbmc.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/` is not found or throws an error."

  expect_error(
    redcap_read(
      redcap_uri    = "https://bbmc.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/", # Wrong url
      token         = credential$token
    ),
    expected_error
  )
})

test_that("hashed record -warn", {
  testthat::skip_on_cran()
  testthat::skip("Temporarily skip testing responses to the bad urls.")
  # This dinky little test is mostly to check that the warning message has legal syntax.
  expected_warning <- "^It appears that the REDCap record IDs have been hashed.+"

  expect_warning(
    REDCapR:::warn_hash_record_id(),
    expected_warning
  )
})

test_that("guess_max deprecated -warn", {
  testthat::skip_on_cran()
  testthat::skip("Temporarily skip testing responses to the bad urls.")
  expected_outcome_message <- "The `guess_max` parameter in `REDCapR::redcap_read\\(\\)` is deprecated\\."

  expect_warning(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      guess_max     = 100
    )
  )
})

rm(credential)
