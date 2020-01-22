library(testthat)

credential  <- retrieve_credential_testing()

test_that("Smoke Test", {
  testthat::skip_on_cran()
  expect_message(
    returned <- redcap_version(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token
    )
  )
})

test_that("Version Successful", {
  testthat::skip_on_cran()
  expect_message(
    actual <- redcap_version(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token
    )
  )

  expected <- package_version("9.0.0")
  expect_equal(actual, expected)
})

test_that("Version Unuccessful --bad token", {
  testthat::skip_on_cran()
  expect_message(
    actual <- redcap_version(
      redcap_uri  = credential$redcap_uri,
      token       = "BAD00000000000000000000000000000"
      )
  )

  expected <- package_version("0.0.0")
  expect_equal(actual, expected)
})

rm(credential)
