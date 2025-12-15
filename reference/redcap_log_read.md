# Get the logging of a project.

This function reads the available logging messages from REDCap as a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## Usage

``` r
redcap_log_read(
  redcap_uri,
  token,
  log_begin_date = Sys.Date() - 7L,
  log_end_date = Sys.Date(),
  record = NULL,
  user = NULL,
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

- log_begin_date:

  Return the events occurring after midnight of this date. Defaults to
  the past week; this default mimics the behavior in the browser and
  also reduces the strain on your server.

- log_end_date:

  Return the events occurring before 24:00 of this date. Defaults to
  today.

- record:

  Return the events belonging only to specific record (referring to an
  existing record name). Defaults to `NULL` which returns logging
  activity related to all records. If a record value passed, it must be
  a single value.

- user:

  Return the events belonging only to specific user (referring to an
  existing username). Defaults to `NULL` which returns logging activity
  related to all users. If a user value passed, it must be a single
  value.

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

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (*i.e.*,
https://community.projectredcap.org/articles/456/api-documentation.html
and https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus
REDCap administrator to send you the static material.

## Author

Jonathan M. Mang, Will Beasley

## Examples

``` r
# \dontrun{
uri          <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token        <- "9A068C425B1341D69E83064A2D273A70"

ds_last_week <- REDCapR::redcap_log_read(redcap_uri=uri, token=token)$data
#> 2,091 rows were read from REDCap in 0.2 seconds.  The http status code was 200.
head(ds_last_week)
#> # A tibble: 6 × 5
#>   timestamp           username        action        details               record
#>   <dttm>              <chr>           <chr>         <chr>                 <chr> 
#> 1 2025-12-15 13:47:00 unittestphifree Manage/Design Export instruments (… NA    
#> 2 2025-12-15 13:47:00 unittestphifree Manage/Design Export DAGs (API)     NA    
#> 3 2025-12-15 13:47:00 unittestphifree Manage/Design Download data dictio… NA    
#> 4 2025-12-15 13:47:00 unittestphifree Manage/Design Export project infor… NA    
#> 5 2025-12-15 09:33:00 unittestphifree NA            NA                    NA    
#> 6 2025-12-15 09:33:00 unittestphifree NA            NA                    NA    

ds_one_day <-
  REDCapR::redcap_log_read(
    redcap_uri     = uri,
    token          = token,
    log_begin_date = as.Date("2024-10-11"),
    log_end_date   = as.Date("2024-10-11")
  )$data
#> 18 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
head(ds_one_day)
#> # A tibble: 6 × 5
#>   timestamp           username        action        details              record
#>   <dttm>              <chr>           <chr>         <chr>                <chr> 
#> 1 2024-10-11 10:44:00 unittestphifree Manage/Design Export Logging (API) NA    
#> 2 2024-10-11 10:43:00 unittestphifree Manage/Design Export Logging (API) NA    
#> 3 2024-10-11 10:43:00 unittestphifree Manage/Design Export Logging (API) NA    
#> 4 2024-10-11 10:42:00 unittestphifree Manage/Design Export Logging (API) NA    
#> 5 2024-10-11 10:42:00 unittestphifree Manage/Design Export Logging (API) NA    
#> 6 2024-10-11 10:41:00 unittestphifree Manage/Design Export Logging (API) NA    

ds_one_day_single_record <-
  REDCapR::redcap_log_read(
    redcap_uri     = uri,
    token          = token,
    log_begin_date = as.Date("2024-10-10"),
    log_end_date   = as.Date("2024-10-10"),
    record         = as.character(3),
    # user           = "unittestphifree"
  )$data
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
head(ds_one_day_single_record)
#> # A tibble: 1 × 5
#>   timestamp           username    action          details      record
#>   <dttm>              <chr>       <chr>           <chr>        <chr> 
#> 1 2024-10-10 20:26:00 itawilliamb Update record 3 bmi = '24.7' 3     
# }
```
