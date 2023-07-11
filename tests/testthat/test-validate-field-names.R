library(testthat)

ds_bad <- data.frame(
  record_id = 1:4,
  bad_logical = c(TRUE, TRUE, FALSE, TRUE),
  bad_Uppercase = c(4, 6, 8, 2)
)
ds_good <- data.frame(
  record_id = 1:4,
  not_logical = c(1, 1, 0, 1),
  no_uppercase = c(4, 6, 8, 2)
)

test_that("validate_field_names -good", {
  ds <- validate_field_names(ds_good)
  expect_equal(nrow(ds), 0)
})

test_that("validate_field_names -stop on error", {
  expect_error(
    validate_field_names(ds_bad, stop_on_error = TRUE),
    "1 field name\\(s\\) violated the naming rules.  Only digits, lowercase letters, and underscores are allowed."
  )
})

test_that("validate_field_names -uppercase", {
  d_bad <- data.frame(record_ID = 1:4)
  expect_error(
    validate_field_names(d_bad, stop_on_error = TRUE),
    "1 field name\\(s\\) violated the naming rules.  Only digits, lowercase letters, and underscores are allowed."
  )
})

test_that("validate_field_names -concern dataset", {
  ds <- validate_field_names(ds_bad)
  expect_equal(object=nrow(ds), expected=1, info="One uppercase field should be flagged")
  expect_equal(object=ds$field_name, expected="bad_Uppercase")
  expect_equal(object=ds$field_index, expected="3")
})


test_that("assert_field_names -good", {
  expect_no_condition(
    assert_field_names(colnames(ds_good))
  )
})

test_that("assert_field_names -bad", {
  expect_error(
    assert_field_names(colnames(ds_bad)),
    "1 field name\\(s\\) violated the naming rules\\."
  )
})
