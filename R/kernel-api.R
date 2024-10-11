#' @title
#' REDCapR internal function for calling the REDCap API
#'
#' @description
#' This function is used by other functions to read and write values.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param post_body List of contents expected by the REDCap API.  Required.
#' @param config_options A list of options passed to [httr::POST()].
#' See details at [httr::httr_options()]. Optional.
#' @param encoding  The encoding value passed to [httr::content()].  Defaults
#' to 'UTF-8'.
#' @param content_type The MIME value passed to [httr::content()].  Defaults
#' to 'text/csv'.
#' @param handle_httr The value passed to the `handle` parameter of
#' [httr::POST()].
#' This is useful for only unconventional authentication approaches.  It
#' should be `NULL` for most institutions.
#' @param encode_httr The value passed to the `encode` parameter of
#' [httr::POST()].
#' Defaults to `"form"`, which is appropriate for most actions.
#' (Currently, the only exception is importing a file,
#' which uses "multipart".)
#'
#' @return
#' A [utils::packageVersion].
#'
#' @details
#' If the API call is unsuccessful, a value of
#' `base::package_version("0.0.0")` will be returned.  This ensures that a
#' the function will always return an object of class [base::package_version].
#' It guarantees the value can always be used in [utils::compareVersion()].
#'
#' @examples
#' config_options <- NULL
#' uri            <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token          <- "9A068C425B1341D69E83064A2D273A70"
#' post_body      <- list(
#'   token    = token,
#'   content  = "project",
#'   format   = "csv"
#' )
#' \dontrun{
#' kernel <- REDCapR:::kernel_api(uri, post_body, config_options)
#'
#' # Consume the results in a few different ways.
#' kernel$result
#' read.csv(text = kernel$raw_text)
#' as.list(read.csv(text = kernel$raw_text))
#' }

kernel_api <- function(
  redcap_uri,
  post_body,
  config_options,
  encoding            = "UTF-8",
  content_type        = "text/csv",
  handle_httr         = NULL,
  encode_httr         = "form"
) {

  checkmate::assert_character(redcap_uri    , len = 1, any.missing = FALSE, null.ok = FALSE)
  checkmate::assert_character(encoding      , len = 1, any.missing = FALSE, null.ok = FALSE)
  checkmate::assert_character(content_type  , len = 1, any.missing = FALSE, null.ok = FALSE)
  # checkmate::assert_character(encode_httr   , len = 1, any.missing = FALSE, null.ok = FALSE)

  start_time <- Sys.time()

  # if (httr::http_error(redcap_uri)) {
  #   stop("The url `", redcap_uri, "` is not found or throws an error.")
  # }

  response <- httr::POST(
    url     = redcap_uri,
    body    = post_body,
    config  = config_options,
    handle  = handle_httr,
    encode  = encode_httr,
    httr::user_agent("OuhscBbmc/REDCapR")
  )

  status_code <- response$status
  success     <- (status_code == 200L)
  raw_text    <- httr::content(
    x           = response,
    as          = "text",
    encoding    = encoding,     # UTF-8 is the default parameter value
    type        = content_type  # text/csv is the default parameter value
  )

  # Convert all line-endings to linux-style
  raw_text        <- gsub("\r\n", "\n", raw_text)
  elapsed_seconds <- as.numeric(difftime(Sys.time(), start_time, units="secs"))

  regex_cannot_connect  <- "^The hostname \\((.+)\\) / username \\((.+)\\) / password \\((.+)\\) combination could not connect.+"
  regex_empty           <- "^\\s+$"

  # Overwrite the success flag if the raw_text is bad.
  if (
    any(grepl(regex_cannot_connect, raw_text)) #||
    # any(grepl(regex_empty         , raw_text))
  ) {
    success <- FALSE  # nocov
  }

  return(list(
    status_code         = status_code,
    success             = success,
    raw_text            = raw_text,
    elapsed_seconds     = elapsed_seconds,
    result              = response,
    result_headers      = response$headers,
    regex_empty         = regex_empty
  ))
}
