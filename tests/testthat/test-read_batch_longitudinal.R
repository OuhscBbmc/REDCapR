library(testthat)

###########
context("Read Batch - Longitudinal")
###########
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "0434F0E9CF53ED0587847AB6E51DE762" #For `UnitTestPhiFree` account on pid=212.
project <- redcap_project$new(redcap_uri=uri, token=token)
directory_relative <- "test_data/project_longitudinal/expected"

test_that("Smoke Test", {  
  testthat::skip_on_cran()
  
  #Static method w/ default batch size
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, verbose=T)    
  )  
  
  #Static method w/ tiny batch size
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, verbose=T, batch_size=2)    
  )
  
  #Instance method w/ default batch size
  expect_message(
    returned_object <- project$read()
  )  
  
  #Instance method w/ tiny batch size
  expect_message(
    returned_object <- project$read(batch_size=2)
  )
})

test_that("SO example for data.frame retreival", {   
  file_name <- "dummy.rds"
  path_qualified <- base::file.path(devtools::inst(name="REDCapR"), directory_relative, file_name)
  
  actual <- data.frame(a=1:5, b=6:10) # saveRDS(actual, file.path("./inst", directory_relative, file_name))
  # browser() #getwd()
  expect_true(file.exists(path_qualified), "The saved data.frame should be retrieved from disk.")
  expected <- readRDS(path_qualified)
  expect_equal(actual, expected, label="The returned data.frame should be correct")
})

test_that("All Records -Default", {   
  testthat::skip_on_cran()  
  
  file_name <- "default.rds"
  path_qualified <- base::file.path(devtools::inst(name="REDCapR"), directory_relative, file_name)
  
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  # saveRDS(returned_object1$data, file.path("./inst", directory_relative, file_name), compress="xz")
  expected_data_frame <- readRDS(path_qualified)
  # expected_data_frame <- eval(parse(path_expected), enclos = new.env()) #dput(returned_object1$data, file=path_expected)
  
  ###########################
  ## Default Batch size
  expect_message(
    returned_object1 <- redcap_read(redcap_uri=uri, token=token, verbose=T),
    regexp = expected_outcome_message
  )  
  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  # expect_match(returned_object1$status_messages, regexp="OK", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)  
  
  ###########################
  ## Tiny Batch size
  expect_message(
    returned_object2 <- redcap_read(redcap_uri=uri, token=token, verbose=T, batch_size=8),
    regexp = expected_outcome_message
  )
  
  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  # expect_match(returned_object2$status_messages, regexp="OK", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})


