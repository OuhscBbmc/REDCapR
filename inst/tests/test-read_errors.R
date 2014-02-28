require(testthat)

###########
context("Read Errors")
###########
test_that("Bad Uri", {
  uri <- "http://bbmc.ouhsc.edu/redcap/api/" #Not HTTPS
  token <- "9A81268476645C4E5F03428B8AC3AA7B"
  certs <- "C:/Users/Will/Documents/Miechv/MReporting/Dal/Certs"
  
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, verbose=T)    
  )
  
  expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  expect_equal(returned_object$raw_csv, expected=raw(0))
  expect_true(is.null(returned_object$records_collapsed))
  expect_true(is.null(returned_object$fields_collapsed))
  if( getRversion() < "3.1.0")
    expect_equal(returned_object$status_message, expected="Reading the REDCap data was not successful.  The error message was:\nError in textConnection(text) : invalid 'text' argument\n")
  else
    expect_equal(returned_object$status_message, expected="Reading the REDCap data was not successful.  The error message was:\nError in textConnection(text, encoding = \"UTF-8\") : \n  invalid 'text' argument\n")
  expect_false(returned_object$success)
})
