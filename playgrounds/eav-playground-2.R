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
# token <- "5007DC786DBE39CE77ED8DD0C68069A6"  # PHI-free demo: Checkboxes 1
# token <- "CCB7E11837D41126D67C744F97389E04"  # PHI-free demo: super-wide --3,000 columns
# token <- "5C1526186C4D04AE0A0630743E69B53C"  # PHI-free demo: super-wide #3--35,000 columns
# token <- "56F43A10D01D6578A46393394D76D88F"  # PHI-free demo: Repeating Instruments --Sparse

fields  <- c("record_id", "dob")
forms   <- "health"

# ---- load-data ---------------------------------------------------------------
system.time(
  ds_expected <- REDCapR::redcap_read_oneshot(redcap_uri, token)$data
)

system.time({
  col_types   <- REDCapR::redcap_metadata_coltypes(redcap_uri, token, print_col_types_to_console = FALSE)

  ds_metadata <-
    REDCapR:::redcap_metadata_internal(redcap_uri, token)$d_variable %>%
    dplyr::filter(
      (.data$field_name_base %in% fields) | (.data$form_name %in% forms)
    )

  desired_fields <- ds_metadata$field_name

  ds_eav      <- REDCapR:::redcap_read_eav_oneshot(redcap_uri, token, fields = desired_fields)$data
})

testit::assert(sort(ds_metadata$field_name) == sort(colnames(ds_expected)))
testthat::expect_setequal( ds_metadata$field_name, colnames(ds_expected))

# ---- tweak-data --------------------------------------------------------------
if (!"event_id" %in% colnames(ds_eav)) {
  ds_eav$event_id <- "dummy_1"
}

ds_eav_possible <-
  ds_eav %>%
  tidyr::expand(
    tidyr::nesting(record, event_id),
    tidyr::crossing(field_name = ds_metadata$field_name)
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

# . <- NULL # For the sake of avoiding an R CMD check note.
ds <-
  ds_eav_2 %>%
  dplyr::select(-.data$field_type, -.data$field_name_base) %>%
  # dplyr::select(-.data$redcap_repeat_instance) %>%        # TODO: need a good fix for repeats
  # tidyr::drop_na(event_id) %>%                            # TODO: need a good fix for repeats
  tidyr::pivot_wider( # Everything else is considered an ID column
    names_from  = field_name,
    values_from = value
  ) %>%
  dplyr::select(!!ds_metadata$field_name) %>%
  readr::type_convert(col_types)
  # dplyr::select(.data = ., !!intersect(variables_to_keep, colnames(.)))

testit::assert(sort(colnames(ds)) == sort(colnames(ds_expected)))
testthat::expect_setequal(colnames(ds), colnames(ds_expected))
