library(testthat)
update_expectation    <- FALSE

test_that("Smoke Test", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project
})

test_that("read-insert-and-update", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/test-project/read-insert-and-update.R"

  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object1 <- project$read(raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  #Remove the calculated fields
  returned_object1$data$bmi <- NULL
  returned_object1$data$age <- NULL

  #Change some values
  returned_object1$data$address <- 1000 + seq_len(nrow(returned_object1$data))
  returned_object1$data$telephone <- sprintf("(405) 321-%1$i%1$i%1$i%1$i", seq_len(nrow(returned_object1$data)))
  project$write(ds=returned_object1$data)

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object2 <- project$read(raw_or_label="raw"),
#     returned_object2 <- REDCapR::redcap_read(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
#     returned_object2 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  #Remove the calculated fields
  returned_object2$data$bmi <- NULL
  returned_object2$data$age <- NULL

  if (update_expectation) save_expected(returned_object2$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected="200")
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
})
