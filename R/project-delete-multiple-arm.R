# These functions are not exported.

populate_project_delete_multiple_arm <- function(verbose = FALSE) {
  if (!requireNamespace("testthat")) {
    # nocov start
    stop(
      "The function REDCapR:::populate_project_delete_multiple_arm() cannot run if the ",
      "`testthat` package is not installed.  Please install it and try again."
    )
    # nocov end
  }

  credential  <- retrieve_credential_testing("arm-multiple-delete")

  project <- REDCapR::redcap_project$new(
    redcap_uri    = credential$redcap_uri,
    token         = credential$token
  )
  path_in <- system.file(
    "test-data/projects/arm-multiple-delete/data.csv",
    # "test-data/delete-multiple-arm/data.csv",
    package = "REDCapR"
  )

  # Write the file to disk (necessary only when you wanted to change the data).  Don't uncomment; just run manually.
  # returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw")
  # utils::write.csv(returned_object$data, file="./inst/test-data/project-delete_multiple_arm/delete_multiple_arm-data.csv", row.names=FALSE)
  # returned_object_metadata <- redcap_metadata_read(redcap_uri=uri, token=token)
  # utils::write.csv(returned_object_metadata$data, file="./inst/test-data/project-delete_multiple_arm/delete_multiple_arm-metadata.csv", row.names=FALSE)

  # Read in the data in R's memory from a csv file.
  ds_to_write <-
    readr::read_csv(
      path_in,
      show_col_types = FALSE
    )
  # ds_to_write <- utils::read.csv(file="./inst/test-data/delete-multiple-arm/delete-multiple-arm-data.csv")

  # Import the data into the REDCap project
  returned_object <-
    REDCapR::redcap_write(
      ds          = ds_to_write,
      redcap_uri  = project$redcap_uri,
      token       = project$token,
      verbose     = verbose
    )

  # Print a message and return a boolean value
  if (verbose) {
    base::message(base::sprintf(
      "populate_project_delete_multiple_arm success: %s.",
      returned_object$success
    ))
  }
  list(is_success = returned_object$success, redcap_project = project)
}

clear_project_delete_multiple_arm <- function(verbose = TRUE) {
  if (!requireNamespace("testthat")) {
    # nocov start
    stop(
      "The function REDCapR:::populate_project_delete_multiple_arm() cannot run if the ",
      "`testthat` package is not installed.  Please install it and try again."
    )
    # nocov end
  }
  path_delete_test_record <- retrieve_plugins("delete_arm_multiple")
  # "https://redcap-dev-2.ouhsc.edu/redcap/plugins/redcapr/delete_redcapr_delete_multiple_arm.php"

  # Returns a boolean value if successful
  was_successful <- !httr::http_error(path_delete_test_record)

  # Print a message and return a boolean value
  if (verbose) {
    base::message(base::sprintf(
      "clear_project_delete_multiple_arm success: %s.",
      was_successful
    ))
  }

  was_successful
}

clean_start_delete_multiple_arm <- function(delay_in_seconds = 1, verbose = FALSE) {
  checkmate::assert_numeric(delay_in_seconds, any.missing=FALSE, len=1, lower=0)

  if (!requireNamespace("testthat")) {
    # nocov start
    stop(
      "The function REDCapR:::populate_project_delete_multiple_arm() cannot run if the ",
      "`testthat` package is not installed.  Please install it and try again."
    )
    # nocov end
  }

  clear_result <- clear_project_delete_multiple_arm(verbose = verbose)
  testthat::expect_true(clear_result, "Clearing the results from the delete_multiple_arm project should be successful.")
  base::Sys.sleep(delay_in_seconds) # Pause after deleting records.

  populate_result <- populate_project_delete_multiple_arm(verbose = verbose)
  testthat::expect_true(populate_result$is_success, "Population of the delete_multiple_arm project should be successful.")
  base::Sys.sleep(delay_in_seconds) # Pause after writing records.

  populate_result
}

# populate_project_delete_multiple_arm()
# clear_project_delete_multiple_arm()
# clean_start_delete_multiple_arm()
# clean_start_delete_multiple_arm(batch = TRUE)
