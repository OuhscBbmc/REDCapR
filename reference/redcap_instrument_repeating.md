# Enumerate repeating instruments and events

This method allows you to export a list of the repeated instruments and
repeating events for a project. This includes their unique instrument
name as seen in the second column of the Data Dictionary, as well as
each repeating instrument's corresponding custom repeating instrument
label. For longitudinal projects, the unique event name is also returned
for each repeating instrument. Additionally, repeating events are
returned as separate items, in which the instrument name will be
blank/null to indicate that it is a repeating event (rather than a
repeating instrument). (Copied from "Export Repeating Instruments and
Events" method of REDCap API documentation, v.16.0.4)

## Usage

``` r
redcap_instrument_repeating(
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

Currently, a list is returned with the following elements,

- `data`: A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  where each row represents one repeating instrument-event combination
  in the REDCap project.

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
<https://redcap.vumc.org/community/post.php?id=456> and
<https://redcap.vumc.org/community/post.php?id=462> ). If you do not
have an account for the wiki, please ask your campus REDCap
administrator to send you the static material.

## Author

Ezra Porter

## Examples

``` r
# \dontrun{
uri                 <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

# Repeating events project
token_1  <- "FEF7A22B52E6B9942AFF7A28C426C871" # "vignette-repeating" test project
token_1  <- "22C3FF1C8B08899FB6F86D91D874A159" # vignette-repeating production
REDCapR::redcap_instrument_repeating(redcap_uri=uri, token=token_1)$data
#> The REDCapR repeating event-instrument retrieval was not successful.  The error message was:
#> ERROR: You do not have permissions to use the API
#> # A tibble: 0 × 0

# Classic project (without repeating instruments) throws an error
token_2  <- "9A068C425B1341D69E83064A2D273A70" # "simple" test project
token_2  <- "9A81268476645C4E5F03428B8AC3AA7B" # "simple" test project production
# Throws an error REDCapR::redcap_instrument_repeating(redcap_uri=uri, token=token_2)$data
# }
```
