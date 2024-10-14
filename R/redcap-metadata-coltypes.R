#' @title
#' Suggests a col_type for each field in a REDCap project
#'
#' @description
#' This function inspects a REDCap project to
#' determine a [readr::cols()] object that is compatible with the
#' the project's current definition.  It can be copied and pasted into the
#' R code so future calls to the server will produce a [tibble::tibble()]
#' with an equivalent set of data types.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param print_col_types_to_console Should the [readr::cols()] object
#' be printed to the console?
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
#'
#' @return
#' A [readr::cols()] object is returned, which can be
#' passed to [redcap_read()] or [redcap_read_oneshot()].
#'
#' Additionally objected is printed to the console, see the Details below.
#'
#' @details
#' `redcap_metadata_coltypes()` returns a [readr::cols()] object in two ways.
#' First, a literal object is returned that can be passed to
#' [redcap_read()] or [redcap_read_oneshot()].
#'
#' Second, the function acts as a code generator.
#' It prints text to the console so that it can be copied
#' and pasted into an R file.  This is useful to (a) document what
#' fields and data types are expected, and (b) adjust those fields and
#' data types if the defaults can be customized for your needs.
#' For instance, you may choose to exclude some variables or tweak a
#' data type (*e.g.*, changing a patient's height from an integer to
#' a double).
#'
#' When printing to the console, each data type decision is accompanied
#' by an explanation on the far right.  See the output from the
#' examples below.  Please file an
#' [issue](https://github.com/OuhscBbmc/REDCapR/issues) if you think
#' something is too restrictive or can be improved.
#'
#' The overall heuristic is assign a data type down a waterfall of decisions:
#'
#' 1. Is the field built into REDCap? This includes
#' an autonumber `record_id`,
#' `redcap_event_name`, `redcap_repeat_instrument`, `redcap_repeat_instance`,
#' and an instrument's completion status.
#'
#' 2. What is the field's type?  For example, sliders should be an
#' [integer](https://stat.ethz.ch/R-manual/R-devel/library/base/html/integer.html),
#' while check marks should be
#' [logical](https://stat.ethz.ch/R-manual/R-devel/library/base/html/logical.html.
#'
#' 3. If the field type is "text", what is the validation type?
#' For instance, a postal code should be a
#' [character](https://stat.ethz.ch/R-manual/R-devel/library/base/html/character.html)
#' (even though it looks like a number),
#' a "mdy" should be cast to a
#' [date](https://stat.ethz.ch/R-manual/R-devel/library/base/html/date.html),
#' and a "number_2dp" should be cast to a
#' [floating point](https://stat.ethz.ch/R-manual/R-devel/library/base/html/double.html)
#'
#' 4. If the field type or validation type is not recognized,
#' the field will be cast to
#' [character](https://stat.ethz.ch/R-manual/R-devel/library/base/html/character.html).
#' This will happen when REDCap develops & releases a new type.
#' If you see something like, "# validation doesn't have an associated col_type.
#' Tell us in a new REDCapR issue", please make sure REDCapR is running the newest
#' [GitHub release](https://ouhscbbmc.github.io/REDCapR/index.html#installation-and-documentation)
#' and file a new [issue](https://github.com/OuhscBbmc/REDCapR/issues) if it's still not
#' recognized.
#'
#' For details of the current implementation,
#' the decision logic starts about half-way down in the
#' [function's source code](https://github.com/OuhscBbmc/REDCapR/blob/HEAD/R/redcap-metadata-coltypes.R)
#'
#' **Validation does NOT Guarantee Conformity*
#'
#' If you're coming to REDCap from a database world, this will be unexpected.
#' A validation type does NOT guarantee that all retrieved values will conform to
#' complementary the data type.
#' The validation setting affects only the values entered
#' *after* the validation was set.
#'
#' For example, if values like "abcd" where entered in a field for a few months, then
#' the project manager selected the "integer" validation option, all those
#' "abcd" values remain untouched.
#'
#' This is one reason `redcap_metadata_coltypes()` prints it suggestions to the console.
#' It allows the developer to adjust the specifications to match the values
#' returned by the API.  The the "abcd" scenario, consider (a) changing the type
#' from `col_integer` to `col_character`, (b) excluding the trash values,
#' then (c) in a [dplyr::mutate()] statement,
#' use [readr::parse_integer()] to cast it to the desired type.
#'
#' @author
#' Will Beasley, Philip Chase
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
#'
#' # A simple project
#' token      <- "9A068C425B1341D69E83064A2D273A70" # simple
#' col_types  <- redcap_metadata_coltypes(uri, token)
#' redcap_read_oneshot(uri, token, col_types = col_types)$data
#'
#' # A longitudinal project
#' token      <- "DA6F2BB23146BD5A7EA3408C1A44A556" # longitudinal
#' col_types  <- redcap_metadata_coltypes(uri, token)
#' redcap_read_oneshot(uri, token, col_types = col_types)$data
#'
#' # A repeating instruments project
#' token      <- "64720C527CA236880FBA785C9934F02A" # repeating-instruments-sparse
#' col_types  <- redcap_metadata_coltypes(uri, token)
#' redcap_read_oneshot(uri, token, col_types = col_types)$data
#'
#' # A project with every field type and validation type.
#' #   Notice it throws a warning that some fields use a comma for a decimal,
#' #   while other fields use a period/dot as a decimal
#' token      <- "EB1FD5DDE583364AE605629AB7619397" # validation-types-1
#' col_types  <- redcap_metadata_coltypes(uri, token)
#' redcap_read_oneshot(uri, token, col_types = col_types)$data
#' }

#' @importFrom magrittr %>%
#' @export
redcap_metadata_coltypes <- function(
  redcap_uri,
  token,

  print_col_types_to_console    = TRUE,

  http_response_encoding        = "UTF-8",
  locale                        = readr::default_locale(),
  verbose                       = FALSE,
  config_options                = NULL,
  handle_httr                   = NULL
) {

  meat <-
    redcap_metadata_internal(
      redcap_uri              = redcap_uri,
      token                   = token,
      http_response_encoding  = http_response_encoding,
      locale                  = locale,
      verbose                 = verbose,
      config_options          = config_options,
      handle_httr             = handle_httr
    )$d_variable %>%
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
    paste0(
      "# col_types <- readr::cols_only( # Use `readr::cols_only()` to restrict the retrieval to only these columns\n",
      "col_types <- readr::cols( # Use `readr::cols()` to include unspecified columns\n",
      header,
      paste(meat, collapse = "\n"),
      "\n)\n"
    )

  if (print_col_types_to_console) {
    sandwich %>%
      message()
  }

  eval(str2expression(sandwich))
}

#' @importFrom magrittr %>%
redcap_metadata_internal <- function(
  redcap_uri,
  token,

  http_response_encoding        = "UTF-8",
  locale                        = readr::default_locale(),
  verbose                       = FALSE,
  config_options                = NULL,
  handle_httr                   = NULL
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
  d_var  <- REDCapR::redcap_variables(        redcap_uri, token, verbose = verbose, handle_httr = handle_httr)$data
  d_meta <- REDCapR::redcap_metadata_read(    redcap_uri, token, verbose = verbose, handle_httr = handle_httr)$data
  d_inst <- REDCapR::redcap_instruments(      redcap_uri, token, verbose = verbose, handle_httr = handle_httr)$data
  d_proj <- REDCapR::redcap_project_info_read(redcap_uri, token, verbose = verbose, handle_httr = handle_httr)$data
  d_dags <- REDCapR::redcap_dag_read(         redcap_uri, token, verbose = verbose, handle_httr = handle_httr)

  # Determine status of autonumbering, instrument complete status, and decimal mark
  .record_field         <- d_var$original_field_name[1] # The first field should always be the "record" identifier.
  .autonumber           <- d_proj$record_autonumbering_enabled[1]
  # If the dags call fails, since the user is assigned to a DAG, then we assign .dags a value of TRUE
  .dags                 <- (1L <= nrow(d_dags$data)) | (grepl("do not have permission", d_dags$raw_text))
  .plumbing_possibles   <- c(.record_field, "redcap_event_name", "redcap_repeat_instrument", "redcap_repeat_instance")
  decimal_period        <- (locale$decimal_mark == ".")
  decimal_comma         <- (locale$decimal_mark == ",")

  # Prepare metadata to be joined
  d_var <-
    d_var %>%
    dplyr::select(
      field_name            = "export_field_name",
      field_name_base       = "original_field_name"
    )

  d_inst <-
    d_inst %>%
    dplyr::select(
      form_name   = "instrument_name",
    ) %>%
    dplyr::mutate(
      form_order  = seq_len(dplyr::n()),
    )

  # Dataset that holds the *_complete checkboxes
  d_complete <-
    d_inst %>%
    dplyr::mutate(
      field_name      = paste0(.data$form_name, "_complete"),
      field_name_base = .data$field_name,  # same for *_complete checkboxes
      field_type      = "complete",
      vt              = NA_character_,
    ) %>%
    dplyr::select(
      "field_name",
      "field_name_base",
      "form_name",
      "field_type",
      "vt",
    )

  # Dataset that holds longitudinal/repeating variables
  d_again <-
    tibble::tibble(
      field_name        = character(0),
      field_name_base   = character(0),
      form_name         = character(0),
      field_type        = character(0),
      vt                = character(0),
    )

  if (d_proj$is_longitudinal[1]) {
    d_again <-
      d_again %>%
      dplyr::union_all(
        tibble::tibble(
          field_name      = "redcap_event_name",
          field_name_base = "redcap_event_name",
          form_name       = "longitudinal/repeating",
          field_type      = "event_name",
          vt              = NA_character_,
        )
      )
  }

  if (is.na(d_proj$has_repeating_instruments_or_events[1])) { # nocov start
    # Don't test coverage for this block b/c it only executes for old versions of REDCap
    error_message <-
      sprintf(
        paste(
          "The REDCap instance at %s failed to report if the",
          "current project uses repeatable instruments or events."
        ),
        redcap_uri
      )
    stop(error_message)
  } # nocov end

  if (d_proj$has_repeating_instruments_or_events[1]) {
    d_again <-
      d_again %>%
      dplyr::union_all(
        tibble::tibble(
          field_name      = c("redcap_repeat_instrument", "redcap_repeat_instance"),
          field_name_base = c("redcap_repeat_instrument", "redcap_repeat_instance"),
          form_name       = "longitudinal/repeating",
          field_type      = c("repeat_instrument"       , "repeat_instance"),
          vt              = NA_character_,
        )
      )
  }

  # Construct extended metadata
  d_meta <-
    d_meta %>%
    dplyr::select(
      field_name_base  = "field_name",
      "form_name",
      "field_type",
      "text_validation_type_or_show_slider_number",
    ) %>%
    dplyr::filter(.data$field_type != "descriptive") %>%
    dplyr::left_join(d_var, by = "field_name_base") %>%
    dplyr::mutate(
      field_name = dplyr::coalesce(.data$field_name, .data$field_name_base),
    ) %>%
    dplyr::select(
      "field_name",
      "field_name_base",
      "form_name",
      "field_type",
      vt            = "text_validation_type_or_show_slider_number",
    )  %>%
    dplyr::union_all(d_complete) %>%
    dplyr::left_join(d_inst, by = "form_name") %>%
    dplyr::group_by(.data$form_name) %>%
    dplyr::mutate(
      field_order_within_form  = seq_len(dplyr::n()),
    ) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(.data$form_order,  .data$field_order_within_form) %>%
    dplyr::select(-"form_order", -"field_order_within_form") %>%
    tibble::add_row(d_again, .after = 1) %>%
    dplyr::mutate(
      plumbing = (.data$field_name %in% .plumbing_possibles)
    )

  # The types of variables that are in metadata, but NOT variables:
  # setdiff(d_meta$field_name_base, d_var$original_field_name)
  # [1] "signature"   "file_upload" "descriptive"

  # Determine & notate the likely data type
  d <-
    d_meta %>%
    dplyr::mutate(
      dags        = (.dags & (.data$field_name == .record_field)),
      autonumber  = (.autonumber & (.data$field_name == .record_field)),
    ) %>%
    dplyr::mutate(
      response =
        dplyr::case_when(
          dags                                                ~ paste0("col_character()"                      , "~~DAGs are enabled for the project"),
          autonumber & !dags                                  ~ paste0("col_integer()"                        , "~~record_autonumbering is enabled and DAGs are disabled for the project"),
          field_type == "event_name"                          ~ paste0("col_character()"                      , "~~longitudinal event_name"),
          field_type == "repeat_instrument"                   ~ paste0("col_character()"                      , "~~repeat_instrument"),
          field_type == "repeat_instance"                     ~ paste0("col_integer()"                        , "~~repeat_instance"),
          field_type == "complete"                            ~ paste0("col_integer()"                        , "~~completion status of form/instrument"),
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
    dplyr::select(
      "field_name",
      "form_name",
      "field_type",
      validation_type           = "vt",
      "autonumber",
      # "response",
      "readr_col_type",
      # "explanation",
      # "padding1",
      # "padding2",
      "aligned",
      "field_name_base",
      "plumbing",
    )

  .plumbing_variables <- intersect(d$field_name, .plumbing_possibles)

  decimal_period_any <- any(d_meta$vt %in% c("number", "number_1dp", "number_2dp", "number_3dp", "number_4dp" ))
  decimal_comma_any  <- any(d_meta$vt %in% c("number_comma_decimal", "number_1dp_comma_decimal", "number_2dp_comma_decimal", "number_3dp_comma_decimal", "number_4dp_comma_decimal"))

  if (decimal_period_any && decimal_comma_any) {
    warning(
      "The metadata for the REDCap project has validation types ",
      "for at least one field that specifies a comma for a decimal ",
      "for at least one field that specifies a period for a decimal.  ",
      "Mixing these two formats in the same project can cause confusion and problems.  ",
      "Consider passing `readr::col_character()` for this field ",
      "(to REDCapR's `col_types` parameter) and then convert the ",
      "desired fields to R's numeric type.  ",
      "The function `readr::parse_double()` is useful for this."
    )
  }

  list(
    d_variable      = d,
    success         = TRUE,
    longitudinal    = d_proj$is_longitudinal[1],
    repeating       = d_proj$has_repeating_instruments_or_events[1],
    record_id_name  = .record_field,
    plumbing_variables = .plumbing_variables
  )
}
