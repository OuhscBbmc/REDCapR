library(testthat)

test_that("sanitize token w/o line endings", {
  secret_token <- "12345678901234567890123456ABCDEF"

  returned <- REDCapR::sanitize_token(secret_token)
  expect_equal(returned, secret_token)
})

test_that("sanitize token w/ line endings", {
  secret_token <- "12345678901234567890123456ABCDEF\n"

  returned <- REDCapR::sanitize_token(secret_token)
  expect_equal(returned, substr(secret_token, 1L, 32L))
})

test_that("sanitize token w/o line endings", {
  secret_token <- "12345678901234567"

  expect_error(
    object    = sanitize_token(secret_token),
    regexp    = "^The token does not conform with the regex."
  )
})

test_that("sanitize token -NA", {
  secret_token <- NA_character_

  expect_error(
    object    = sanitize_token(secret_token),
    regexp    = "The token is `NA`, which is not allowed\\."
  )
})

test_that("sanitize token -empty", {
  secret_token <- ""

  expect_error(
    object    = sanitize_token(secret_token),
    regexp    = "The token is an empty string, which is not allowed\\."
  )
})

test_that("sanitize token - lowercase (#347)", {
  secret_token <- "12345678901234567890123456abcdef"

  returned <- REDCapR::sanitize_token(secret_token)
  # No change
  expect_equal(returned, secret_token)
})

test_that("sanitize token - env variable -success", {
  Sys.setenv("REDCAP_TOKEN_PATTERN" = "^([A-Za-z\\d+/\\+=]{10})$")
  base::on.exit(Sys.unsetenv("REDCAP_TOKEN_PATTERN"))

  secret_token <- "abcde1234="
  returned <- REDCapR::sanitize_token(secret_token)

  # No change
  expect_equal(returned, secret_token)
  Sys.getenv("REDCAP_TOKEN_PATTERN")
})
test_that("sanitize token - env variable -bad", {
  Sys.setenv("REDCAP_TOKEN_PATTERN" = "^([A-Za-z\\d+/\\+=]{10})$")
  base::on.exit(Sys.unsetenv("REDCAP_TOKEN_PATTERN"))

  secret_token <- "abcde12341234="

  expect_error(
    REDCapR::sanitize_token(secret_token),
    "^The token does not conform with the regex"
  )
})
