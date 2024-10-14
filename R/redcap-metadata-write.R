#' @title
#' Import metadata of a REDCap project
#'
#' @description
#' Import metadata (*i.e.*, data dictionary)
#' into a project. Because of this method's destructive nature,
#' it works for only projects in Development status.
#'
#' @param ds The [base::data.frame()] or [tibble::tibble()]
#' to be imported into the REDCap project.
#' Required.
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
#' Currently, a list is returned with the following elements:
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `field_count`: Number of fields imported.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' @author
#' Will Beasley
#'
#' @references
#' The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki.
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' # Please don't run this example without changing the token to
#' # point to your server.  It could interfere with our testing suite.
#' uri            <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token          <- "06C38F6D76B3863DFAE84069D8DBCFFC" # metadata-write
#'
#' # Read in the dictionary in R's memory from a csv file.
#' ds_to_write <-
#'   readr::read_csv(
#'     file = system.file(
#'       "test-data/projects/simple/metadata.csv",
#'       package = "REDCapR"
#'     ),
#'     col_types = readr::cols(.default = readr::col_character())
#'   )
#' ds_to_write
#'
#' # Import the dictionary into the REDCap project
#' REDCapR::redcap_metadata_write(
#'   ds          = ds_to_write,
#'   redcap_uri  = uri,
#'   token       = token
#' )
#' }
#'
#' @export
redcap_metadata_write <- function(
  ds,
  redcap_uri,
  token,
  verbose         = TRUE,
  config_options  = NULL,
  handle_httr       = NULL
) {

  # This prevents the R CHECK NOTE: 'No visible binding for global variable Note in R CMD check';
  # Also see if( getRversion() >= "2.15.1" )    utils::globalVariables(names=c("csv_elements"))
  # https://stackoverflow.com/questions/8096313/; https://stackoverflow.com/questions/9439256
  csv_elements <- NULL

  checkmate::assert_character(redcap_uri, any.missing = FALSE, len = 1, pattern = "^.{1,}$")
  checkmate::assert_character(token     , any.missing = FALSE, len = 1, pattern = "^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  con     <-  base::textConnection(
    object  = "csv_elements",
    open    = "w",
    local   = TRUE
  )
  utils::write.csv(ds, con, row.names = FALSE, na = "")
  close(con)

  csv     <- paste(csv_elements, collapse = "\n")
  rm(csv_elements, con)

  post_body <- list(
    token         = token,
    content       = "metadata",
    format        = "csv",
    data          = csv,
    returnFormat  = "csv"
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
    field_count           <- as.integer(kernel$raw_text)
    outcome_message       <- sprintf(
      "%s fields were written to the REDCap dictionary in %0.1f seconds.",
      format(field_count, big.mark = ",", scientific = FALSE, trim = TRUE),
      kernel$elapsed_seconds
    )

    # If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
    kernel$raw_text <- ""
  } else { # If the returned content wasn't recognized as a valid integer, then
    field_count            <- 0L
    outcome_message        <- sprintf(
      "The REDCapR write/import metadata operation was not successful.  The error message was:\n%s",
      kernel$raw_text
    )
  }

  if (verbose)
    message(outcome_message)

  list(
    success                   = kernel$success,
    status_code               = kernel$status_code,
    outcome_message           = outcome_message,
    field_count               = field_count,
    elapsed_seconds           = kernel$elapsed_seconds,
    raw_text                  = kernel$raw_text
  )
}
