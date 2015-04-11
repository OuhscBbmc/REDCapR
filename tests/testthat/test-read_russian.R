library(testthat)

###########
context("Read Oneshot")
###########
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "D72C6485B52FE9F75D27B696977FBA43" #For `UnitTestPhiFree` account on pid=153.

test_that("Smoke Test", {  
  testthat::skip_on_cran()
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, verbose=T)    
  )
})
