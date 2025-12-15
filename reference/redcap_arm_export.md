# Export Arms

Export Arms of a REDCap project

## Usage

``` r
redcap_arm_export(
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

- `has_arms`: a `logical` value indicating if the REDCap project has
  arms (*i.e.*, "TRUE") or is a classic non-longitudinal project
  (*i.e.*, "FALSE").

- `data`: a
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  with one row per arm. The columns are `arm_number` (an integer) and
  `arm_name` (a human-friendly string).

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
uri            <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

# Query a classic project with 3 arms
token_1  <- "14817611F9EA1A6E149BBDC37134E8EA" # arm-multiple-delete
result_1 <- REDCapR::redcap_arm_export(redcap_uri=uri, token=token_1)
#> The list of arms was retrieved from the REDCap project in 0.1 seconds. The http status code was 200.
result_1$has_arms
#> [1] TRUE
result_1$data
#> # A tibble: 3 × 2
#>   arm_number arm_name
#>        <int> <chr>   
#> 1          1 Arm 1   
#> 2          2 Arm 2   
#> 3          3 Arm 3   

# Query a classic project without arms
token_2  <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write
result_2 <- REDCapR::redcap_arm_export(redcap_uri=uri, token=token_2)
#> A 'classic' REDCap project has no arms.  Retrieved in 0.1 seconds. The http status code was 400.
result_2$has_arms
#> [1] FALSE
result_2$data
#> # A tibble: 0 × 2
#> # ℹ 2 variables: arm_number <int>, arm_name <chr>
# }
```
