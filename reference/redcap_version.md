# Determine version of REDCap instance

This function uses REDCap's API to query its version.

## Usage

``` r
redcap_version(
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

a
[utils::packageDescription](https://rdrr.io/r/utils/packageDescription.html)

## Details

If the API call is unsuccessful, a value of
`base::package_version("0.0.0")` will be returned. This ensures that a
the function will always return an object of class
[base::numeric_version](https://rdrr.io/r/base/numeric_version.html). It
guarantees the value can always be used in
[`utils::compareVersion()`](https://rdrr.io/r/utils/compareVersion.html).

## Examples

``` r
# \dontrun{
uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token    <- "9A068C425B1341D69E83064A2D273A70"

REDCapR::redcap_version(redcap_uri = uri, token = token)
#> The REDCap version was successfully determined in 0.1 seconds. The http status code was 200.  Is is 15.2.0.
#> [1] ‘15.2.0’
# }
```
