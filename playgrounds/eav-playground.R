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
token <- "D70F9ACD1EDD6F151C6EA78683944E98"  #This is for a PHI-free demo project

raw_or_label <- "raw"
export_data_access_groups_string <- "false"

# ---- load-data ---------------------------------------------------------------
system.time(
ds_expected <- REDCapR::redcap_read_oneshot(redcap_uri, token)$data
)

system.time({
ds_metadata <- REDCapR::redcap_metadata_read(redcap_uri, token)$data
ds_variable <- REDCapR::redcap_variables(redcap_uri, token)$data

r <- httr::POST(
  url  = redcap_uri,
  body = list(
    token       = token,
    content     = 'record',
    format      = 'csv',
    type        = 'eav'  ##This is the difference from the call above
    # , rawOrLabel = raw_or_label
    , exportDataAccessGroups = export_data_access_groups_string
    # , records = records_collapsed
    # , fields = "studyid,referral_source" #fields_collapsed
  )
)
r$status_code
r$headers$status
r$headers$statusmessage
raw_text <- httr::content(r, "text")

ds_eav <- readr::read_csv(raw_text, show_col_types  = FALSE)
})

# ds_eav$field_name


# ---- tweak-data --------------------------------------------------------------

if (!"event_id" %in% colnames(ds_eav)) {
  ds_eav$event_id <- "dummy_1"
}

ds_metadata_expanded <-
  ds_metadata %>%
  dplyr::select(.data$field_name, .data$select_choices_or_calculations, .data$field_type) %>%
  dplyr::mutate(
    is_checkbox   = (.data$field_type == "checkbox"),
    ids           = dplyr::if_else(.data$is_checkbox, .data$select_choices_or_calculations, "1"),
    ids           = gsub("(\\d+),.+?(\\||$)", "\\1", .data$ids),
    ids           = strsplit(.data$ids, " ")
  ) %>%
  dplyr::select(-.data$select_choices_or_calculations, -.data$field_type) %>%
  tidyr::unnest(.data$ids) %>%
  dplyr::transmute(
    .data$is_checkbox,
    field_name          = dplyr::if_else(.data$is_checkbox, paste0(.data$field_name, "___", .data$ids), .data$field_name)
  )

distinct_checkboxes <-
  ds_metadata_expanded %>%
  dplyr::filter(.data$is_checkbox) %>%
  dplyr::pull(.data$field_name)

ds_possible_checkbox_rows  <-
  tidyr::crossing(
    field_name = distinct_checkboxes,
    record     = unique(ds_eav$record),
    field_type = "checkbox",
    event_id   = unique(ds_eav$event_id)
  )

# ds_metadata %>%
#   dplyr::filter(field_type %in% c("calc", "file")) %>%
#   dplyr::select_("field_name")
variables_to_keep <-
  ds_metadata_expanded %>%
  dplyr::select(.data$field_name) %>%
  dplyr::union(
    ds_variable %>%
      dplyr::select(field_name = .data$export_field_name) %>%
      dplyr::filter(grepl("^\\w+?_complete$", .data$field_name))
  ) %>%
  dplyr::pull(.data$field_name) #%>% rev()

ds_eav_2 <-
  ds_eav %>%
  dplyr::left_join(
    ds_metadata %>%
      dplyr::select(.data$field_name, .data$field_type),
    by = "field_name"
  ) %>%
  dplyr::mutate(
    field_name = dplyr::if_else(!is.na(.data$field_type) & (.data$field_type == "checkbox"), paste0(.data$field_name, "___", .data$value), .data$field_name)
  ) %>%
  dplyr::full_join(ds_possible_checkbox_rows, by=c("record", "field_name", "field_type", "event_id")) %>%
  dplyr::mutate(
    value      = dplyr::if_else(!is.na(.data$field_type) & (.data$field_type == "checkbox"), as.character(!is.na(.data$value)), .data$value)
  )
ds <-
  ds_eav_2 %>%
  dplyr::select(-.data$field_type) %>%
  # dplyr::select(-.data$redcap_repeat_instance) %>%        # TODO: need a good fix for repeats
  # tidyr::drop_na(event_id) %>%                            # TODO: need a good fix for repeats
  tidyr::spread(key = .data$field_name, value = .data$value) %>%
  dplyr::select(.data = ., !!intersect(variables_to_keep, colnames(.)))

ds_2 <-
  ds %>%
  dplyr::mutate_if(is.character, ~type.convert(., as.is = FALSE)) %>%
  dplyr::mutate_if(is.factor   , as.character)


# ---- verify-values -----------------------------------------------------------
setdiff(colnames(ds_expected), colnames(ds_2))
setdiff(colnames(ds_2), colnames(ds_expected))

# setdiff(colnames(ds_3), colnames(ds_2))
# setdiff(colnames(ds_2), colnames(ds_3))
# testit::assert("All IDs should be nonmissing and positive.", all(!is.na(ds$CountyID) & (ds$CountyID>0)))


# ---- old-snippets ------------------------------------------------------------

# TODO: get this list from metadata, in case there are columns that aren't yet populated.
# checkboxes <- ds_eav_2 %>%
#   dplyr::filter(field_type=="checkbox") %>%
#   dplyr::distinct(field_name) %>%
#   .[["field_name"]] %>%
#   sort()

# strsplit(ds_meta_checkbox$select_choices_or_calculations[[1]], split="\\s*\\|\\s*", perl=FALSE)[[1]]

# checkbox_ids <-
#   ds_meta_checkbox$select_choices_or_calculations[1] %>%
#   strsplit( split="\\s*\\|\\s*", perl=FALSE) %>%
#   .[[1]] %>%
#   gsub("(\\d{1,}),\\s*.+", "\\1", ., perl=TRUE) %>%
#   as.integer()
#
# ds_meta_checkbox$select_choices_or_calculations %>%
#   gsub("(\\d+),.+?(\\||$)", "\\1", .)
#
# ds_2 <- ds_2 %>%
#   dplyr::mutate_at(
#     .cols = dplyr::vars(dplyr::one_of(checkboxes)),
#     .funs = function(x) !is.na(x)                       # If there's any value, then it's TRUE.  Missingness is converted to FALSE.
#   )
