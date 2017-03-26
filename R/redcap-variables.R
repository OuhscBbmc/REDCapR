#' @name redcap_variables
#' @export
#' @title Enumerate the exported variables.
#'
#' @description This function calls the 'exportFieldNames' function of the REDCap API.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  The verbose output might contain sensitive information (*e.g.* PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the `httr` package.  See the details below. Optional.
#' @return Currently, a list is returned with the following elements,
#' * `data`: An R [base::data.frame()] where each row represents one column in the readl dataset.
#' * `success`: A boolean value indicating if the operation was apparently successful.
#' * `status_code`: The [http status code](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the operation.
#' * `outcome_message`: A human readable string indicating the operation's outcome.
#' * `records_collapsed`: The desired records IDs, collapsed into a single string, separated by commas.
#' * `fields_collapsed`: The desired field names, collapsed into a single string, separated by commas.
#' * `filter_logic`: The filter statement passed as an argument.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by REDCap.  If an operation is successful, the `raw_text` is returned as an empty string to save RAM.
#'
#' @details
#' The full list of configuration options accepted by the `httr` package is viewable by executing [httr::httr_options()].  The `httr`
#' package and documentation is available at https://cran.r-project.org/package=httr.
#'
#' As of REDCap version 6.14.2, three variable types are *not* returned in this call:
#' calculated, file, and descriptive.  All variables returned are writable/uploadable.
#'
#' @author Will Beasley
#' @references The official documentation can be found on the 'API Help Page' and 'API Examples' pages
#' on the REDCap wiki (ie, https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html). If you do not have an account
#' for the wiki, please ask your campus REDCap administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' library(REDCapR) #Load the package into the current R session.
#' uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token    <- "9A81268476645C4E5F03428B8AC3AA7B"
#' ds_variable <- redcap_variables(redcap_uri=uri, token=token)$data
#' }
#'
redcap_variables <- function(
  redcap_uri, token, verbose=TRUE, config_options=NULL
) {
  start_time <- Sys.time()

  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_read_oneshot()`.")
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_read_oneshot()`.")

  token <- sanitize_token(token)

  post_body <- list(
    token                   = token,
    content                 = 'exportFieldNames',
    format                  = 'csv'
  )

  result <- httr::POST(
    url     = redcap_uri,
    body    = post_body,
    config  = config_options
  )

  status_code <- result$status
  success <- (status_code==200L)

  raw_text <- httr::content(result, "text")
  elapsed_seconds <- as.numeric(difftime(Sys.time(), start_time, units="secs"))

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
        ds <- utils::read.csv(text=raw_text, stringsAsFactors=FALSE)
        # ds <- readr::read_csv(file=raw_text)
      }, #Convert the raw text to a dataset.
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )


    if( exists("ds") & inherits(ds, "data.frame") ) {
      outcome_message <- paste0(
        format(nrow(ds), big.mark=",", scientific=FALSE, trim=TRUE),
        " variable metadata records were read from REDCap in ",
        round(elapsed_seconds, 1), " seconds.  The http status code was ",
        status_code, "."
      )

      #If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
      raw_text <- ""
    } else {
      success          <- FALSE #Override the 'success' determination from the http status code.
      ds               <- data.frame() #Return an empty data.frame
      outcome_message  <- paste0("The REDCap variable retrieval failed.  The http status code was ", status_code, ".  The 'raw_text' returned was '", raw_text, "'.")
    }
  }
  else {
    ds                 <- data.frame() #Return an empty data.frame
    if( any(grepl(regex_empty, raw_text)) ) {
      outcome_message    <- "The REDCapR read/export operation was not successful.  The returned dataset was empty."
    } else {
      outcome_message    <- paste0("The REDCapR variable retrieval was not successful.  The error message was:\n",  raw_text)
    }
  }

  if( verbose )
    message(outcome_message)

  return( list(
    data               = ds,
    success            = success,
    status_code        = status_code,
    outcome_message    = outcome_message,
    elapsed_seconds    = elapsed_seconds,
    raw_text           = raw_text
  ) )
}
