library(testthat)

test_that("validate_uniqueness -good -all four", {
  d <- tibble::tribble(
    ~record_id, ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance,
    1L, "e1", "i1", 1L,
    1L, "e1", "i1", 2L,
    1L, "e1", "i1", 3L,
    1L, "e1", "i1", 4L,
    1L, "e1", "i2", 1L,
    1L, "e1", "i2", 2L,
    1L, "e1", "i2", 3L,
    1L, "e1", "i2", 4L,
    1L, "e2", "i1", 1L,
    1L, "e2", "i1", 2L,
    1L, "e2", "i1", 3L,
    1L, "e2", "i1", 4L,
    1L, "e2", "i2", 1L,
    1L, "e2", "i2", 2L,
    2L, "e1", "i1", 1L,
    2L, "e1", "i1", 2L,
    2L, "e1", "i1", 3L,
    2L, "e1", "i1", 4L,
  )

  ds <- validate_uniqueness(d)
  expect_equal(nrow(ds), 0)
})

test_that("validate_uniqueness -good -events", {
  d <- tibble::tribble(
    ~record_id, ~redcap_event_name,
    1L, "e1",
    1L, "e2",
    1L, "e3",
    1L, "e4",
    1L, "e5",
    2L, "e1",
    2L, "e2",
    2L, "e3",
  )

  ds <- validate_uniqueness(d)
  expect_equal(nrow(ds), 0)
})

test_that("validate_uniqueness -good -repeated", {
  d <- tibble::tribble(
    ~record_id, ~redcap_repeat_instrument, ~redcap_repeat_instance,
    1L, "i1", 1L,
    1L, "i1", 2L,
    1L, "i1", 3L,
    1L, "i1", 4L,
    1L, "i2", 1L,
    1L, "i2", 2L,
    1L, "i2", 3L,
    1L, "i2", 4L,
    2L, "i1", 1L,
    2L, "i1", 2L,
    2L, "i1", 3L,
    2L, "i1", 4L,
  )

  ds <- validate_uniqueness(d)
  expect_equal(nrow(ds), 0)
})

test_that("validate_uniqueness -bad -all four", {
  d <- tibble::tribble(
    ~record_id, ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance,
    1L, "e1", "i1", 1L,
    1L, "e1", "i1", 2L,
    1L, "e1", "i1", 3L,
    1L, "e1", "i1", 3L
  )

  expect_error(
    validate_uniqueness(d, stop_on_error = TRUE),
    "There are \\d+ record\\(s\\) that violate the uniqueness requirement:"
  )

  ds <- validate_uniqueness(d, stop_on_error = FALSE)
  expect_equal(object = nrow(ds), expected = 1)
  expect_equal(object = ds$field_name, expected = "record_id, redcap_event_name, redcap_repeat_instrument, redcap_repeat_instance")
  expect_equal(object = ds$field_index, expected = "1, 2, 3, 4")
})

test_that("validate_uniqueness -bad -events", {
  d <- tibble::tribble(
    ~record_id, ~redcap_event_name,
    1L, "e1",
    1L, "e2",
    1L, "e3",
    1L, "e4",
    1L, "e5",
    2L, "e1",
    2L, "e2",
    2L, "e1",
  )

  expect_error(
    validate_uniqueness(d, stop_on_error = TRUE),
    "There are \\d+ record\\(s\\) that violate the uniqueness requirement:"
  )

  ds <- validate_uniqueness(d, stop_on_error = FALSE)
  expect_equal(object = nrow(ds), expected = 1)
  expect_equal(object = ds$field_name, expected = "record_id, redcap_event_name")
  expect_equal(object = ds$field_index, expected = "1, 2")
})
