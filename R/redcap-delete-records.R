#' @title Delete one ore more records from REDCap
#'
#' @description Delete existing records by their ID from REDCap.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap
#' project.  Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param record_ids A single record id or an array of ids to delete.
#' Make sure these ids exist in REDCap.
#' @inheritParams redcap_metadata_read
#'
#' @return The number of records deleted.
#'
#' @author Jonathan Mang
#'
#' @examples
#' \dontrun{
#' uri   <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token <- "9A81268476645C4E5F03428B8AC3AA7B"
#' redcap_delete_records(redcap_uri = redcap_uri,
#'                      token = token,
#'                      record_ids = record_ids)
#' }

#' @importFrom magrittr %>%
#' @export
redcap_delete_records <- function(redcap_uri,
                                  token,
                                  record_ids,
                                  verbose = TRUE,
                                  config_options = NULL) {
  ## Make sure the url and the token are syntactically valid:
  checkmate::assert_character(
    redcap_uri,
    any.missing = FALSE,
    len = 1,
    pattern = "^.{1,}$"
  )
  checkmate::assert_character(token,
                              any.missing = FALSE,
                              len = 1,
                              pattern = "^.{1,}$")

  token <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(token = token,
                    action = "delete",
                    content = "record")

  ## Add the actual ids to remove to the body:
  i <- 0
  for (id in record_ids) {
    post_body[[paste0("records[", i, "]")]] <- id
    i <- i + 1
  }

  # This is the important line that communicates with the REDCap server.
  kernel <- kernel_api(redcap_uri, post_body, config_options)

  if (kernel$success) {
    try({
      # Convert the raw text to a dataset.
      res <- as.numeric(kernel$raw_text)
    },
    # Don't print the warning in the try block.  Print it below,
    #   where it's under the control of the caller.
    silent = TRUE)

    if (exists("res") & inherits(res, "numeric")) {
      outcome_message <- sprintf(
        paste(
          "The %s records were deleted from REDCap in %0.1f seconds.",
          "The http status code was %i."
        ),
        format(
          length(record_ids),
          big.mark = ",",
          scientific = FALSE,
          trim = TRUE
        ),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      # If an operation is successful, the `raw_text` is no longer returned
      #   to save RAM.  The content is not really necessary with httr's status
      #   message exposed.
      kernel$raw_text   <- ""
    } else {
      # nocov start
      # Override the 'success' determination from the http status code
      #   and return an empty numeric.
      kernel$success <- FALSE
      res <- numeric()
      outcome_message <- sprintf(
        paste(
          "The REDCap record deletion failed.",
          "The http status code was %i.",
          "The 'raw_text' returned was '%s'."
        ),
        kernel$status_code,
        kernel$raw_text
      )
    }       # nocov end
  } else {
    res <- numeric() # Return an empty numeric
    outcome_message     <- sprintf(
      paste(
        "The REDCapR record deletion was not successful.",
        "The error message was:\n%s"
      ),
      kernel$raw_text
    )
  }

  if (verbose)
    message(outcome_message)

  return(
    list(
      data               = res,
      success            = kernel$success,
      status_code        = kernel$status_code,
      outcome_message    = outcome_message,
      elapsed_seconds    = kernel$elapsed_seconds,
      raw_text           = kernel$raw_text
    )
  )
}
