library(testthat)
context("Constant")

test_that("constant -scalar", {
  expect_equal(object= constant("form_incomplete"    ), expected=0L)
  expect_equal(object= constant("form_unverified"    ), expected=1L)
  expect_equal(object= constant("form_complete"      ), expected=2L)
})

test_that("constant -scalar", {
  # expected_error_message <- "Assertion on 'name' failed: Must be a subset of {'form_complete','form_incomplete','form_unverified'}, but is {'bad-name'}."
  expected_error_message <- "^Assertion on 'name' failed.+"

  expect_error(
    constant("bad-name"),
    expected_error_message
  )
})
