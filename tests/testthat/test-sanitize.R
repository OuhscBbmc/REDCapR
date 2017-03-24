library(testthat)
context("Sanitize Token")

test_that("sanitize token w/o line endings", {
  secret_token <- "12345678901234567890123456ABCDEF"
  sanitize_token(secret_token)

  returned <- REDCapR::sanitize_token(secret_token)
  expect_equal(returned, secret_token)
})

test_that("sanitize token w/ line endings", {
  secret_token <- "12345678901234567890123456ABCDEF\n"
  sanitize_token(secret_token)

  returned <- REDCapR::sanitize_token(secret_token)
  expect_equal(returned, substr(secret_token, 1L, 32L))
})

test_that("sanitize token w/o line endings", {
  secret_token <- "12345678901234567"
  expect_error(
    object    = sanitize_token(secret_token),
    regexp    = "The token is not a valid 32-character hexademical value\\."
  )
})

test_that("sanitize token -NA", {
  secret_token <- NA_character_
  expect_error(
    object    = sanitize_token(secret_token),
    regexp    = "The token is `NA`, not a valid 32-character hexademical value\\."
  )
})

test_that("sanitize token -empty", {
  secret_token <- ""
  expect_error(
    object    = sanitize_token(secret_token),
    regexp    = "The token is an empty string, not a valid 32-character hexademical value\\."
  )
})
