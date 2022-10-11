library(testthat)
update_expectation    <- FALSE

test_that("Smoke Test", {
  testthat::skip_on_cran()
  start_clean_result <-
    REDCapR:::clean_start_simple(
      batch   = TRUE,
      verbose = FALSE
    )
  project <- start_clean_result$redcap_project
})

test_that("read-insert-and-update", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/test-project/read-insert-and-update.R"

  start_clean_result <-
    REDCapR:::clean_start_simple(
      batch   = TRUE,
      verbose = FALSE
    )
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object1 <-
    project$read(
      raw_or_label = "raw",
      guess_type   = FALSE,
      verbose      = FALSE
    )
  expect_match(returned_object1$outcome_message, regexp=expected_outcome_message, perl=TRUE)

  #Remove the calculated fields
  returned_object1$data$bmi <- NULL
  returned_object1$data$age <- NULL

  #Change some values
  returned_object1$data$address <- 1000 + seq_len(nrow(returned_object1$data))
  returned_object1$data$telephone <- sprintf("(405) 321-%1$i%1$i%1$i%1$i", seq_len(nrow(returned_object1$data)))
  project$write(
    ds      = returned_object1$data,
    verbose = FALSE
  )

  col_types <-
    readr::cols(
      .default      = readr::col_double(),
      name_first    = readr::col_character(),
      name_last     = readr::col_character(),
      telephone     = readr::col_character(),
      email         = readr::col_character(),
      dob           = readr::col_date(format = ""),
      comments      = readr::col_character(),
      mugshot       = readr::col_character()
    )
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  returned_object2 <-
    project$read(
      raw_or_label  = "raw",
      col_types     = col_types,
      verbose       = FALSE
    )

  #Remove the calculated fields
  returned_object2$data$bmi <- NULL
  returned_object2$data$age <- NULL

  if (update_expectation) save_expected(returned_object2$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected="200")
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
  expect_s3_class(returned_object2$data, "tbl")
})
