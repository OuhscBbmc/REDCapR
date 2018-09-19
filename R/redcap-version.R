#' @title Determine version of REDCap instance
#'
#' @description This function uses REDCap's API to query its version.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  The verbose output might contain sensitive information (*e.g.* PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the `httr` package.  See the details below.  Optional.
#'
#' @return a \code{\link[utils:packageDescription]{utils::packageVersion}}.
#'
#' @details If the API call is unsuccessful, a value of `base::package_version("0.0.0")` will be returned.
#' This ensures that a the function will always return an object of class \code{\link[base:numeric_version]{base::package_version}}.
#' It guarantees the value can always be used in [utils::compareVersion()].
#'
#' @examples
#' uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token    <- "9A81268476645C4E5F03428B8AC3AA7B"
#' REDCapR::redcap_version(redcap_uri=uri, token=token)

#' @export
redcap_version <- function( redcap_uri, token, verbose=TRUE, config_options=NULL ) {
  version_error <- base::package_version("0.0.0")

  checkmate::assert_character(redcap_uri                , any.missing=F, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=F, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token                   = token,
    content                 = 'version',
    format                  = 'csv'
  )

  # This is the important line that communicates with the REDCap server.
  kernel <- kernel_api(redcap_uri, post_body, config_options)

  if( kernel$success ) {
    try (
      {
        version <- package_version(kernel$raw_text)
      },
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )

    # if( exists("version") & inherits(version, "character") ) {
    if( exists("version") & inherits(version, "package_version") ) {
      outcome_message <- paste0(
        "The REDCap version was successfully determined in ",
        round(kernel$elapsed_seconds, 1), " seconds.  The http status code was ",
        kernel$status_code, ".  It is ", version, "."
      )

    } else {
      version          <- version_error
      outcome_message  <- paste0("The REDCap version determination failed.  The http status code was ", kernel$status_code, ".  The 'raw_text' returned was '", kernel$raw_text, "'.")
    }
  } else {
    version          <- version_error
    outcome_message  <- paste0("The REDCap version determination failed.  The error message was:\n",  kernel$raw_text)
  }

  if( verbose )
    message(outcome_message)

  return( version )
}
