# ---- commas-as-decimals ------------------------------------------------------
credential  <- retrieve_credential_testing(2630L)
m <- redcap_metadata_read(credential$redcap_uri, credential$token)$data
m$text_validation_type_or_show_slider_number

# ---- so-example --------------------------------------------------------------
# https://stackoverflow.com/q/70147474/1082435
fxs <- c(
  "Sepal.Length"   = "\\(x) x *   1",
  "Sepal.Width"    = "\\(x) x *  10",
  "Petal.Length"   = "\\(x) x * 100"
)

d <- iris[1:5, 1:3]
for (variable in colnames(d)) {
  fx <- base::eval(base::parse(text = fxs[[variable]]))
  d[[variable]] <- fx(d[[variable]])
}
d

# ---- longitudinal ------------------------------------------------------
credential  <- retrieve_credential_testing(212L)
d <- redcap_read_oneshot(credential$redcap_uri, credential$token, col_types = readr::cols(.default = readr::col_character()))$data
d_m <- redcap_metadata_read(credential$redcap_uri, credential$token)$data
d_m$text_validation_type_or_show_slider_number
d$comments       <- NULL # wordy cells throw off visibility
d$study_comments <- NULL # wordy cells throw off visibility
d$vob7           <- NULL # wordy cells throw off visibility
d$vob14          <- NULL # wordy cells throw off visibility

# ds_mapping_validation_name <-
#   tibble::tribble(
#     ~validation_name, ~fx_export,
#     "number", '\\(x) readr::parse_number(x)',
#     "number_comma_decimal", '\\(x) readr::parse_number(x, locale = readr::locale(decimal_mark = ,\n))',
#     "phone", '\\(x) readr::parse_character(x)',
#     "date_ymd", '\\(x) readr::parse_date(x)',
#   )

ds_mapping_validation_name <-
  "misc/validation-transformation.yml" |>
  system.file(package = "REDCapR") |>
  yaml::yaml.load_file() |>
  purrr::map_df(tibble::as_tibble)

ds_mapping_validation_name

f <- eval(parse(text = ds_mapping_validation_name$fx_export[3]))
f("234,01")

fxs <-
  d_m |>
  dplyr::select(
    field_name,
    validation_name = text_validation_type_or_show_slider_number
  ) |>
  dplyr::left_join(ds_mapping_validation_name, by = "validation_name") |>
  tidyr::drop_na(fx_export) |>
  dplyr::pull(fx_export, name = field_name)

d <- tibble::as_tibble(d)
for (variable in names(fxs)) {
  fx <- base::eval(base::parse(text = fxs[[variable]]))
  d[[variable]] <- fx(d[[variable]])
}
d


# ---- create-project-for-testing ----------------------------------------------
# ds_dictionary <-
ds_mapping_validation_name |>
  dplyr::select(
    field_name    = validation_name,
    field_label   = validation_label,
  ) |>
  dplyr::mutate(
    form_name     = "form_1",
    section_header                              = "",
    field_type                                  = "text",
    select_choices_or_calculations              = "",
    field_note                                  = "",
    text_validation_type_or_show_slider_number  = field_name,
    text_validation_min                         = "",
    text_validation_max                         = "",
    identifier                                  = "",
    branching_logic                             = "",
    required_field                              = "",
    custom_alignment                            = "",
    question_number                             = "",
    matrix_group_name                           = "",
    matrix_ranking                              = "",
    field_annotation                            = "",
  ) |>
  dplyr::select(
    field_name,
    form_name,
    section_header,
    field_type,
    field_label,
    select_choices_or_calculations,
    field_note,
    text_validation_type_or_show_slider_number,
    text_validation_min,
    text_validation_max,
    identifier,
    branching_logic,
    required_field,
    custom_alignment,
    question_number,
    matrix_group_name,
    matrix_ranking,
    field_annotation,
  ) |>
  readr::write_csv("inst/test-data/validation-types-v1/dictionary.csv")

ds_mapping_validation_name$validation_name |>
  paste(collapse=",") |>
  readr::write_file("inst/test-data/validation-types-v1/data.csv")


