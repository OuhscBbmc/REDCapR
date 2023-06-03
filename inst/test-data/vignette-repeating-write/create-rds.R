rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("readr"        )
requireNamespace("tidyr"        )
requireNamespace("dplyr"        ) # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("rlang"        ) # Language constructs, like quosures
requireNamespace("checkmate"    ) # For asserting conditions meet expected patterns/conditions. # remotes::install_github("mllg/checkmate")
# requireNamespace("OuhscMunge"   ) # remotes::install_github(repo="OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
# config                         <- config::get()
pid     <- 3748L
# REDCapR::retrieve_credential_local()
directory <- "inst/test-data/vignette-repeating-write/"
path_patient  <- fs::path(directory, "data-patient.rds")
path_daily    <- fs::path(directory, "data-daily.rds")

# col_types <- readr::cols_only( # Use `readr::cols_only()` to restrict the retrieval to only these columns
col_types_patient <- readr::cols( # Use `readr::cols()` to include unspecified columns
  # [field]                         [readr col_type]            [explanation for col_type]
  id_code                         = readr::col_character()  , # was integer: record_autonumbering is enabled and DAGs are disabled for the project
  date                            = readr::col_date()       , # validation is 'date_ymd'
  is_mobile                       = readr::col_character()  , # field_type is dropdown
  is_mobile_where                 = readr::col_character()  , # field_type is dropdown
  initials                        = readr::col_character()  , # validation is 'alpha_only'
  unique_initials                 = readr::col_character()  , # validation is 'alpha_only'
  initials_mother                 = readr::col_character()  , # validation is 'alpha_only'
  unique_initials_mother          = readr::col_character()  , # validation is 'alpha_only'
  birth_month                     = readr::col_character()  , # field_type is dropdown
  unique_birth_month              = readr::col_character()  , # field_type is text and validation isn't set
  birth_year                      = readr::col_double()     , # validation is 'number'
  simulated_dob                   = readr::col_character()  , # field_type is text and validation isn't set
  age_at_enrollment               = readr::col_character()  , # field_type is calc
  race                            = readr::col_character()  , # field_type is dropdown
  unique_race                     = readr::col_character()  , # field_type is text and validation isn't set
  is_hispanic                     = readr::col_character()  , # field_type is dropdown
  sex_at_birth                    = readr::col_character()  , # field_type is dropdown
  unique_sex_at_birth             = readr::col_character()  , # field_type is text and validation isn't set
  gender                          = readr::col_character()  , # field_type is radio
  unique_idcode                   = readr::col_character()  , # field_type is text and validation isn't set
  is_homeless                     = readr::col_character()  , # field_type is dropdown
  is_homeless_length              = readr::col_double()     , # validation is 'number'
  is_homeless_units               = readr::col_character()  , # field_type is radio
  zip                             = readr::col_character()  , # validation is 'zipcode'
  language                        = readr::col_character()  , # field_type is radio
  language_other                  = readr::col_character()  , # validation is 'alpha_only'
  sexual_orientation              = readr::col_character()  , # field_type is radio
  relationship                    = readr::col_character()  , # field_type is radio
  education                       = readr::col_character()  , # field_type is dropdown
  employed                        = readr::col_character()  , # field_type is dropdown
  income                          = readr::col_character()  , # field_type is dropdown
  where_lived_six_months___2      = readr::col_logical()    , # field_type is checkbox
  where_lived_six_months___3      = readr::col_logical()    , # field_type is checkbox
  where_lived_six_months___4      = readr::col_logical()    , # field_type is checkbox
  where_lived_six_months___5      = readr::col_logical()    , # field_type is checkbox
  where_lived_six_months___6      = readr::col_logical()    , # field_type is checkbox
  where_lived_six_months___7      = readr::col_logical()    , # field_type is checkbox
  where_lived_six_months___8      = readr::col_logical()    , # field_type is checkbox
  where_lived_six_months___9      = readr::col_logical()    , # field_type is checkbox
  where_lived_six_months___10     = readr::col_logical()    , # field_type is checkbox
  where_lived_six_months___11     = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___1       = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___2       = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___3       = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___4       = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___5       = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___6       = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___7       = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___8       = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___9       = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___10      = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___11      = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___12      = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___13      = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___14      = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___15      = readr::col_logical()    , # field_type is checkbox
  noninject_drug_thirty___16      = readr::col_logical()    , # field_type is checkbox
  noninjection_drugs_other        = readr::col_character()  , # field_type is text and validation isn't set
  injection_drugs___1             = readr::col_logical()    , # field_type is checkbox
  injection_drugs___2             = readr::col_logical()    , # field_type is checkbox
  injection_drugs___3             = readr::col_logical()    , # field_type is checkbox
  injection_drugs___4             = readr::col_logical()    , # field_type is checkbox
  injection_drugs___5             = readr::col_logical()    , # field_type is checkbox
  injection_drugs___6             = readr::col_logical()    , # field_type is checkbox
  injection_drugs___7             = readr::col_logical()    , # field_type is checkbox
  injection_drugs___8             = readr::col_logical()    , # field_type is checkbox
  injection_drugs___9             = readr::col_logical()    , # field_type is checkbox
  injection_drugs___10            = readr::col_logical()    , # field_type is checkbox
  injection_drugs___11            = readr::col_logical()    , # field_type is checkbox
  injection_drugs___12            = readr::col_logical()    , # field_type is checkbox
  injection_drugs___13            = readr::col_logical()    , # field_type is checkbox
  injection_drugs___14            = readr::col_logical()    , # field_type is checkbox
  injection_drugs___15            = readr::col_logical()    , # field_type is checkbox
  injection_drugs___16            = readr::col_logical()    , # field_type is checkbox
  injection_drugs_other           = readr::col_character()  , # field_type is text and validation isn't set
  amount_inject_thirty            = readr::col_double()     , # validation is 'number'
  amount_inject_thirty_un         = readr::col_character()  , # field_type is radio
  reused_thirty                   = readr::col_character()  , # field_type is radio
  shared_thirty                   = readr::col_character()  , # field_type is radio
  age_first_drug_injection        = readr::col_double()     , # validation is 'number'
  has_od                          = readr::col_character()  , # field_type is radio
  hiv_test_ever                   = readr::col_character()  , # field_type is radio
  hiv_test_ninety_days            = readr::col_character()  , # field_type is radio
  hiv_test_most_recent            = readr::col_date()       , # validation is 'date_ymd'
  hiv_test_prior_result           = readr::col_character()  , # field_type is radio
  hiv_test_treat                  = readr::col_logical()    , # field_type is yesno
  hiv_test_today                  = readr::col_logical()    , # field_type is yesno
  hiv_test_today_date             = readr::col_character()  , # field_type is text and validation isn't set
  hiv_test_today_brand            = readr::col_character()  , # field_type is text and validation isn't set
  hiv_test_today_result           = readr::col_character()  , # field_type is radio
  hcv_test_ever                   = readr::col_character()  , # field_type is radio
  hcv_test_ninety_days            = readr::col_character()  , # field_type is radio
  hcv_test_most_recent            = readr::col_date()       , # validation is 'date_ymd'
  hcv_test_prior_result           = readr::col_character()  , # field_type is radio
  hcv_test_treat                  = readr::col_logical()    , # field_type is yesno
  hcv_test_today                  = readr::col_logical()    , # field_type is yesno
  hcv_test_today_result           = readr::col_character()  , # field_type is radio
  hcv_rna_offered                 = readr::col_logical()    , # field_type is yesno
  hcv_rna_accepted                = readr::col_logical()    , # field_type is yesno
  hcv_rna_results                 = readr::col_character()  , # field_type is radio
  hcv_rna_viral_load              = readr::col_double()     , # validation is 'number'
  is_vaccinated_hep_a             = readr::col_character()  , # field_type is radio
  is_vaccinated_hep_b             = readr::col_character()  , # field_type is radio
  is_vaccinated_covid             = readr::col_character()  , # field_type is dropdown
  is_vaccinated_covid_br___1      = readr::col_logical()    , # field_type is checkbox
  is_vaccinated_covid_br___2      = readr::col_logical()    , # field_type is checkbox
  is_vaccinated_covid_br___3      = readr::col_logical()    , # field_type is checkbox
  is_vaccinated_covid_br___4      = readr::col_logical()    , # field_type is checkbox
  is_vaccinated_covid_ref         = readr::col_logical()    , # field_type is yesno
  covid_test_today                = readr::col_logical()    , # field_type is yesno
  covid_test_today_result         = readr::col_character()  , # field_type is radio
  covid_test_today_class          = readr::col_character()  , # field_type is radio
  hear_about_exchange___1         = readr::col_logical()    , # field_type is checkbox
  hear_about_exchange___2         = readr::col_logical()    , # field_type is checkbox
  hear_about_exchange___3         = readr::col_logical()    , # field_type is checkbox
  hear_about_exchange___4         = readr::col_logical()    , # field_type is checkbox
  hear_about_exchange___5         = readr::col_logical()    , # field_type is checkbox
  hear_about_exchange___6         = readr::col_logical()    , # field_type is checkbox
  hear_about_exchange___7         = readr::col_logical()    , # field_type is checkbox
  hear_about_other                = readr::col_character()  , # field_type is text and validation isn't set
  used_sep_prior                  = readr::col_logical()    , # field_type is yesno
  holding_meds                    = readr::col_logical()    , # field_type is yesno
  holding_meds_locker             = readr::col_character()  , # field_type is text and validation isn't set
  interview_notes                 = readr::col_character()  , # field_type is note
  completed_by                    = readr::col_character()  , # field_type is dropdown
  completed_by_other              = readr::col_character()  , # field_type is text and validation isn't set
  enrollment_complete             = readr::col_integer()      # completion status of form/instrument
)
col_types_daily <- readr::cols( # Use `readr::cols()` to include unspecified columns
  # [field]                         [readr col_type]            [explanation for col_type]
  id_code                         = readr::col_character()  , # was integer: record_autonumbering is enabled and DAGs are disabled for the project
  da_date                         = readr::col_date()       , # validation is 'date_ymd'
  da_is_mobile                    = readr::col_character()  , # field_type is dropdown
  da_is_mobile_where              = readr::col_character()  , # field_type is dropdown
  da_encounter_type               = readr::col_character()  , # field_type is radio
  da_visit_reason___1             = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___2             = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___3             = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___4             = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___5             = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___6             = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___7             = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___8             = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___9             = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___10            = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___13            = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___12            = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___11            = readr::col_logical()    , # field_type is checkbox
  da_visit_reason___14            = readr::col_logical()    , # field_type is checkbox
  da_exchange_who___1             = readr::col_logical()    , # field_type is checkbox
  da_exchange_who___2             = readr::col_logical()    , # field_type is checkbox
  da_exchange_who___3             = readr::col_logical()    , # field_type is checkbox
  da_exchange_who___4             = readr::col_logical()    , # field_type is checkbox
  da_needle_size_1___1            = readr::col_logical()    , # field_type is checkbox
  da_needle_size_2___1            = readr::col_logical()    , # field_type is checkbox
  da_needle_size_3___1            = readr::col_logical()    , # field_type is checkbox
  da_needle_size_4___1            = readr::col_logical()    , # field_type is checkbox
  da_needle_size_5___1            = readr::col_logical()    , # field_type is checkbox
  da_needle_size_6___1            = readr::col_logical()    , # field_type is checkbox
  da_needle_size_7___1            = readr::col_logical()    , # field_type is checkbox
  da_needle_size_8___1            = readr::col_logical()    , # field_type is checkbox
  da_needle_size_9___1            = readr::col_logical()    , # field_type is checkbox
  da_needle_size_10___1           = readr::col_logical()    , # field_type is checkbox
  da_needle_size_11___1           = readr::col_logical()    , # field_type is checkbox
  da_needle_size_12___1           = readr::col_logical()    , # field_type is checkbox
  da_needle_size_13___1           = readr::col_logical()    , # field_type is checkbox
  da_needle_size_14___1           = readr::col_logical()    , # field_type is checkbox
  da_needle_size_15___1           = readr::col_logical()    , # field_type is checkbox
  da_needles_in_1                 = readr::col_integer()    , # validation is 'integer'
  da_needles_in_2                 = readr::col_integer()    , # validation is 'integer'
  da_needles_in_3                 = readr::col_integer()    , # validation is 'integer'
  da_needles_in_4                 = readr::col_integer()    , # validation is 'integer'
  da_needles_in_5                 = readr::col_integer()    , # validation is 'integer'
  da_needles_in_6                 = readr::col_integer()    , # validation is 'integer'
  da_needles_in_7                 = readr::col_integer()    , # validation is 'integer'
  da_needles_in_8                 = readr::col_integer()    , # validation is 'integer'
  da_needles_in_9                 = readr::col_integer()    , # validation is 'integer'
  da_needles_in_10                = readr::col_integer()    , # validation is 'integer'
  da_needles_in_11                = readr::col_integer()    , # validation is 'integer'
  da_needles_in_12                = readr::col_integer()    , # validation is 'integer'
  da_needles_in_13                = readr::col_integer()    , # validation is 'integer'
  da_needles_in_14                = readr::col_integer()    , # validation is 'integer'
  da_needles_in_15                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_1                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_2                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_3                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_4                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_5                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_6                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_7                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_8                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_9                = readr::col_integer()    , # validation is 'integer'
  da_needles_out_10               = readr::col_integer()    , # validation is 'integer'
  da_needles_out_11               = readr::col_integer()    , # validation is 'integer'
  da_needles_out_12               = readr::col_integer()    , # validation is 'integer'
  da_needles_out_13               = readr::col_integer()    , # validation is 'integer'
  da_needles_out_14               = readr::col_integer()    , # validation is 'integer'
  da_needles_out_15               = readr::col_integer()    , # validation is 'integer'
  da_total_needles_in             = readr::col_character()  , # field_type is calc
  da_total_needles_out            = readr::col_character()  , # field_type is calc
  da_noninject_drug_thirty___1    = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___2    = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___3    = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___4    = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___5    = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___6    = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___7    = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___8    = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___9    = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___10   = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___11   = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___12   = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___13   = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___14   = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___15   = readr::col_logical()    , # field_type is checkbox
  da_noninject_drug_thirty___16   = readr::col_logical()    , # field_type is checkbox
  da_noninject_drugs_other        = readr::col_character()  , # field_type is text and validation isn't set
  da_injection_drugs___1          = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___2          = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___3          = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___4          = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___5          = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___6          = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___7          = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___8          = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___9          = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___10         = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___11         = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___12         = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___13         = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___14         = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___15         = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs___16         = readr::col_logical()    , # field_type is checkbox
  da_injection_drugs_other        = readr::col_character()  , # field_type is text and validation isn't set
  da_amount_inject_thirty         = readr::col_double()     , # validation is 'number'
  da_amount_inject_thirty_un      = readr::col_character()  , # field_type is radio
  da_reused_thirty                = readr::col_character()  , # field_type is radio
  da_shared_thirty                = readr::col_character()  , # field_type is radio
  da_narcan_consented             = readr::col_logical()    , # field_type is yesno
  da_narcan_given                 = readr::col_logical()    , # field_type is yesno
  da_narcan_nasal___1             = readr::col_logical()    , # field_type is checkbox
  da_narcan_nasal_amt             = readr::col_character()  , # field_type is dropdown
  da_narcan_who_nasal             = readr::col_character()  , # field_type is radio
  da_narcan_refill_nasal          = readr::col_logical()    , # field_type is yesno
  da_narcan_refill_nasal_why      = readr::col_character()  , # field_type is radio
  da_narcan_nasal_loss_date       = readr::col_date()       , # validation is 'date_ymd'
  da_narcan_ai___1                = readr::col_logical()    , # field_type is checkbox
  da_narcan_refill_inject         = readr::col_logical()    , # field_type is yesno
  da_narcan_inject___1            = readr::col_logical()    , # field_type is checkbox
  da_narcan_ai_amt                = readr::col_character()  , # field_type is dropdown
  da_narcan_inject_amt            = readr::col_character()  , # field_type is dropdown
  da_narcan_who_ai                = readr::col_character()  , # field_type is radio
  da_narcan_who_inject            = readr::col_character()  , # field_type is radio
  da_narcan_refill_ai             = readr::col_logical()    , # field_type is yesno
  da_narcan_refill_ai_why         = readr::col_character()  , # field_type is radio
  da_narcan_refill_inject_why     = readr::col_character()  , # field_type is radio
  da_narcan_ai_loss_date          = readr::col_date()       , # validation is 'date_ymd'
  da_narcan_inject_loss_date      = readr::col_date()       , # validation is 'date_ymd'
  da_narcan_reversal_nasal        = readr::col_integer()    , # validation is 'integer'
  da_narcan_reversal_ai           = readr::col_integer()    , # validation is 'integer'
  da_narcan_reversal_inject       = readr::col_integer()    , # validation is 'integer'
  da_narcan_total                 = readr::col_character()  , # field_type is calc
  da_narcan_reversal_total        = readr::col_character()  , # field_type is calc
  da_referral___1                 = readr::col_logical()    , # field_type is checkbox
  da_referral___2                 = readr::col_logical()    , # field_type is checkbox
  da_referral___3                 = readr::col_logical()    , # field_type is checkbox
  da_referral___4                 = readr::col_logical()    , # field_type is checkbox
  da_referral___5                 = readr::col_logical()    , # field_type is checkbox
  da_referral___6                 = readr::col_logical()    , # field_type is checkbox
  da_referral___7                 = readr::col_logical()    , # field_type is checkbox
  da_referral___8                 = readr::col_logical()    , # field_type is checkbox
  da_referral___9                 = readr::col_logical()    , # field_type is checkbox
  da_referral___10                = readr::col_logical()    , # field_type is checkbox
  da_referral___11                = readr::col_logical()    , # field_type is checkbox
  da_referral___12                = readr::col_logical()    , # field_type is checkbox
  da_referral___13                = readr::col_logical()    , # field_type is checkbox
  da_referral___14                = readr::col_logical()    , # field_type is checkbox
  da_referral___15                = readr::col_logical()    , # field_type is checkbox
  da_hiv_test_today               = readr::col_character()  , # field_type is dropdown
  da_hiv_test_today_result        = readr::col_character()  , # field_type is radio
  da_hcv_test_today               = readr::col_character()  , # field_type is dropdown
  da_hcv_test_today_result        = readr::col_character()  , # field_type is radio
  da_hcv_rna_offered              = readr::col_logical()    , # field_type is yesno
  da_hcv_rna_accepted             = readr::col_logical()    , # field_type is yesno
  da_hcv_rna_results              = readr::col_character()  , # field_type is radio
  da_hcv_rna_viral_load           = readr::col_double()     , # validation is 'number'
  da_ref_hiv_tx                   = readr::col_character()  , # field_type is dropdown
  da_ref_hcv_trx                  = readr::col_character()  , # field_type is dropdown
  da_ref_prep                     = readr::col_character()  , # field_type is dropdown
  da_ref_primary                  = readr::col_character()  , # field_type is dropdown
  da_ref_cmhc                     = readr::col_character()  , # field_type is dropdown
  da_ref_detox                    = readr::col_character()  , # field_type is dropdown
  da_ref_detox_other              = readr::col_character()  , # field_type is text and validation isn't set
  da_ref_residential_tx           = readr::col_character()  , # field_type is dropdown
  da_ref_residential_other        = readr::col_character()  , # field_type is text and validation isn't set
  da_ref_shelter                  = readr::col_character()  , # field_type is dropdown
  da_linkage___1                  = readr::col_logical()    , # field_type is checkbox
  da_linkage___2                  = readr::col_logical()    , # field_type is checkbox
  da_linkage___3                  = readr::col_logical()    , # field_type is checkbox
  da_linkage___4                  = readr::col_logical()    , # field_type is checkbox
  da_linkage___5                  = readr::col_logical()    , # field_type is checkbox
  da_linkage___6                  = readr::col_logical()    , # field_type is checkbox
  da_linkage___7                  = readr::col_logical()    , # field_type is checkbox
  da_linkage___8                  = readr::col_logical()    , # field_type is checkbox
  da_linkage___9                  = readr::col_logical()    , # field_type is checkbox
  da_linkage___10                 = readr::col_logical()    , # field_type is checkbox
  da_covid_test_today             = readr::col_logical()    , # field_type is yesno
  da_covid_test_today_result      = readr::col_character()  , # field_type is dropdown
  da_covid_test_today_class       = readr::col_character()  , # field_type is dropdown
  da_wound                        = readr::col_logical()    , # field_type is yesno
  da_incidents                    = readr::col_logical()    , # field_type is yesno
  da_incidents_info               = readr::col_character()  , # field_type is text and validation isn't set
  da_completed_by                 = readr::col_character()  , # field_type is dropdown
  da_other                        = readr::col_character()  , # field_type is text and validation isn't set
  da_hiv_needed                   = readr::col_character()  , # field_type is text and validation isn't set
  da_hiv_needed_out               = readr::col_character()  , # field_type is text and validation isn't set
  da_hcv_needed                   = readr::col_character()  , # field_type is text and validation isn't set
  da_hcv_needed_out               = readr::col_character()  , # field_type is text and validation isn't set
  daily_complete                  = readr::col_integer()    , # completion status of form/instrument
)

credential  <- REDCapR::retrieve_credential_local(
  path_credential = system.file("misc/example.credentials", package = "REDCapR"),
  project_id      = 3748
)

# ---- load-data ---------------------------------------------------------------
# REDCapR::redcap_metadata_coltypes(
#   redcap_uri  = credential$redcap_uri,
#   token       = credential$token,
# )

# ds_block <-
#   REDCapR::redcap_read(
#     redcap_uri  = credential$redcap_uri,
#     token       = credential$token,
#   )$data

ds_patient <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token,
    forms       = "enrollment",
    col_types   = col_types_patient
    # records     =
  )$data

ds_daily <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token,
    forms       = "daily",
    col_types   = col_types_daily
  )$data

rm(col_types_patient, col_types_daily)

# ---- tweak-data --------------------------------------------------------------
# OuhscMunge::column_rename_headstart(ds) # Help write `dplyr::select()` call.

ds_patient <-
  ds_patient |>
  dplyr::select(
    -redcap_repeat_instrument,
    -redcap_repeat_instance,
  )

# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds)
# checkmate::assert_integer(  ds$subject_id , any.missing=F , lower=1001, upper=1200 , unique=T)
# checkmate::assert_integer(  ds$county_id  , any.missing=F , lower=1, upper=77     )
# checkmate::assert_numeric(  ds$gender_id  , any.missing=F , lower=1, upper=255     )
# checkmate::assert_character(ds$race       , any.missing=F , pattern="^.{5,41}$"    )
# checkmate::assert_character(ds$ethnicity  , any.missing=F , pattern="^.{18,30}$"   )

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds), collapse=",\n"))

# Define the subset of columns that will be needed in the analyses.
#   The fewer columns that are exported, the fewer things that can break downstream.

# ds_slim <-
#   ds |>
#   # dplyr::slice(1:100) |>
#   dplyr::select(
#     subject_id,
#     county_id,
#     gender_id,
#     race,
#     ethnicity,
#   )
#
# ds_slim

# ---- save-to-disk ------------------------------------------------------------
# If there's no PHI, a rectangular CSV is usually adequate, and it's portable to other machines and software.
# readr::write_csv(ds_slim, path_out_unified)
readr::write_rds(ds_patient, path_patient, compress="gz") # Save as a compressed R-binary file if it's large or has a lot of factors.
readr::write_rds(ds_daily  , path_daily  , compress="gz") # Save as a compressed R-binary file if it's large or has a lot of factors.
