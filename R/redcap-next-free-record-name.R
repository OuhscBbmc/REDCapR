#' @title
#' Determine free available record ID
#'
#' @description
#' Determines the next available record ID.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
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
#' a [base::character] vector of either
#' length 1 (if successful) or length 0 (if not successful).
#'
#' @details
#' If the API call is unsuccessful, a value of `character(0)` will
#' be returned (*i.e.*, an empty vector).  This ensures that a the function
#' will always return an object of class
#' [base::character].
#'
#' @note
#' **Documentation in REDCap 8.4.0**
#'
#' To be used by projects with record auto-numbering enabled, this method
#' exports the next potential record ID for a project. It generates the next
#' record name by determining the current maximum numerical record ID and then
#' incrementing it by one.
#'
#' ```
#' Note: This method does not create a new record, but merely determines what
#' the next record name would be.
#'
#' If using Data Access Groups (DAGs) in the project, this method accounts for
#' the special formatting of the record name for users in DAGs (e.g., DAG-ID);
#' in this case, it only assigns the next value for ID for all numbers inside
#' a DAG. For example, if a DAG has a corresponding DAG number of 223 wherein
#' records 223-1 and 223-2 already exist, then the next record will be 223-3
#' if the API user belongs to the DAG that has DAG number 223. (The DAG number
#' is auto-assigned by REDCap for each DAG when the DAG is first created.)
#'
#' When generating a new record name in a DAG, the method considers all records
#' in the entire project when determining the maximum record ID, including
#' those that might have been originally created in that DAG but then later
#' reassigned to another DAG.
#'
#' Note: This method functions the same even for projects that do not have
#' record auto-numbering enabled.
#' ```
#'
#' @examples
#' uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token    <- "9A068C425B1341D69E83064A2D273A70"

#' # Returns 6
#' REDCapR::redcap_next_free_record_name(redcap_uri = uri, token = token)

#' @export
redcap_next_free_record_name <- function(
  redcap_uri,
  token,
  verbose           = TRUE,
  config_options    = NULL,
  handle_httr       = NULL
) {

  value_error       <- character(0)

  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_logical(  verbose   , any.missing=FALSE)

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token     = token,
    content   = "generateNextRecordName",
    format    = "csv"
  )

  # This is the important call that communicates with the REDCap server.
  kernel <-
    kernel_api(
      redcap_uri      = redcap_uri,
      post_body       = post_body,
      config_options  = config_options,
      handle_httr     = handle_httr
    )

  if (kernel$success) {
    # Don't print the warning in the try block.  Print it below,
    # where it's under the control of the caller.
    try(
      value <- kernel$raw_text
      , silent = TRUE
    )

    if (exists("value")) {
      outcome_message <- sprintf(
        "The next free record name in REDCap was successfully determined in %0.1f seconds.  The http status code was %i.  Is is %s.",
        kernel$elapsed_seconds,
        kernel$status_code,
        value
      )

    } else {
      # nocov start
      value          <- value_error
      outcome_message  <- sprintf(
        "The REDCap determination of the next free record id failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  } else {
    value          <- value_error
    outcome_message  <- sprintf(
      "The REDCap determination of the next free record id failed.  The error message was:\n%s",
      kernel$raw_text
    )
  }

  if (verbose)
    message(outcome_message)

  value
}
