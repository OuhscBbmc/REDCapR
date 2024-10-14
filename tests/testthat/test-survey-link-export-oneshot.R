library(testthat)

credential   <- retrieve_credential_testing("survey")
record       <- 1
instrument   <- "participant_morale_questionnaire"

test_that("Smoke Test", {
  testthat::skip_on_cran()

  suppressMessages({
    returned_object <-
      REDCapR::redcap_survey_link_export_oneshot(
        record         = record,
        instrument     = instrument,
        redcap_uri     = credential$redcap_uri,
        token          = credential$token,
        verbose        = TRUE
      )
  })
  expect_type(returned_object, "list")
})

test_that("Vanilla", {
  testthat::skip_on_cran()

  result <-
    REDCapR::redcap_survey_link_export_oneshot(
      record         = record,
      instrument     = instrument,
      redcap_uri     = credential$redcap_uri,
      token          = credential$token,
      verbose        = FALSE
    )

  # https://redcap-dev-2.ouhsc.edu/redcap/surveys/?s=EHXE4PNJW8E3MDAE
  expect_match(result$survey_link, "^https://.+?/redcap/surveys/\\?s=\\w+$")
  expect_true(result$success)
  expect_equal(result$status_code, 200L)
  expect_equal(result$instrument, "participant_morale_questionnaire")
  expect_equal(result$records_affected_count, 1L)
  expect_equal(result$affected_ids, c("1"))
})

test_that("Nonexistent Record ID", {
  testthat::skip_on_cran()

  record_bad <- -1

  result <-
    REDCapR::redcap_survey_link_export_oneshot(
      record         = record_bad,
      instrument     = instrument,
      redcap_uri     = credential$redcap_uri,
      token          = credential$token,
      verbose        = FALSE
    )

  expect_equal(result$survey_link, character(0))
  expect_false(result$success)
  expect_equal(result$status_code, 400L)
  expect_equal(result$instrument, "participant_morale_questionnaire")
  expect_equal(result$records_affected_count, 0L)
  expect_equal(result$affected_ids, character(0))
  expect_equal(result$raw_text, "ERROR: The record \"-1\" does not exist")
})

rm(credential, record, instrument)
