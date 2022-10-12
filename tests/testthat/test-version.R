library(testthat)

credential  <- retrieve_credential_testing()

test_that("smoke", {
  testthat::skip_on_cran()
  returned <-
    redcap_version(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )
  expect_type(returned, "list")
})

test_that("version-successful", {
  testthat::skip_on_cran()
  actual <-
    redcap_version(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token,
    verbose     = FALSE
  )

  expected <- package_version("12.5.5")
  version_good <- (expected <= actual)
  expect_true(version_good)
})

test_that("version-unuccessful-bad-token", {
  testthat::skip_on_cran()
  actual <-
    redcap_version(
      redcap_uri  = credential$redcap_uri,
      token       = "BAD00000000000000000000000000000",
      verbose     = FALSE
    )

  expected <- package_version("0.0.0")
  expect_equal(actual, expected)
})

rm(credential)
