#' @title REDCapR internal function for calling the REDCap API
#'
#' @description This function is used by other functions to read and write
#' values.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap
#' project.  Required.
#' @param post_body List of contents expected by the REDCap API.  Required.
#' @param config_options  A list of options to pass to `POST` method in the
#' `httr` package.  See the details below.  Optional.
#' @param encoding  The encoding value passed to [httr::content()].  Defaults
#' to 'UTF-8'.
#' @param content_type The MIME value passed to [httr::content()].  Defaults
#' to 'text/csv'.
#'
#' @return A [utils::packageVersion].
#'
#' @details If the API call is unsuccessful, a value of
#' `base::package_version("0.0.0")` will be returned.  This ensures that a
#' the function will always return an object of class [base::package_version].
#' It guarantees the value can always be used in [utils::compareVersion()].
#'
#' @examples
#' config_options <- NULL
#' uri            <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token          <- "9A81268476645C4E5F03428B8AC3AA7B"
#' post_body      <- list(
#'   token    = token,
#'   content  = 'project',
#'   format   = 'csv'
#' )
#' kernel <- REDCapR:::kernel_api(uri, post_body, config_options)
#'
#' # Consume the results in a few different ways.
#' kernel$result
#' read.csv(text=kernel$raw_text)
#' as.list(read.csv(text=kernel$raw_text))

kernel_api <- function(
  redcap_uri,
  post_body,
  config_options,
  encoding            = "UTF-8",
  content_type        = "text/csv"
  ) {

  start_time <- Sys.time()

  result <- httr::POST(
    url     = redcap_uri,
    body    = post_body,
    config  = config_options
  )

  status_code           <- result$status
  success               <- (status_code == 200L)
  # raw_text              <- as.character(httr::content(result, as = "text"))
  raw_text              <- httr::content(
    x           = result,
    as          = "text",
    encoding    = encoding,     # UTF-8 is the default parameter value
    type        = content_type  # text/csv is the default parameter value
  )

  # Convert all line-endings to linux-style
  raw_text        <- gsub("\r\n", "\n", raw_text)
  elapsed_seconds <- as.numeric(difftime(Sys.time(), start_time, units="secs"))

  # example: raw_text <- "The hostname (redcap-db.hsc.net.ou.edreu) / username (redcapsql) / password (XXXXXX) combination could not connect to the MySQL server. \r\n\t\tPlease check their values."
  regex_cannot_connect  <- "^The hostname \\((.+)\\) / username \\((.+)\\) / password \\((.+)\\) combination could not connect.+"
  regex_empty           <- "^\\s+$"

  # Overwrite the success flag if the raw_text is bad.
  if (
    any(grepl(regex_cannot_connect, raw_text)) |
    any(grepl(regex_empty         , raw_text))
  ) {
    success     <- FALSE  # nocov
  }

  return(list(
    status_code         = status_code,
    success             = success,
    raw_text            = raw_text,
    elapsed_seconds     = elapsed_seconds,
    result              = result,
    result_headers      = result$headers,

    regex_empty         = regex_empty
  ))
}
