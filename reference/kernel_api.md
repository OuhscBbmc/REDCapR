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
if (FALSE) { # \dontrun{
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
read.csv(text = kernel$raw_text)
as.list(read.csv(text = kernel$raw_text))
} # }
```
