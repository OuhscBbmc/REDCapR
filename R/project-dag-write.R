# These functions are not exported.

populate_project_dag_write <- function(batch = FALSE, verbose = FALSE) {
  checkmate::assert_logical(batch, any.missing = FALSE, len = 1)

  if (!requireNamespace("testthat")) {
    # nocov start
    stop(
      "The function REDCapR:::populate_project_dag_write() cannot run if the ",
      "`testthat` package is not installed.  Please install it and try again."
    )
    # nocov end
  }

  credential  <- retrieve_credential_testing("dag-write", username = "admin")

  project <- REDCapR::redcap_project$new(
    redcap_uri    = credential$redcap_uri,
    token         = credential$token
  )
  path_in_dag <- system.file(
    "test-data/projects/dag/data.csv",
    package = "REDCapR"
  )

  # Write the file to disk (necessary only when you wanted to change the data).  Don't uncomment; just run manually.
  # returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw")
  # utils::write.csv(returned_object$data, file="./inst/test-data/project-dag/dag-data.csv", row.names=FALSE)
  # returned_object_metadata <- redcap_metadata_read(redcap_uri=uri, token=token)
  # utils::write.csv(returned_object_metadata$data, file="./inst/test-data/project-dag/dag-metadata.csv", row.names=FALSE)

  # Read in the data in R's memory from a csv file.
  ds_to_write <-
    readr::read_csv(
      path_in_dag,
      show_col_types = FALSE
    )
  # ds_to_write <- utils::read.csv(file="./inst/test-data/project-dag/dag-data.csv")

  # Remove the calculated variables.
  ds_to_write$last_name <- NULL
  # ds_to_write$bmi <- NULL

  # ds_to_write$record_id <- sub("^\\d+-(\\d+)$", "\\1",  ds_to_write$record_id)
  # ds_to_write$redcap_data_access_group <- NULL

  # Import the data into the REDCap project
  # testthat::expect_message(
  returned_object <- if (batch) {
    REDCapR::redcap_write(
      ds_to_write                 = ds_to_write,
      redcap_uri                  = project$redcap_uri,
      token                       = project$token,
      verbose                     = verbose,
      convert_logical_to_integer  = TRUE
    )
  } else {
    REDCapR::redcap_write_oneshot(
      ds                          = ds_to_write,
      redcap_uri                  = project$redcap_uri,
      token                       = project$token,
      verbose                     = verbose,
      convert_logical_to_integer  = TRUE
    )
  }
  # )

  # # If uploading the data was successful, then upload the image files.
  # if (returned_object$success) {
  #   upload_file_dag(
  #     redcap_uri    = project$redcap_uri,
  #     token         = project$token
  #   )
  # }

  # Print a message and return a boolean value
  if (verbose) {
    # no cov start
    base::message(base::sprintf(
      "populate_project_dag_write success: %s.",
      returned_object$success
    ))
    # no cov end
  }
  list(is_success = returned_object$success, redcap_project = project)
}

clear_project_dag_write <- function(verbose = FALSE) {
  if (!requireNamespace("testthat")) {
    # nocov start
    stop(
      "The function REDCapR:::populate_project_dag_write() cannot run if the ",
      "`testthat` package is not installed.  Please install it and try again."
    )
    # nocov end
  }

  path_delete_test_record <- retrieve_plugins("delete_dag")
  # "https://redcap-dev-2.ouhsc.edu/redcap/plugins/redcapr/delete_redcapr_dag_write.php"

  # Returns a boolean value if successful
  was_successful <- !httr::http_error(path_delete_test_record)

  # Print a message and return a boolean value
  if (verbose) {
    # no cov start
    base::message(base::sprintf(
      "clear_project_dag_write success: %s.",
      was_successful
    ))
    # no cov end
  }

  was_successful
}

clean_start_dag_write <- function(
  batch             = FALSE,
  delay_in_seconds  = 1,
  verbose           = FALSE
) {
  checkmate::assert_logical(batch           , any.missing=FALSE, len=1)
  checkmate::assert_numeric(delay_in_seconds, any.missing=FALSE, len=1, lower=0)

  if (!requireNamespace("testthat")) {
    # nocov start
    stop(
      "The function REDCapR:::populate_project_dag_write() cannot run if the ",
      "`testthat` package is not installed.  Please install it and try again."
    )
    # nocov end
  }
  # testthat::expect_message(
  clear_result <- clear_project_dag_write(verbose = verbose)
  #   regexp = "clear_project_dag_write success: TRUE."
  # )
  testthat::expect_true(clear_result, "Clearing the results from the dag_write project should be successful.")
  base::Sys.sleep(delay_in_seconds) # Pause after deleting records.

  # testthat::expect_message(
  populate_result <- populate_project_dag_write(batch = batch, verbose = verbose)
  #   regexp = "populate_project_dag_write success: TRUE."
  # )
  testthat::expect_true(populate_result$is_success, "Population of the dag_write project should be successful.")
  base::Sys.sleep(delay_in_seconds) # Pause after writing records.

  populate_result
}

# upload_file_dag_write <- function(redcap_uri, token = token) {
#   checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, min.chars = 5)
#   checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^\\w{32}$")

#   records <- 1:5
#   file_paths <- system.file(
#     paste0("test-data/mugshot-", records, ".jpg"),
#     package = "REDCapR"
#   )

#   field <- "mugshot"
#   # event <- "" # only for longitudinal events

#   token <- sanitize_token(token)

#   for (i in seq_along(records)) {
#     record    <- records[i]
#     file_path <- file_paths[i]
#     redcap_file_upload_oneshot(
#       file_name   = file_path,
#       record      = record,
#       field       = field,
#       redcap_uri  = redcap_uri,
#       token       = token
#     )
#   }
# }

# populate_project_dag_write()
# populate_project_dag_write(batch = TRUE)
# clear_project_dag_write()
# clean_start_dag_write()
# clean_start_dag_write(batch = TRUE)
