#' @title Enumerate the exported variables
#'
#' @description This function calls the 'exportFieldNames' function of the
#' REDCap API.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap
#' project.  Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options A list of options to pass to `POST` method in the
#' `httr` package.  See the details below. Optional.
#'
#' @return Currently, a list is returned with the following elements,
#' * `data`: An R [base::data.frame()] where each row represents one column
#' in the REDCap dataset.
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' @details
#' The full list of configuration options accepted by the `httr` package is
#' viewable by executing [httr::httr_options()].  The `httr` package and
#' documentation is available at https://cran.r-project.org/package=httr.
#'
#' As of REDCap version 6.14.2, three variable types are *not* returned in
#' this call: calculated, file, and descriptive.  All variables returned are
#' writable/uploadable.
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
#' uri         <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token       <- "9A81268476645C4E5F03428B8AC3AA7B"
#' ds_variable <- REDCapR::redcap_variables(redcap_uri=uri, token=token)$data
#' }

#' @export
redcap_variables <- function(
  redcap_uri,
  token,
  verbose           = TRUE,
  config_options    = NULL
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

  # This is the important line that communicates with the REDCap server.
  kernel <- kernel_api(redcap_uri, post_body, config_options)

  if (kernel$success) {
    try(
      {
        ds <- readr::read_csv(file = kernel$raw_text)
      }, #Convert the raw text to a dataset.
      silent = TRUE
      # Don't print the warning in the try block.  Print it below, where
      #    it's under the control of the caller.
    )

    if (exists("ds") & inherits(ds, "data.frame")) {
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
      ds              <- data.frame() #Return an empty data.frame

      outcome_message <- sprintf(
        "The REDCap variable retrieval failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  } else {
    ds              <- data.frame() #Return an empty data.frame
    outcome_message <- if (any(grepl(kernel$regex_empty, kernel$raw_text))) {
      "The REDCapR read/export operation was not successful.  The returned dataset (of variables) was empty."
    } else {
      sprintf(
        "The REDCapR variable retrieval was not successful.  The error message was:\n%s",
        kernel$raw_text
      )
    }
  }

  if( verbose )
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
