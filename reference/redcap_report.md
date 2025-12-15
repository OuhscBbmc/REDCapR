# Read/Export records that populate a REDCap report

Exports the data set of a report created on a project's 'Data Exports,
Reports, and Stats' page.

## Usage

``` r
redcap_report(
  redcap_uri,
  token,
  report_id,
  raw_or_label = "raw",
  raw_or_label_headers = "raw",
  export_checkbox_label = FALSE,
  col_types = NULL,
  guess_type = TRUE,
  guess_max = 1000,
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

- report_id:

  A single integer, provided next to the report name on the report list
  page. Required.

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

- col_types:

  A [`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
  object passed internally to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).
  Optional.

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

- `elapsed_seconds`: The duration of the function.

- `raw_text`: If an operation is NOT successful, the text returned by
  REDCap. If an operation is successful, the `raw_text` is returned as
  an empty string to save RAM.

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
uri          <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token        <- "9A068C425B1341D69E83064A2D273A70"

report_1_id  <- 12L
report_2_id  <- 13L

# Return all records and all variables.
ds_1a <-
  REDCapR::redcap_report(
    redcap_uri = uri,
    token      = token,
    report_id  = report_1_id
  )$data
#> 5 records and 5 columns were read from REDCap in 0.1 seconds.  The http status code was 200.


# Specify the column types.
col_types_1 <- readr::cols(
  record_id          = readr::col_integer(),
  height             = readr::col_double(),
  health_complete    = readr::col_integer(),
  address            = readr::col_character(),
  ethnicity          = readr::col_integer()
)
ds_1b <-
  REDCapR::redcap_report(
    redcap_uri = uri,
    token      = token,
    report_id  = report_1_id,
    col_types  = col_types_1
  )$data
#> 5 records and 5 columns were read from REDCap in 0.1 seconds.  The http status code was 200.


# Return condensed checkboxes Report option:
#   "Combine checkbox options into single column of only the checked-off
#   options (will be formatted as a text field when exported to
#   stats packages)"
col_types_2 <- readr::cols(
  record_id          = readr::col_integer(),
  race               = readr::col_character()
)
ds_2 <-
  REDCapR::redcap_report(
    redcap_uri = uri,
    token      = token,
    report_id  = report_2_id,
    col_types  = col_types_2
  )$data
#> 5 records and 2 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
# }
```
