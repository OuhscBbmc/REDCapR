#' @title Determine free available record ID
#'
#' @description Determines the next available record ID.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  The verbose output might contain sensitive information (*e.g.* PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the `httr` package.  See the details below.  Optional.
#'
#' @return a \code{\link[base:character]{base::character}} vector of either length 1 (if successful) or length 0 (if not successful).
#'
#' @details If the API call is unsuccessful, a value of `character(0)` will be returned (*i.e.*, an empty vector).
#' This ensures that a the function will always return an object of class \code{\link[base:character]{base::character}}.
#'
#' @note
#' **Documentation in REDCap 8.4.0**
#'
#' To be used by projects with record auto-numbering enabled, this method exports the next potential record ID for a project. It generates the next record name by determining the current maximum numerical record ID and then incrementing it by one.
#' > Note: This method does not create a new record, but merely determines what the next record name would be.
#' >
#' > If using Data Access Groups (DAGs) in the project, this method accounts for the special formatting of the record name for users in DAGs (e.g., DAG-ID); in this case, it only assigns the next value for ID for all numbers inside a DAG. For example, if a DAG has a corresponding DAG number of 223 wherein records 223-1 and 223-2 already exist, then the next record will be 223-3 if the API user belongs to the DAG that has DAG number 223. (The DAG number is auto-assigned by REDCap for each DAG when the DAG is first created.) When generating a new record name in a DAG, the method considers all records in the entire project when determining the maximum record ID, including those that might have been originally created in that DAG but then later reassigned to another DAG.
#' >
#' > Note: This method functions the same even for projects that do not have record auto-numbering enabled.
#'
#' @examples
#' uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token    <- "9A81268476645C4E5F03428B8AC3AA7B"
#' REDCapR::redcap_next_free_record_name(redcap_uri=uri, token=token) # Should return "6"

#' @export
redcap_next_free_record_name <- function( redcap_uri, token, verbose=TRUE, config_options=NULL ) {
  value_error       <- character(0)

  checkmate::assert_character(redcap_uri                , any.missing=F, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=F, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token                   = token,
    content                 = 'generateNextRecordName',
    format                  = 'csv'
  )

  # This is the important line that communicates with the REDCap server.
  kernel <- kernel_api(redcap_uri, post_body, config_options)

  if( kernel$success ) {
    try (
      {
        value <- kernel$raw_text
      },
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )

    if( exists("value") ) {
      outcome_message <- paste0(
        "The next free record name in REDCap was successfully determined in ",
        round(kernel$elapsed_seconds, 1), " seconds.  The http status code was ",
        kernel$status_code, ".  It is ", value, "."
      )

    } else {
      value          <- value_error
      outcome_message  <- paste0("The REDCap determination of the next free record id failed.  The http status code was ", kernel$status_code, ".  The 'raw_text' returned was '", kernel$raw_text, "'.")
    }
  } else {
    value          <- value_error
    outcome_message  <- paste0("The REDCap determination of the next free record id failed.  The error message was:\n",  kernel$raw_text)
  }

  if( verbose )
    message(outcome_message)

  return( value )
}
