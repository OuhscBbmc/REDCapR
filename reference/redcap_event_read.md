# Export Events

Export Events of a REDCap project

## Usage

``` r
redcap_event_read(
  redcap_uri,
  token,
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

- `data`: a
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with one row per arm-event combination. The columns are `event_name`
  (a human-friendly string), `arm_num` (an integer), `unique_event_name`
  (a string), `custom_event_label` (a string), and `event_id` (an
  integer).

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

Ezra Porter, Will Beasley

## Examples

``` r
# \dontrun{
uri            <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

# Query a longitudinal project with a single arm and 3 events
token_1  <- "76B4A71A0158BD34C98F10DA72D5F27C" # arm-single-longitudinal
result_1 <- REDCapR::redcap_event_read(redcap_uri=uri, token=token_1)
#> The list of events was retrieved from the REDCap project in 0.1 seconds. The http status code was 200.
result_1$data
#> # A tibble: 3 × 5
#>   event_name arm_num unique_event_name custom_event_label event_id
#>   <chr>        <int> <chr>             <chr>                 <int>
#> 1 Intake           1 intake_arm_1      NA                       95
#> 2 Dischage         1 dischage_arm_1    NA                       96
#> 3 Follow up        1 follow_up_arm_1   NA                       97

# Query a longitudinal project with 2 arms and complex arm-event mappings
token_2  <- "DA6F2BB23146BD5A7EA3408C1A44A556" # longitudinal
result_2 <- REDCapR::redcap_event_read(redcap_uri=uri, token=token_2)
#> The list of events was retrieved from the REDCap project in 0.1 seconds. The http status code was 200.
result_2$data
#> # A tibble: 12 × 5
#>    event_name              arm_num unique_event_name custom_event_label event_id
#>    <chr>                     <int> <chr>             <chr>                 <int>
#>  1 Enrollment                    1 enrollment_arm_1  NA                       61
#>  2 Dose 1                        1 dose_1_arm_1      NA                       62
#>  3 Visit 1                       1 visit_1_arm_1     NA                       63
#>  4 Dose 2                        1 dose_2_arm_1      NA                       64
#>  5 Visit 2                       1 visit_2_arm_1     NA                       65
#>  6 Final visit                   1 final_visit_arm_1 NA                       66
#>  7 Enrollment                    2 enrollment_arm_2  NA                       67
#>  8 Deadline to opt out of…       2 deadline_to_opt_… NA                       68
#>  9 First dose                    2 first_dose_arm_2  NA                       69
#> 10 First visit                   2 first_visit_arm_2 NA                       70
#> 11 Final visit                   2 final_visit_arm_2 NA                       71
#> 12 Deadline to return fee…       2 deadline_to_retu… NA                       72

# Query a classic project without events
token_3  <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write
result_3 <- REDCapR::redcap_event_read(redcap_uri=uri, token=token_3)
#> A 'classic' REDCap project has no events.  Retrieved in 0.1 seconds. The http status code was 400.
result_3$data
#> # A tibble: 0 × 5
#> # ℹ 5 variables: event_name <chr>, arm_num <int>, unique_event_name <chr>,
#> #   custom_event_label <chr>, event_id <int>
# }
```
