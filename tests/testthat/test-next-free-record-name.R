library(testthat)

credential  <- retrieve_credential_testing()

test_that("Smoke Test", {
  testthat::skip_on_cran()
  returned <-
    redcap_next_free_record_name(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )
  expect_type(returned, "character")
})

test_that("Numeric ID", {
  testthat::skip_on_cran()
  expected <- "6"
  observed <-
    redcap_next_free_record_name(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  expect_equal(observed, expected)
})

test_that("Arm", {
  testthat::skip_on_cran()

  credential_arm  <- retrieve_credential_testing("longitudinal")

  expected <- "305"
  observed <-
    redcap_next_free_record_name(
      redcap_uri  = credential_arm$redcap_uri,
      token       = credential_arm$token,
      verbose     = FALSE
    )

  expect_equal(observed, expected)
})

test_that("Character ID", {
  testthat::skip_on_cran()

  credential_character <- retrieve_credential_testing("nonnumeric-record-id")

  expected <- "1"
  observed <-
    redcap_next_free_record_name(
      redcap_uri  = credential_character$redcap_uri,
      token       = credential_character$token,
      verbose     = FALSE
    )

  expect_equal(observed, expected)
})

test_that("DAG", {
  testthat::skip_on_cran()

  credential_dag <- retrieve_credential_testing("dag")
  if (credential_dag$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
    testthat::skip("Skipping test when run on a different server.")
  }

  expected <- "20-1"
  observed <-
    redcap_next_free_record_name(
      redcap_uri  = credential_dag$redcap_uri,
      token       = credential_dag$token,
      verbose     = FALSE
    )

  expect_equal(observed, expected)
})

test_that("bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The REDCap determination of the next free record id failed\\."

  expect_message(
    observed <-
      redcap_next_free_record_name(
        redcap_uri    = credential$redcap_uri,
        token         = "BAD00000000000000000000000000000"
      ),
    expected_outcome_message
  )
  testthat::expect_equal(observed, character(0))
})
rm(credential)
