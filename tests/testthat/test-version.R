library(testthat)
context("Version")

credential <- REDCapR::retrieve_credential_local(
  path_credential = system.file("misc/example.credentials", package="REDCapR"),
  project_id      = 153
)

test_that("Smoke Test", {
  testthat::skip_on_cran()
  expect_message(
    returned <- redcap_version(redcap_uri=credential$redcap_uri, token=credential$token)
  )
})

test_that("Version Successful", {
  testthat::skip_on_cran()
  expect_message(
    actual <- redcap_version(redcap_uri=credential$redcap_uri, token=credential$token)
  )

  expected <- package_version("9.0.0")
  expect_equal(actual, expected)
})

test_that("Version Unuccessful --bad token", {
  testthat::skip_on_cran()
  expect_message(
    actual <- redcap_version(redcap_uri=credential$redcap_uri, token="0000008476645C4E5F03428B8AC3AA7C")
  )

  expected <- package_version("0.0.0")
  expect_equal(actual, expected)
})
