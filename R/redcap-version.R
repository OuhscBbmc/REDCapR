#' @title
#' Determine version of REDCap instance
#'
#' @description
#' This function uses REDCap's API to query its version.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for
#' a project.  Required.
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
#' a [utils::packageDescription]
#'
#' @details
#' If the API call is unsuccessful, a value of
#' `base::package_version("0.0.0")` will be returned.
#' This ensures that a the function will always return an object of class
#' [base::numeric_version].  It guarantees the value can always be used in
#' [utils::compareVersion()].
#'
#' @examples
#' uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token    <- "9A068C425B1341D69E83064A2D273A70"
#' REDCapR::redcap_version(redcap_uri = uri, token = token)

#' @export
redcap_version <- function(
  redcap_uri,
  token,
  verbose         = TRUE,
  config_options  = NULL,
  handle_httr       = NULL
) {

  version_error <- base::package_version("0.0.0")

  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token    = token,
    content  = "version",
    format   = "csv"
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
    try(
      version <- package_version(kernel$raw_text),
      silent = TRUE
      # Don't print the warning in the try block.  Print it below, where it's
      #   under the control of the caller.
    )

    if (exists("version") && inherits(version, "package_version")) {
      outcome_message <- sprintf(
        "The REDCap version was successfully determined in %0.1f seconds. The http status code was %i.  Is is %s.",
        kernel$elapsed_seconds,
        kernel$status_code,
        version
      )
    } else {
      # nocov start
      version          <- version_error
      outcome_message  <- sprintf(
        "The REDCap version determination failed.  The http status code was %s.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  } else {
    version          <- version_error
    outcome_message  <- sprintf(
      "The REDCap version determination failed.  The error message was:\n%s",
      kernel$raw_text
    )
  }

  if (verbose)
    message(outcome_message)

  version
}
