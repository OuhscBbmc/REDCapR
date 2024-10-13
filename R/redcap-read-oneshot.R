#' @title
#' Read/Export records from a REDCap project
#'
#' @description
#' This function uses REDCap's API to select and return data.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param records An array, where each element corresponds to the ID of a
#' desired record.  Optional.
#' @param fields An array, where each element corresponds to a desired project
#' field.  Optional.
#' @param forms An array, where each element corresponds to a desired project
#' form.  Optional.
#' @param events An array, where each element corresponds to a desired project
#' event.  Optional.
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
#' @param export_survey_fields A boolean that specifies whether to export the
#' survey identifier field (e.g., 'redcap_survey_identifier') or survey
#' timestamp fields (e.g., instrument+'_timestamp').
#' The timestamp outputs reflect the survey's *completion* time
#' (according to the time and timezone of the REDCap server.)
#' @param export_data_access_groups A boolean value that specifies whether or
#' not to export the `redcap_data_access_group` field when data access groups
#' are utilized in the project. Default is `FALSE`. See the details below.
#' @param filter_logic String of logic text (e.g., `[gender] = 'male'`) for
#' filtering the data to be returned by this API method, in which the API will
#' only return the records (or record-events, if a longitudinal project) where
#' the logic evaluates as TRUE.   An blank/empty string returns all records.
#' @param datetime_range_begin To return only records that have been created or
#' modified *after* a given datetime, provide a
#' [POSIXct](https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html)
#' value.
#' If not specified, REDCap will assume no begin time.
#' @param datetime_range_end To return only records that have been created or
#' modified *before* a given datetime, provide a
#' [POSIXct](https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html)
#' value.
#' If not specified, REDCap will assume no end time.
#' @param blank_for_gray_form_status A boolean value that specifies whether
#' or not to export blank values for instrument complete status fields that have
#' a gray status icon. All instrument complete status fields having a gray icon
#' can be exported either as a blank value or as "0" (Incomplete). Blank values
#' are recommended in a data export if the data will be re-imported into a
#' REDCap project. Default is `FALSE`.
#' @param col_types A [readr::cols()] object passed internally to
#' [readr::read_csv()].  Optional.
#' @param na A [character] vector passed internally to [readr::read_csv()].
#' Defaults to `c("", "NA")`.
#' @param guess_type A boolean value indicating if all columns should be
#' returned as character.  If true, [readr::read_csv()] guesses the intended
#' data type for each column.  Ignored if `col_types` is not null.
#' @param guess_max A positive [base::numeric] value
#' passed to [readr::read_csv()] that
#' specifies the maximum number of records to use for guessing column types.
#' @param http_response_encoding  The encoding value passed to
#' [httr::content()].  Defaults to 'UTF-8'.
#' @param locale a [readr::locale()] object to specify preferences like
#' number, date, and time formats.  This object is passed to
#' [readr::read_csv()].  Defaults to [readr::default_locale()].
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
# @param encode_httr The value passed to the `encode` parameter of
# [httr::POST()].
# This is useful for only unconventional authentication approaches.
# Defaults to `"multipart"`, which is appropriate for most institutions.
#'
#' @return
#' Currently, a list is returned with the following elements:
#' * `data`: A [tibble::tibble()] of the desired records and columns.
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `records_collapsed`: The desired records IDs, collapsed into a single
#' string, separated by commas.
#' * `fields_collapsed`: The desired field names, collapsed into a single
#' string, separated by commas.
#' * `filter_logic`: The filter statement passed as an argument.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' If no records are retrieved (such as no records meet the filter criteria),
#' a zero-row tibble is returned.
#' Currently the empty tibble has zero columns, but that may change in the future.
#'
#' @details
#' If you do not pass an `export_data_access_groups` value, it will default
#' to `FALSE`. The following is from the API help page for version 10.5.1:
#' *This flag is only viable if the user whose token is being used to make the
#' API request is **not** in a data access group. If the user is in a group,
#' then this flag will revert to its default value*.
#'
#' The REDCap project may contain "pseudofields", depending on its structure.
#' Pseudofields are exported for certain project structures, but are not
#' defined by users and do not appear in the codebook.
#' If a recognized pseudofield is passed to the `fields` api parameter,
#' it is suppressed by [REDCapR::redcap_read()] and [REDCapR::redcap_read_oneshot()]
#' so the server doesn't throw an error.
#' Requesting a pseudofield is discouraged, so a message is returned to the user.
#'
#' Pseudofields include:
#' * `redcap_event_name`: for longitudinal projects or multi-arm projects.
#' * `redcap_repeat_instrument`:  for projects with repeating instruments.
#' * `redcap_repeat_instance`:   for projects with repeating instruments.
#' * `redcap_data_access_group`: for projects with DAGs when the
#'   `export_data_access_groups` api parameter is TRUE.
#' * `redcap_survey_identifier`:  for projects with surveys when the
#'   `export_survey_fields` api parameter is TRUE.
#' * *instrument_name*`_timestamp`: for projects with surveys.
#'   For example, an instrument called "demographics" will have a pseudofield
#'   named `demographics_timestamp`.
#'   REDCapR does not suppress requests for timestamps, so the server will
#'   throw an error like
#'
#'   ```
#'   ERROR: The following values in the parameter fields are not valid: 'demographics_timestamp'
#'   ```
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
#' \dontrun{
#' uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token    <- "9A068C425B1341D69E83064A2D273A70"
#'
#' # Return all records and all variables.
#' ds <- REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token)$data
#'
#' # Return only records with IDs of 1 and 3
#' desired_records_v1 <- c(1, 3)
#' ds_some_rows_v1 <- REDCapR::redcap_read_oneshot(
#'   redcap_uri = uri,
#'   token      = token,
#'   records    = desired_records_v1
#' )$data
#'
#' # Return only the fields record_id, name_first, and age
#' desired_fields_v1 <- c("record_id", "name_first", "age")
#' ds_some_fields_v1 <- REDCapR::redcap_read_oneshot(
#'   redcap_uri = uri,
#'   token      = token,
#'   fields     = desired_fields_v1
#' )$data
#'
#' # Specify the column types.
#' col_types <- readr::cols(
#'   record_id  = readr::col_integer(),
#'   race___1   = readr::col_logical(),
#'   race___2   = readr::col_logical(),
#'   race___3   = readr::col_logical(),
#'   race___4   = readr::col_logical(),
#'   race___5   = readr::col_logical(),
#'   race___6   = readr::col_logical()
#' )
#' ds_col_types <- REDCapR::redcap_read_oneshot(
#'   redcap_uri = uri,
#'   token      = token,
#'   col_types  = col_types
#' )$data
#' }

#' @importFrom magrittr %>%
#' @export
redcap_read_oneshot <- function(
  redcap_uri,
  token,
  records                       = NULL,
  fields                        = NULL,
  forms                         = NULL,
  events                        = NULL,
  raw_or_label                  = "raw",
  raw_or_label_headers          = "raw",
  export_checkbox_label         = FALSE,
  # placeholder returnFormat
  export_survey_fields          = FALSE,
  export_data_access_groups     = FALSE,
  filter_logic                  = "",
  datetime_range_begin          = as.POSIXct(NA),
  datetime_range_end            = as.POSIXct(NA),
  blank_for_gray_form_status    = FALSE,
  col_types                     = NULL,
  na                            = c("", "NA"),
  guess_type                    = TRUE,
  guess_max                     = 1000,
  http_response_encoding        = "UTF-8",
  locale                        = readr::default_locale(),
  verbose                       = TRUE,
  config_options                = NULL,
  handle_httr                   = NULL
  # encode_httr                   = "multipart"
) {

  checkmate::assert_character(redcap_uri                , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_atomic(records                      , any.missing=TRUE , min.len=0)
  checkmate::assert_character(fields                    , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE)
  checkmate::assert_character(forms                     , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE)
  checkmate::assert_character(events                    , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE)
  checkmate::assert_character(raw_or_label              , any.missing=FALSE, len=1)
  checkmate::assert_subset(   raw_or_label              , c("raw", "label"))
  checkmate::assert_character(raw_or_label_headers      , any.missing=FALSE, len=1)
  checkmate::assert_subset(   raw_or_label_headers      , c("raw", "label"))
  checkmate::assert_logical(  export_checkbox_label     , any.missing=FALSE, len=1)
  # placeholder: returnFormat
  checkmate::assert_logical(  export_survey_fields      , any.missing=FALSE, len=1)
  checkmate::assert_logical(  export_data_access_groups , any.missing=FALSE, len=1)
  checkmate::assert_character(filter_logic              , any.missing=FALSE, len=1, pattern="^.{0,}$")
  checkmate::assert_posixct(  datetime_range_begin      , any.missing=TRUE , len=1, null.ok=TRUE)
  checkmate::assert_posixct(  datetime_range_end        , any.missing=TRUE , len=1, null.ok=TRUE)
  checkmate::assert_logical( blank_for_gray_form_status , any.missing=FALSE, len=1)

  checkmate::assert_character(na                        , any.missing=FALSE)
  checkmate::assert_logical(  guess_type                , any.missing=FALSE, len=1)
  checkmate::assert_numeric(   guess_max                , any.missing=FALSE, len=1, lower=1)

  checkmate::assert_character(http_response_encoding    , any.missing=FALSE,     len=1)
  checkmate::assert_class(    locale, "locale"          , null.ok = FALSE)
  checkmate::assert_logical(  verbose                   , any.missing=FALSE, len=1, null.ok=TRUE)
  checkmate::assert_list(     config_options            , any.missing=TRUE ,        null.ok=TRUE)
  # checkmate::assert_character(encode_httr               , any.missing=FALSE, len=1, null.ok = FALSE)

  assert_field_names(fields)

  pseudofields <- c(
    "redcap_event_name",
    "redcap_repeat_instrument",
    "redcap_repeat_instance",
    "redcap_survey_identifier",
    "redcap_data_access_group"
  )

  if (1L <= length(fields) && any(fields %in% pseudofields)) {
    fields  <- setdiff(fields, pseudofields) # Remove any that are requested.
    message(
      "At least one 'pseudofield' was requested and will be suppressed before calling the server. ",
      "The server will return it if it's appropriate for the project structure.\n\n",
      "Common pseudofields are: ",
      paste(pseudofields, collapse = ", "),
      "."
    )
  }

  token               <- sanitize_token(token)
  records_collapsed   <- collapse_vector(records)
  fields_collapsed    <- collapse_vector(fields)
  forms_collapsed     <- collapse_vector(forms)
  events_collapsed    <- collapse_vector(events)
  filter_logic        <- filter_logic_prepare(filter_logic)
  datetime_range_begin<- dplyr::coalesce(strftime(datetime_range_begin, "%Y-%m-%d %H:%M:%S"), "")
  datetime_range_end  <- dplyr::coalesce(strftime(datetime_range_end  , "%Y-%m-%d %H:%M:%S"), "")
  verbose             <- verbose_prepare(verbose)

  post_body <- list(
    token                   = token,
    content                 = "record",
    format                  = "csv",
    type                    = "flat",
    rawOrLabel              = raw_or_label,
    rawOrLabelHeaders       = raw_or_label_headers,
    exportCheckboxLabel     = tolower(as.character(export_checkbox_label)),
    # placeholder: returnFormat
    exportSurveyFields      = tolower(as.character(export_survey_fields)),
    exportDataAccessGroups  = tolower(as.character(export_data_access_groups)),
    filterLogic             = filter_logic,
    dateRangeBegin          = datetime_range_begin,
    dateRangeEnd            = datetime_range_end,
    exportBlankForGrayFormStatus = blank_for_gray_form_status
    # record, fields, forms & events are specified below
  )

  if (0L < nchar(records_collapsed)) post_body$records  <- records_collapsed
  if (0L < nchar(fields_collapsed )) post_body$fields   <- fields_collapsed
  if (0L < nchar(forms_collapsed  )) post_body$forms    <- forms_collapsed
  if (0L < nchar(events_collapsed )) post_body$events   <- events_collapsed

  # This is the important call that communicates with the REDCap server.
  kernel <- kernel_api(
    redcap_uri      = redcap_uri,
    post_body       = post_body,
    config_options  = config_options,
    encoding        = http_response_encoding,
    handle_httr     = handle_httr
    # encode_httr     = encode_httr
  )

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
          na              = na,
          guess_max       = guess_max,
          locale          = locale,
          show_col_types  = FALSE
        ),

      # Don't print the warning in the try block.  Print it below,
      #   where it's under the control of the caller.
      silent = TRUE
    )

    if (exists("ds") && inherits(ds, "data.frame")) {
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
      ds               <- tibble::tibble()
      outcome_message  <- sprintf(
        "The REDCap read failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  } else { # kernel fails
    ds              <- tibble::tibble() # Return an empty data.frame
    outcome_message <-
      if (any(grepl(kernel$regex_empty, kernel$raw_text))) {
        "The REDCapR read/export operation was not successful.  The returned dataset was empty."  # nocov
      } else {
        sprintf(
          "The REDCapR read/export operation was not successful.  The error message was:\n%s",
          kernel$raw_text
        )
      }
  }

  if (verbose)
    message(outcome_message)

  list(
    data                    = ds,
    success                 = kernel$success,
    status_code             = kernel$status_code,
    outcome_message         = outcome_message,
    records_collapsed       = records_collapsed,
    fields_collapsed        = fields_collapsed,
    forms_collapsed         = forms_collapsed,
    events_collapsed        = events_collapsed,
    filter_logic            = filter_logic,
    datetime_range_begin    = datetime_range_begin,
    datetime_range_end      = datetime_range_end,
    elapsed_seconds         = kernel$elapsed_seconds,
    raw_text                = kernel$raw_text
  )
}
