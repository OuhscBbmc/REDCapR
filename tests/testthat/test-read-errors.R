library(testthat)

credential  <- retrieve_credential_testing()

test_that("One Shot: Bad Uri -Not HTTPS", {
  testthat::skip_on_cran()
  testthat::skip("The response is dependent on the client.  This test is probably too picky anyway.")
  # expected_message_411 <- "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\"http://www.w3.org/TR/html4/strict.dtd\">\n<HTML><HEAD><TITLE>Length Required</TITLE>\n<META HTTP-EQUIV=\"Content-Type\" Content=\"text/html; charset=us-ascii\"></HEAD>\n<BODY><h2>Length Required</h2>\n<hr><p>HTTP Error 411. The request must be chunked or have a content length.</p>\n</BODY></HTML>\n"
  # expected_message_501 <- "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><hash><error>The requested method is not implemented.</error></hash>"

  expect_error(
    redcap_read_oneshot(
      redcap_uri    = "http://redcap-dev-2.ouhsc.edu/redcap/api/", # Not HTTPS
      token         = credential$token
    )
  )
})

test_that("One Shot: Bad Uri -wrong address", {
  testthat::skip_on_cran()
  expected_message <- "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>404 Not Found</title>\n</head><body>\n<h1>Not Found</h1>\n<p>The requested URL was not found on this server.</p>\n</body></html>\n"

  returned_object <-
    redcap_read_oneshot(
      redcap_uri    = "https://redcap-dev-2.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/", # Wrong url
      token         = credential$token,
      verbose       = FALSE
    )

  expect_equal(returned_object$data, expected=tibble::tibble(), label="An empty data.frame should be returned.", ignore_attr = TRUE)
  expect_equal(returned_object$status_code, expected=404L)
  expect_equal(returned_object$raw_text, expected=expected_message)
  expect_equal(returned_object$records_collapsed, "")
  expect_equal(returned_object$fields_collapsed, "")
  expect_false(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("Batch: Bad Uri -Not HTTPS", {
  testthat::skip_on_cran()
  testthat::skip("The response is dependent on the client.  This test is probably too picky anyway.")
  # expected_outcome_message <- "The initial call failed with the code: (411|501)."

  expect_error(
    redcap_read(
      redcap_uri    = "http://redcap-dev-2.ouhsc.edu/redcap/api/", # Not HTTPS
      token         = credential$token
    )
  )
})

test_that("Batch: Bad Uri -wrong address", {
  testthat::skip_on_cran()
  # expected_message <- "The initial call failed with the code: 404."
  expected_message <- "The requested URL was not found on this server."

  expect_error(
    redcap_read(
      redcap_uri    = "https://redcap-dev-2.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/", # Wrong url
      token         = credential$token
    ),
    expected_message
  )
})

test_that("hashed record -warn", {
  testthat::skip_on_cran()
  # This dinky little test is mostly to check that the warning message has legal syntax.
  expected_warning <- "^It appears that the REDCap record IDs have been hashed.+"

  expect_warning(
    REDCapR:::warn_hash_record_id(),
    expected_warning
  )
})

test_that("guess_max deprecated -warn", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The `guess_max` parameter in `REDCapR::redcap_read\\(\\)` is deprecated\\."

  expect_warning(
    regexp           = expected_outcome_message,
    redcap_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      guess_max     = 100,
      verbose       = FALSE
    )
  )
})

rm(credential)
