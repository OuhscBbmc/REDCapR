# Export project information.

This function exports some of the basic attributes of a given REDCap
project, such as the project's title, if it is longitudinal, if surveys
are enabled, the time the project was created and moved to production.
Returns a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## Usage

``` r
redcap_project_info_read(
  redcap_uri,
  token,
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

- `data`: An R
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  of all data access groups of the project.

- `success`: A boolean value indicating if the operation was apparently
  successful.

- `status_codes`: A collection of [http status
  codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
  separated by semicolons. There is one code for each batch attempted.

- `outcome_messages`: A collection of human readable strings indicating
  the operations' semicolons. There is one code for each batch
  attempted. In an unsuccessful operation, it should contain diagnostic
  information.

- `elapsed_seconds`: The duration of the function.

## Details

**Timezones**

Several datetime variables are returned, such as the project's
`creation_time`. For the time to be meaningful, you'll need to set the
time zone because this function uses
[`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html),
which assigns
[UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) if no
timezone is specified. Find your server's location listed in
[`base::OlsonNames()`](https://rdrr.io/r/base/timezones.html), and pass
it to readr's
[`readr::locale()`](https://readr.tidyverse.org/reference/locale.html)
function, and then pass that to `redcap_project_info_read()`. See the
examples below

For more timezone details see the
[Timezones](https://readr.tidyverse.org/articles/locales.html#timezones)
section of readr's
[locales](https://readr.tidyverse.org/articles/locales.html) vignette.

**Columns not yet added** This function casts columns into data types
that we think are most natural to use. For example, `in_production` is
cast from a 0/1 to a boolean TRUE/FALSE. All columns not (yet)
recognized by REDCapR will be still be returned to the client, but cast
as a character. If the REDCap API adds a new column in the future,
please alert us in a [REDCapR
issue](https://github.com/OuhscBbmc/REDCapR/issues) and we'll expand the
casting specifications.

**External Modules**

A project's `external_modules` cell contains all its approved EMs,
separated by a column. Consider using a function like
[`tidyr::separate_rows()`](https://tidyr.tidyverse.org/reference/separate_rows.html)
to create a long data structure.

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (*i.e.*,
https://community.projectredcap.org/articles/456/api-documentation.html
and https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus
REDCap administrator to send you the static material.

## Author

Will Beasley, Stephan Kadauke

## Examples

``` r
# \dontrun{
# Specify your project uri and token(s).
uri                  <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token_simple         <- "9A068C425B1341D69E83064A2D273A70"
token_longitudinal   <- "DA6F2BB23146BD5A7EA3408C1A44A556"

# ---- Simple examples
REDCapR::redcap_project_info_read(uri, token_simple      )$data
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 1 × 26
#>   project_id project_title creation_time       production_time in_production
#>        <int> <chr>         <dttm>              <dttm>          <lgl>        
#> 1         33 REDCapR: sim… 2024-10-10 20:21:18 NA              FALSE        
#> # ℹ 21 more variables: project_language <chr>, purpose <int>,
#> #   purpose_other <chr>, project_notes <chr>, custom_record_label <chr>,
#> #   secondary_unique_field <chr>, is_longitudinal <lgl>,
#> #   has_repeating_instruments_or_events <lgl>, surveys_enabled <lgl>,
#> #   scheduling_enabled <lgl>, record_autonumbering_enabled <lgl>,
#> #   randomization_enabled <lgl>, ddp_enabled <lgl>, project_irb_number <chr>,
#> #   project_grant_number <chr>, project_pi_firstname <chr>, …
REDCapR::redcap_project_info_read(uri, token_longitudinal)$data
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 1 × 26
#>   project_id project_title creation_time       production_time in_production
#>        <int> <chr>         <dttm>              <dttm>          <lgl>        
#> 1         34 REDCapR: lon… 2024-10-10 20:40:17 NA              FALSE        
#> # ℹ 21 more variables: project_language <chr>, purpose <int>,
#> #   purpose_other <chr>, project_notes <chr>, custom_record_label <chr>,
#> #   secondary_unique_field <chr>, is_longitudinal <lgl>,
#> #   has_repeating_instruments_or_events <lgl>, surveys_enabled <lgl>,
#> #   scheduling_enabled <lgl>, record_autonumbering_enabled <lgl>,
#> #   randomization_enabled <lgl>, ddp_enabled <lgl>, project_irb_number <chr>,
#> #   project_grant_number <chr>, project_pi_firstname <chr>, …

# ---- Specify timezone
# Specify the server's timezone, for example, US Central
server_locale <- readr::locale(tz = "America/Chicago")
d3 <-
  REDCapR::redcap_project_info_read(
    uri,
    token_simple,
    locale     = server_locale
  )$data
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
d3$creation_time
#> [1] "2024-10-10 20:21:18 CDT"

# Alternatively, set timezone to the client's location.
client_locale <- readr::locale(tz = Sys.timezone())

# ---- Inspect multiple projects in the same tibble
# Stack all the projects on top of each other in a (nested) tibble,
#   starting from a csv of REDCapR test projects.
# The native pipes in this snippet require R 4.1+.
d_all <-
  system.file("misc/dev-2.credentials", package = "REDCapR") %>%
  readr::read_csv(
    comment     = "#",
    col_select  = c(redcap_uri, token),
    col_types   = readr::cols(.default = readr::col_character())
  ) %>%
  dplyr::filter(32L == nchar(token)) %>%
  purrr::pmap_dfr(REDCapR::redcap_project_info_read, locale = server_locale)
#> Error in system.file("misc/dev-2.credentials", package = "REDCapR") %>%     readr::read_csv(comment = "#", col_select = c(redcap_uri,         token), col_types = readr::cols(.default = readr::col_character())) %>%     dplyr::filter(32L == nchar(token)) %>% purrr::pmap_dfr(REDCapR::redcap_project_info_read,     locale = server_locale): could not find function "%>%"

# Inspect values stored on the server.
d_all$data
#> Error: object 'd_all' not found
# or: View(d_all$data)

# Inspect everything returned, including values like the http status code.
d_all
#> Error: object 'd_all' not found
# }
```
