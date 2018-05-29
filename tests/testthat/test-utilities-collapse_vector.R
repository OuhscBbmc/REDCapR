library(testthat)
context("collapse_vector")

test_that("both NULL", {
  elements  <- NULL
  collapsed <- NULL
  expected  <- ""

  observed  <- REDCapR:::collapse_vector(elements, collapsed)
  expect_equal(observed, expected)
})
test_that("collapsed NULL", {
  elements  <- letters
  collapsed <- NULL
  expected  <- "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"

  observed  <- REDCapR:::collapse_vector(elements, collapsed)
  expect_equal(observed, expected)
})
test_that("elements NULL", {
  elements  <- NULL
  collapsed <- "4,5,6"
  expected  <- collapsed

  observed  <- REDCapR:::collapse_vector(elements, collapsed)
  expect_equal(observed, expected)
})

#' REDCapR:::collapse_vector(elements=NULL, collapsed=NULL)
#' REDCapR:::collapse_vector(elements=letters, collapsed=NULL)
#' REDCapR:::collapse_vector(elements=NULL, collapsed="4,5,6")
