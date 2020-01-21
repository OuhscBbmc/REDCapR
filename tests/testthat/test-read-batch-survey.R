library(testthat)


credential          <- retrieve_credential_testing(817L)
project             <- redcap_project$new(redcap_uri=credential$redcap_uri, token=credential$token)
directory_relative  <- "test-data/project-survey/expected"

test_that("Smoke Test", {
  testthat::skip_on_cran()

  #Static method w/ default batch size
  expect_message(
    returned_object <- redcap_read(
      redcap_uri=credential$redcap_uri, token=credential$token, export_survey_fields=TRUE
    )
  )
  #Instance method w/ default batch size
  expect_message(
    returned_object <- project$read(export_survey_fields=TRUE)
  )

  #Instance method w/ tiny batch size
  expect_message(
    returned_object <- project$read(batch_size=2, export_survey_fields=TRUE)
  )
})

test_that("SO example for data.frame retreival", {
  file_name <- "dummy.rds"
  path_qualified <- system.file(directory_relative, file_name, package="REDCapR")

  actual <- data.frame(a=1:5, b=6:10) # saveRDS(actual, file.path("./inst", directory_relative, file_name))
  expect_true(file.exists(path_qualified), "The saved data.frame should be retrieved from disk.")
  expected <- readRDS(path_qualified)
  expect_equal(actual, expected, label="The returned data.frame should be correct")
})

test_that("All Records -Default", {
  testthat::skip_on_cran()

  file_name <- "default.rds"
  path_qualified <- system.file(directory_relative, file_name, package="REDCapR")

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  # saveRDS(returned_object1$data, file.path("./inst", directory_relative, file_name), compress="xz")
  expected_data_frame <- readRDS(path_qualified)
  # expected_data_frame <- eval(parse(path_expected), enclos = new.env()) #dput(returned_object1$data, file=path_expected)

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, export_survey_fields=TRUE)
  )
  expect_equivalent(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(all(!is.na(returned_object1$data$prescreening_survey_timestamp)))
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(nchar(returned_object1$filter_logic)==0L, "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)

  ###########################
  ## Tiny Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, export_survey_fields=TRUE, batch_size=8)
  )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(all(!is.na(returned_object1$data$prescreening_survey_timestamp)))
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(nchar(returned_object2$filter_logic)==0L, "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})

rm(credential)
