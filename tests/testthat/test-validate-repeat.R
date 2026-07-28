library(testthat)

test_that("validate_repeat_instance: no column", {
  ds <- validate_repeat_instance(mtcars)
  expect_identical(object = nrow(ds), expected = 0L)
})

test_that("validate_repeat_instance: good", {
  d <-
    mtcars %>%
    dplyr::mutate(
      redcap_repeat_instance = sample(1:100, size = 32, replace = TRUE)
    )
  ds <- validate_repeat_instance(d)
  expect_identical(object = nrow(ds), expected = 0L)
})

test_that("validate_repeat_instance -double", {
  d <-
    tibble::tibble(
      redcap_repeat_instance = as.double(1:5)
    )

  expect_error(
    validate_repeat_instance(d, stop_on_error = TRUE),
    "The `redcap_repeat_instance` column should be an integer\\.  Use `as\\.integer\\(\\)` to cast it\\."
  )

  ds <- validate_repeat_instance(d)
  expect_identical(object=nrow(ds), expected=1L)
  expect_identical(object=ds$field_name, expected="redcap_repeat_instance")
  expect_identical(object=ds$field_index, expected="1")
})
