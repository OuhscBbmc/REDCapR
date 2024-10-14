#' @title
#' Write/Import records to a REDCap project
#'
#' @description
#' This function uses REDCap's API to select and return data.
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
#' @param overwrite_with_blanks A boolean value indicating if
#' blank/`NA` values in the R data frame
#' will overwrite data on the server.
#' This is the default behavior for REDCapR,
#' which essentially deletes the cell's value
#' If `FALSE`, blank/`NA` values in the data frame
#' will be ignored.  Optional.
#' @param convert_logical_to_integer If `TRUE`, all [base::logical] columns
#' in `ds` are cast to an integer before uploading to REDCap.
#' Boolean values are typically represented as 0/1 in REDCap radio buttons.
#' Optional.
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
#' * `records_affected_count`: The number of records inserted or updated.
#' * `affected_ids`: The subject IDs of the inserted or updated records.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' @details
#' Currently, the function doesn't modify any variable types to conform to
#' REDCap's supported variables.  See [validate_for_write()] for a helper
#' function that checks for some common important conflicts.
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
#' if (FALSE) {
#' # Define some constants
#' uri            <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token          <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write
#'
#' # Read the dataset for the first time.
#' result_read1   <- REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token)
#' ds1            <- result_read1$data
#' ds1$telephone
#'
#' # Manipulate a field in the dataset in a VALID way
#' ds1$telephone  <- paste0("(405) 321-000", seq_len(nrow(ds1)))
#'
#' ds1 <- ds1[1:3, ]
#' ds1$age        <- NULL; ds1$bmi <- NULL # Drop the calculated fields before writing.
#' result_write   <- REDCapR::redcap_write_oneshot(ds=ds1, redcap_uri=uri, token=token)
#'
#' # Read the dataset for the second time.
#' result_read2   <- REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token)
#' ds2            <- result_read2$data
#' ds2$telephone
#'
#' # Manipulate a field in the dataset in an INVALID way.  A US exchange can't be '111'.
#' ds1$telephone  <- paste0("(405) 321-000", seq_len(nrow(ds1)))
#'
#' # This next line will throw an error.
#' result_write   <- REDCapR::redcap_write_oneshot(ds=ds1, redcap_uri=uri, token=token)
#' result_write$raw_text
#' }

#' @importFrom magrittr %>%
#' @export
redcap_write_oneshot <- function(
  ds,
  redcap_uri,
  token,
  overwrite_with_blanks         = TRUE,
  convert_logical_to_integer    = FALSE,
  verbose                       = TRUE,
  config_options                = NULL,
  handle_httr                   = NULL
) {

  # This prevents the R CHECK NOTE: 'No visible binding for global variable Note in R CMD check';
  # Also see  if( getRversion() >= "2.15.1" )    utils::globalVariables(names=c("csv_elements"))
  # https://stackoverflow.com/questions/8096313/; https://stackoverflow.com/questions/9439256
  csv_elements <- NULL

  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)
  overwrite_with_blanks <- dplyr::if_else(overwrite_with_blanks, "overwrite", "normal")

  if (convert_logical_to_integer) {
    ds <-
      ds %>%
      dplyr::mutate_if(is.logical, as.integer)
  }

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
    token     = token,
    content   = "record",
    format    = "csv",
    type      = "flat",

    # These next values separate the import from the export API call
    # overwriteBehavior:
    #  *normal* - blank/empty values will be ignored [default];
    #  *overwrite* - blank/empty values are valid and will overwrite data

    data                = csv,
    overwriteBehavior   = overwrite_with_blanks,
    returnContent       = "ids",
    returnFormat        = "csv"
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
    elements               <- unlist(strsplit(kernel$raw_text, split="\\n"))
    affected_ids           <- as.character(elements[-1])
    records_affected_count <- length(affected_ids)
    outcome_message        <- sprintf(
      "%s records were written to REDCap in %0.1f seconds.",
      format(records_affected_count, big.mark = ",", scientific = FALSE, trim = TRUE),
      kernel$elapsed_seconds
    )

    # If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
    kernel$raw_text <- ""
  } else { # If the returned content wasn't recognized as valid IDs, then
    affected_ids           <- character(0) # Return an empty array
    records_affected_count <- NA_integer_
    outcome_message        <- sprintf(
      "The REDCapR write/import operation was not successful.  The error message was:\n%s",
      kernel$raw_text
    )
  }

  if (verbose)
    message(outcome_message)

  list(
    success                   = kernel$success,
    status_code               = kernel$status_code,
    outcome_message           = outcome_message,
    records_affected_count    = records_affected_count,
    affected_ids              = affected_ids,
    elapsed_seconds           = kernel$elapsed_seconds,
    raw_text                  = kernel$raw_text
  )
}
