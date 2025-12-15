# Read records from a REDCap project in subsets, and stacks them together before returning a dataset

From an external perspective, this function is similar to
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md).
The internals differ in that `redcap_read` retrieves subsets of the
data, and then combines them before returning (among other objects) a
single
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).
This function can be more appropriate than
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
when returning large datasets that could tie up the server.

## Usage

``` r
redcap_read(
  batch_size = 100L,
  interbatch_delay = 0.5,
  continue_on_error = FALSE,
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
  guess_max = NULL,
  http_response_encoding = "UTF-8",
  locale = readr::default_locale(),
  verbose = TRUE,
  config_options = NULL,
  handle_httr = NULL,
  id_position = 1L
)
```

## Arguments

- batch_size:

  The maximum number of subject records a single batch should contain.
  The default is 100.

- interbatch_delay:

  The number of seconds the function will wait before requesting a new
  subset from REDCap. The default is 0.5 seconds.

- continue_on_error:

  If an error occurs while reading, should records in subsequent batches
  be attempted. The default is `FALSE`, which prevents subsequent
  batches from running. Required.

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

  A string (either `'raw'` or `'label'` that specifies whether to export
  the raw coded values or the labels for the options of multiple choice
  fields. Default is `'raw'`.

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

  Deprecated.

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

- id_position:

  The column position of the variable that unique identifies the subject
  (typically `record_id`). This defaults to the first variable in the
  dataset.

## Value

Currently, a list is returned with the following elements:

- `data`: A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  of the desired records and columns.

- `success`: A boolean value indicating if the operation was apparently
  successful.

- `status_codes`: A collection of [http status
  codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
  separated by semicolons. There is one code for each batch attempted.

- `outcome_messages`: A collection of human readable strings indicating
  the operations' semicolons. There is one code for each batch
  attempted. In an unsuccessful operation, it should contain diagnostic
  information.

- `records_collapsed`: The desired records IDs, collapsed into a single
  string, separated by commas.

- `fields_collapsed`: The desired field names, collapsed into a single
  string, separated by commas.

- `filter_logic`: The filter statement passed as an argument.

- `elapsed_seconds`: The duration of the function.

If no records are retrieved (such as no records meet the filter
criteria), a zero-row tibble is returned. Currently the empty tibble has
zero columns, but that may change in the future.

## Batching subsets of data

`redcap_read()` internally uses multiple calls to
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
to select and return data. Initially, only the primary key is queried
through the REDCap API. The long list is then subsetted into batches,
whose sizes are determined by the `batch_size` parameter. REDCap is then
queried for all variables of the subset's subjects. This is repeated for
each subset, before returning a unified
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

The function allows a delay between calls, which allows the server to
attend to other users' requests (such as the users entering data in a
browser). In other words, a delay between batches does not bog down the
webserver when exporting/importing a large dataset.

A second benefit is less RAM is required on the webserver. Because each
batch is smaller than the entire dataset, the webserver tackles more
manageably sized objects in memory. Consider batching if you encounter
the error:

    ERROR: REDCap ran out of server memory. The request cannot be processed.
    Please try importing/exporting a smaller amount of data.

A third benefit (compared to `redcap_read()`) is that important fields
are included, even if not explicitly requested. As a result:

1.  `record_id` (or it's customized name) will always be returned

2.  `redcap_event_name` will be returned for longitudinal projects

3.  `redcap_repeat_instrument` and `redcap_repeat_instance` will be
    returned for projects with repeating instruments

## Export permissions

For
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
to function properly, the user must have Export permissions for the
'Full Data Set'. Users with only 'De-Identified' export privileges can
still use `redcap_read_oneshot`. To grant the appropriate permissions:

- go to 'User Rights' in the REDCap project site,

- select the desired user, and then select 'Edit User Privileges',

- in the 'Data Exports' radio buttons, select 'Full Data Set'.

## Pseudofields

The REDCap project may contain "pseudofields", depending on its
structure. Pseudofields are exported for certain project structures, but
are not defined by users and do not appear in the codebook. If a
recognized pseudofield is passed to the `fields` api parameter, it is
suppressed by `redcap_read()` and
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
so the server doesn't throw an error. Requesting a pseudofield is
discouraged, so a message is returned to the user.

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

## Events

The `event` argument is a vector of characters passed to the server. It
is the "event-name", not the "event-label". The event-label is the value
presented to the users, which contains uppercase letters and spaces,
while the event-name can contain only lowercase letters, digits, and
underscores.

If `event` is nonnull and the project is not longitudinal,
`redcap_read()` will throw an error. Similarly, if a value in the
`event` vector is not a current event-name, `redcap_read()` will throw
an error.

The simpler
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
function does not check for invalid event values, and will not throw
errors.

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
token   <- "9A068C425B1341D69E83064A2D273A70"

# Return the entire dataset
REDCapR::redcap_read(batch_size=2, redcap_uri=uri, token=token)$data
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 5 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 5 records  at 2025-12-15 19:47:41.804249.
#> Reading batch 1 of 3, with subjects 1 through 2 (ie, 2 unique subject records).
#> 2 records and 25 columns were read from REDCap in 0.2 seconds.  The http status code was 200.
#> Reading batch 2 of 3, with subjects 3 through 4 (ie, 2 unique subject records).
#> 2 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Reading batch 3 of 3, with subjects 5 through 5 (ie, 1 unique subject records).
#> 1 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 5 × 25
#>   record_id name_first name_last address  telephone email dob          age   sex
#>       <dbl> <chr>      <chr>     <chr>    <chr>     <chr> <date>     <dbl> <dbl>
#> 1         1 Nutmeg     Nutmouse  "14 Ros… (405) 32… nutt… 2003-08-30    11     0
#> 2         2 Tumtum     Nutmouse  "14 Ros… (405) 32… tumm… 2003-03-10    11     1
#> 3         3 Marcus     Wood      "243 Hi… (405) 32… mw@m… 1934-04-09    80     1
#> 4         4 Trudy      DAG       "342 El… (405) 32… pero… 1952-11-02    61     0
#> 5         5 John Lee   Walker    "Hotel … (405) 32… left… 1955-04-15    59     1
#> # ℹ 16 more variables: demographics_complete <dbl>, height <dbl>, weight <dbl>,
#> #   bmi <dbl>, comments <chr>, mugshot <chr>, health_complete <dbl>,
#> #   race___1 <dbl>, race___2 <dbl>, race___3 <dbl>, race___4 <dbl>,
#> #   race___5 <dbl>, race___6 <dbl>, ethnicity <dbl>, interpreter_needed <dbl>,
#> #   race_and_ethnicity_complete <dbl>

# Return a subset of columns while also specifying the column types.
col_types <- readr::cols(
  record_id  = readr::col_integer(),
  race___1   = readr::col_logical(),
  race___2   = readr::col_logical(),
  race___3   = readr::col_logical(),
  race___4   = readr::col_logical(),
  race___5   = readr::col_logical(),
  race___6   = readr::col_logical()
)
REDCapR::redcap_read(
  redcap_uri = uri,
  token      = token,
  col_types  = col_types,
  batch_size = 2
)$data
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 5 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 5 records  at 2025-12-15 19:47:44.661025.
#> Reading batch 1 of 3, with subjects 1 through 2 (ie, 2 unique subject records).
#> 2 records and 25 columns were read from REDCap in 0.2 seconds.  The http status code was 200.
#> Reading batch 2 of 3, with subjects 3 through 4 (ie, 2 unique subject records).
#> 2 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Reading batch 3 of 3, with subjects 5 through 5 (ie, 1 unique subject records).
#> 1 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 5 × 25
#>   record_id name_first name_last address  telephone email dob          age   sex
#>       <int> <chr>      <chr>     <chr>    <chr>     <chr> <date>     <dbl> <dbl>
#> 1         1 Nutmeg     Nutmouse  "14 Ros… (405) 32… nutt… 2003-08-30    11     0
#> 2         2 Tumtum     Nutmouse  "14 Ros… (405) 32… tumm… 2003-03-10    11     1
#> 3         3 Marcus     Wood      "243 Hi… (405) 32… mw@m… 1934-04-09    80     1
#> 4         4 Trudy      DAG       "342 El… (405) 32… pero… 1952-11-02    61     0
#> 5         5 John Lee   Walker    "Hotel … (405) 32… left… 1955-04-15    59     1
#> # ℹ 16 more variables: demographics_complete <dbl>, height <dbl>, weight <dbl>,
#> #   bmi <dbl>, comments <chr>, mugshot <chr>, health_complete <dbl>,
#> #   race___1 <lgl>, race___2 <lgl>, race___3 <lgl>, race___4 <lgl>,
#> #   race___5 <lgl>, race___6 <lgl>, ethnicity <dbl>, interpreter_needed <dbl>,
#> #   race_and_ethnicity_complete <dbl>
# }
```
