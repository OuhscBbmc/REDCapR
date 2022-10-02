rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------

# ---- load-packages -----------------------------------------------------------
library("magrittr")
requireNamespace("httr")
requireNamespace("dplyr")
requireNamespace("readr")
requireNamespace("testit")

# ---- declare-globals ---------------------------------------------------------
redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B"  # PHI-free demo: simple static
token <- "5007DC786DBE39CE77ED8DD0C68069A6"  # PHI-free demo: Checkboxes 1
# token <- "CCB7E11837D41126D67C744F97389E04"  # PHI-free demo: super-wide --3,000 columns
# token <- "5C1526186C4D04AE0A0630743E69B53C"  # PHI-free demo: super-wide #3--35,000 columns
# token <- "56F43A10D01D6578A46393394D76D88F"  # PHI-free demo: Repeating Instruments --Sparse

raw_or_label <- "raw"
export_data_access_groups_string <- "false"

# ---- load-data ---------------------------------------------------------------
system.time(
  ds_expected <- REDCapR::redcap_read_oneshot(redcap_uri, token)$data
)

system.time({
  ds_metadata <- REDCapR:::redcap_metadata_internal(redcap_uri, token)$d_variable
  ds_variable <- REDCapR::redcap_variables(redcap_uri, token)$data

  post_body <- list(
    token                        = token,
    content                      = "record",
    format                       = "csv",
    type                         = "eav"#,
    # rawOrLabel                   = raw_or_label,
    # rawOrLabelHeaders            = raw_or_label_headers,
    # exportDataAccessGroups       = export_data_access_groups,
    # filterLogic                  = filter_logic,
    # dateRangeBegin               = datetime_range_begin,
    # dateRangeEnd                 = datetime_range_end,
    # exportBlankForGrayFormStatus = blank_for_gray_form_status
    # record, fields, forms & events are specified below
  )
  kernel <- REDCapR:::kernel_api(
    redcap_uri      = redcap_uri,
    post_body       = post_body,
    config_options  = NULL
    # config_options  = config_options,
    # encoding        = http_response_encoding,
    # handle_httr     = handle_httr
  )
})

# ds_eav$field_name
testit::assert(sort(ds_metadata$field_name) == sort(colnames(ds_expected)))
testthat::expect_setequal( ds_metadata$field_name, colnames(ds_expected))

# ---- tweak-data --------------------------------------------------------------

ds_eav <-
  readr::read_csv(
    file            = I(kernel$raw_text),
    col_types       = readr::cols(.default = readr::col_character()),
    # locale          = locale,
    show_col_types  = FALSE
  )

if (!"event_id" %in% colnames(ds_eav)) {
  ds_eav$event_id <- "dummy_1"
}

ds_eav_possible <-
  ds_eav %>%
  tidyr::expand(
    tidyr::nesting(record, event_id),
    tidyr::crossing(field_name = ds_metadata$field_name)
  )

# distinct_checkboxes <-
#   ds_metadata %>%
#   dplyr::filter(.data$field_type == "checkbox") %>%
#   dplyr::pull(.data$field_name)
#
# ds_possible_checkbox_rows  <-
#   tidyr::crossing(
#     field_name = distinct_checkboxes,
#     record     = unique(ds_eav$record),
#     field_type = "checkbox",
#     event_id   =  unique(ds_eav$event_id)
#   )

# variables_to_keep <-
#   ds_metadata %>%
#   dplyr::select(.data$field_name) %>%
#   dplyr::union(
#     ds_variable %>%
#       dplyr::select(field_name = .data$export_field_name) %>%
#       dplyr::filter(grepl("^\\w+?_complete$", .data$field_name))
#   ) %>%
#   dplyr::pull(.data$field_name) #%>% rev()

ds_eav_2 <-
  ds_eav %>%
  dplyr::rename(field_name_base = field_name) %>%
  dplyr::left_join(
    ds_metadata %>%
      dplyr::distinct(.data$field_name_base, .data$field_type), # .data$field_name,
    by = "field_name_base"
  ) %>%
  dplyr::mutate(
    field_name = dplyr::if_else(!is.na(.data$field_type) & (.data$field_type == "checkbox"), paste0(.data$field_name_base , "___", .data$value), .data$field_name_base )
  ) %>%
  dplyr::mutate(
    value      = dplyr::if_else(!is.na(.data$field_type) & (.data$field_type == "checkbox"), as.character(!is.na(.data$value)), .data$value)
  ) %>%
  dplyr::right_join(ds_eav_possible, by = c("record", "event_id", "field_name"))



. <- NULL # For the sake of avoiding an R CMD check note.
# ds <-
  ds_eav_2 %>%
  dplyr::select(-.data$field_type, -.data$field_name_base) %>%
  # dplyr::select(-.data$redcap_repeat_instance) %>%        # TODO: need a good fix for repeats
  # tidyr::drop_na(event_id) %>%                            # TODO: need a good fix for repeats
  tidyr::pivot_wider(
    # id_cols   = c(record, event_id),
    names_from  = field_name,
    values_from = value
  ) #%>%
  # dplyr::select(.data = ., !!intersect(variables_to_keep, colnames(.)))

ds_2 <-
  ds %>%
  dplyr::mutate_if(is.character, ~type.convert(., as.is = FALSE)) %>%
  dplyr::mutate_if(is.factor   , as.character)
