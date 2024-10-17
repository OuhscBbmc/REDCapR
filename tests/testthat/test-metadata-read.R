library(testthat)

credential            <- retrieve_credential_testing()
credential_super_wide_1 <- retrieve_credential_testing("super-wide-1")
credential_super_wide_2<-retrieve_credential_testing("super-wide-2")
credential_super_wide_3<-retrieve_credential_testing("super-wide-3")
credential_problem    <- retrieve_credential_testing("potentially-problematic-dictionary")
update_expectation    <- FALSE

if (credential$redcap_uri != "https://redcap-dev-2.ouhsc.edu/redcap/api/") {
  testthat::skip("Skipping EAV test on non-dev server")
  # The two servers have different outputs/spaces around the pipes.
  # dev : "0, Female|1, Male"
  # bbmc: "0, Female | 1, Male"
}

test_that("Smoke Test", {
  testthat::skip_on_cran()
  expect_message({
    returned_object <-
      redcap_metadata_read(
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        verbose     = TRUE
      )
  })
  expect_type(returned_object, "list")
})

test_that("normal", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/metadata-read/normal.R"
  expected_outcome_message <- "The data dictionary describing \\d+ fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  # datapasta::tribble_paste(returned_object$data)
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_true(returned_object$forms_collapsed=="", "A subset of forms was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("normal-filter-form-demographics", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/metadata-read/normal-filter-form-demographics.R"
  expected_outcome_message <- "The data dictionary describing \\d+ fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      forms       = "demographics",
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$forms_collapsed, "demographics")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("normal-filter-form-health", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/metadata-read/normal-filter-form-health.R"
  expected_outcome_message <- "The data dictionary describing \\d+ fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      forms       = "health",
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$forms_collapsed, "health")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("normal-filter-form-race_and_ethnicity", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/metadata-read/normal-filter-form-race_and_ethnicity.R"
  expected_outcome_message <- "The data dictionary describing \\d+ fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      forms       = "race_and_ethnicity",
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$forms_collapsed, "race_and_ethnicity")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("normal-filter-form-all-three", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/metadata-read/normal-filter-form-all-three.R"
  expected_outcome_message <- "The data dictionary describing \\d+ fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      forms       = c("demographics", "race_and_ethnicity"),
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$forms_collapsed, "demographics,race_and_ethnicity")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("normal-filter-form-demographics-and-health-race_and_ethnicity", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/metadata-read/normal.R"
  expected_outcome_message <- "The data dictionary describing \\d+ fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      forms       = c("demographics", "health", "race_and_ethnicity"),
      verbose     = FALSE
    )

  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$forms_collapsed, "demographics,health,race_and_ethnicity")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("normal-filter-form-out-of-order", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/metadata-read/normal.R"
  expected_outcome_message <- "The data dictionary describing \\d+ fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential$redcap_uri,
      token       = credential$token,
      forms       = c("race_and_ethnicity", "demographics", "health"),
      verbose     = FALSE
    )

  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$forms_collapsed, "race_and_ethnicity,demographics,health")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("super-wide", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The data dictionary describing 3,001 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."
  expected_row_count    <- 3001L
  expected_column_count <- 18L
  expected_na_cells     <- 42014L

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential_super_wide_1$redcap_uri,
      token       = credential_super_wide_1$token,
      verbose     = FALSE
    )

  expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
  expect_equal(ncol(returned_object$data), expected=expected_column_count)
  expect_equal(sum(is.na(returned_object$data)), expected=expected_na_cells)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("super-wide 2", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The data dictionary describing 5,751 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."
  expected_row_count    <- 5751L
  expected_column_count <- 18L
  expected_na_cells     <- 63511L

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential_super_wide_2$redcap_uri,
      token       = credential_super_wide_2$token,
      verbose     = FALSE
    )

  expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
  expect_equal(ncol(returned_object$data), expected=expected_column_count)
  expect_equal(sum(is.na(returned_object$data)), expected=expected_na_cells)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("super-wide 3", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The data dictionary describing 35,004 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."
  expected_row_count    <- 35004L
  expected_column_count <- 18L
  expected_na_cells     <- 397297L

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential_super_wide_3$redcap_uri,
      token       = credential_super_wide_3$token,
      verbose     = FALSE
    )

  expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
  expect_equal(ncol(returned_object$data), expected=expected_column_count)
  expect_equal(sum(is.na(returned_object$data)), expected=expected_na_cells)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("super-wide 3 -subset", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/metadata-read/super-wide-3-subset.R"
  expected_outcome_message <- "The data dictionary describing 11 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential_super_wide_3$redcap_uri,
      token       = credential_super_wide_3$token,
      forms       = c("form_0001", "form_0003"),
      verbose     = FALSE
    )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$forms_collapsed, "form_0001,form_0003")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  expect_s3_class(returned_object$data, "tbl")
})

test_that("Problematic Dictionary", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The data dictionary describing 6 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."
  expected_row_count    <- 6L
  expected_column_count <- 18L
  expected_na_cells     <- 76L

  returned_object <-
    redcap_metadata_read(
      redcap_uri  = credential_problem$redcap_uri,
      token       = credential_problem$token,
      verbose     = FALSE
    )

  expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
  expect_equal(ncol(returned_object$data), expected=expected_column_count)
  expect_equal(sum(is.na(returned_object$data)), expected=expected_na_cells)
  expect_s3_class(returned_object$data, "tbl")
})

rm(credential           )
rm(credential_super_wide_1)
rm(credential_super_wide_2)
rm(credential_super_wide_3)
rm(credential_problem   )
rm(update_expectation)
