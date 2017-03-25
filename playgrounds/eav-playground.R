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
export_data_access_groups_string <- "true"

# ---- load-data ---------------------------------------------------------------
system.time(
ds_expected <- REDCapR::redcap_read_oneshot(redcap_uri, token)$data
)

system.time({
ds_metadata <- REDCapR::redcap_metadata_read(redcap_uri, token)$data

r <- httr::POST(
  url  = redcap_uri,
  body = list(
    token       = token,
    content     = 'record',
    format      = 'csv',
    type        = 'eav'  ##This is the difference from the call above
    # , rawOrLabel = raw_or_label
    # , exportDataAccessGroups = export_data_access_groups_string
    # , records = records_collapsed
    # , fields = "studyid,referral_source" #fields_collapsed
  )
)
r$status_code
r$headers$status
r$headers$statusmessage
raw_text <- httr::content(r, "text")

ds_eav <- readr::read_csv(raw_text)
# ds_csv <- readr::read_csv(raw_text)
# ds_json <- jsonlite::fromJSON(raw_text)
})

# ds_eav$field_name


# ---- tweak-data --------------------------------------------------------------

ds_metadata_expanded <- ds_metadata %>%
  dplyr::select(field_name, select_choices_or_calculations, field_type) %>%
  dplyr::mutate(
    is_checkbox  = (field_type=="checkbox"),
    ids   = dplyr::if_else(is_checkbox, select_choices_or_calculations, "1"),
    ids   = gsub("(\\d+),.+?(\\||$)", "\\1", ids),
    ids   = strsplit(ids, " ")
  ) %>%
  dplyr::select(-select_choices_or_calculations, -field_type) %>%
  tidyr::unnest(ids) %>%
  dplyr::transmute(
    is_checkbox,
    field_name          = dplyr::if_else(is_checkbox, paste0(field_name, "___", ids), field_name)
  ) %>%
  tibble::as_tibble()

ds_possible_checkbox_rows <- ds_metadata_expanded %>%
  dplyr::filter(is_checkbox) %>%
  .[["field_name"]] %>%
  tidyr::crossing(
    field_name = .,
    record     = dplyr::distinct(ds_eav, record),
    field_type = "checkbox"
  )

ds_eav_2 <- ds_eav %>%
  dplyr::left_join(
    ds_metadata %>%
      dplyr::select(field_name, field_type),
    by = "field_name"
  ) %>%
  dplyr::mutate(
    field_name = dplyr::if_else(!is.na(field_type) & (field_type=="checkbox"), paste0(field_name, "___", value), field_name)
  ) %>%
  dplyr::full_join(ds_possible_checkbox_rows, by=c("record", "field_name", "field_type")) %>%
  dplyr::mutate(
    value      = dplyr::if_else(!is.na(field_type) & (field_type=="checkbox"), as.character(!is.na(value))                        , value     )
  )

ds <- ds_eav_2 %>%
  dplyr::select(-field_type) %>%
  tidyr::spread(key=field_name, value=value) %>%
  dplyr::select_(.dots=ds_metadata_expanded$field_name)  #TODO: don't drop the *form*_complete booleans

ds_2 <- ds %>%
  dplyr::mutate_if(is.character, type.convert) %>%
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

# strsplit(ds_meta_checkbox$select_choices_or_calculations[[1]], split="\\s*\\|\\s*", perl=F)[[1]]

# checkbox_ids <-
#   ds_meta_checkbox$select_choices_or_calculations[1] %>%
#   strsplit( split="\\s*\\|\\s*", perl=F) %>%
#   .[[1]] %>%
#   gsub("(\\d{1,}),\\s*.+", "\\1", ., perl=T) %>%
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

