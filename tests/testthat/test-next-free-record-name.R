library(testthat)
context("Next Free Record Name")

credential <- REDCapR::retrieve_credential_local(
  path_credential = system.file("misc/example.credentials", package="REDCapR"),
  project_id      = 153
)

test_that("Smoke Test", {
  testthat::skip_on_cran()
  expect_message(
    returned <- redcap_next_free_record_name(redcap_uri=credential$redcap_uri, token=credential$token)
  )
})

test_that("Numeric ID", {
  testthat::skip_on_cran()
  expected <- "6"
  observed <- redcap_next_free_record_name(redcap_uri=credential$redcap_uri, token=credential$token)

  expect_equal(observed, expected)
})

test_that("Arm", {
  testthat::skip_on_cran()
  credential_arm <- REDCapR::retrieve_credential_local(
    path_credential = system.file("misc/example.credentials", package="REDCapR"),
    project_id      = 212
  )

  expected <- "305"
  observed <- redcap_next_free_record_name(redcap_uri=credential_arm$redcap_uri, token=credential_arm$token)

  expect_equal(observed, expected)
})

test_that("Character ID", {
  testthat::skip_on_cran()
  credential_character <- REDCapR::retrieve_credential_local(
    path_credential = system.file("misc/example.credentials", package="REDCapR"),
    project_id      = 998
  )

  expected <- "1"
  observed <- redcap_next_free_record_name(redcap_uri=credential_character$redcap_uri, token=credential_character$token)

  expect_equal(observed, expected)
})

test_that("DAG", {
  testthat::skip_on_cran()
  credential_dag <- REDCapR::retrieve_credential_local(
    path_credential = system.file("misc/example.credentials", package="REDCapR"),
    project_id      = 999
  )

  expected <- "331-3"
  observed <- redcap_next_free_record_name(redcap_uri=credential_dag$redcap_uri, token=credential_dag$token)

  expect_equal(observed, expected)
})
