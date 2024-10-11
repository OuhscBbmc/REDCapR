library(testthat)

credential  <- retrieve_credential_testing("metadata-write")

# Read in the dictionary in R's memory from a csv file.
path_in <- system.file(
  "test-data/projects/simple/metadata.csv",
  package = "REDCapR"
)
dictionary_to_write <-
  readr::read_csv(
    file            = path_in,
    col_types       = readr::cols(.default = readr::col_character()),
    show_col_types  = FALSE
  )

test_that("Metadata Write", {
  testthat::skip_on_cran()

  testthat::expect_message(
    returned_object <-
      REDCapR::redcap_metadata_write(
        ds          = dictionary_to_write,
        redcap_uri  = credential$redcap_uri,
        token       = credential$token,
        verbose     = TRUE
      ),
    "16 fields were written to the REDCap dictionary in \\d{1,2}\\.\\d seconds."
  )

  testthat::expect_true(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 200L)
  testthat::expect_equal(returned_object$field_count, 16L)
  testthat::expect_equal(returned_object$raw_text, "")
})
test_that("Metadata Write -Error", {
  testthat::skip_on_cran()

  testthat::expect_message(
    returned_object <-
      REDCapR::redcap_metadata_write(
        ds          = dictionary_to_write,
        redcap_uri  = credential$redcap_uri,
        token       = "BAD00000000000000000000000000000"
      ),
    "The REDCapR write/import metadata operation was not successful\\."
  )

  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$field_count, 0L)
  testthat::expect_equal(returned_object$raw_text, "ERROR: You do not have permissions to use the API")
})

rm(credential)
