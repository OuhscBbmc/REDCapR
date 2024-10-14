#' @title
#' Get survey link from REDCap
#'
#' @description
#' This function uses REDCap's API to get the link for a survey.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param record The record ID associated with the
#' survey link. Required
#' @param instrument The name of the instrument associated with the
#' survey link.  Required
#' @param event The name of the event associated with the
#' survey link.
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
#' * `survey_link`: a character string containing the URL for the survey.
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `instrument`: The instrument associated with the survey link.
#' * `records_affected_count`: The number of records associated with
#' the survey link.
#' * `affected_ids`: The subject IDs associated with the survey link.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' @details
#' Currently, the function doesn't modify any variable types to conform to
#' REDCap's supported variables.  See [validate_for_write()] for a helper
#' function that checks for some common important conflicts.
#'
#' **Permissions Required**
#' To use this method, you must have API Export privileges in the project.
#' (As stated in the 9.0.0 documentation.)
#'
#' @author
#' Will Beasley
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
#' token   <- "4780D038A2080BA2E7CC904A14218662" # survey
#' record  <- 1
#' instrument   <- "participant_morale_questionnaire"
#' # event <- "" # only for longitudinal projects
#'
#' result <- REDCapR::redcap_survey_link_export_oneshot(
#'   record         = record,
#'   instrument     = instrument,
#'   redcap_uri     = uri,
#'   token          = token
#' )
#' result$survey_link
#' }

#' @export
redcap_survey_link_export_oneshot <- function(
  redcap_uri,
  token,
  record,
  instrument,
  event           = "",
  verbose         = TRUE,
  config_options  = NULL,
  handle_httr     = NULL
) {

  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")
  record  <- as.character(record)
  checkmate::assert_character(record    , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(instrument, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(event     , any.missing=FALSE, len=1, pattern="^.{0,}$")
  checkmate::assert_logical(  verbose   , any.missing=FALSE)

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token         = token,
    content       = "surveyLink",
    record        = record,
    instrument    = instrument,
    event         = event,
    returnFormat  = "csv"
  )

  if (0L < nchar(event)) post_body$event <- event

  # This is the important call that communicates with the REDCap server.
  kernel <-
    kernel_api(
      redcap_uri      = redcap_uri,
      post_body       = post_body,
      config_options  = config_options,
      handle_httr     = handle_httr
    )

  if (kernel$success) {
    if (verbose)
      message("Preparing to export the survey link for the instrument `", instrument, "`.")

    link  <- kernel$raw_text

    outcome_message <- sprintf(
      "exported the survey link in %0.1f seconds, for instrument `%s`, record `%s`.",
      kernel$elapsed_seconds,
      instrument,
      record
    )

    records_affected_count  <- length(record)
    record_id               <- as.character(record)
    kernel$raw_text         <- ""
    # If an operation is successful, the `raw_text` is no longer returned to
    #   save RAM.  The content is not really necessary with httr's status
    #   message exposed.
  } else { # If the operation was unsuccessful, then...
    # kernel$status_code placeholder
    outcome_message         <- "survey link NOT returned."
    records_affected_count  <- 0L
    record_id               <- character(0) # Return an empty vector.
    # kernel$raw_text
    link               <- character(0)
  }

  if (verbose)
    message(outcome_message)

  list(
    survey_link               = link,
    success                   = kernel$success,
    status_code               = kernel$status_code,
    outcome_message           = outcome_message,
    instrument                = instrument,
    records_affected_count    = records_affected_count,
    affected_ids              = record_id,
    elapsed_seconds           = kernel$elapsed_seconds,
    raw_text                  = kernel$raw_text
  )
}
