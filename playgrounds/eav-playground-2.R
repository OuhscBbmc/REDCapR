rm(list = ls(all = TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------

# ---- load-packages -----------------------------------------------------------
library("magrittr")
requireNamespace("dplyr")
requireNamespace("readr")
requireNamespace("testit")

# ---- declare-globals ---------------------------------------------------------
redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B"  # PHI-free demo: simple static
token <- "5007DC786DBE39CE77ED8DD0C68069A6"  # PHI-free demo: Checkboxes 1
# token <- "CCB7E11837D41126D67C744F97389E04"  # PHI-free demo: super-wide --3,000 columns
# token <- "5C1526186C4D04AE0A0630743E69B53C"  # PHI-free demo: super-wide #3--35,000 columns
token <- "56F43A10D01D6578A46393394D76D88F"  # PHI-free demo: Repeating Instruments --Sparse

# fields  <- c("record_id", "dob")
# forms   <- "health"
fields  <- NULL
forms   <- NULL
records <- NULL #c("1")

# ---- load-data ---------------------------------------------------------------
system.time({
  col_types   <- REDCapR::redcap_metadata_coltypes(redcap_uri, token, print_col_types_to_console = FALSE)

  # View(REDCapR::redcap_variables(redcap_uri, token)$data)

  ds_metadata <-
    REDCapR:::redcap_metadata_internal(redcap_uri, token)$d_variable %>%
    dplyr::filter(
      # (.data$field_name_base %in% fields) | (.data$form_name %in% forms)
    )

  desired_fields <- ds_metadata$field_name

  ds_eav      <- REDCapR:::redcap_read_eav_oneshot(redcap_uri, token, fields = desired_fields, records=records)$data
})

system.time(
  ds_expected <- REDCapR::redcap_read_oneshot(redcap_uri, token, records=records, col_types=col_types)$data
)

testit::assert(ds_metadata$field_name == colnames(ds_expected))
testthat::expect_setequal( ds_metadata$field_name, colnames(ds_expected))

# ---- tweak-data --------------------------------------------------------------
if (!"event_id" %in% colnames(ds_eav)) {
  ds_eav$event_id <- "dummy_1"
  .dummy_event <- TRUE
} else {
  .dummy_event <- FALSE
}

.fields_plumbing  <- c("record", "event_id", "redcap_repeat_instrument", "redcap_repeat_instance")
.fields_to_cross <- setdiff(ds_metadata$field_name, c("redcap_repeat_instrument", "redcap_repeat_instance"))
.fields_to_return <- c("record", "event_id", ds_metadata$field_name)
.record_id_name   <- ds_metadata$field_name[1]

ds_eav_possible <-
  ds_eav %>%
  tidyr::expand(
    tidyr::nesting(record, event_id),
    tidyr::crossing(field_name = .fields_to_cross)
  )

ds_eav_2 <-
  ds_eav %>%
  dplyr::rename(field_name_base = field_name) %>%
  dplyr::left_join(
    ds_metadata %>%
      dplyr::distinct(.data$field_name_base, .data$field_type),
    by = "field_name_base"
  ) %>%
  dplyr::mutate(
    field_name = dplyr::if_else(!is.na(.data$field_type) & (.data$field_type == "checkbox"), paste0(.data$field_name_base , "___", .data$value), .data$field_name_base ),
    value      = dplyr::if_else(!is.na(.data$field_type) & (.data$field_type == "checkbox"), as.character(!is.na(.data$value)), .data$value),
  ) %>%
  dplyr::right_join(ds_eav_possible, by = c("record", "event_id", "field_name"))

ds <-
  ds_eav_2 %>%
  dplyr::select(-.data$field_type, -.data$field_name_base) %>%
  # dplyr::slice(1:46) %>%
  # dplyr::group_by(record, redcap_repeat_instrument, redcap_repeat_instance, event_id, field_name) %>%
  # dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
  # dplyr::filter(n > 1L) %>%
  # View()
  # dplyr::select(-.data$redcap_repeat_instance) %>%        # TODO: need a good fix for repeats
  # tidyr::drop_na(event_id) %>%                            # TODO: need a good fix for repeats
  tidyr::pivot_wider( # Everything else is considered an ID column
    id_cols     = !!.fields_plumbing,
    names_from  = .data$field_name,
    values_from = .data$value
  ) %>%
  dplyr::select(!!.fields_to_return)
  # dplyr::select(.data = ., !!intersect(variables_to_keep, colnames(.)))

if (.dummy_event) {
  ds$event_id <- NULL
}

ds[[.record_id_name]] <- NULL
ds <-
  ds %>%
  dplyr::rename(
    !!.record_id_name := .data$record
  ) %>%
  readr::type_convert(col_types)# |>
    # View()

testit::assert(colnames(ds) == colnames(ds_expected))
testthat::expect_setequal(colnames(ds), colnames(ds_expected))

# ds_expected <-
#   ds_expected %>%
#   readr::type_convert(col_types=col_types)

testthat::expect_equal(ds, ds_expected)
