## ----pre-req------------------------------------------------------------------
requireNamespace("REDCapR")

# If this fails, run `install.packages("REDCapR")` or `remotes::install_github(repo="OuhscBbmc/REDCapR")`

## ----retrieve-credential------------------------------------------------------
path_credential <- system.file("misc/dev-2.credentials", package = "REDCapR")
credential  <- REDCapR::retrieve_credential_local(
  path_credential = path_credential,
  project_id      = 62
)

credential

## ----unstructured-1-----------------------------------------------------------
ds_1 <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token
  )$data

View(ds_1)


# View corresponding REDCap project in browser:
# https://redcap-dev-2.ouhsc.edu/redcap/redcap_v14.3.13/DataEntry/record_home.php?pid=62&arm=1&id=1


# ---- redcap_metadata_read ----------------------------------------------------
REDCapR::redcap_metadata_read(
  redcap_uri  = credential$redcap_uri,
  token       = credential$token
)$data


# ---- grain - intake -----------------------------------------------------------
col_types_intake <-
  readr::cols_only(
    record_id                 = readr::col_integer(),
    height                    = readr::col_double(),
    weight                    = readr::col_double(),
    bmi                       = readr::col_double()
  )

ds_intake <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri, # From the previous code snippet.
    token       = credential$token,
    forms       = "intake",
    col_types   = col_types_intake,
    verbose     = FALSE,
  )$data

ds_intake


# ---- grain - bp --------------------------------------------------------------
col_types_blood_pressure <-
  readr::cols(
    record_id                 = readr::col_integer(),
    redcap_repeat_instrument  = readr::col_character(),
    redcap_repeat_instance    = readr::col_integer(),
    sbp                       = readr::col_double(),
    dbp                       = readr::col_double(),
    blood_pressure_complete   = readr::col_integer()
  )

ds_blood_pressure <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token,
    forms       = "blood_pressure",
    col_types   = col_types_blood_pressure,
    verbose     = FALSE
  )$data

ds_blood_pressure |>
  tidyr::drop_na(redcap_repeat_instrument)

# ---- grain - labs ------------------------------------------------------------
col_types_laboratory  <-
  readr::cols(
    record_id                 = readr::col_integer(),
    redcap_repeat_instrument  = readr::col_character(),
    redcap_repeat_instance    = readr::col_integer(),
    lab                       = readr::col_character(),
    conc                      = readr::col_character(),
    laboratory_complete       = readr::col_integer()
  )

ds_laboratory  <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token,
    forms       = "laboratory",
    col_types   = col_types_laboratory,
    verbose     = FALSE
  )$data

ds_laboratory |>
  tidyr::drop_na(redcap_repeat_instrument)
