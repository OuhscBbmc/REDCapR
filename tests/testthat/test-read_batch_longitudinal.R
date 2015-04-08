library(testthat)

###########
context("Read Batch - Longitudinal")
###########
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "0434F0E9CF53ED0587847AB6E51DE762" #For `UnitTestPhiFree` account on pid=153.
project <- redcap_project$new(redcap_uri=uri, token=token)

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

# test_that("All Records -Default", {   
#   testthat::skip_on_cran()
#   path_expected <- "./inst/test_data/project_longitudinal/expected/default.rds"
#   expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#   
#   expect_message(
#     returned_object1 <- redcap_read(redcap_uri=uri, token=token, verbose=T),
#     regexp = expected_outcome_message
#   )
#   
#   # saveRDS(returned_object1$data, file=path_expected, ascii=F)#, compress="xz")
#   # dump("returned_object1$data", file=path_expected)
#   expected_data_frame <- readRDS(path_expected)
#   # expected_data_frame <- eval(parse(path_expected), enclos = new.env()) #dput(returned_object1$data, file=path_expected)
#   expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # 
#   
#   expect_true(returned_object1$success)
#   expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
#   # expect_match(returned_object1$status_messages, regexp="OK", perl=TRUE)
#   expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
# })
test_that("SO example for data.frame retreival", {   
  # path_relative <- "inst/test_data/project_longitudinal/expected/dummy.rds"
  # path_qualified <- base::system.file(path_relative, package="REDCapR")
  path_qualified <- base::file.path(devtools::inst(name="REDCapR"), "test_data/project_longitudinal/expected/dummy.rds")
  
  actual <- data.frame(a=1:5, b=6:10) #saveRDS(actual, file=path_relative)
  # warning(getwd())
  # browser()
  expect_true(file.exists(path_qualified), "The saved data.frame should be retrieved from disk.")
  expected <- readRDS(path_qualified)
  expect_equal(actual, expected, label="The returned data.frame should be correct")
})
