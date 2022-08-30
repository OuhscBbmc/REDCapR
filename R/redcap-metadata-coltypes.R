#' @title Read/Export records from a REDCap project
#'
#' @description This function uses REDCap's API to select and return data.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param http_response_encoding  The encoding value passed to
#' [httr::content()].  Defaults to 'UTF-8'.
#' @param locale a [readr::locale()] object to specify preferences like
#' number, date, and time formats.  This object is passed to
#' [`readr::read_csv()`].  Defaults to [readr::default_locale()].
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the
#' `httr` package.  See the details below. Optional.
#'
#' @return Currently, a list is returned with the following elements:
#' * `data`: A [tibble::tibble()] of the desired records and columns.
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
#' uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
#'
#' # A simple project with a variety of types
#' token    <- "9A81268476645C4E5F03428B8AC3AA7B" # 153 - Simple
#' redcap_metadata_coltypes(uri, token)
#'
#' # This project includes every field type and validation type.
#' #   It throws a warning that some fields use a comma for a decimal,
#' #   while other fields use a period/dot as a decimal
#' token    <- "8F5313CAA266789F560D79EFCEE2E2F1" # 2634 - Validation Types
#' redcap_metadata_coltypes(uri, token)
#' }

#' @importFrom magrittr %>%
#' @export
redcap_metadata_coltypes <- function(
    redcap_uri,
    token,

    http_response_encoding        = "UTF-8",
    locale                        = readr::default_locale(),
    verbose                       = FALSE,
    config_options                = NULL
) {

  checkmate::assert_character(redcap_uri                , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=FALSE, len=1, pattern="^.{1,}$")

  checkmate::assert_character(http_response_encoding    , any.missing=FALSE,     len=1)
  checkmate::assert_class(    locale, "locale"          , null.ok = FALSE)
  checkmate::assert_logical(  verbose                   , any.missing=FALSE, len=1, null.ok=TRUE)
  checkmate::assert_list(     config_options            , any.missing=TRUE ,        null.ok=TRUE)

  token               <- sanitize_token(token)
  verbose             <- verbose_prepare(verbose)

  # Retrieve the info necessary to infer the likely data types
  d_var  <- REDCapR::redcap_variables(        redcap_uri, token, verbose = verbose)$data
  d_meta <- REDCapR::redcap_metadata_read(    redcap_uri, token, verbose = verbose)$data
  d_inst <- REDCapR::redcap_instruments(      redcap_uri, token, verbose = verbose)$data
  d_proj <- REDCapR::redcap_project_info_read(redcap_uri, token, verbose = verbose)$data

  # Determine status of autonumbering, instrument complete status, and decimal mark
  .record_field         <- d_var$original_field_name[1]
  .autonumber           <- d_proj$record_autonumbering_enabled[1]
  .form_complete_boxes  <- paste0(d_inst$instrument_name, "_complete")
  decimal_period        <- (locale$decimal_mark == ".")
  decimal_comma         <- (locale$decimal_mark == ",")

  # Prepare metadata to be joined
  d_meta <-
    d_meta %>%
    dplyr::select(
      field_name_original  = field_name,
      field_type,
      text_validation_type_or_show_slider_number,
    )

  # setdiff(d_meta$field_name_original, d_var$original_field_name)
  # [1] "signature"   "file_upload" "descriptive"

  # Translate the four datasets into a single `readr:cols()` string printed to the console
  meat <-
    d_var %>%
    dplyr::select(
      field_name = export_field_name,
      field_name_original  = original_field_name
    ) %>%
    dplyr::left_join(d_meta, by = "field_name_original") %>%
    dplyr::select(
      field_name,
      field_type,
      vt            = text_validation_type_or_show_slider_number,
    ) %>%
    dplyr::mutate(
      vt          = dplyr::if_else(.data$field_name %in% .form_complete_boxes, "complete", vt),
      autonumber  = (.autonumber & (.data$field_name == .record_field)),
    ) %>%
    dplyr::mutate(
      response =
        dplyr::case_when(
          autonumber                                          ~ paste0("col_integer()"                        , "~~record_autonumbering is enabled for the project"),
          field_type == "truefalse"                           ~ paste0("col_logical()"                        , "~~field_type is truefalse"),
          field_type == "yesno"                               ~ paste0("col_logical()"                        , "~~field_type is yesno"),
          field_type == "checkbox"                            ~ paste0("col_logical()"                        , "~~field_type is checkbox"),
          field_type == "radio"                               ~ paste0("col_character()"                      , "~~field_type is radio"),
          field_type == "dropdown"                            ~ paste0("col_character()"                      , "~~field_type is dropdown"),
          field_type == "file"                                ~ paste0("col_character()"                      , "~~field_type is file"),
          field_type == "notes"                               ~ paste0("col_character()"                      , "~~field_type is note"),
          field_type == "slider"                              ~ paste0("col_integer()"                        , "~~field_type is slider"),
          field_type == "calc"                                ~ paste0("col_character()"                      , "~~field_type is calc"),
          field_type == "descriptive"                         ~ paste0("col_character()"                      , "~~field_type is descriptive"),
          field_type == "sql"                                 ~ paste0("col_character()"                      , "~~field_type is sql"),
          field_type == "text" & is.na(vt)                    ~ paste0("col_character()"                      , "~~field_type is text and validation isn't set"),
          field_type == "text" & vt == ""                     ~ paste0("col_character()"                      , "~~field_type is text and validation isn't set"),
          is.na(field_type) & vt == "complete"                ~ paste0("col_integer()"                        , "~~indicates completion status of form/instrument"),
          vt == "alpha_only"                                  ~ paste0("col_character()"                      , "~~validation is 'alpha_only'"),
          vt == "date_dmy"                                    ~ paste0("col_date()"                           , "~~validation is 'date_dmy'"),
          vt == "date_mdy"                                    ~ paste0("col_date()"                           , "~~validation is 'date_mdy'"),
          vt == "date_ymd"                                    ~ paste0("col_date()"                           , "~~validation is 'date_ymd'"),
          vt == "datetime_dmy"                                ~ paste0("col_datetime(\"%Y-%m-%d %H:%M\")"     , "~~validation is 'datetime_dmy'"),
          vt == "datetime_mdy"                                ~ paste0("col_datetime(\"%Y-%m-%d %H:%M\")"     , "~~validation is 'datetime_mdy'"),
          vt == "datetime_seconds_dmy"                        ~ paste0("col_datetime(\"%Y-%m-%d %H:%M:%S\")"  , "~~validation is 'datetime_seconds_dmy'"),
          vt == "datetime_seconds_mdy"                        ~ paste0("col_datetime(\"%Y-%m-%d %H:%M:%S\")"  , "~~validation is 'datetime_seconds_mdy'"),
          vt == "datetime_seconds_ymd"                        ~ paste0("col_datetime(\"%Y-%m-%d %H:%M:%S\")"  , "~~validation is 'datetime_seconds_ymd'"),
          vt == "datetime_ymd"                                ~ paste0("col_datetime(\"%Y-%m-%d %H:%M\")"     , "~~validation is 'datetime_ymd'"),
          vt == "email"                                       ~ paste0("col_character()"                      , "~~validation is 'email'"),
          vt == "integer"                                     ~ paste0("col_integer()"                        , "~~validation is 'integer'"),
          vt == "mrn_10d"                                     ~ paste0("col_character()"                      , "~~validation is 'mrn_10d'"),
          vt == "mrn_generic"                                 ~ paste0("col_character()"                      , "~~validation is 'mrn_generic'"),
          vt == "number"                    &  decimal_period ~ paste0("col_double()"                         , "~~validation is 'number'"),
          vt == "number_1dp"                &  decimal_period ~ paste0("col_double()"                         , "~~validation is 'number_1dp'"),
          vt == "number_2dp"                &  decimal_period ~ paste0("col_double()"                         , "~~validation is 'number_2dp'"),
          vt == "number_3dp"                &  decimal_period ~ paste0("col_double()"                         , "~~validation is 'number_3dp'"),
          vt == "number_4dp"                &  decimal_period ~ paste0("col_double()"                         , "~~validation is 'number_4dp'"),
          vt == "number"                    & !decimal_period ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a period, yet validation is 'number'"),
          vt == "number_1dp"                & !decimal_period ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a period, yet validation is 'number_1dp'"),
          vt == "number_2dp"                & !decimal_period ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a period, yet validation is 'number_2dp'"),
          vt == "number_3dp"                & !decimal_period ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a period, yet validation is 'number_3dp'"),
          vt == "number_4dp"                & !decimal_period ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a period, yet validation is 'number_4dp'"),
          vt == "number_comma_decimal"      &  decimal_comma  ~ paste0("col_double()"                         , "~~validation is 'number_comma_decimal'"),
          vt == "number_1dp_comma_decimal"  &  decimal_comma  ~ paste0("col_double()"                         , "~~validation is 'number_1dp_comma_decimal'"),
          vt == "number_2dp_comma_decimal"  &  decimal_comma  ~ paste0("col_double()"                         , "~~validation is 'number_2dp_comma_decimal'"),
          vt == "number_3dp_comma_decimal"  &  decimal_comma  ~ paste0("col_double()"                         , "~~validation is 'number_3dp_comma_decimal'"),
          vt == "number_4dp_comma_decimal"  &  decimal_comma  ~ paste0("col_double()"                         , "~~validation is 'number_4dp_comma_decimal'"),
          vt == "number_comma_decimal"      & !decimal_comma  ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a comma, yet validation is 'number_comma_decimal'"),
          vt == "number_1dp_comma_decimal"  & !decimal_comma  ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a comma, yet validation is 'number_1dp_comma_decimal'"),
          vt == "number_2dp_comma_decimal"  & !decimal_comma  ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a comma, yet validation is 'number_2dp_comma_decimal'"),
          vt == "number_3dp_comma_decimal"  & !decimal_comma  ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a comma, yet validation is 'number_3dp_comma_decimal'"),
          vt == "number_4dp_comma_decimal"  & !decimal_comma  ~ paste0("col_character()"                      , "~~locale's decimal mark isn't a comma, yet validation is 'number_4dp_comma_decimal'"),
          vt == "phone"                                       ~ paste0("col_character()"                      , "~~validation is 'phone'"),
          vt == "phone_australia"                             ~ paste0("col_character()"                      , "~~validation is 'phone_australia'"),
          vt == "postalcode_australia"                        ~ paste0("col_character()"                      , "~~validation is 'postalcode_australia'"),
          vt == "postalcode_canada"                           ~ paste0("col_character()"                      , "~~validation is 'postalcode_canada'"),
          vt == "postalcode_french"                           ~ paste0("col_character()"                      , "~~validation is 'postalcode_french'"),
          vt == "postalcode_germany"                          ~ paste0("col_character()"                      , "~~validation is 'postalcode_germany'"),
          vt == "ssn"                                         ~ paste0("col_character()"                      , "~~validation is 'ssn'"),
          vt == "time"                                        ~ paste0("col_time(\"%H:%M\")"                  , "~~validation is 'time'"),
          vt == "time_hh_mm_ss"                               ~ paste0("col_time(\"%H:%M:%S\")"               , "~~validation is 'time_hh_mm_ss'"),
          vt == "time_mm_ss"                                  ~ paste0("col_time(\"%M:%S\")"                  , "~~validation is 'time_mm_ss'"),
          vt == "vmrn"                                        ~ paste0("col_character()"                      , "~~validation is 'vmrn'"),
          vt == "zipcode"                                     ~ paste0("col_character()"                      , "~~validation is 'zipcode'"),
          TRUE                                                ~ paste0("col_character()"                      , "~~validation doesn't have an associated col_type.  Tell us in a new REDCapR issue. "),
        )
    ) %>%
    dplyr::mutate(
      # Retrieve the col_type and the explanation
      readr_col_type  = sub("^(col_.+)~~(.+)$", "\\1", .data$response),
      explanation     = sub("^(col_.+)~~(.+)$", "\\2", .data$response),

      # Calculate the odd number of spaces -just beyond the longest variable name.
      padding1  = nchar(.data$field_name),
      padding1  = max(.data$padding1) %/% 2 * 2 + 3,
      padding2  = nchar(.data$readr_col_type),
      padding2  = max(.data$padding2) %/% 2 * 2 + 3,

      # Pad the left side before appending the right side.
      aligned = sprintf("  %-*s = readr::%-*s, # %s", .data$padding1, .data$field_name, .data$padding2, .data$readr_col_type, .data$explanation)
    ) %>%
    # View()
    # tibble::add_row(aligned = sprintf("  %-*s = readr::%-*s, # b/c %s", .data$padding1, .data$field_name, .data$padding2, .data$readr_col_type, .data$explanation)) %>%
    dplyr::pull(.data$aligned)

  # Construct an explanation header that's aligned with the col_types output
  gaps <- unlist(gregexpr("[=#]", meat[1]))
  header <- sprintf(
    "  # %-*s %-*s %s\n",
    gaps[1] - 4,
    "[field]",
    gaps[2] - gaps[1] - 1,
    "[readr col_type]",
    "[explanation for col_type]"
  )

  # Sandwich the col_types output in between the opening+header and the closing
  sandwich <-
    meat %>%
    paste(collapse = "\n") %>%
    # I'd prefer this approach, but the `.` is causing problems with R CMD check.
    paste0(
      "# col_types <- readr::cols_only( # Use `readr::cols_only()` to restrict the retrieval to only these columns\n",
      "col_types <- readr::cols( # Use `readr::cols()` to include unspecified columns\n",
      header,
      .,
      "\n)\n"
    )

  sandwich %>%
    message()

  decimal_period_any <- any(d_meta$text_validation_type_or_show_slider_number %in% c("number", "number_1dp", "number_2dp", "number_3dp", "number_4dp" ))
  decimal_comma_any  <- any(d_meta$text_validation_type_or_show_slider_number %in% c("number_comma_decimal", "number_1dp_comma_decimal", "number_2dp_comma_decimal", "number_3dp_comma_decimal", "number_4dp_comma_decimal"))

  if (decimal_period_any && decimal_comma_any) {
    warning(
      "The metadata for the REDCap project has validation types ",
      "for at least one field that specifies a comma for a decimal ",
      "for at least one field that specifies a period for a decimal.  ",
      "Mixing these two formats in the same proejct can cause confusion and problems.  ",
      "Consider passing `readr::col_character()` for this field ",
      "(to REDCapR's `col_types` parameter) and then convert the ",
      "desired fields to R's numeric type.  ",
      "The function `readr::parse_double()` is useful for this."
    )
  }

  .col_types <- eval(str2expression(sandwich))

  list(
    col_types          = .col_types,
    success            = TRUE,
    status_code        = 200
  )
}
