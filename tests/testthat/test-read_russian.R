library(testthat)

###########
context("Russian")
###########
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "D72C6485B52FE9F75D27B696977FBA43" #For `UnitTestPhiFree` account on pid=153.

test_that("Russian Recruit", {  
  testthat::skip_on_cran()
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, verbose=T)    
  )
  
  d <- returned_object$data
  d$recruitment_other
  
  expected_single <- "от сотрудницы"
  # expect_equal(d$recruitment_other[1], expected_single)
})

test_that("Russian Recruit", {  
  testthat::skip_on_cran()
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, verbose=T)    
  )
  
  d <- returned_object$data
  d$recruitment_other
  
  expected <- c("<U+043E><U+0442> <U+0441><U+043E><U+0442><U+0440><U+0443><U+0434><U+043D><U+0438><U+0446><U+044B>", 
                "<U+043C><U+0430><U+043C><U+0430> <U+0438> <U+0441><U+0435><U+0441><U+0442><U+0440><U+0430>", 
                "<U+043F><U+043E><U+0434><U+0440><U+0443><U+0433><U+0430> <U+043F><U+043E> <U+043E><U+0431><U+0449><U+0435><U+0436><U+0438><U+0442><U+0438><U+044E>")
  iconv("н", "UTF-8")
  iconv("s", "UTF-8")
  # expect_equal(d$recruitment_other, expected)
})
