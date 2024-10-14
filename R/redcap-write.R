#' @title
#' Write/Import records to a REDCap project
#'
#' @description
#' This function uses REDCap's APIs to select and return data.
#'
#' @param ds_to_write The [base::data.frame()] or [tibble::tibble()]
#' to be imported into the REDCap project.  Required.
#' @param batch_size The maximum number of subject records a single batch
#' should contain.  The default is 100.
#' @param interbatch_delay The number of seconds the function will wait before
#' requesting a new subset from REDCap. The default is 0.5 seconds.
#' @param continue_on_error If an error occurs while writing, should records
#' in subsequent batches be attempted.  The default is `FALSE`, which prevents
#' subsequent batches from running.  Required.
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param overwrite_with_blanks A boolean value indicating if
#' blank/`NA` values in the R data frame
#' will overwrite data on the server.
#' This is the default behavior for REDCapR,
#' which essentially deletes the cell's value
#' If `FALSE`, blank/`NA` values in the data.frame
#' will be ignored.  Optional.
#' @param convert_logical_to_integer If `TRUE`, all [base::logical] columns
#' in `ds` are cast to an integer before uploading to REDCap.
#' Boolean values are typically represented as 0/1 in REDCap radio buttons.
#' Optional.
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options A list of options passed to [httr::POST()].
#' See details at [httr::httr_options()]. Optional.
#' @param handle_httr The value passed to the `handle` parameter of
#' [httr::POST()].
#' This is useful for only unconventional authentication approaches.  It
#' should be `NULL` for most institutions.  Optional.
#'
#' @return
#' Currently, a list is returned with the following elements:
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `records_affected_count`: The number of records inserted or updated.
#' * `affected_ids`: The subject IDs of the inserted or updated records.
#' * `elapsed_seconds`: The duration of the function.
#'
#' @details
#' Currently, the function doesn't modify any variable types to conform to
#' REDCap's supported variables.
#' See [validate_for_write()] for a helper function that checks for some
#' common important conflicts.
#'
#' For `redcap_write` to function properly, the user must have Export
#' permissions for the 'Full Data Set'.  Users with only 'De-Identified'
#' export privileges can still use [redcap_write_oneshot()].  To grant
#' the appropriate permissions:
#' * go to 'User Rights' in the REDCap project site,
#' * select the desired user, and then select 'Edit User Privileges',
#' * in the 'Data Exports' radio buttons, select 'Full Data Set'.
#'
#' @author
#' Will Beasley
#'
#' @references
#' The official documentation can be found on the 'API Help
#' Page' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' if (FALSE) {
#' # Define some constants
#' uri           <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token         <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write
#'
#' # Read the dataset for the first time.
#' result_read1  <- REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token)
#' ds1           <- result_read1$data
#' ds1$telephone
#'
#' # Manipulate a field in the dataset in a VALID way
#' ds1$telephone <- paste0("(405) 321-000", seq_len(nrow(ds1)))
#'
#' ds1 <- ds1[1:3, ]
#' ds1$age       <- NULL; ds1$bmi <- NULL # Drop the calculated fields before writing.
#' result_write  <- REDCapR::redcap_write(ds1, redcap_uri=uri, token=token)
#'
#' # Read the dataset for the second time.
#' result_read2  <- REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token)
#' ds2           <- result_read2$data
#' ds2$telephone
#'
#' # Manipulate a field in the dataset in an INVALID way.  A US exchange can't be '111'.
#' ds1$telephone <- paste0("(405) 321-000", seq_len(nrow(ds1)))
#'
#' # This next line will throw an error.
#' result_write <- REDCapR::redcap_write(ds1, redcap_uri=uri, token=token)
#' result_write$raw_text
#' }

#' @export
redcap_write <- function(
  ds_to_write,
  batch_size                  = 100L,
  interbatch_delay            = 0.5,
  continue_on_error           = FALSE,
  redcap_uri,
  token,
  overwrite_with_blanks       = TRUE,
  convert_logical_to_integer  = FALSE,
  verbose                     = TRUE,
  config_options              = NULL,
  handle_httr                 = NULL
) {

  start_time <- base::Sys.time()
  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  ds_glossary <- REDCapR::create_batch_glossary(
    row_count   = base::nrow(ds_to_write),
    batch_size  = batch_size
  )

  affected_ids          <- character(0)
  lst_status_code       <- NULL
  lst_outcome_message   <- NULL
  success_combined      <- TRUE

  if (verbose) {
    message(sprintf(
      "Starting to update %s records to be written at %s.",
      format(nrow(ds_to_write), big.mark = ",", scientific = FALSE, trim = TRUE),
      Sys.time()
    ))
  }

  for (i in seq_along(ds_glossary$id)) {
    selected_indices <- seq(
      from  = ds_glossary$start_index[i],
      to    = ds_glossary$stop_index[i]
    )

    if (0L < i) Sys.sleep(time = interbatch_delay)

    if (verbose) {
      message(sprintf(
        "Writing batch %i of %i, with indices %i through %i.",
        i,
        nrow(ds_glossary),
        min(selected_indices),
        max(selected_indices)
      ))
    }

    write_result <- REDCapR::redcap_write_oneshot(
      ds                          = ds_to_write[selected_indices, ],
      redcap_uri                  = redcap_uri,
      token                       = token,
      overwrite_with_blanks       = overwrite_with_blanks,
      convert_logical_to_integer  = convert_logical_to_integer,
      verbose                     = verbose,
      config_options              = config_options,
      handle_httr                 = handle_httr
    )

    lst_status_code[[i]]     <- write_result$status_code
    lst_outcome_message[[i]] <- write_result$outcome_message

    if (!write_result$success) {
      error_message <- paste0("The `redcap_write()` call failed on iteration ", i, ".")
      error_message <- paste(error_message, ifelse(!verbose, "Set the `verbose` parameter to TRUE and rerun for additional information.", ""))

      if (continue_on_error) warning(error_message)
      else stop(error_message)
    }

    affected_ids     <- c(affected_ids, write_result$affected_ids)
    success_combined <- success_combined & write_result$success

    rm(write_result) # Admittedly overkill defensiveness.
  }

  elapsed_seconds          <- as.numeric(difftime( Sys.time(), start_time, units="secs"))
  status_code_combined     <- paste(lst_status_code    , collapse = "; ")
  outcome_message_combined <- paste(lst_outcome_message, collapse = "; ")

  list(
    success                  = success_combined,
    status_code              = status_code_combined,
    outcome_message          = outcome_message_combined,
    records_affected_count   = length(affected_ids),
    affected_ids             = affected_ids,
    elapsed_seconds          = elapsed_seconds
  )
}
