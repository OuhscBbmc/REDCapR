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

ds_mapping_validation_name <-
  tibble::tribble(
    ~validation_name, ~fx_export,
    "number", '\\(x) readr::parse_number(x)',
    "number_comma_decimal", '\\(x) readr::parse_number(x, locale = readr::locale(decimal_mark = ","))',
    "phone", '\\(x) readr::parse_character(x)',
    "date_ymd", '\\(x) readr::parse_date(x)',
  )

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
  {
    \(x)
    rlang::set_names(
      x   = x$fx_export,
      nm  = x$field_name
    )
  }()


for (variable in names(fxs)) {
  fx <- base::eval(base::parse(text = fxs[[variable]]))
  d[[variable]] <- fx(d[[variable]])
}
d
