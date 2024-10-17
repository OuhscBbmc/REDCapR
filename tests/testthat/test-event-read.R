library(testthat)

retrieve_expected_events <- function(path) {
  full_path   <- system.file(path, package = "REDCapR")
  if (!file.exists(full_path))
    stop("The expected file `", full_path, "` was not found.")  # nocov

  col_types <- readr::cols_only(
    event_name         = readr::col_character(),
    arm_num            = readr::col_integer(),
    unique_event_name  = readr::col_character(),
    custom_event_label = readr::col_character()#,
    # event_id           = readr::col_integer()
  )

  full_path %>%
    readr::read_csv(col_types = col_types)
}

empty_data_frame <-
  tibble::tibble(
    event_name         = character(0),
    arm_num            = integer(0),
    unique_event_name  = character(0),
    custom_event_label = character(0)#,
    # event_id           = integer(0)
  )

test_that("Longitudinal Single Arm", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing("arm-single-longitudinal")

  path_expected <- "test-data/projects/arm-single-longitudinal/event.csv"
  expected_data_frame <- retrieve_expected_events(path_expected)

  expected_outcome_message <- "The list of events was retrieved from the REDCap project in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object <-
    redcap_event_read(
      redcap_uri        = credential$redcap_uri,
      token             = credential$token,
      verbose           = FALSE
    )

  expect_true(all(!is.na(returned_object$data$event_id)))
  expect_true(all(0 < returned_object$data$event_id))

  returned_object$data$event_id <- NULL

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("Longitudinal Two Arms", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing("longitudinal")

  path_expected <- "test-data/projects/longitudinal/event.csv"
  expected_data_frame <- retrieve_expected_events(path_expected)

  expected_outcome_message <- "The list of events was retrieved from the REDCap project in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object <-
    redcap_event_read(
      redcap_uri        = credential$redcap_uri,
      token             = credential$token,
      verbose           = FALSE
    )

  expect_true(all(!is.na(returned_object$data$event_id)))
  expect_true(all(0 < returned_object$data$event_id))

  returned_object$data$event_id <- NULL

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("Classic", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing()

  expected_outcome_message <- "A 'classic' REDCap project has no events.  Retrieved in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message({
    returned_object <-
      redcap_event_read(
        redcap_uri        = credential$redcap_uri,
        token             = credential$token,
        verbose           = TRUE
      )
  })

  expect_true(all(!is.na(returned_object$data$event_id)))
  expect_true(all(0 < returned_object$data$event_id))

  returned_object$data$event_id <- NULL

  expect_equal(returned_object$data, expected=empty_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object$status_code, expected=400L)
  expect_equal(returned_object$raw_text, expected="ERROR: You cannot export events for classic projects", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_false(returned_object$success)
})

test_that("delete-multiple-arm", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing("arm-multiple-delete")

  path_expected <- "test-data/projects/arm-multiple-delete/event.csv"
  expected_data_frame <- retrieve_expected_events(path_expected)

  expected_outcome_message <- "The list of events was retrieved from the REDCap project in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object <-
    redcap_event_read(
      redcap_uri        = credential$redcap_uri,
      token             = credential$token,
      verbose           = FALSE
    )

  expect_true(all(!is.na(returned_object$data$event_id)))
  expect_true(all(0 < returned_object$data$event_id))

  returned_object$data$event_id <- NULL

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("delete-single-arm", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing("arm-single-delete")

  expected_outcome_message <- "A 'classic' REDCap project has no events.  Retrieved in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message({
    returned_object <-
      redcap_event_read(
        redcap_uri        = credential$redcap_uri,
        token             = credential$token,
        verbose           = TRUE
      )
  })

  expect_true(all(!is.na(returned_object$data$event_id)))
  expect_true(all(0 < returned_object$data$event_id))

  returned_object$data$event_id <- NULL

  expect_equal(returned_object$data, expected=empty_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object$status_code, expected=400L)
  expect_equal(returned_object$raw_text, expected="ERROR: You cannot export events for classic projects", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_false(returned_object$success)
})

test_that("Bad Token", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing("arm-single-longitudinal")
  bad_token   <- "1234567890ABCDEF1234567890ABCDEF"

  expected_error_message <- "The REDCapR event export failed\\. The http status code was 403. The error message was: 'ERROR: You do not have permissions to use the API'"
  expect_error(
    redcap_event_read(
      redcap_uri        = credential$redcap_uri,
      token             = bad_token,
      verbose           = FALSE
    ),
    regexp = expected_error_message
  )
})

rm(retrieve_expected_events, empty_data_frame)
