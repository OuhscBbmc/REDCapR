rm(list = ls(all.names = TRUE))
import::from("magrittr", "%>%")

uri   <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" # 153
token <- "0434F0E9CF53ED0587847AB6E51DE762" # 212
# token <- "CCB7E11837D41126D67C744F97389E04" # 753 - superwide
# token <- "F187271FC6FD72C3BFCE37990A6BF6A7" # 1400 - Repeating Instruments # 753 - superwide
# token <- "221E86DABFEEA233067C6889991B7FBB" # 1425 - Potentially problematic dictionary
# token <- "8F5313CAA266789F560D79EFCEE2E2F1" # 2634 - Validation Types

# Retrieve the info necessary to infer the likely data types
d_var  <- REDCapR::redcap_variables(        uri, token, verbose = FALSE)$data
d_meta <- REDCapR::redcap_metadata_read(    uri, token, verbose = FALSE)$data
d_inst <- REDCapR::redcap_instruments(      uri, token, verbose = FALSE)$data
d_proj <- REDCapR::redcap_project_info_read(uri, token, verbose = FALSE)$data

# Determine status of autonumbering and instrument complete
.record_field        <- d_var$original_field_name[1]
.autonumber          <- d_proj$record_autonumbering_enabled[1]
.form_complete_boxes <- paste0(d_inst$instrument_name, "_complete")

locale_current  <- readr::locale()
decimal_period  <- (locale_current$decimal_mark == ".")
decimal_comma   <- (locale_current$decimal_mark == ",")

# Prepare var to be joined
d_var <-
  d_var %>%
  dplyr::select(
    field_name = export_field_name,
    field_name_original  = original_field_name
  )

d_complete <-
  tibble::tibble(
    field_name  = .form_complete_boxes,
    field_type  = "complete",
    vt          = NA_character_,
  )

d_again <-
  tibble::tibble(
    field_name  = character(0),
    field_type  = character(0),
    vt          = character(0),
  )

if (d_proj$is_longitudinal[1]) {
  d_again <-
    d_again %>%
    dplyr::union_all(
      tibble::tibble(
        field_name  = "redcap_event_name",
        field_type  = "event_name",
        vt          = NA_character_,
      )
    )
}
if (d_proj$has_repeating_instruments_or_events[1]) {
  d_again <-
    d_again %>%
    dplyr::union_all(
      tibble::tibble(
        field_name  = c("redcap_repeat_instrument", "redcap_repeat_instance"),
        field_type  = c("repeat_instrument"       , "repeat_instance"),
        vt          = NA_character_,
      )
    )
}

# Prepare metadata to be joined
d_meta <-
  d_meta %>%
  dplyr::select(
    field_name_original  = field_name,
    field_type,
    text_validation_type_or_show_slider_number,
  ) %>%
  dplyr::filter(field_type != "descriptive") %>%
  dplyr::left_join(d_var, by = "field_name_original") %>%
  dplyr::mutate(
    field_name = dplyr::coalesce(field_name, field_name_original),
  ) %>%
  dplyr::select(
    field_name,
    field_type,
    vt            = text_validation_type_or_show_slider_number,
  ) %>%
  tibble::add_row(d_again, .after = 1) %>%
  dplyr::union_all(d_complete)

setdiff(d_meta$field_name, d_var$field_name)
setdiff(d_var$field_name, d_meta$field_name)
# [1] "signature"   "file_upload" "descriptive"

# Translate the four datasets into a single `readr:cols()` string printed to the console
meat <-
  d_meta %>%
  dplyr::mutate(
    # vt          = dplyr::if_else(.data$field_name %in% .form_complete_boxes, "complete", vt),
    autonumber  = (.autonumber & (.data$field_name == .record_field)),
  ) %>%
  dplyr::mutate(
    response =
      dplyr::case_when(
        autonumber                                          ~ paste0("col_integer()"                        , "~~record_autonumbering is enabled for the project"),
        field_type == "event_name"                          ~ paste0("col_character()"                      , "~~longitudinal event_name"),
        field_type == "repeat_instrument"                   ~ paste0("col_character()"                      , "~~repeat_instrument"),
        field_type == "repeat_instance"                     ~ paste0("col_integer()"                        , "~~repeat_instance"),
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
        field_type == "complete"                            ~ paste0("col_integer()"                        , "~~indicates completion status of form/instrument"),
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
  paste0(
    "# col_types <- readr::cols_only( # Use `readr::cols_only()` to restrict the retrieval to only these columns\n",
    "col_types <- readr::cols( # Use `readr::cols()` to include unspecified columns\n",
    header,
    paste(meat, collapse = "\n") ,
    "\n)\n"
  )

sandwich %>%
  cat()

decimal_period_any <- any(d_meta$vt %in% c("number", "number_1dp", "number_2dp", "number_3dp", "number_4dp" ))
decimal_comma_any  <- any(d_meta$vt %in% c("number_comma_decimal", "number_1dp_comma_decimal", "number_2dp_comma_decimal", "number_3dp_comma_decimal", "number_4dp_comma_decimal"))

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

col_types_1 <- eval(str2expression(sandwich))

col_types_2 <- readr::cols(
  # col_types <- readr::cols_only( # Use cols_only to restrict the retrieval to only these columns
  # [field]                       [readr col_type]                              [explanation for col_type]
  record_id                     = readr::col_integer()                      , # record_autonumbering is enabled for the project
  f_calculated                  = readr::col_character()                    , # field_type is calc
  f_checkbox___0                = readr::col_logical()                      , # field_type is checkbox
  f_checkbox___1                = readr::col_logical()                      , # field_type is checkbox
  f_checkbox___2                = readr::col_logical()                      , # field_type is checkbox
  f_dropdown                    = readr::col_character()                    , # field_type is dropdown
  f_notes                       = readr::col_character()                    , # field_type is note
  f_radio                       = readr::col_character()                    , # field_type is radio
  f_slider                      = readr::col_integer()                      , # field_type is slider
  f_sql                         = readr::col_character()                    , # field_type is sql
  f_text                        = readr::col_character()                    , # field_type is text and validation isn't set
  f_true_false                  = readr::col_logical()                      , # field_type is truefalse
  f_yes_no                      = readr::col_logical()                      , # field_type is yesno
  v_alpha_only                  = readr::col_character()                    , # validation is 'alpha_only'
  v_date_dmy                    = readr::col_date()                         , # validation is 'date_dmy'
  v_date_mdy                    = readr::col_date()                         , # validation is 'date_mdy'
  v_date_ymd                    = readr::col_date()                         , # validation is 'date_ymd'
  v_datetime_dmy                = readr::col_datetime("%Y-%m-%d %H:%M")     , # validation is 'datetime_dmy'
  v_datetime_mdy                = readr::col_datetime("%Y-%m-%d %H:%M")     , # validation is 'datetime_mdy'
  v_datetime_seconds_dmy        = readr::col_datetime("%Y-%m-%d %H:%M:%S")  , # validation is 'datetime_seconds_dmy'
  v_datetime_seconds_mdy        = readr::col_datetime("%Y-%m-%d %H:%M:%S")  , # validation is 'datetime_seconds_mdy'
  v_datetime_seconds_ymd        = readr::col_datetime("%Y-%m-%d %H:%M:%S")  , # validation is 'datetime_seconds_ymd'
  v_datetime_ymd                = readr::col_datetime("%Y-%m-%d %H:%M")     , # validation is 'datetime_ymd'
  v_email                       = readr::col_character()                    , # validation is 'email'
  v_integer                     = readr::col_integer()                      , # validation is 'integer'
  v_mrn_10d                     = readr::col_character()                    , # validation is 'mrn_10d'
  v_mrn_generic                 = readr::col_character()                    , # validation is 'mrn_generic'
  v_number                      = readr::col_double()                       , # validation is 'number'
  v_number_1dp                  = readr::col_double()                       , # validation is 'number_1dp'
  v_number_2dp                  = readr::col_double()                       , # validation is 'number_2dp'
  v_number_3dp                  = readr::col_double()                       , # validation is 'number_3dp'
  v_number_4dp                  = readr::col_double()                       , # validation is 'number_4dp'
  v_number_comma_decimal        = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_comma_decimal'
  v_number_1dp_comma_decimal    = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_1dp_comma_decimal'
  v_number_2dp_comma_decimal    = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_2dp_comma_decimal'
  v_number_3dp_comma_decimal    = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_3dp_comma_decimal'
  v_number_4dp_comma_decimal    = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_4dp_comma_decimal'
  v_phone                       = readr::col_character()                    , # validation is 'phone'
  v_phone_australia             = readr::col_character()                    , # validation is 'phone_australia'
  v_postalcode_australia        = readr::col_character()                    , # validation is 'postalcode_australia'
  v_postalcode_canada           = readr::col_character()                    , # validation is 'postalcode_canada'
  v_postalcode_french           = readr::col_character()                    , # validation is 'postalcode_french'
  v_postalcode_germany          = readr::col_character()                    , # validation is 'postalcode_germany'
  v_ssn                         = readr::col_character()                    , # validation is 'ssn'
  v_time_hh_mm                  = readr::col_time("%H:%M")                  , # validation is 'time'
  v_time_hh_mm_ss               = readr::col_time("%H:%M:%S")               , # validation is 'time_hh_mm_ss'
  v_time_mm_ss                  = readr::col_time("%M:%S")                  , # validation is 'time_mm_ss'
  v_vmrn                        = readr::col_character()                    , # validation is 'vmrn'
  v_zipcode                     = readr::col_character()                    , # validation is 'zipcode'
  form_1_complete               = readr::col_integer()                      , # indicates completion status of form/instrument
)
identical(col_types_1, col_types_2)

d1 <- REDCapR::redcap_read_oneshot(uri, token, col_types = eval(str2expression(sandwich)))$data
readr::problems(d1)

# col_types <- REDCapR::redcap_metadata_suggest(uri, token, col_types = col_types_2)$data

d2 <- REDCapR::redcap_read_oneshot(uri, token, col_types = col_types_2)$data
readr::problems(d2)
