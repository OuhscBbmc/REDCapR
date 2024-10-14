#' @title
#' Enumerate the exported variables
#'
#' @description
#' This function calls the 'exportFieldNames' function of the
#' REDCap API.
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
#' Currently, a list is returned with the following elements,
#' * `data`: A [tibble::tibble()] where each row represents one column
#' in the REDCap dataset.
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' @details
#' As of REDCap version 6.14.2, three variable types are *not* returned in
#' this call: calculated, file, and descriptive.  All variables returned are
#' writable/uploadable.
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
#' uri         <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token       <- "9A068C425B1341D69E83064A2D273A70"
#' ds_variable <- REDCapR::redcap_variables(redcap_uri=uri, token=token)$data
#' }

#' @export
redcap_variables <- function(
  redcap_uri,
  token,
  verbose           = TRUE,
  config_options    = NULL,
  handle_httr       = NULL
) {

  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token     = token,
    content   = "exportFieldNames",
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

  if (!kernel$success) {
    if (is.null(kernel$raw_text)) {
      # nocov start
      rlang::abort(
        message = "REDCapR::redcap_variables() encountered an error communicating with the server."
      )
      # nocov end
    } else {
      # nocov start
      rlang::abort(
        message = kernel$raw_text
      )
      # nocov end
    }
  } else {
    try(
      {
        # Convert the raw text to a dataset.
        ds <-
          readr::read_csv(
            file            = I(kernel$raw_text),
            show_col_types  = FALSE
          )
      },
      silent = TRUE
      # Don't print the warning in the try block.  Print it below, where
      #    it's under the control of the caller.
    )

    if (exists("ds") && inherits(ds, "data.frame")) {
      outcome_message <- sprintf(
        "%s variable metadata records were read from REDCap in %0.1f seconds.  The http status code was %i.",
        format(nrow(ds), big.mark = ",", scientific = FALSE, trim = TRUE),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      kernel$raw_text   <- ""
      # If an operation is successful, the `raw_text` is no longer returned
      #   to save RAM.  The content is not really necessary with httr's status
      #   message exposed.
    } else {
      # nocov start
      kernel$success  <- FALSE # Override the 'success' http status code.
      ds              <- tibble::tibble() # Return an empty data.frame

      outcome_message <- sprintf(
        "The REDCap variable retrieval failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  }
  # } else {
  #   ds              <- tibble::tibble() # Return an empty data.frame
  #   outcome_message <-
  #     if (any(grepl(kernel$regex_empty, kernel$raw_text))) {
  #       "The REDCapR read/export operation was not successful.  The returned dataset (of variables) was empty." # nocov
  #     } else {
  #       sprintf(
  #         "The REDCapR variable retrieval was not successful.  The error message was:\n%s",
  #         kernel$raw_text
  #       )
  #     }
  # }

  if (verbose)
    message(outcome_message)

  list(
    data                = ds,
    success             = kernel$success,
    status_code         = kernel$status_code,
    outcome_message     = outcome_message,
    elapsed_seconds     = kernel$elapsed_seconds,
    raw_text            = kernel$raw_text
  )
}
