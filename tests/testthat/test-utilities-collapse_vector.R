library(testthat)

test_that("NULL", {
  elements  <- NULL
  expected  <- ""

  observed  <- REDCapR:::collapse_vector(elements)
  expect_equal(observed, expected)
})
test_that("specified", {
  elements  <- letters
  expected  <- "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"

  observed  <- REDCapR:::collapse_vector(elements)
  expect_equal(observed, expected)
})

#' REDCapR:::collapse_vector(elements=NULL, collapsed=NULL)
#' REDCapR:::collapse_vector(elements=letters, collapsed=NULL)
#' REDCapR:::collapse_vector(elements=NULL, collapsed="4,5,6")
