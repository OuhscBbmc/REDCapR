library(testthat)

###########
context("Validate data frame for writing to REDCap")
###########
dfBad <- data.frame(
  record_id = 1:4,
  bad_logical = c(T, T, F, T),
  bad_Uppercase = c(4, 6, 8, 2)
)
dfGood <- data.frame(
  record_id = 1:4,
  not_logical = c(1, 1, 0, 1),
  no_uppercase = c(4, 6, 8, 2)
)



test_that("validate_for_write", {
  ds <- validate_for_write(d=dfBad)
  expect_equal(object=nrow(ds), expected=2)
})

test_that("validate_for_write_no_errors", {
  ds <- validate_for_write(d=dfGood)
  expect_equal(object=nrow(ds), expected=0)
})

test_that("validate_no_logical", {
  ds <- validate_no_logical(d=dfBad)
  expect_equal(object=nrow(ds), expected=1, info="One logical field should be flagged")
  expect_equal(object=ds$field_name, expected="bad_logical")
  expect_equal(object=ds$field_index, expected=2)
})

test_that("validate_no_uppercase", {
  ds <- validate_no_uppercase(d=dfBad)
  expect_equal(object=nrow(ds), expected=1, info="One uppercase field should be flagged")
  expect_equal(object=ds$field_name, expected="bad_Uppercase")
  expect_equal(object=ds$field_index, expected=3)
})
