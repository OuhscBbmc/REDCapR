# Get survey link from REDCap

This function uses REDCap's API to get the link for a survey.

## Usage

``` r
redcap_survey_link_export_oneshot(
  redcap_uri,
  token,
  record,
  instrument,
  event = "",
  verbose = TRUE,
  config_options = NULL,
  handle_httr = NULL
)
```

## Arguments

- redcap_uri:

  The
  [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
  of the REDCap server typically formatted as
  "https://server.org/apps/redcap/api/". Required.

- token:

  The user-specific string that serves as the password for a project.
  Required.

- record:

  The record ID associated with the survey link. Required

- instrument:

  The name of the instrument associated with the survey link. Required

- event:

  The name of the event associated with the survey link. Optional

- verbose:

  A boolean value indicating if `message`s should be printed to the R
  console during the operation. Optional.

- config_options:

  A list of options passed to
  [`httr::POST()`](https://httr.r-lib.org/reference/POST.html). See
  details at
  [`httr::httr_options()`](https://httr.r-lib.org/reference/httr_options.html).
  Optional.

- handle_httr:

  The value passed to the `handle` parameter of
  [`httr::POST()`](https://httr.r-lib.org/reference/POST.html). This is
  useful for only unconventional authentication approaches. It should be
  `NULL` for most institutions. Optional.

## Value

Currently, a list is returned with the following elements,

- `survey_link`: a character string containing the URL for the survey.

- `success`: A boolean value indicating if the operation was apparently
  successful.

- `status_code`: The [http status
  code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the
  operation.

- `outcome_message`: A human readable string indicating the operation's
  outcome.

- `instrument`: The instrument associated with the survey link.

- `records_affected_count`: The number of records associated with the
  survey link.

- `affected_ids`: The subject IDs associated with the survey link.

- `elapsed_seconds`: The duration of the function.

- `raw_text`: If an operation is NOT successful, the text returned by
  REDCap. If an operation is successful, the `raw_text` is returned as
  an empty string to save RAM.

## Details

Currently, the function doesn't modify any variable types to conform to
REDCap's supported variables. See
[`validate_for_write()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
for a helper function that checks for some common important conflicts.

**Permissions Required** To use this method, you must have API Export
privileges in the project. (As stated in the 9.0.0 documentation.)

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (*i.e.*,
https://community.projectredcap.org/articles/456/api-documentation.html
and https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus
REDCap administrator to send you the static material.

## Author

Will Beasley

## Examples

``` r
# \dontrun{
uri     <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token   <- "4780D038A2080BA2E7CC904A14218662" # survey

record  <- 1
instrument   <- "participant_morale_questionnaire"
# event <- "" # only for longitudinal projects

result <- REDCapR::redcap_survey_link_export_oneshot(
  record         = record,
  instrument     = instrument,
  redcap_uri     = uri,
  token          = token
)
#> Preparing to export the survey link for the instrument `participant_morale_questionnaire`.
#> exported the survey link in 0.1 seconds, for instrument `participant_morale_questionnaire`, record `1`.
result$survey_link
#> [1] "https://redcap-dev-2.ouhsc.edu/redcap/surveys/?s=wrz55jpDyXYBuw73"
# }
```
