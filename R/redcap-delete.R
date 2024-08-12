#' @title
#' Delete records in a REDCap project
#'
#' @description
#' Delete existing records by their ID from REDCap.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param records_to_delete A character vector of the project's `record_id`
#' values to delete.  Required.
#' @param arm_of_records_to_delete A single integer reflecting the arm
#' containing the records to be deleted.  Leave it as NULL if the project
#' has no arms and is not longitudinal. Required if the REDCap project
#' has arms.  See Details below.
#'
#' @inheritParams redcap_metadata_read
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
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' @details
#' REDCap requires that at least one `record_id` value be passed to
#' the delete call.
#'
#' When the project has arms, REDCapR has stricter requirements than REDCap.
#' If the REDCap project has arms, a value must be passed to
#' `arm_of_records_to_delete`.  This is a different behavior than calling
#' the server through cURL --which if no  arm number is specified,
#' then all arms are cleared of the specified `record_id`s.
#'
#' Note that all longitudinal projects technically have arms, even if
#' only one arm is defined.  Therefore a value of `arm_number` must be
#' specified for all longitudinal projects.
#'
#' @author
#' Jonathan Mang, Will Beasley
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
#' if (FALSE) {
#' records_to_delete <- c(102, 103, 105, 120)
#'
#' # Deleting from a non-longitudinal project with no defined arms:
#' REDCapR::redcap_delete(
#'   redcap_uri               = uri,
#'   token                    = token,
#'   records_to_delete        = records_to_delete,
#' )
#'
#' # Deleting from a project that has arms or is longitudinal:
#' arm_number <- 2L # Not the arm name
#' REDCapR::redcap_delete(
#'   redcap_uri               = uri,
#'   token                    = token,
#'   records_to_delete        = records_to_delete,
#'   arm_of_records_to_delete = arm_number
#' )
#' }

#' @export
redcap_delete <- function(
  redcap_uri,
  token,
  records_to_delete,
  arm_of_records_to_delete = NULL,
  verbose         = TRUE,
  config_options  = NULL,
  handle_httr     = NULL
) {

  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_vector(records_to_delete, any.missing = FALSE, min.len = 1)
  checkmate::assert_integer(arm_of_records_to_delete, any.missing=FALSE, null.ok = TRUE, len=1, lower = 1)

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)
  records_to_delete <- as.character(records_to_delete)
  checkmate::assert_character(records_to_delete, any.missing = FALSE, min.len = 1)

  records_to_delete <-
    stats::setNames(
      records_to_delete,
      sprintf("records[%i]", seq_along(records_to_delete) - 1)
    )

  arms_call <-
    redcap_arm_export(
      redcap_uri      = redcap_uri,
      token           = token,
      verbose         = FALSE,
      config_options  = config_options,
      handle_httr     = handle_httr
    )

  if (arms_call$has_arms && is.null(arm_of_records_to_delete)) {
    stop("This REDCap project has arms.  Please specify which arm contains the records to be deleted.")
  } else if (!arms_call$has_arms && !is.null(arm_of_records_to_delete)) {
    stop("This REDCap project does not have arms, but `arm_of_records_to_delete` is not NULL.")
  }

  arm_list <-
    if (is.null(arm_of_records_to_delete)) {
      NULL # A null object here is essentially ignored when constructing `post_body` below.
    } else {
      list(arm = arm_of_records_to_delete)
    }

  post_body <- c(
    list(
      token     = token,
      content   = "record",
      action    = "delete"
    ),
    arm_list,
    records_to_delete
  )

  try(
    {
      # This is the important call that communicates with the REDCap server.
      kernel <-
        kernel_api(
          redcap_uri      = redcap_uri,
          post_body       = post_body,
          config_options  = config_options,
          handle_httr     = handle_httr
        )
    },
    # Don't print the warning in the try block.  Print it below,
    #   where it's under the control of the caller.
    silent = TRUE
  )

  if (exists("kernel")) {
    if (kernel$success) {
      records_affected_count <- as.integer(kernel$raw_text)
      outcome_message <- sprintf(
        paste(
          "The %s records were deleted from REDCap in %0.1f seconds.",
          "The http status code was %i."
        ),
        format(
          records_affected_count,
          big.mark = ",",
          scientific = FALSE,
          trim = TRUE
        ),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      # If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
      kernel$raw_text <- ""
    } else {
      records_affected_count <- 0
      error_message <- sprintf(
        paste(
          "The REDCapR record deletion failed.",
          "The http status code was %i.",
          "The error message was: '%s'."
        ),
        kernel$status_code,
        kernel$raw_text
      )
      stop(error_message)
    }
  } else {
    # nocov start
    error_message     <- sprintf(
      paste(
        "The REDCapR record deletion was not successful.",
        "The error message was:\n%s"
      ),
      kernel$raw_text
    )
    stop(error_message)
    # nocov end
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
