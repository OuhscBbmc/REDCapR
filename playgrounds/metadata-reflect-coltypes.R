
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
    readr_col_type =
      dplyr::case_when(
        field_type == "truefalse"         ~ "col_logical()",
        field_type == "radio"             ~ "col_character()",
        field_type == "file"              ~ "col_character()",

        vt == "alpha_only"                ~ "col_character()",
        vt == "date_dmy"                  ~ "col_date()",
        vt == "date_mdy"                  ~ "col_date()",
        vt == "date_ymd"                  ~ "col_date()",
        vt == "datetime_dmy"              ~ "col_datetime(\"%Y-%m-%d %H:%M\")",
        vt == "datetime_mdy"              ~ "col_datetime(\"%Y-%m-%d %H:%M\")",
        vt == "datetime_seconds_dmy"      ~ "col_datetime(\"%Y-%m-%d %H:%M:%S\")",
        vt == "datetime_seconds_mdy"      ~ "col_datetime(\"%Y-%m-%d %H:%M:%S\")",
        vt == "datetime_seconds_ymd"      ~ "col_datetime(\"%Y-%m-%d %H:%M:%S\")",
        vt == "datetime_ymd"              ~ "col_datetime(\"%Y-%m-%d %H:%M\")",
        vt == "email"                     ~ "col_character()",
        vt == "integer"                   ~ "col_integer()",
        vt == "mrn_10d"                   ~ "col_character()",
        vt == "mrn_generic"               ~ "col_character()",
        vt == "number"                    ~ "col_double()",
        vt == "number_1dp"                ~ "col_double()",
        vt == "number_1dp_comma_decimal"  ~ "col_double()",
        vt == "number_2dp"                ~ "col_double()",
        vt == "number_2dp_comma_decimal"  ~ "col_double()",
        vt == "number_3dp"                ~ "col_double()",
        vt == "number_3dp_comma_decimal"  ~ "col_double()",
        vt == "number_4dp"                ~ "col_double()",
        vt == "number_4dp_comma_decimal"  ~ "col_double()",
        vt == "number_comma_decimal"      ~ "col_double()",
        vt == "phone"                     ~ "col_character()",
        vt == "phone_australia"           ~ "col_character()",
        vt == "postalcode_australia"      ~ "col_character()",
        vt == "postalcode_canada"         ~ "col_character()",
        vt == "postalcode_french"         ~ "col_character()",
        vt == "postalcode_germany"        ~ "col_character()",
        vt == "ssn"                       ~ "col_character()",
        vt == "time"                      ~ "col_time(\"%H:%M\")",
        vt == "time_mm_ss"                ~ "col_time(\"%H:%M\")",
        vt == "vmrn"                      ~ "col_character()",
        vt == "zipcode"                   ~ "col_character()",
        TRUE                              ~ "col_character()"
      )
  ) |>
  dplyr::mutate(
    suggestion  = paste0("readr::", readr_col_type),

    # Calculate the odd number of spaces -just beyond the longest variable name.
    padding = nchar(.data$field_name),
    padding = max(.data$padding) %/% 2 * 2 + 3,

    # Pad the left side before appending the right side.
    aligned = sprintf("  %-*s = readr::%s", .data$padding, .data$field_name, .data$readr_col_type)
  ) |>
  dplyr::pull(.data$aligned) |>
  paste(collapse = ",\n") %>%
  # I'd prefer this approach, but the `.` is causing problems with R CMD check.
  paste0(
    "col_types <- readr::cols_only(\n",
    .,
    "\n)\n"
  ) |>
  cat()
  # View()
