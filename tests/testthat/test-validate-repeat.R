library(testthat)

test_that("repeat-instance: no column", {
  ds <- validate_repeat_instance(mtcars)
  expect_equal(object = nrow(ds), expected = 0)
})
