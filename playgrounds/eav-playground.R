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
ds_expected <- REDCapR::redcap_read_oneshot(redcap_uri, token)$data
ds_metadata <- REDCapR::redcap_metadata_read(redcap_uri, token)$data

r <- httr::POST(
  url = redcap_uri
  , body = list(
    token = token
    , content = 'record'
    , format = 'csv'
    , type = 'eav'  ##This is the difference from the call above
    # , rawOrLabel = raw_or_label
    # , exportDataAccessGroups = export_data_access_groups_string
    # , records = records_collapsed
    # , fields = fields_collapsed
  )
)
r$status_code
r$headers$status
r$headers$statusmessage
raw_text <- httr::content(r, "text")

ds_eav <- readr::read_csv(raw_text)

# ---- tweak-data --------------------------------------------------------------

ds_checkbox <- ds_metadata %>%
  dplyr::filter(field_type=="checkbox")

ds <- ds_eav %>%
  dplyr::left_join(
    ds_metadata %>%
      dplyr::select(field_name, field_type),
    by = "field_name"
  ) %>%
  dplyr::mutate(
    field_name = dplyr::if_else(!is.na(field_type) & (field_type=="checkbox"), paste0(field_name, "___", value), field_name),
    value      = dplyr::if_else(!is.na(field_type) & (field_type=="checkbox"), "TRUE"                          , value     )
  ) %>%
  dplyr::select(-field_type) %>%
  tidyr::spread(key=field_name, value=value)#, -record)

# ---- verify-values -----------------------------------------------------------
# testit::assert("All IDs should be nonmissing and positive.", all(!is.na(ds$CountyID) & (ds$CountyID>0)))

