import::from("magrittr", "%>%")

uri   <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B"
d <- REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)$data

# out <-
d |>
  dplyr::select(
    field_name,
    field_type,
    vt            = text_validation_type_or_show_slider_number,
  ) |>
  dplyr::mutate(
    response =
      dplyr::case_when(
        field_type == "truefalse"         ~ paste0("col_logical()"                        , "||field_type is truefalse"),
        field_type == "radio"             ~ paste0("col_character()"                      , "||field_type is radio"),
        field_type == "file"              ~ paste0("col_character()"                      , "||field_type is file"),
        field_type == "text" & is.na(vt)  ~ paste0("col_character()"                      , "||field_type is text and validation is ''"),
        field_type == "text" & vt == ""   ~ paste0("col_character()"                      , "||field_type is text and validation is ''"),
        vt == "alpha_only"                ~ paste0("col_character()"                      , "||validation is alpha_only"),
        vt == "date_dmy"                  ~ paste0("col_date()"                           , "||validation is date_dmy"),
        vt == "date_mdy"                  ~ paste0("col_date()"                           , "||validation is date_mdy"),
        vt == "date_ymd"                  ~ paste0("col_date()"                           , "||validation is date_ymd"),
        vt == "datetime_dmy"              ~ paste0("col_datetime(\"%Y-%m-%d %H:%M\")"     , "||validation is datetime_dmy"),
        vt == "datetime_mdy"              ~ paste0("col_datetime(\"%Y-%m-%d %H:%M\")"     , "||validation is datetime_mdy"),
        vt == "datetime_seconds_dmy"      ~ paste0("col_datetime(\"%Y-%m-%d %H:%M:%S\")"  , "||validation is datetime_seconds_dmy"),
        vt == "datetime_seconds_mdy"      ~ paste0("col_datetime(\"%Y-%m-%d %H:%M:%S\")"  , "||validation is datetime_seconds_mdy"),
        vt == "datetime_seconds_ymd"      ~ paste0("col_datetime(\"%Y-%m-%d %H:%M:%S\")"  , "||validation is datetime_seconds_ymd"),
        vt == "datetime_ymd"              ~ paste0("col_datetime(\"%Y-%m-%d %H:%M\")"     , "||validation is datetime_ymd"),
        vt == "email"                     ~ paste0("col_character()"                      , "||validation is email"),
        vt == "integer"                   ~ paste0("col_integer()"                        , "||validation is integer"),
        vt == "mrn_10d"                   ~ paste0("col_character()"                      , "||validation is mrn_10d"),
        vt == "mrn_generic"               ~ paste0("col_character()"                      , "||validation is mrn_generic"),
        vt == "number"                    ~ paste0("col_double()"                         , "||validation is number"),
        vt == "number_1dp"                ~ paste0("col_double()"                         , "||validation is number_1dp"),
        vt == "number_1dp_comma_decimal"  ~ paste0("col_double()"                         , "||validation is number_1dp_comma_decimal"),
        vt == "number_2dp"                ~ paste0("col_double()"                         , "||validation is number_2dp"),
        vt == "number_2dp_comma_decimal"  ~ paste0("col_double()"                         , "||validation is number_2dp_comma_decimal"),
        vt == "number_3dp"                ~ paste0("col_double()"                         , "||validation is number_3dp"),
        vt == "number_3dp_comma_decimal"  ~ paste0("col_double()"                         , "||validation is number_3dp_comma_decimal"),
        vt == "number_4dp"                ~ paste0("col_double()"                         , "||validation is number_4dp"),
        vt == "number_4dp_comma_decimal"  ~ paste0("col_double()"                         , "||validation is number_4dp_comma_decimal"),
        vt == "number_comma_decimal"      ~ paste0("col_double()"                         , "||validation is number_comma_decimal"),
        vt == "phone"                     ~ paste0("col_character()"                      , "||validation is phone"),
        vt == "phone_australia"           ~ paste0("col_character()"                      , "||validation is phone_australia"),
        vt == "postalcode_australia"      ~ paste0("col_character()"                      , "||validation is postalcode_australia"),
        vt == "postalcode_canada"         ~ paste0("col_character()"                      , "||validation is postalcode_canada"),
        vt == "postalcode_french"         ~ paste0("col_character()"                      , "||validation is postalcode_french"),
        vt == "postalcode_germany"        ~ paste0("col_character()"                      , "||validation is postalcode_germany"),
        vt == "ssn"                       ~ paste0("col_character()"                      , "||validation is ssn"),
        vt == "time"                      ~ paste0("col_time(\"%H:%M\")"                  , "||validation is time"),
        vt == "time_mm_ss"                ~ paste0("col_time(\"%H:%M\")"                  , "||validation is time_mm_ss"),
        vt == "vmrn"                      ~ paste0("col_character()"                      , "||validation is vmrn"),
        vt == "zipcode"                   ~ paste0("col_character()"                      , "||validation is zipcode"),
        TRUE                              ~ paste0("col_character()"                      , "||no condition was recognized"),
      )
  ) |>
  dplyr::mutate(
    readr_col_type  = sub("^(col_.+)\\|\\|(.+)$", "\\1", .data$response),
    explanation     = sub("^(col_.+)\\|\\|(.+)$", "\\2", .data$response),

    # Calculate the odd number of spaces -just beyond the longest variable name.
    padding1  = nchar(.data$field_name),
    padding1  = max(.data$padding1) %/% 2 * 2 + 3,
    padding2  = nchar(.data$readr_col_type),
    padding2  = max(.data$padding2) %/% 2 * 2 + 3,

    # Pad the left side before appending the right side.
    aligned = sprintf("  %-*s = readr::%-*s, # b/c %s", .data$padding1, .data$field_name, .data$padding2, .data$readr_col_type, .data$explanation)
  ) |>
  # dplyr::pull(.data$response) |>
  dplyr::pull(.data$aligned) |>
  paste(collapse = "\n") %>%
  # I'd prefer this approach, but the `.` is causing problems with R CMD check.
  paste0(
    "col_types <- readr::cols_only(\n",
    .,
    "\n)\n"
  ) |>
  cat()
  # View()
