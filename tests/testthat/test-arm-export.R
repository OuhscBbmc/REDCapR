library(testthat)

read_arms <- function(path) {
  full_path   <- system.file(path, package = "REDCapR")
  if (!file.exists(full_path))
    stop("The expected file `", full_path, "` was not found.")  # nocov

  col_types <- readr::cols(
    arm_num = readr::col_integer(),
    name    = readr::col_character()
  )
  full_path %>%
    readr::read_csv(col_types = col_types) %>%
    dplyr::select(
      arm_number  = "arm_num",
      arm_name    = "name"
    )
}

empty_data_frame <-
  tibble::tibble(
    arm_number = integer(0),
    arm_name   = character(0)
  )

test_that("delete-multiple-arm", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing(2627L)

  path_expected <- "test-data/delete-multiple-arm/arm.csv"
  expected_data_frame <- read_arms(path_expected)
  # start_clean_result <- REDCapR:::clean_start_delete_single_arm()

  expected_outcome_message <- "The list of arms was retrieved from the REDCap project in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object <-
    redcap_arm_export(
      redcap_uri        = credential$redcap_uri,
      token             = credential$token,
      verbose           = FALSE
    )

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("delete-single-arm", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing(2626L)

  expected_outcome_message <- "A 'classic' REDCap project has no arms.  Retrieved in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message({
    returned_object <-
      redcap_arm_export(
        redcap_uri        = credential$redcap_uri,
        token             = credential$token,
        verbose           = TRUE
      )
  })

  expect_equal(returned_object$data, expected=empty_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object$status_code, expected=400L)
  expect_equal(returned_object$raw_text, expected="ERROR: You cannot export arms for classic projects", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_false(returned_object$success)
})

test_that("Longitudinal Two Arms", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing(212L)

  path_expected <- "test-data/project-longitudinal/arm.csv"
  expected_data_frame <- read_arms(path_expected)

  expected_outcome_message <- "The list of arms was retrieved from the REDCap project in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object <-
    redcap_arm_export(
      redcap_uri        = credential$redcap_uri,
      token             = credential$token,
      verbose           = FALSE
    )

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("Longitudinal Single Arm", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing(2629L)

  path_expected <- "test-data/longitudinal-single-arm/arm.csv"
  expected_data_frame <- read_arms(path_expected)

  expected_outcome_message <- "The list of arms was retrieved from the REDCap project in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object <-
    redcap_arm_export(
      redcap_uri        = credential$redcap_uri,
      token             = credential$token,
      verbose           = FALSE
    )

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object2$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("Bad Token", {
  testthat::skip_on_cran()
  credential  <- retrieve_credential_testing(2629L)
  bad_token   <- "1234567890ABCDEF1234567890ABCDEF"

  expected_error_message <- "The REDCapR arm export failed\\. The http status code was 403. The error message was: 'ERROR: You do not have permissions to use the API'"
  expect_error(
    redcap_arm_export(
      redcap_uri        = credential$redcap_uri,
      token             = bad_token,
      verbose           = FALSE
    ),
    regexp = expected_error_message
  )
})

rm(read_arms, empty_data_frame)
