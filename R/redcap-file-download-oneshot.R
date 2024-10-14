#' @title
#' Download a file from a REDCap project record
#'
#' @aliases
#' redcap_file_download_oneshot redcap_download_file_oneshot
#'
#' @description
#' This function uses REDCap's API to download a file.
#'
#' @param file_name The name of the file where the downloaded file is saved.
#' If empty the original name of the file will be used and saved in the
#' default directory.  Optional.
#' @param directory The directory where the file is saved. By default current
#' directory. Optional
#' @param overwrite Boolean value indicating if existing files should be
#' overwritten. Optional
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param record The record ID where the file is to be imported. Required
#' @param field The name of the field where the file is saved in REDCap.
#' Required
#' @param event The name of the event where the file is saved in REDCap.
#' Optional
#' @param repeat_instance (only for projects with repeating instruments/events)
#' The repeat instance number of the repeating event (if longitudinal) or the
#' repeating instrument (if classic or longitudinal). Default value is '1'.
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
#' Currently, a list is returned with the following elements,
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
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#' * `file_name`: The name of the file persisted to disk. This is useful if
#' the name stored in REDCap is used (which is the default).
#'
#' @details
#' For files in a repeating instrument, don't specify `repeating_instrument`.
#' The server only needs `field` (name) and `repeating_instance`.
#'
#' The function `redcap_download_file_oneshot()` is soft-deprecated
#' as of REDCapR 1.2.0.
#' Please rename to [redcap_file_download_oneshot()].
#'
#' @author
#' Will Beasley, John J. Aponte
#'
#' @references
#' The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' uri     <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token   <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write
#' record  <- 1
#' field   <- "mugshot"
#' # event <- "" # only for longitudinal projects
#'
#' result_1 <- REDCapR::redcap_file_download_oneshot(
#'   record        = record,
#'   field         = field,
#'   redcap_uri    = uri,
#'   token         = token
#' )
#' base::unlink("mugshot-1.jpg")
#'
#' (full_name <- base::tempfile(pattern="mugshot", fileext = ".jpg"))
#' result_2   <- REDCapR::redcap_file_download_oneshot(
#'   file_name     = full_name,
#'   record        = record,
#'   field         = field,
#'   redcap_uri    = uri,
#'   token         = token
#' )
#' base::unlink(full_name)
#'
#' (relative_name <- "ssss.jpg")
#' result_3 <- REDCapR::redcap_file_download_oneshot(
#'   file_name    = relative_name,
#'   record       = record,
#'   field        = field,
#'   redcap_uri   = uri,
#'   token        = token
#' )
#' base::unlink(relative_name)
#' }

#' @export
redcap_file_download_oneshot <- function(
  file_name       = NULL,
  directory       = NULL,
  overwrite       = FALSE,
  redcap_uri,
  token,
  record,
  field,
  event           = "",
  repeat_instance = NULL,
  verbose         = TRUE,
  config_options  = NULL,
  handle_httr     = NULL
) {

  checkmate::assert_character(file_name , null.ok   = TRUE , len=1, pattern="^.{1,}$")
  checkmate::assert_character(directory , null.ok   = TRUE , len=1, pattern="^.{1,}$")
  checkmate::assert_logical(  overwrite , any.missing=FALSE)
  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")
  record  <- as.character(record)
  checkmate::assert_character(record    , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(field     , any.missing=FALSE, len=1, pattern="^.{1,}$")
  assert_field_names(field)
  checkmate::assert_character(event     , any.missing=FALSE, len=1, pattern="^.{0,}$")
  checkmate::assert_logical(  verbose   , any.missing=FALSE)

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token         = token,
    content       = "file",
    action        = "export",
    record        = record,
    field         = field,
    # event         = event,
    returnFormat  = "csv"
  )

  if (0L < nchar(event)) post_body$event <- event

  if (!is.null(repeat_instance)) post_body$repeat_instance <- repeat_instance

  # This is the first of two important lines in the function.
  #   It retrieves the information from the server and stores it in RAM.
  kernel <-
    kernel_api(
      redcap_uri      = redcap_uri,
      post_body       = post_body,
      config_options  = config_options,
      handle_httr     = handle_httr
    )

  if (kernel$success) {
    result_header <- kernel$result_headers$`content-type`

    if (missing(file_name) || is.null(file_name)) {
      # process the content-type to get the file name
      regex_matches <- regmatches(
        kernel$result_headers,
        regexpr("name=.*", kernel$result_headers)
      )

      file_name <- gsub(
        pattern     = '(name=.)|(")',
        replacement = "",
        x           = regex_matches
      )
    }

    file_path <- if (missing(directory) && is.null(directory)) {
      file_name # Use relative path.
    } else {
      file.path(directory, file_name) # Qualify the file with its full path.
    }

    if (verbose)
      message("Preparing to download the file `", file_path, "`.")

    if (!overwrite && file.exists(file_path)) {
      stop(
        "The operation was halted because the file `",
        file_path,
        "` already exists and `overwrite` is FALSE.  ",
        "Please check the directory if you believe this is a mistake."
      )
    }

    # This is the second of two important lines in the function.
    #   It persists/converts the information in RAM to a file.
    writeBin(httr::content(kernel$result, as = "raw"), con = file_path)

    outcome_message <- sprintf(
      "%s successfully downloaded in %0.1f seconds, and saved as %s.",
      result_header,
      kernel$elapsed_seconds,
      file_path
    )

    records_affected_count  <- length(record)
    record_id               <- as.character(record)
    kernel$raw_text         <- ""
    # If an operation is successful, the `raw_text` is no longer returned to
    #   save RAM.  The content is not really necessary with httr's status
    #   message exposed.
  } else { # If the operation was unsuccessful, then...
    # kernel$status_code placeholder
    outcome_message         <- "file NOT downloaded."
    records_affected_count  <- 0L
    record_id               <- character(0) # Return an empty vector.
    # kernel$raw_text
    file_path               <- character(0)
  }

  if (verbose)
    message(outcome_message)

  list(
    success                  = kernel$success,
    status_code              = kernel$status_code,
    outcome_message          = outcome_message,
    records_affected_count   = records_affected_count,
    affected_ids             = record_id,
    elapsed_seconds          = kernel$elapsed_seconds,
    raw_text                 = kernel$raw_text,
    file_name                = file_name,
    file_path                = file_path
  )
}

#' @usage
#' redcap_download_file_oneshot(...)

#' @export
redcap_download_file_oneshot <- function(...) {
  # nocov start
  warning(
    "The function `redcap_download_file_oneshot()` is soft-deprecated as of REDCapR 1.2.0. ",
    "Please use `redcap_file_download_oneshot()`."
  )
  redcap_file_download_oneshot(...)
  # nocov end
}
