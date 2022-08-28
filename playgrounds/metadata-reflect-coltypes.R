import::from("magrittr", "%>%")

uri   <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" # 153
token <- "0434F0E9CF53ED0587847AB6E51DE762" # 212
# token <- "CCB7E11837D41126D67C744F97389E04" # 753 - superwide
token <- "F187271FC6FD72C3BFCE37990A6BF6A7" # 1400 - Repeating Instruments # 753 - superwide
token <- "221E86DABFEEA233067C6889991B7FBB" # 1425 - Potentially problematic dictionary
token <- "8F5313CAA266789F560D79EFCEE2E2F1" # 2634 - Validation Types

d_var  <- REDCapR::redcap_variables(    uri, token, verbose = FALSE)$data
d_meta <- REDCapR::redcap_metadata_read(uri, token, verbose = FALSE)$data

d_meta <-
  d_meta |>
  dplyr::select(
    field_name_original  = field_name,
    field_type,
    text_validation_type_or_show_slider_number,
  )

# setdiff(d_meta$field_name_original, d_var$original_field_name)
# [1] "signature"   "file_upload" "descriptive"

d_var <-
  d_var |>
  dplyr::select(
    field_name = export_field_name,
    field_name_original  = original_field_name
  ) |>
  dplyr::left_join(d_meta, by = "field_name_original")



out <-
  d_var |>
  dplyr::select(
    field_name,
    field_type,
    vt            = text_validation_type_or_show_slider_number,
  ) |>
  dplyr::mutate(
    response =
      dplyr::case_when(
        field_type == "truefalse"         ~ paste0("col_logical()"                        , "||field_type is truefalse"),
        field_type == "yesno"             ~ paste0("col_logical()"                        , "||field_type is yesno"),
        field_type == "checkbox"          ~ paste0("col_logical()"                        , "||field_type is checkbox"),
        field_type == "radio"             ~ paste0("col_integer()"                        , "||field_type is radio"),
        field_type == "dropdown"          ~ paste0("col_integer()"                        , "||field_type is dropdown"),
        field_type == "file"              ~ paste0("col_character()"                      , "||field_type is file"),
        field_type == "notes"             ~ paste0("col_character()"                      , "||field_type is note"),
        field_type == "slider"            ~ paste0("col_integer()"                        , "||field_type is slider"),
        field_type == "calc"              ~ paste0("col_character()"                      , "||field_type is calc"),
        field_type == "descriptive"       ~ paste0("col_character()"                      , "||field_type is descriptive"),
        field_type == "sql"               ~ paste0("col_character()"                      , "||field_type is sql"),
        field_type == "text" & is.na(vt)  ~ paste0("col_character()"                      , "||field_type is text and validation isn't set"),
        field_type == "text" & vt == ""   ~ paste0("col_character()"                      , "||field_type is text and validation isn't set"),
        vt == "alpha_only"                ~ paste0("col_character()"                      , "||validation is 'alpha_only'"),
        vt == "date_dmy"                  ~ paste0("col_date()"                           , "||validation is 'date_dmy'"),
        vt == "date_mdy"                  ~ paste0("col_date()"                           , "||validation is 'date_mdy'"),
        vt == "date_ymd"                  ~ paste0("col_date()"                           , "||validation is 'date_ymd'"),
        vt == "datetime_dmy"              ~ paste0("col_datetime(\"%Y-%m-%d %H:%M\")"     , "||validation is 'datetime_dmy'"),
        vt == "datetime_mdy"              ~ paste0("col_datetime(\"%Y-%m-%d %H:%M\")"     , "||validation is 'datetime_mdy'"),
        vt == "datetime_seconds_dmy"      ~ paste0("col_datetime(\"%Y-%m-%d %H:%M:%S\")"  , "||validation is 'datetime_seconds_dmy'"),
        vt == "datetime_seconds_mdy"      ~ paste0("col_datetime(\"%Y-%m-%d %H:%M:%S\")"  , "||validation is 'datetime_seconds_mdy'"),
        vt == "datetime_seconds_ymd"      ~ paste0("col_datetime(\"%Y-%m-%d %H:%M:%S\")"  , "||validation is 'datetime_seconds_ymd'"),
        vt == "datetime_ymd"              ~ paste0("col_datetime(\"%Y-%m-%d %H:%M\")"     , "||validation is 'datetime_ymd'"),
        vt == "email"                     ~ paste0("col_character()"                      , "||validation is 'email'"),
        vt == "integer"                   ~ paste0("col_integer()"                        , "||validation is 'integer'"),
        vt == "mrn_10d"                   ~ paste0("col_character()"                      , "||validation is 'mrn_10d'"),
        vt == "mrn_generic"               ~ paste0("col_character()"                      , "||validation is 'mrn_generic'"),
        vt == "number"                    ~ paste0("col_double()"                         , "||validation is 'number'"),
        vt == "number_1dp"                ~ paste0("col_double()"                         , "||validation is 'number_1dp'"),
        vt == "number_1dp_comma_decimal"  ~ paste0("col_double()"                         , "||validation is 'number_1dp_comma_decimal'"),
        vt == "number_2dp"                ~ paste0("col_double()"                         , "||validation is 'number_2dp'"),
        vt == "number_2dp_comma_decimal"  ~ paste0("col_double()"                         , "||validation is 'number_2dp_comma_decimal'"),
        vt == "number_3dp"                ~ paste0("col_double()"                         , "||validation is 'number_3dp'"),
        vt == "number_3dp_comma_decimal"  ~ paste0("col_double()"                         , "||validation is 'number_3dp_comma_decimal'"),
        vt == "number_4dp"                ~ paste0("col_double()"                         , "||validation is 'number_4dp'"),
        vt == "number_4dp_comma_decimal"  ~ paste0("col_double()"                         , "||validation is 'number_4dp_comma_decimal'"),
        vt == "number_comma_decimal"      ~ paste0("col_double()"                         , "||validation is 'number_comma_decimal'"),
        vt == "phone"                     ~ paste0("col_character()"                      , "||validation is 'phone'"),
        vt == "phone_australia"           ~ paste0("col_character()"                      , "||validation is 'phone_australia'"),
        vt == "postalcode_australia"      ~ paste0("col_character()"                      , "||validation is 'postalcode_australia'"),
        vt == "postalcode_canada"         ~ paste0("col_character()"                      , "||validation is 'postalcode_canada'"),
        vt == "postalcode_french"         ~ paste0("col_character()"                      , "||validation is 'postalcode_french'"),
        vt == "postalcode_germany"        ~ paste0("col_character()"                      , "||validation is 'postalcode_germany'"),
        vt == "ssn"                       ~ paste0("col_character()"                      , "||validation is 'ssn'"),
        vt == "time"                      ~ paste0("col_time(\"%H:%M\")"                  , "||validation is 'time'"),
        vt == "time_hh_mm_ss"             ~ paste0("col_time(\"%H:%M:%S\")"               , "||validation is 'time_hh_mm_ss'"),
        vt == "time_mm_ss"                ~ paste0("col_time(\"%M:%S\")"                  , "||validation is 'time_mm_ss'"),
        vt == "vmrn"                      ~ paste0("col_character()"                      , "||validation is 'vmrn'"),
        vt == "zipcode"                   ~ paste0("col_character()"                      , "||validation is 'zipcode'"),
        TRUE                              ~ paste0("col_character()"                      , "||validation doesn't have an associated col_type.  Tell us in a new REDCapR issue. "),
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
    aligned = sprintf("  %-*s = readr::%-*s, # %s", .data$padding1, .data$field_name, .data$padding2, .data$readr_col_type, .data$explanation)
  ) |>
  # View()
  # tibble::add_row(aligned = sprintf("  %-*s = readr::%-*s, # b/c %s", .data$padding1, .data$field_name, .data$padding2, .data$readr_col_type, .data$explanation)) |>
  dplyr::pull(.data$aligned)

gaps <- unlist(gregexpr("[=#]", out[1]))
header <- sprintf(
  "  # %-*s %-*s %s\n",
  gaps[1] - 4,
  "[field]",
  gaps[2] - gaps[1] - 1,
  "[readr col_type]",
  "[explanation for col_type]"
)

col_types <- readr::cols(
  # col_types <- readr::cols_only( # Use cols_only to restrict the retrieval to only these columns
  # [field]                     [readr col_type]                              [explanation for col_type]
  record_id                   = readr::col_character()                    , # field_type is text and validation isn't set
  alpha_only                  = readr::col_character()                    , # validation is 'alpha_only'
  date_dmy                    = readr::col_date()                         , # validation is 'date_dmy'
  date_mdy                    = readr::col_date()                         , # validation is 'date_mdy'
  date_ymd                    = readr::col_date()                         , # validation is 'date_ymd'
  datetime_dmy                = readr::col_datetime("%Y-%m-%d %H:%M")     , # validation is 'datetime_dmy'
  datetime_mdy                = readr::col_datetime("%Y-%m-%d %H:%M")     , # validation is 'datetime_mdy'
  datetime_seconds_dmy        = readr::col_datetime("%Y-%m-%d %H:%M:%S")  , # validation is 'datetime_seconds_dmy'
  datetime_seconds_mdy        = readr::col_datetime("%Y-%m-%d %H:%M:%S")  , # validation is 'datetime_seconds_mdy'
  datetime_seconds_ymd        = readr::col_datetime("%Y-%m-%d %H:%M:%S")  , # validation is 'datetime_seconds_ymd'
  datetime_ymd                = readr::col_datetime("%Y-%m-%d %H:%M")     , # validation is 'datetime_ymd'
  email                       = readr::col_character()                    , # validation is 'email'
  integer                     = readr::col_integer()                      , # validation is 'integer'
  mrn_10d                     = readr::col_character()                    , # validation is 'mrn_10d'
  mrn_generic                 = readr::col_character()                    , # validation is 'mrn_generic'
  number                      = readr::col_double()                       , # validation is 'number'
  number_1dp                  = readr::col_double()                       , # validation is 'number_1dp'
  number_1dp_comma_decimal    = readr::col_double()                       , # validation is 'number_1dp_comma_decimal'
  number_2dp                  = readr::col_double()                       , # validation is 'number_2dp'
  number_2dp_comma_decimal    = readr::col_double()                       , # validation is 'number_2dp_comma_decimal'
  number_3dp                  = readr::col_double()                       , # validation is 'number_3dp'
  number_3dp_comma_decimal    = readr::col_double()                       , # validation is 'number_3dp_comma_decimal'
  number_4dp                  = readr::col_double()                       , # validation is 'number_4dp'
  number_4dp_comma_decimal    = readr::col_double()                       , # validation is 'number_4dp_comma_decimal'
  number_comma_decimal        = readr::col_double()                       , # validation is 'number_comma_decimal'
  phone                       = readr::col_character()                    , # validation is 'phone'
  phone_australia             = readr::col_character()                    , # validation is 'phone_australia'
  postalcode_australia        = readr::col_character()                    , # validation is 'postalcode_australia'
  postalcode_canada           = readr::col_character()                    , # validation is 'postalcode_canada'
  postalcode_french           = readr::col_character()                    , # validation is 'postalcode_french'
  postalcode_germany          = readr::col_character()                    , # validation is 'postalcode_germany'
  ssn                         = readr::col_character()                    , # validation is 'ssn'
  time_hh_mm                  = readr::col_time("%H:%M")                  , # validation is 'time'
  time_hh_mm_ss               = readr::col_time("%H:%M:%S")               , # validation is 'time_hh_mm_ss'
  time_mm_ss                  = readr::col_time("%M:%S")                  , # validation is 'time_mm_ss'
  vmrn                        = readr::col_character()                    , # validation is 'vmrn'
  zipcode                     = readr::col_character()                    , # validation is 'zipcode'
  text                        = readr::col_character()                    , # field_type is text and validation isn't set
  notes                       = readr::col_character()                    , # field_type is note
  calculated                  = readr::col_character()                    , # field_type is calc
  dropdown                    = readr::col_integer()                      , # field_type is dropdown
  radio                       = readr::col_integer()                      , # field_type is radio
  checkbox___0                = readr::col_logical()                      , # field_type is checkbox
  checkbox___1                = readr::col_logical()                      , # field_type is checkbox
  checkbox___2                = readr::col_logical()                      , # field_type is checkbox
  yes_no                      = readr::col_logical()                      , # field_type is yesno
  true_false                  = readr::col_logical()                      , # field_type is truefalse
  slider                      = readr::col_integer()                      , # field_type is slider
  sql                         = readr::col_character()                    , # field_type is sql
  form_1_complete             = readr::col_character()                    , # validation doesn't have an associated col_type.  Tell us in a new REDCapR issue.
)

d <- REDCapR::redcap_read_oneshot(uri, token, col_types = col_types)$data
