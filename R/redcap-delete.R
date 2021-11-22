#' @title Delete records in a REDCap project
#'
#' @description This function uses REDCap's API to delete the specified records.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap
#' project.  Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param records_to_delete A character vector of the project's `record_id`
#' values to delete.  Required.
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to [httr::POST()] method
#' in the 'httr' package.  See the details in [redcap_read_oneshot()] Optional.
#'
#' @return Currently, a list is returned with the following elements:
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `records_affected_count`: The number of records inserted or updated.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' @details
#' REDCap requires that at least one `record_id` value be passed to
#' the delete call.
#'
#' @author Will Beasley
#'
#' @references The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' #Define some constants
#' uri            <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token          <- "D70F9ACD1EDD6F151C6EA78683944E98"
#'
#' # Read the dataset for the first time.
#' result_read1   <- REDCapR::redcap_delete(redcap_uri=uri, token=token)
#' ds1            <- result_read1$data
#' ds1$telephone
#'
#' }

#' @export
redcap_delete <- function(
  redcap_uri,
  token,
  records_to_delete,
  verbose         = TRUE,
  config_options  = NULL
) {

  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_vector(records_to_delete, any.missing = FALSE, min.len = 1)

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)
  records_to_delete <- as.character(records_to_delete)
  checkmate::assert_character(records_to_delete, any.missing = FALSE, min.len = 1)

  # record_string <-
  #   sprintf(
  #     "'records[%i]': '%s'",
  #     seq_along(records_to_delete) - 1,
  #     records_to_delete
  #   ) #%>%
  #   # paste(collapse = ",")
  records_to_delete <-
    stats::setNames(
      records_to_delete,
      sprintf("records[%i]", seq_along(records_to_delete) - 1)
    )

  post_body <- c(
    list(
      token     = token,
      content   = "record",
      action    = "delete"
    ),
    records_to_delete
  )

  # This is the important line that communicates with the REDCap server.
  kernel <- kernel_api(redcap_uri, post_body, config_options)

  if (kernel$success) {
    records_affected_count <- as.integer(kernel$raw_text)
    outcome_message        <- sprintf(
      "%s records were deleted from REDCap in %0.1f seconds.",
      format(records_affected_count, big.mark = ",", scientific = FALSE, trim = TRUE),
      kernel$elapsed_seconds
    )

    #If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
    kernel$raw_text <- ""
  } else { #If the returned content wasn't recognized as valid IDs, then
    records_affected_count <- 0
    outcome_message        <- sprintf(
      "The REDCapR delete operation was not successful.  The error message was:\n%s",
      kernel$raw_text
    )
  }

  if (verbose)
    message(outcome_message)

  list(
    success                   = kernel$success,
    status_code               = kernel$status_code,
    outcome_message           = outcome_message,
    records_affected_count    = records_affected_count,
    elapsed_seconds           = kernel$elapsed_seconds,
    raw_text                  = kernel$raw_text
  )
}
