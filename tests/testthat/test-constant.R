library(testthat)
context("Constant")

test_that("scalar w/ simplify", {
  expect_equal(object= constant("form_incomplete"    ), expected=0L)
  expect_equal(object= constant("form_unverified"    ), expected=1L)
  expect_equal(object= constant("form_complete"      ), expected=2L)
})

test_that("scalar w/o simplify", {
  expect_equal(object= constant("form_incomplete"    , simplify=T), expected=0L)
  expect_equal(object= constant("form_unverified"    , simplify=T), expected=1L)
  expect_equal(object= constant("form_complete"      , simplify=T), expected=2L)
})

test_that("vector w/ simplify", {
  expected <- c(2L, 2L, 0L)
  observed <- constant(c("form_complete", "form_complete", "form_incomplete"), simplify=T)
  expect_equal(observed, expected)
})

test_that("vector w/o simplify", {
  expected <- list(2L, 2L, 0L)
  observed <- constant(c("form_complete", "form_complete", "form_incomplete"), simplify=F)
  expect_equal(observed, expected)
})

test_that("bad-name", {
  # expected_error_message <- "Assertion on 'name' failed: Must be a subset of {'form_complete','form_incomplete','form_unverified'}, but is {'bad-name'}."
  expected_error_message <- "^Assertion on 'name' failed.+"

  expect_error(
    constant("bad-name"),
    expected_error_message
  )
  expect_error(
    constant(c("bad-name", "form_complete")),
    expected_error_message
  )
})

test_that("missing name", {
  # expected_error_message <- ""Assertion on 'name' failed: Must be a subset of {'form_complete','form_incomplete','form_unverified'}, but is {'bad-name'}.""Assertion on 'name' failed: Contains missing values (element 1)."
  expected_error_message <- "^Assertion on 'name' failed.+"

  expect_error(
    constant(NA_character_),
    expected_error_message
  )
  expect_error(
    constant(c(NA_character_, "form_complete")),
    expected_error_message
  )
})
