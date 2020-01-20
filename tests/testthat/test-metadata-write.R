library(testthat)

test_that("Metadata Write", {
  testthat::skip_on_cran()

  # Declare the server & user information
  credential <- REDCapR::retrieve_credential_local(
    path_credential = system.file("misc/example.credentials", package="REDCapR"),
    project_id      = 1490L
  )

  # Read in the data in R's memory from a csv file.
  path_in <- system.file(
    "test-data/project-simple/simple-metadata.csv",
    package = "REDCapR"
  )
  ds_to_write <- readr::read_csv(path_in, col_types = readr::cols(.default = readr::col_character()))

  # Import the data into the REDCap project
  testthat::expect_message(
    returned_object <-
      REDCapR::redcap_metadata_write(
        ds          = ds_to_write,
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        verbose     = TRUE
      ),
    "0 records were written to REDCap in \\d{1,2}\\.\\d seconds."
  )

  testthat::expect_true(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 200L)
  testthat::expect_equal(returned_object$records_affected_count, 0L)
  testthat::expect_equal(returned_object$affected_ids, character(0))
  testthat::expect_equal(returned_object$raw_text, "")
})
