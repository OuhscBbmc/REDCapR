#' @title
#' Upload a file into to a REDCap project record
#'
#' @aliases
#' redcap_file_upload_oneshot redcap_upload_file_oneshot
#'
#' @description
#' This function uses REDCap's API to upload a file.
#'
#' @param file_name The name of the relative or full file to be uploaded into
#' the REDCap project.  Required.
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param record The record ID where the file is to be imported.  Required
#' @param field The name of the field where the file is saved in REDCap.
#' Required
#' @param event The name of the event where the file is saved in REDCap.
#' Optional
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  Optional.
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
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as
#' an empty string to save RAM.
#'
#' @details
#' Currently, the function doesn't modify any variable types to conform to
#' REDCap's supported variables.  See [validate_for_write()] for a helper
#' function that checks for some common important conflicts.
#'
#' The function `redcap_upload_file_oneshot()` is soft-deprecated
#' as of REDCapR 1.2.0.
#' Please rename to [redcap_file_upload_oneshot()].
#'
#' @author
#' Will Beasley, John J. Aponte
#'
#' @references
#' The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (ie,
#' https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' # Define some constants
#' uri    <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token  <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write
#' field  <- "mugshot"
#' event  <- "" # only for longitudinal events
#'
#' # Upload a single image file.
#' record    <- 1
#' file_path <- system.file("test-data/mugshot-1.jpg", package = "REDCapR")
#'
#' REDCapR::redcap_file_upload_oneshot(
#'   file_name  = file_path,
#'   record     = record,
#'   field      = field,
#'   redcap_uri = uri,
#'   token      = token
#' )
#'
#' # Upload a collection of five images.
#' records    <- 1:5
#' file_paths <- system.file(
#'   paste0("test-data/mugshot-", records, ".jpg"),
#'   package="REDCapR"
#' )
#'
#' for (i in seq_along(records)) {
#'   record    <- records[i]
#'   file_path <- file_paths[i]
#'   REDCapR::redcap_file_upload_oneshot(
#'     file_name  = file_path,
#'     record     = record,
#'     field      = field,
#'     redcap_uri = uri,
#'     token      = token
#'   )
#' }
#' }

#' @export
redcap_file_upload_oneshot <- function(
  file_name,
  record,
  redcap_uri,
  token,
  field,
  event             = "",
  verbose           = TRUE,
  config_options    = NULL,
  handle_httr       = NULL
) {

  checkmate::assert_character(file_name   , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_file_exists(file_name                                          )
  checkmate::assert_character(redcap_uri  , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token       , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(field       , any.missing=FALSE, len=1, pattern="^.{1,}$")
  assert_field_names(field)
  checkmate::assert_character(event       , any.missing=FALSE, len=1, pattern="^.{0,}$")
  checkmate::assert_logical(  verbose     , any.missing=FALSE)

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  if (verbose)
    message("Preparing to upload the file `", file_name, "`.")

  post_body <- list(
    token          = token,
    content        = "file",
    action         = "import",
    record         = record,
    field          = field,
    # event          = event,
    file           = httr::upload_file(path = file_name),
    returnFormat   = "csv"
  )

  if (0L < nchar(event)) post_body$event  <- event

  # This is the important call that communicates with the REDCap server.
  kernel <-
    kernel_api(
      redcap_uri      = redcap_uri,
      post_body       = post_body,
      config_options  = config_options,
      handle_httr     = handle_httr,
      encode_httr     = "multipart"      # Uploading a file is a rare occasion doesn't use "form"
    )

  if (kernel$success) {
    outcome_message         <- sprintf(
      "file uploaded to REDCap in %0.1f seconds.",
      kernel$elapsed_seconds
    )
    records_affected_count  <- 1L
    record_id               <- as.character(record)
    kernel$raw_text         <- ""
  } else { # If the returned content wasn't recognized as valid IDs, then
    # kernel$raw_text
    outcome_message         <- "file NOT uploaded "
    records_affected_count  <- 0L
    record_id               <- character(0) # Return an empty vector.
  }
  if (verbose)
    message(outcome_message)

  list(
    success                 = kernel$success,
    status_code             = kernel$status_code,
    outcome_message         = outcome_message,
    records_affected_count  = records_affected_count,
    affected_ids            = record_id,
    elapsed_seconds         = kernel$elapsed_seconds,
    raw_text                = kernel$raw_text
  )
}

#' @usage
#' redcap_upload_file_oneshot(...)

#' @export
redcap_upload_file_oneshot <- function(...) {
  # nocov start
  warning(
    "The function `redcap_upload_file_oneshot()` is soft-deprecated as of REDCapR 1.2.0. ",
    "Please use `redcap_file_upload_oneshot()`."
  )
  redcap_file_upload_oneshot(...)
  # nocov end
}
