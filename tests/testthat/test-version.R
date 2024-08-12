library(testthat)

credential  <- retrieve_credential_testing()

test_that("smoke", {
  testthat::skip_on_cran()
  expect_message({
    returned <-
      redcap_version(
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        verbose     = TRUE
      )
  })
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

  expected <- package_version("13.7.1")
  version_good <- (expected <= actual)
  expect_true(version_good)
})

test_that("version-unsuccessful-bad-token", {
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
