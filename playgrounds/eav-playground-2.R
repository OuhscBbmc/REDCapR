rm(list = ls(all = TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------

# ---- load-packages -----------------------------------------------------------
library("magrittr")
requireNamespace("dplyr")
requireNamespace("readr")
requireNamespace("testit")

# ---- declare-globals ---------------------------------------------------------
redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
# token <- "9A81268476645C4E5F03428B8AC3AA7B"  # PHI-free demo: simple static
token <- "5007DC786DBE39CE77ED8DD0C68069A6"  # PHI-free demo: Checkboxes 1 #3074
# token <- "CCB7E11837D41126D67C744F97389E04"  # PHI-free demo: super-wide --3,000 columns
# token <- "5C1526186C4D04AE0A0630743E69B53C"  # PHI-free demo: super-wide #3--35,000 columns
# token <- "56F43A10D01D6578A46393394D76D88F"  # PHI-free demo: Repeating Instruments --Sparse #2603

# fields  <- c("record_id", "dob")
# forms   <- "health"
fields  <- NULL
forms   <- NULL
records <- NULL #c("1")
blank_for_gray_form_status <- FALSE

.complete_value_for_untouched_forms <-
  dplyr::if_else(
    blank_for_gray_form_status,
    NA_character_,
    as.character(REDCapR::constant("form_incomplete"))
  )
# .default_check_for_untouched_forms <- dplyr::if_else(blank_for_gray_form_status, FALSE, NA)

# ---- load-data ---------------------------------------------------------------
  # View(REDCapR::redcap_variables(redcap_uri, token)$data)
system.time({
  col_types   <- REDCapR::redcap_metadata_coltypes(redcap_uri, token, print_col_types_to_console = FALSE)
  meta        <- REDCapR:::redcap_metadata_internal(redcap_uri, token)

  ds_metadata <-
    meta$d_variable %>%
    dplyr::filter(
      # (.data$field_name_base %in% fields) | (.data$form_name %in% forms)
    )

  desired_fields <- ds_metadata$field_name_base

  ds_eav      <- REDCapR:::redcap_read_eav_oneshot(redcap_uri, token, fields = desired_fields, records=records)$data
})

system.time(
  ds_expected <-
    REDCapR::redcap_read_oneshot(
      redcap_uri,
      token,
      records                     = records,
      col_types                   = col_types,
      blank_for_gray_form_status  = blank_for_gray_form_status
    )$data
)

testit::assert(ds_metadata$field_name == colnames(ds_expected))
testthat::expect_setequal( ds_metadata$field_name, colnames(ds_expected))

# ---- tweak-data --------------------------------------------------------------
.fields_plumbing  <- c("record", "event_id")

if (!meta$longitudinal) {
  ds_eav$event_id <- "dummy_1"
}
if (meta$repeating) {
  .fields_plumbing <- c(.fields_plumbing, "redcap_repeat_instrument", "redcap_repeat_instance")
}

.fields_to_cross  <- setdiff(ds_metadata$field_name, c("redcap_repeat_instrument", "redcap_repeat_instance"))
.fields_to_return <- c("record", "event_id", ds_metadata$field_name)
.record_id_name   <- ds_metadata$field_name[1]

ds_eav_possible <-
  ds_eav %>%
  tidyr::expand(
    tidyr::nesting(record, event_id),
    tidyr::crossing(field_name = .fields_to_cross)
  )

# To try to have checkboxes NA if the forms weren't touched.
# ds_form_pt <-
#   ds_metadata %>%
#   dplyr::filter(.data$field_type == "complete") %>%
#   dplyr::select("field_name", "form_name") %>%
#   dplyr::inner_join(ds_eav, by = "field_name") %>%
#   dplyr::mutate(
#     .default_check = dplyr::i
#   )

ds_eav_2 <-
  ds_eav %>%
  dplyr::rename(field_name_base = field_name) %>%
  dplyr::left_join(
    ds_metadata %>%
      dplyr::distinct(.data$field_name_base, .data$field_type),
    by = "field_name_base"
  ) %>%
  dplyr::mutate(
    checkbox   = !is.na(.data$field_type) & (.data$field_type == "checkbox"),
    field_name = dplyr::if_else(.data$checkbox, paste0(.data$field_name_base , "___", .data$value), .data$field_name_base),
    value      = dplyr::if_else(.data$checkbox, as.character(!is.na(.data$value)), .data$value),
  ) %>%
  dplyr::right_join(ds_eav_possible, by = c("record", "event_id", "field_name")) %>%
  dplyr::select(-"field_type", -"field_name_base", -"checkbox") %>%
  dplyr::left_join(
    ds_metadata %>%
      dplyr::select("field_name", "field_name_base", "field_type"),
    by = "field_name"
  ) %>%
  dplyr::mutate(
    value = dplyr::if_else(.data$field_type == "checkbox", dplyr::coalesce(value, "FALSE"), value),
    value = dplyr::if_else(.data$field_type == "complete", dplyr::coalesce(value, .complete_value_for_untouched_forms), value),
  )

ds <-
  ds_eav_2 %>%
  dplyr::select(-"field_type", -"field_name_base") %>%
  # dplyr::slice(1:46) %>%
  # dplyr::group_by(record, redcap_repeat_instrument, redcap_repeat_instance, event_id, field_name) %>%
  # dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
  # dplyr::filter(n > 1L) %>%
  # View()
  # dplyr::select(-.data$redcap_repeat_instance) %>%        # TODO: need a good fix for repeats
  # tidyr::drop_na(event_id) %>%                            # TODO: need a good fix for repeats
  tidyr::pivot_wider( # Everything else is considered an ID column
    id_cols     = !!.fields_plumbing,
    names_from  = "field_name",
    values_from = "value"
  ) %>%
  dplyr::select(!!.fields_to_return)
  # dplyr::select(.data = ., !!intersect(variables_to_keep, colnames(.)))

if (!meta$longitudinal) {
  ds$event_id <- NULL
}

ds[[.record_id_name]] <- NULL
ds <-
  ds %>%
  dplyr::rename(
    !!.record_id_name := "record"
  ) %>%
  readr::type_convert(col_types)# |>
    # View()

testit::assert(colnames(ds) == colnames(ds_expected))
testthat::expect_setequal(colnames(ds), colnames(ds_expected))

# ds_expected <-
#   ds_expected %>%
#   readr::type_convert(col_types=col_types)

testthat::expect_equal(ds, ds_expected)
