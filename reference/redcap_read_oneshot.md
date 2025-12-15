# Read/Export records from a REDCap project

This function uses REDCap's API to select and return data.

## Usage

``` r
redcap_read_oneshot(
  redcap_uri,
  token,
  records = NULL,
  fields = NULL,
  forms = NULL,
  events = NULL,
  raw_or_label = "raw",
  raw_or_label_headers = "raw",
  export_checkbox_label = FALSE,
  export_survey_fields = FALSE,
  export_data_access_groups = FALSE,
  filter_logic = "",
  datetime_range_begin = as.POSIXct(NA),
  datetime_range_end = as.POSIXct(NA),
  blank_for_gray_form_status = FALSE,
  col_types = NULL,
  na = c("", "NA"),
  guess_type = TRUE,
  guess_max = 1000,
  http_response_encoding = "UTF-8",
  locale = readr::default_locale(),
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

- records:

  An array, where each element corresponds to the ID of a desired
  record. Optional.

- fields:

  An array, where each element corresponds to a desired project field.
  Optional.

- forms:

  An array, where each element corresponds to a desired project form.
  Optional.

- events:

  An array, where each element corresponds to a desired project event.
  Optional.

- raw_or_label:

  A string (either `'raw'` or `'label'`) that specifies whether to
  export the raw coded values or the labels for the options of multiple
  choice fields. Default is `'raw'`.

- raw_or_label_headers:

  A string (either `'raw'` or `'label'` that specifies for the CSV
  headers whether to export the variable/field names (raw) or the field
  labels (label). Default is `'raw'`.

- export_checkbox_label:

  specifies the format of checkbox field values specifically when
  exporting the data as labels. If `raw_or_label` is `'label'` and
  `export_checkbox_label` is TRUE, the values will be the text displayed
  to the users. Otherwise, the values will be 0/1.

- export_survey_fields:

  A boolean that specifies whether to export the survey identifier field
  (e.g., 'redcap_survey_identifier') or survey timestamp fields (e.g.,
  instrument+'\_timestamp'). The timestamp outputs reflect the survey's
  *completion* time (according to the time and timezone of the REDCap
  server.)

- export_data_access_groups:

  A boolean value that specifies whether or not to export the
  `redcap_data_access_group` field when data access groups are utilized
  in the project. Default is `FALSE`. See the details below.

- filter_logic:

  String of logic text (e.g., `[gender] = 'male'`) for filtering the
  data to be returned by this API method, in which the API will only
  return the records (or record-events, if a longitudinal project) where
  the logic evaluates as TRUE. An blank/empty string returns all
  records.

- datetime_range_begin:

  To return only records that have been created or modified *after* a
  given datetime, provide a
  [POSIXct](https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html)
  value. If not specified, REDCap will assume no begin time.

- datetime_range_end:

  To return only records that have been created or modified *before* a
  given datetime, provide a
  [POSIXct](https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html)
  value. If not specified, REDCap will assume no end time.

- blank_for_gray_form_status:

  A boolean value that specifies whether or not to export blank values
  for instrument complete status fields that have a gray status icon.
  All instrument complete status fields having a gray icon can be
  exported either as a blank value or as "0" (Incomplete). Blank values
  are recommended in a data export if the data will be re-imported into
  a REDCap project. Default is `FALSE`.

- col_types:

  A [`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
  object passed internally to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).
  Optional.

- na:

  A [character](https://rdrr.io/r/base/character.html) vector passed
  internally to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).
  Defaults to `c("", "NA")`.

- guess_type:

  A boolean value indicating if all columns should be returned as
  character. If true,
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
  guesses the intended data type for each column. Ignored if `col_types`
  is not null.

- guess_max:

  A positive [base::numeric](https://rdrr.io/r/base/numeric.html) value
  passed to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
  that specifies the maximum number of records to use for guessing
  column types.

- http_response_encoding:

  The encoding value passed to
  [`httr::content()`](https://httr.r-lib.org/reference/content.html).
  Defaults to 'UTF-8'.

- locale:

  a
  [`readr::locale()`](https://readr.tidyverse.org/reference/locale.html)
  object to specify preferences like number, date, and time formats.
  This object is passed to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).
  Defaults to
  [`readr::default_locale()`](https://readr.tidyverse.org/reference/locale.html).

- verbose:

  A boolean value indicating if `message`s should be printed to the R
  console during the operation. The verbose output might contain
  sensitive information (*e.g.* PHI), so turn this off if the output
  might be visible somewhere public. Optional.

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

Currently, a list is returned with the following elements:

- `data`: A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  of the desired records and columns.

- `success`: A boolean value indicating if the operation was apparently
  successful.

- `status_code`: The [http status
  code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the
  operation.

- `outcome_message`: A human readable string indicating the operation's
  outcome.

- `records_collapsed`: The desired records IDs, collapsed into a single
  string, separated by commas.

- `fields_collapsed`: The desired field names, collapsed into a single
  string, separated by commas.

- `filter_logic`: The filter statement passed as an argument.

- `elapsed_seconds`: The duration of the function.

- `raw_text`: If an operation is NOT successful, the text returned by
  REDCap. If an operation is successful, the `raw_text` is returned as
  an empty string to save RAM.

If no records are retrieved (such as no records meet the filter
criteria), a zero-row tibble is returned. Currently the empty tibble has
zero columns, but that may change in the future.

## Details

If you do not pass an `export_data_access_groups` value, it will default
to `FALSE`. The following is from the API help page for version 10.5.1:
*This flag is only viable if the user whose token is being used to make
the API request is **not** in a data access group. If the user is in a
group, then this flag will revert to its default value*.

The REDCap project may contain "pseudofields", depending on its
structure. Pseudofields are exported for certain project structures, but
are not defined by users and do not appear in the codebook. If a
recognized pseudofield is passed to the `fields` api parameter, it is
suppressed by
[`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
and `redcap_read_oneshot()` so the server doesn't throw an error.
Requesting a pseudofield is discouraged, so a message is returned to the
user.

Pseudofields include:

- `redcap_event_name`: for longitudinal projects or multi-arm projects.

- `redcap_repeat_instrument`: for projects with repeating instruments.

- `redcap_repeat_instance`: for projects with repeating instruments.

- `redcap_data_access_group`: for projects with DAGs when the
  `export_data_access_groups` api parameter is TRUE.

- `redcap_survey_identifier`: for projects with surveys when the
  `export_survey_fields` api parameter is TRUE.

- *instrument_name*`_timestamp`: for projects with surveys. For example,
  an instrument called "demographics" will have a pseudofield named
  `demographics_timestamp`. REDCapR does not suppress requests for
  timestamps, so the server will throw an error like

      ERROR: The following values in the parameter fields are not valid: 'demographics_timestamp'

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
uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token    <- "9A068C425B1341D69E83064A2D273A70"

# Return all records and all variables.
ds <- REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token)$data
#> 5 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

# Return only records with IDs of 1 and 3
desired_records_v1 <- c(1, 3)
ds_some_rows_v1 <- REDCapR::redcap_read_oneshot(
  redcap_uri = uri,
  token      = token,
  records    = desired_records_v1
)$data
#> 2 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

# Return only the fields record_id, name_first, and age
desired_fields_v1 <- c("record_id", "name_first", "age")
ds_some_fields_v1 <- REDCapR::redcap_read_oneshot(
  redcap_uri = uri,
  token      = token,
  fields     = desired_fields_v1
)$data
#> 5 records and 3 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

# Specify the column types.
col_types <- readr::cols(
  record_id  = readr::col_integer(),
  race___1   = readr::col_logical(),
  race___2   = readr::col_logical(),
  race___3   = readr::col_logical(),
  race___4   = readr::col_logical(),
  race___5   = readr::col_logical(),
  race___6   = readr::col_logical()
)
ds_col_types <- REDCapR::redcap_read_oneshot(
  redcap_uri = uri,
  token      = token,
  col_types  = col_types
)$data
#> 5 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
# }
```
