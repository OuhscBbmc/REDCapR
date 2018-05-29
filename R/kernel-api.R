kernel_api <- function( redcap_uri, post_body, config_options ) {

  start_time <- Sys.time()

  result <- httr::POST(
    url     = redcap_uri,
    body    = post_body,
    config  = config_options
  )

  status_code           <- result$status
  success               <- (status_code==200L)
  raw_text              <- httr::content(result, "text")
  raw_text              <- gsub("\r\n", "\n", raw_text) # Convert all line-ending to linux-style
  elapsed_seconds       <- as.numeric(difftime(Sys.time(), start_time, units="secs"))

  # example: raw_text <- "The hostname (redcap-db.hsc.net.ou.edu) / username (redcapsql) / password (XXXXXX) combination could not connect to the MySQL server. \r\n\t\tPlease check their values."
  regex_cannot_connect  <- "^The hostname \\((.+)\\) / username \\((.+)\\) / password \\((.+)\\) combination could not connect.+"
  regex_empty           <- "^\\s+$"

  success     <- (success & !any(grepl(regex_cannot_connect, raw_text)) & !any(grepl(regex_empty, raw_text)))

  return( list(
    status_code         = status_code,
    success             = success,
    raw_text            = raw_text,
    elapsed_seconds     = elapsed_seconds,
    result              = result,
    result_headers      = result$headers,

    regex_empty         = regex_empty
  ) )
}
