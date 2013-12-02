require(testthat)

###########
context("Read Errors")
###########
test_that("Bad Uri", {
  uri <- "http://miechvprojects.ouhsc.edu/redcap/api/"
  token <- "9446D2E3FAA71ABB815A2336E4692AF3"
  certs <- "C:/Users/Will/Documents/Miechv/MReporting/Dal/Certs"
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, verbose=T)    
  )
  
  expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  expect_equal(returned_object$raw_csv, expected=raw(0))
  expect_true(is.null(returned_object$records_collapsed))
  expect_true(is.null(returned_object$fields_collapsed))
  expect_equal(returned_object$status_message, expected="Reading the REDCap data was not successful.  The error message was:\nError in textConnection(text) : invalid 'text' argument\n")
  expect_false(returned_object$success)
})
