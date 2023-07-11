library(testthat)

test_that("validate_record_id_name: default", {
  d1 <- data.frame(
    record_id      = 1:4,
    flag_logical   = c(TRUE, TRUE, FALSE, TRUE),
    flag_Uppercase = c(4, 6, 8, 2)
  )

  ds <- validate_record_id_name(d1)
  expect_equal(object = nrow(ds), expected = 0)
})

test_that("validate_record_id_name: nondefault", {
  d1 <- data.frame(
    pt_id          = 1:4,
    flag_logical   = c(TRUE, TRUE, FALSE, TRUE),
    flag_Uppercase = c(4, 6, 8, 2)
  )

  ds <- validate_record_id_name(d1, record_id_name = "pt_id")
  expect_equal(object = nrow(ds), expected = 0)
})


test_that("validate_repeat_instance -stopping", {
  expect_error(
    validate_record_id_name(mtcars, stop_on_error = TRUE),
    "The field called `record_id` is not found in the dataset\\."
  )
})

test_that("validate_repeat_instance -not stopping", {
  ds <- validate_record_id_name(mtcars, stop_on_error = FALSE)

  expect_equal(object=nrow(ds), expected=1)
  expect_equal(object=ds$field_name, expected="record_id")
  expect_true(is.na(ds$field_index))
})
