# REDCapR internal function for calling the REDCap API

This function is used by other functions to read and write values.

## Usage

``` r
kernel_api(
  redcap_uri,
  post_body,
  config_options,
  encoding = "UTF-8",
  content_type = "text/csv",
  handle_httr = NULL,
  encode_httr = "form"
)
```

## Arguments

- redcap_uri:

  The
  [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
  of the REDCap server typically formatted as
  "https://server.org/apps/redcap/api/". Required.

- post_body:

  List of contents expected by the REDCap API. Required.

- config_options:

  A list of options passed to
  [`httr::POST()`](https://httr.r-lib.org/reference/POST.html). See
  details at
  [`httr::httr_options()`](https://httr.r-lib.org/reference/httr_options.html).
  Optional.

- encoding:

  The encoding value passed to
  [`httr::content()`](https://httr.r-lib.org/reference/content.html).
  Defaults to 'UTF-8'.

- content_type:

  The MIME value passed to
  [`httr::content()`](https://httr.r-lib.org/reference/content.html).
  Defaults to 'text/csv'.

- handle_httr:

  The value passed to the `handle` parameter of
  [`httr::POST()`](https://httr.r-lib.org/reference/POST.html). This is
  useful for only unconventional authentication approaches. It should be
  `NULL` for most institutions.

- encode_httr:

  The value passed to the `encode` parameter of
  [`httr::POST()`](https://httr.r-lib.org/reference/POST.html). Defaults
  to `"form"`, which is appropriate for most actions. (Currently, the
  only exception is importing a file, which uses "multipart".)

## Value

A
[utils::packageVersion](https://rdrr.io/r/utils/packageDescription.html).

## Details

If the API call is unsuccessful, a value of
`base::package_version("0.0.0")` will be returned. This ensures that a
the function will always return an object of class
[base::package_version](https://rdrr.io/r/base/numeric_version.html). It
guarantees the value can always be used in
[`utils::compareVersion()`](https://rdrr.io/r/utils/compareVersion.html).

## Examples

``` r
# \dontrun{
uri            <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token          <- "9A068C425B1341D69E83064A2D273A70"

config_options <- NULL
post_body      <- list(
  token    = token,
  content  = "project",
  format   = "csv"
)
kernel <- REDCapR:::kernel_api(uri, post_body, config_options)

# Consume the results in a few different ways.
kernel$result
#> Response [https://redcap-dev-2.ouhsc.edu/redcap/api/]
#>   Date: 2025-12-15 19:47
#>   Status: 200
#>   Content-Type: text/csv; charset=utf-8
#>   Size: 590 B
#> project_id,project_title,creation_time,production_time,in_production,project_...
#> 33,"REDCapR: simple","2024-10-10 20:21:18",,0,English,4,,,,,0,0,0,0,1,0,0,,,,...
read.csv(text = kernel$raw_text)
#>   project_id   project_title       creation_time production_time in_production
#> 1         33 REDCapR: simple 2024-10-10 20:21:18              NA             0
#>   project_language purpose purpose_other project_notes custom_record_label
#> 1          English       4            NA            NA                  NA
#>   secondary_unique_field is_longitudinal has_repeating_instruments_or_events
#> 1                     NA               0                                   0
#>   surveys_enabled scheduling_enabled record_autonumbering_enabled
#> 1               0                  0                            1
#>   randomization_enabled ddp_enabled project_irb_number project_grant_number
#> 1                     0           0                 NA                   NA
#>   project_pi_firstname project_pi_lastname display_today_now_button
#> 1                   NA                  NA                        1
#>   missing_data_codes external_modules bypass_branching_erase_field_prompt
#> 1                 NA    redcap_entity                                   0
as.list(read.csv(text = kernel$raw_text))
#> $project_id
#> [1] 33
#> 
#> $project_title
#> [1] "REDCapR: simple"
#> 
#> $creation_time
#> [1] "2024-10-10 20:21:18"
#> 
#> $production_time
#> [1] NA
#> 
#> $in_production
#> [1] 0
#> 
#> $project_language
#> [1] "English"
#> 
#> $purpose
#> [1] 4
#> 
#> $purpose_other
#> [1] NA
#> 
#> $project_notes
#> [1] NA
#> 
#> $custom_record_label
#> [1] NA
#> 
#> $secondary_unique_field
#> [1] NA
#> 
#> $is_longitudinal
#> [1] 0
#> 
#> $has_repeating_instruments_or_events
#> [1] 0
#> 
#> $surveys_enabled
#> [1] 0
#> 
#> $scheduling_enabled
#> [1] 0
#> 
#> $record_autonumbering_enabled
#> [1] 1
#> 
#> $randomization_enabled
#> [1] 0
#> 
#> $ddp_enabled
#> [1] 0
#> 
#> $project_irb_number
#> [1] NA
#> 
#> $project_grant_number
#> [1] NA
#> 
#> $project_pi_firstname
#> [1] NA
#> 
#> $project_pi_lastname
#> [1] NA
#> 
#> $display_today_now_button
#> [1] 1
#> 
#> $missing_data_codes
#> [1] NA
#> 
#> $external_modules
#> [1] "redcap_entity"
#> 
#> $bypass_branching_erase_field_prompt
#> [1] 0
#> 
# }
```
