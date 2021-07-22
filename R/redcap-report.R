#' @title Read/Export records that populate a REDCap report
#'
#' @description Exports the data set of a report created on a project's
#' 'Data Exports, Reports, and Stats' page.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap
#' project.  Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param report_id A single integer, provided next to the report name on the
#' report list page.  Required.
#' @param raw_or_label A string (either `'raw'` or `'label'`) that specifies
#' whether to export the raw coded values or the labels for the options of
#' multiple choice fields.  Default is `'raw'`.
#' @param raw_or_label_headers A string (either `'raw'` or `'label'` that
#' specifies for the CSV headers whether to export the variable/field names
#' (raw) or the field labels (label).  Default is `'raw'`.
#' @param export_checkbox_label specifies the format of checkbox field values
#' specifically when exporting the data as labels.  If `raw_or_label` is
#' `'label'` and `export_checkbox_label` is TRUE, the values will be the text
#' displayed to the users.  Otherwise, the values will be 0/1.
# placeholder: returnFormat
#' @param col_types A [readr::cols()] object passed internally to
#' [readr::read_csv()].  Optional.
#' @param guess_type A boolean value indicating if all columns should be
#' returned as character.  If false, [readr::read_csv()] guesses the intended
#' data type for each column.  Ignored if `col_types` is not null.
#' @param guess_max A positive integer passed to [readr::read_csv()] that
#' specifies the maximum number of records to use for guessing column types.
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the
#' `httr` package.  See the details below. Optional.
#'
#' @return Currently, a list is returned with the following elements:
#' * `data`: An R [base::data.frame()] of the desired records and columns.
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
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
#' uri          <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token        <- "9A81268476645C4E5F03428B8AC3AA7B"
#' report_1_id  <- 5980L
#' report_2_id  <- 6431L
#'
#' # Return all records and all variables.
#' ds_1a <-
#'   REDCapR::redcap_report(
#'     redcap_uri = uri,
#'     token      = token,
#'     report_id  = report_1_id
#'   )$data
#'
#'
#' # Specify the column types.
#' col_types_1 <- readr::cols(
#'   record_id          = readr::col_integer(),
#'   height             = readr::col_double(),
#'   health_complete    = readr::col_integer(),
#'   address            = readr::col_character(),
#'   ethnicity          = readr::col_integer()
#' )
#' ds_1b <-
#'   REDCapR::redcap_report(
#'     redcap_uri = uri,
#'     token      = token,
#'     report_id  = report_1_id,
#'     col_types  = col_types_1
#'   )$data
#'
#'
#' # Return condensed checkboxes Report option:
#' #   "Combine checkbox options into single column of only the checked-off
#' #   options (will be formatted as a text field when exported to
#' #   stats packages)"
#' col_types_2 <- readr::cols(
#'   record_id          = readr::col_integer(),
#'   race               = readr::col_character()
#' )
#' ds_2 <-
#'   REDCapR::redcap_report(
#'     redcap_uri = uri,
#'     token      = token,
#'     report_id  = report_2_id,
#'     col_types  = col_types_2
#'   )$data
#' }

#' @importFrom magrittr %>%
#' @export
redcap_report <- function(
  redcap_uri,
  token,
  report_id,
  raw_or_label                  = "raw",
  raw_or_label_headers          = "raw",
  export_checkbox_label         = FALSE,

  col_types                     = NULL,
  guess_type                    = TRUE,
  guess_max                     = 1000L,
  verbose                       = TRUE,
  config_options                = NULL
) {

  checkmate::assert_character(redcap_uri                , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_integerish(report_id                , any.missing=FALSE, len=1, lower=1)
  checkmate::assert_character(raw_or_label              , any.missing=FALSE, len=1)
  checkmate::assert_subset(   raw_or_label              , c("raw", "label"))
  checkmate::assert_character(raw_or_label_headers      , any.missing=FALSE, len=1)
  checkmate::assert_subset(   raw_or_label_headers      , c("raw", "label"))
  checkmate::assert_logical(  export_checkbox_label     , any.missing=FALSE, len=1)

  checkmate::assert_logical(  guess_type                , any.missing=FALSE, len=1)
  checkmate::assert_integerish(guess_max                , any.missing=FALSE, len=1, lower=1)
  checkmate::assert_logical(  verbose                   , any.missing=FALSE, len=1, null.ok=TRUE)
  checkmate::assert_list(     config_options            , any.missing=TRUE ,        null.ok=TRUE)

  token               <- sanitize_token(token)
  verbose             <- verbose_prepare(verbose)

  post_body <- list(
    token                   = token,
    content                 = "report",
    report_id               = report_id,
    format                  = "csv",
    rawOrLabel              = raw_or_label,
    rawOrLabelHeaders       = raw_or_label_headers,
    exportCheckboxLabel     = tolower(as.character(export_checkbox_label))
  )

  # This is the important line that communicates with the REDCap server.
  kernel <- kernel_api(redcap_uri, post_body, config_options)

  if (kernel$success) {
    col_types <-
      if (!is.null(col_types)) col_types
      else if (guess_type)     NULL
      else                     readr::cols(.default = readr::col_character())

    try(
      # Convert the raw text to a dataset.
      ds <-
        readr::read_csv(
          file            = I(kernel$raw_text),
          col_types       = col_types,
          guess_max       = guess_max,
          show_col_types  = FALSE
        ) %>%
        as.data.frame(),

      # Don't print the warning in the try block.  Print it below,
      #   where it's under the control of the caller.
      silent = TRUE
    )

    if (exists("ds") & inherits(ds, "data.frame")) {
      outcome_message <- sprintf(
        "%s records and %s columns were read from REDCap in %0.1f seconds.  The http status code was %i.",
        format(  nrow(ds), big.mark = ",", scientific = FALSE, trim = TRUE),
        format(length(ds), big.mark = ",", scientific = FALSE, trim = TRUE),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      # If an operation is successful, the `raw_text` is no longer returned to
      #   save RAM.  The content is not really necessary with httr's status
      #   message exposed.
      kernel$raw_text   <- ""
    } else { # ds doesn't exist as a data.frame.
      # nocov start
      # Override the 'success' determination from the http status code.
      #   and return an empty data.frame.
      kernel$success   <- FALSE
      ds               <- data.frame()
      outcome_message  <- sprintf(
        "The REDCap report failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  } else { # kernel fails
    ds              <- data.frame() #Return an empty data.frame
    outcome_message <- if (any(grepl(kernel$regex_empty, kernel$raw_text))) {
      "The REDCapR report operation was not successful.  The returned dataset was empty."  # nocov
    } else {
      sprintf(
        "The REDCapR report operation was not successful.  The error message was:\n%s",
        kernel$raw_text
      )
    }
  }

  if (verbose)
    message(outcome_message)

  list(
    data               = ds,
    success            = kernel$success,
    status_code        = kernel$status_code,
    outcome_message    = outcome_message,
    report_id          = report_id,
    elapsed_seconds    = kernel$elapsed_seconds,
    raw_text           = kernel$raw_text
  )
}
