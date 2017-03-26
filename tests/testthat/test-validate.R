library(testthat)
context("Validate data frame for writing to REDCap")

ds_bad <- data.frame(
  record_id = 1:4,
  bad_logical = c(T, T, F, T),
  bad_Uppercase = c(4, 6, 8, 2)
)
ds_good <- data.frame(
  record_id = 1:4,
  not_logical = c(1, 1, 0, 1),
  no_uppercase = c(4, 6, 8, 2)
)

test_that("validate_for_write", {
  ds <- validate_for_write(d=ds_bad)
  expect_equal(object=nrow(ds), expected=2)
})

test_that("validate_for_write_no_errors", {
  ds <- validate_for_write(d=ds_good)
  expect_equal(object=nrow(ds), expected=0)
})

test_that("validate_field_names -stop on error", {
  expect_error(
    validate_no_logical(sapply(ds_bad, class), stop_on_error = TRUE),
    "1 field\\(s\\) were logical/boolean.  The REDCap API does not automatically convert boolean values to 0/1 values.  Convert the variable with the `as.integer\\(\\)` function."
  )
})

test_that("validate_no_logical -concern dataset", {
  ds <- validate_no_logical(sapply(ds_bad, class))
  expect_equal(object=nrow(ds), expected=1, info="One logical field should be flagged")
  expect_equal(object=ds$field_name, expected="bad_logical")
  expect_equal(object=ds$field_index, expected=2)
})

test_that("validate_field_names -stop on error", {
  expect_error(
    validate_field_names(colnames(ds_bad), stop_on_error = TRUE),
    "1 field name\\(s\\) violated the naming rules.  Only digits, lowercase letters, and underscores are allowed."
  )
})

test_that("validate_field_names -concern dataset", {
  ds <- validate_field_names(colnames(ds_bad))
  expect_equal(object=nrow(ds), expected=1, info="One uppercase field should be flagged")
  expect_equal(object=ds$field_name, expected="bad_Uppercase")
  expect_equal(object=ds$field_index, expected=3)
})
