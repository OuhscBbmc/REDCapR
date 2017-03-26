#' @name redcap_version
#' @export
#' @title Determine version of REDCap instance
#'
#' @description This function uses REDCap's API to query its version.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  The verbose output might contain sensitive information (*e.g.* PHI), so turn this off if the output might be visible somewhere public. Optional.
#'
#' @details If the API call is unsuccessful, a value of `base::package_version("0.0.0")` will be returned.
#' This ensures that a the function will always return an object of class [base::package_version].
#' It guarantees the value can always be used in [utils::compareVersion()].
#'
#' @return A [utils::packageVersion].
#' @examples
#' library(REDCapR) #Load the package into the current R session.
#' uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token    <- "9A81268476645C4E5F03428B8AC3AA7B"
#' redcap_version(redcap_uri=uri, token=token)
#

redcap_version <- function( redcap_uri, token, verbose=TRUE ) {
 version_error=base::package_version("0.0.0")
  start_time <- Sys.time()

  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_version()`.")
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_version()`.")

  token <- sanitize_token(token)
  post_body <- list(
    token                   = token,
    content                 = 'version',
    format                  = 'csv'
  )

  result <- httr::POST(
    url     = redcap_uri,
    body    = post_body
  )

  status_code <- result$status
  success <- (status_code==200L)

  raw_text <- httr::content(result, "text")
  elapsed_seconds <- as.numeric(difftime(Sys.time(), start_time, units="secs"))

  # raw_text <- "The hostname (redcap-db.hsc.net.ou.edu) / username (redcapsql) / password (XXXXXX) combination could not connect to the MySQL server. \r\n\t\tPlease check their values."
  regex_cannot_connect <- "^The hostname \\((.+)\\) / username \\((.+)\\) / password \\((.+)\\) combination could not connect.+"
  regex_empty <- "^\\s+$"

  if(
    any(grepl(regex_cannot_connect, raw_text)) |
    any(grepl(regex_empty, raw_text))
  ) {
    success <- FALSE
  }

  if( success ) {
    try (
      {
        version <- package_version(raw_text)
      },
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )

    # if( exists("version") & inherits(version, "character") ) {
    if( exists("version") & inherits(version, "package_version") ) {
      outcome_message <- paste0(
        "The REDCap version was successfully determined in ",
        round(elapsed_seconds, 1), " seconds.  The http status code was ",
        status_code, ".  It is ", version, "."
      )

    } else {
      version          <- version_error
      outcome_message  <- paste0("The REDCap version determination failed.  The http status code was ", status_code, ".  The 'raw_text' returned was '", raw_text, "'.")
    }
  }
  else {
    version          <- version_error
    outcome_message  <- paste0("The REDCap version determination failed.  The error message was:\n",  raw_text)
  }

  if( verbose )
    message(outcome_message)

  return( version )
}
