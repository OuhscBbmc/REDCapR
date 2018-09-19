#' @title Read/Export records from a REDCap project
#'
#' @description This function uses REDCap's API to select and return data.
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param records An array, where each element corresponds to the ID of a desired record.  Optional.
#' @param records_collapsed A single string, where the desired ID values are separated by commas.  Optional.
#' @param fields An array, where each element corresponds to a desired project field.  Optional.
#' @param fields_collapsed A single string, where the desired field names are separated by commas.  Optional.
#' @param forms An array, where each element corresponds to a desired project form.  Optional.
#' @param forms_collapsed A single string, where the desired form names are separated by commas.  Optional.
#' @param events An array, where each element corresponds to a desired project event.  Optional.
#' @param events_collapsed A single string, where the desired event names are separated by commas.  Optional.
#' @param raw_or_label A string (either `'raw'` or `'label'`) that specifies whether to export the raw coded values or the labels for the options of multiple choice fields.  Default is `'raw'`.
#' @param raw_or_label_headers A string (either `'raw'` or `'label'` that specifies for the CSV headers whether to export the variable/field names (raw) or the field labels (label).  Default is `'raw'`.
#' @param export_checkbox_label specifies the format of checkbox field values specifically when exporting the data as labels.  If `raw_or_label` is `'label'` and `export_checkbox_label` is TRUE, the values will be the text displayed to the users.  Otherwise, the values will be 0/1.
# placeholder: returnFormat
#' @param export_survey_fields A boolean that specifies whether to export the survey identifier field (e.g., 'redcap_survey_identifier') or survey timestamp fields (e.g., instrument+'_timestamp') .
#' @param export_data_access_groups A boolean value that specifies whether or not to export the `redcap_data_access_group` field when data access groups are utilized in the project. Default is `FALSE`. See the details below.
#' @param filter_logic String of logic text (e.g., `[gender] = 'male'`) for filtering the data to be returned by this API method, in which the API will only return the records (or record-events, if a longitudinal project) where the logic evaluates as TRUE.   An blank/empty string returns all records.
#'
#' @param guess_type A boolean value indicating if all columns should be returned as character.  If false, [readr::read_csv()] guesses the intended data type for each column.
#' @param guess_max A positive integer passed to [readr::read_csv()] that specifies the maximum number of records to use for guessing column types.
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  The verbose output might contain sensitive information (*e.g.* PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the `httr` package.  See the details below. Optional.
#'
#' @return Currently, a list is returned with the following elements:
#' * `data`: An R [base::data.frame()] of the desired records and columns.
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
#' If you do not pass in this export_data_access_groups value, it will default to `FALSE`. The following is from the API help page for version 5.2.3: This flag is only viable if the user whose token is being used to make the API request is *not* in a data access group. If the user is in a group, then this flag will revert to its default value.
#' @author Will Beasley
#'
#' @references The official documentation can be found on the 'API Help Page' and 'API Examples' pages
#' on the REDCap wiki (*i.e.*, https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html). If you do not have an account
#' for the wiki, please ask your campus REDCap administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token    <- "9A81268476645C4E5F03428B8AC3AA7B"
#'
#' #Return all records and all variables.
#' ds <- REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token)$data
#'
#' #Return only records with IDs of 1 and 3
#' desired_records_v1 <- c(1, 3)
#' ds_some_rows_v1 <- REDCapR::redcap_read_oneshot(
#'    redcap_uri = uri,
#'    token      = token,
#'    records    = desired_records_v1
#' )$data
#'
#' #Return only the fields record_id, name_first, and age
#' desired_fields_v1 <- c("record_id", "name_first", "age")
#' ds_some_fields_v1 <- REDCapR::redcap_read_oneshot(
#'    redcap_uri = uri,
#'    token      = token,
#'    fields     = desired_fields_v1
#' )$data
#' }

#' @importFrom magrittr %>%
#' @export
redcap_read_oneshot <- function(
  redcap_uri,
  token,
  records                       = NULL, records_collapsed = "",
  fields                        = NULL, fields_collapsed  = "",
  forms                         = NULL, forms_collapsed   = "",
  events                        = NULL, events_collapsed  = "",
  raw_or_label                  = "raw",
  raw_or_label_headers          = "raw",
  export_checkbox_label         = FALSE,
  # placeholder returnFormat
  export_survey_fields          = FALSE,
  export_data_access_groups     = FALSE,
  filter_logic                  = "",

  guess_type                    = TRUE,
  guess_max                     = 1000L,
  verbose                       = TRUE,
  config_options                = NULL
) {

  checkmate::assert_character(redcap_uri                , any.missing=F, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=F, len=1, pattern="^.{1,}$")
  checkmate::assert_atomic(records                      , any.missing=T, min.len=0)
  checkmate::assert_character(records_collapsed         , any.missing=T, len=1, pattern="^.{0,}$", null.ok=T)
  checkmate::assert_character(fields                    , any.missing=T, min.len=1, pattern="^.{1,}$", null.ok=T)
  checkmate::assert_character(fields_collapsed          , any.missing=T, len=1, pattern="^.{0,}$", null.ok=T)
  checkmate::assert_character(forms                     , any.missing=T, min.len=1, pattern="^.{1,}$", null.ok=T)
  checkmate::assert_character(forms_collapsed           , any.missing=T, len=1, pattern="^.{0,}$", null.ok=T)
  checkmate::assert_character(events                    , any.missing=T, min.len=1, pattern="^.{1,}$", null.ok=T)
  checkmate::assert_character(events_collapsed          , any.missing=T, len=1, pattern="^.{0,}$", null.ok=T)
  checkmate::assert_character(raw_or_label              , any.missing=F, len=1)
  checkmate::assert_subset(   raw_or_label              , c("raw", "label"))
  checkmate::assert_character(raw_or_label_headers      , any.missing=F, len=1)
  checkmate::assert_subset(   raw_or_label_headers      , c("raw", "label"))
  checkmate::assert_logical(  export_checkbox_label     , any.missing=F, len=1)
  # placeholder: returnFormat
  checkmate::assert_logical(  export_survey_fields      , any.missing=F, len=1)
  checkmate::assert_logical(  export_data_access_groups , any.missing=F, len=1)
  checkmate::assert_character(filter_logic              , any.missing=F, len=1, pattern="^.{0,}$")
  #
  checkmate::assert_logical(  guess_type                , any.missing=F, len=1)
  checkmate::assert_integerish(guess_max                , any.missing=F, len=1, lower=1)
  checkmate::assert_logical(  verbose                   , any.missing=F, len=1, null.ok=T)
  checkmate::assert_list(     config_options            , any.missing=T, len=1, null.ok=T)

  validate_field_names(fields)

  token               <- sanitize_token(token)
  records_collapsed   <- collapse_vector(records  , records_collapsed)
  fields_collapsed    <- collapse_vector(fields   , fields_collapsed)
  forms_collapsed     <- collapse_vector(forms    , forms_collapsed)
  events_collapsed    <- collapse_vector(events   , events_collapsed)
  filter_logic        <- filter_logic_prepare(filter_logic)
  verbose             <- verbose_prepare(verbose)

  if( any(grepl("[A-Z]", fields_collapsed)) )
    warning("The fields passed to REDCap appear to have at least uppercase letter.  REDCap variable names are snake case.")

  post_body <- list(
    token                   = token,
    content                 = 'record',
    format                  = 'csv',
    type                    = 'flat',
    rawOrLabel              = raw_or_label,
    rawOrLabelHeaders       = raw_or_label_headers,
    exportCheckboxLabel     = tolower(as.character(export_checkbox_label)),
    # placeholder: returnFormat
    exportSurveyFields      = tolower(as.character(export_survey_fields)),
    exportDataAccessGroups  = tolower(as.character(export_data_access_groups)),
    filterLogic             = filter_logic
    # record, fields, forms & events are specified below
  )

  if( nchar(records_collapsed) > 0 ) post_body$records  <- records_collapsed
  if( nchar(fields_collapsed ) > 0 ) post_body$fields   <- fields_collapsed
  if( nchar(forms_collapsed  ) > 0 ) post_body$forms    <- forms_collapsed
  if( nchar(events_collapsed ) > 0 ) post_body$events   <- events_collapsed

  # This is the important line that communicates with the REDCap server.
  kernel <- kernel_api(redcap_uri, post_body, config_options)

  if( kernel$success ) {
    col_types <- if( guess_type ) NULL else readr::cols(.default=readr::col_character())
    try (
      {
        ds <-
          kernel$raw_text %>%
          readr::read_csv(col_types=col_types, guess_max=guess_max) %>%
          as.data.frame()
      }, #Convert the raw text to a dataset.
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )

    if( exists("ds") & inherits(ds, "data.frame") ) {
      outcome_message <- paste0(
        format(  nrow(ds), big.mark=",", scientific=FALSE, trim=TRUE), " records and ",
        format(length(ds), big.mark=",", scientific=FALSE, trim=TRUE), " columns were read from REDCap in ",
        round(kernel$elapsed_seconds, 1), " seconds.  The http status code was ", kernel$status_code, "."
      )

      # ds <- dplyr::mutate_if(
      #   ds,
      #   is.character,
      #   function(x) dplyr::coalesce(x, "") #Replace NAs with blanks
      # )
      #
      # ds <- dplyr::mutate_if(
      #   ds,
      #   is.character,
      #   function( x ) gsub("\r\n", "\n", x, perl=TRUE)
      # )
      # ds <- dplyr::mutate_if(
      #   ds,
      #   function( x) inherits(x, "Date"),
      #   as.character
      # )
      #
      # ds <- base::as.data.frame(ds)

      kernel$raw_text   <- "" # If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
    } else {
      kernel$success   <- FALSE #Override the 'success' determination from the http status code.
      ds               <- data.frame() #Return an empty data.frame
      outcome_message  <- paste0("The REDCap read failed.  The http status code was ", kernel$status_code, ".  The 'raw_text' returned was '", kernel$raw_text, "'.")
    }
  } else {
    ds                 <- data.frame() #Return an empty data.frame
    outcome_message    <- if( any(grepl(kernel$regex_empty, kernel$raw_text)) ) {
      "The REDCapR read/export operation was not successful.  The returned dataset was empty."
    } else {
      paste0("The REDCapR read/export operation was not successful.  The error message was:\n",  kernel$raw_text)
    }
  }

  if( verbose )
    message(outcome_message)

  return( list(
    data               = ds,
    success            = kernel$success,
    status_code        = kernel$status_code,
    outcome_message    = outcome_message,
    records_collapsed  = records_collapsed,
    fields_collapsed   = fields_collapsed,
    forms_collapsed    = forms_collapsed,
    events_collapsed   = events_collapsed,
    filter_logic       = filter_logic,
    elapsed_seconds    = kernel$elapsed_seconds,
    raw_text           = kernel$raw_text
  ) )
}
