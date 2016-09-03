library(testthat)
context("Read Errors")

test_that("One Shot: Bad Uri -Not HTTPS", {
  expected_message_411 <- "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\"http://www.w3.org/TR/html4/strict.dtd\">\r\n<HTML><HEAD><TITLE>Length Required</TITLE>\r\n<META HTTP-EQUIV=\"Content-Type\" Content=\"text/html; charset=us-ascii\"></HEAD>\r\n<BODY><h2>Length Required</h2>\r\n<hr><p>HTTP Error 411. The request must be chunked or have a content length.</p>\r\n</BODY></HTML>\r\n"
  expected_message_501 <- "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><hash><error>The requested method is not implemented.</error></hash>"
  
  credential <- REDCapR::retrieve_credential_local(
    path_credential = base::file.path(devtools::inst(name="REDCapR"), "misc/example.credentials"),
    project_id      = 153
  )
  credential$redcap_uri <- "http://bbmc.ouhsc.edu/redcap/api/" #Not HTTPS
  
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)    
  )  

  expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  expect_true(returned_object$status_code %in% c(411L, 501L))
  expect_true(returned_object$raw_text %in% c(expected_message_411, expected_message_501))
  # expect_equal(returned_object$raw_text, expected=expected_message)
  expect_equal(returned_object$records_collapsed, "")
  expect_equal(returned_object$fields_collapsed, "")
  expect_false(returned_object$success)
})

test_that("One Shot: Bad Uri -wrong address", {
  expected_message <- "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\r\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n<head>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\"/>\r\n<title>404 - File or directory not found.</title>\r\n<style type=\"text/css\">\r\n<!--\r\nbody{margin:0;font-size:.7em;font-family:Verdana, Arial, Helvetica, sans-serif;background:#EEEEEE;}\r\nfieldset{padding:0 15px 10px 15px;} \r\nh1{font-size:2.4em;margin:0;color:#FFF;}\r\nh2{font-size:1.7em;margin:0;color:#CC0000;} \r\nh3{font-size:1.2em;margin:10px 0 0 0;color:#000000;} \r\n#header{width:96%;margin:0 0 0 0;padding:6px 2% 6px 2%;font-family:\"trebuchet MS\", Verdana, sans-serif;color:#FFF;\r\nbackground-color:#555555;}\r\n#content{margin:0 0 0 2%;position:relative;}\r\n.content-container{background:#FFF;width:96%;margin-top:8px;padding:10px;position:relative;}\r\n-->\r\n</style>\r\n</head>\r\n<body>\r\n<div id=\"header\"><h1>Server Error</h1></div>\r\n<div id=\"content\">\r\n <div class=\"content-container\"><fieldset>\r\n  <h2>404 - File or directory not found.</h2>\r\n  <h3>The resource you are looking for might have been removed, had its name changed, or is temporarily unavailable.</h3>\r\n </fieldset></div>\r\n</div>\r\n</body>\r\n</html>\r\n"
  
  credential <- REDCapR::retrieve_credential_local(
    path_credential = base::file.path(devtools::inst(name="REDCapR"), "misc/example.credentials"),
    project_id      = 153
  )
  credential$redcap_uri <- "https://bbmc.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/" #Wrong url
  
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)    
  )
  
  expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  expect_equal(returned_object$status_code, expected=404L)
  expect_equal(returned_object$raw_text, expected=expected_message)
  expect_equal(returned_object$records_collapsed, "")
  expect_equal(returned_object$fields_collapsed, "")
  expect_false(returned_object$success)
})

test_that("Batch: Bad Uri -Not HTTPS", {
  expected_outcome_message <- "The initial call failed with the code: (411|501)."
  
  credential <- REDCapR::retrieve_credential_local(
    path_credential = base::file.path(devtools::inst(name="REDCapR"), "misc/example.credentials"),
    project_id      = 153
  )
  credential$redcap_uri <- "http://bbmc.ouhsc.edu/redcap/api/" #Not HTTPS
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)    
  )  
  
  expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  expect_true(returned_object$status_code %in% c(411L, 501L))
  expect_equal(returned_object$records_collapsed, "failed in initial batch call")
  expect_equal(returned_object$fields_collapsed, "failed in initial batch call")
  expect_match(returned_object$outcome_messages, expected_outcome_message)
  expect_false(returned_object$success)
})

test_that("Batch: Bad Uri -wrong address", {
  expected_outcome_message <- "The initial call failed with the code: 404."
  
  credential <- REDCapR::retrieve_credential_local(
    path_credential = base::file.path(devtools::inst(name="REDCapR"), "misc/example.credentials"),
    project_id      = 153
  )
  credential$redcap_uri <- "https://bbmc.ouhsc.edu/redcappppp/apiFFFFFFFFFFFFFF/" #Wrong url

  expect_message(
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)    
  )
  
  expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  expect_equal(returned_object$status_code, expected=404L)
  expect_equal(returned_object$records_collapsed, "failed in initial batch call")
  expect_equal(returned_object$fields_collapsed, "failed in initial batch call")
  expect_equal(returned_object$outcome_messages, expected_outcome_message) 
  expect_false(returned_object$success)
})