# Enumerate the instruments to event mappings

Export the instrument-event mappings for a project (i.e., how the data
collection instruments are designated for certain events in a
longitudinal project). (Copied from "Export Instrument-Event Mappings"
method of REDCap API documentation, v.10.5.1)

## Usage

``` r
redcap_event_instruments(
  redcap_uri,
  token,
  arms = NULL,
  delimiter = ",",
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

- arms:

  A character string of arms to retrieve. Defaults to all arms of the
  project.

- delimiter:

  A single-character value passed to the `delim` parameter of
  [`readr::read_delim()`](https://readr.tidyverse.org/reference/read_delim.html).
  Options include:

  1.  `,` (a comma, the default),

  2.  `;` (a semi-colon),

  3.  `|` (a pipe),

  4.  `^` (a caret), or

  5.  `\t` (a tab).

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
  where each row represents one column in the REDCap dataset.

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

## See also

[`redcap_instruments()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_instruments.md)

## Author

Victor Castro, Will Beasley

## Examples

``` r
if (FALSE) { # \dontrun{
uri                 <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

# Longitudinal project with one arm
token_1  <- "76B4A71A0158BD34C98F10DA72D5F27C" # "arm-single-longitudinal" test project
REDCapR::redcap_arm_export(redcap_uri=uri, token=token_1)$data
REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_1)$data

# Project with two arms
token_2  <- "DA6F2BB23146BD5A7EA3408C1A44A556" # "longitudinal" test project
REDCapR::redcap_arm_export(redcap_uri=uri, token=token_2)$data
REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_2)$data
REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_2, arms = c("1", "2"))$data
REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_2, arms = "2")$data

# Classic project (without arms) throws an error
token_3  <- "9A068C425B1341D69E83064A2D273A70" # "simple" test project
REDCapR::redcap_arm_export(redcap_uri=uri, token=token_3)$data
# REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_3)$data
} # }
```
