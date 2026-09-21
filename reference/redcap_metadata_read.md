# Export the metadata of a REDCap project

Export the metadata (as a data dictionary) of a REDCap project as a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).
Each row in the data dictionary corresponds to one field in the
project's dataset.

## Usage

``` r
redcap_metadata_read(
  redcap_uri,
  token,
  forms = NULL,
  fields = NULL,
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

- forms:

  An array, where each element corresponds to the REDCap form of the
  desired fields. Optional.

- fields:

  An array, where each element corresponds to a desired project field.
  Optional.

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
  of the desired fields (as rows).

- `success`: A boolean value indicating if the operation was apparently
  successful.

- `status_codes`: A collection of [http status
  codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
  separated by semicolons. There is one code for each batch attempted.

- `outcome_messages`: A collection of human readable strings indicating
  the operations' semicolons. There is one code for each batch
  attempted. In an unsuccessful operation, it should contain diagnostic
  information.

- `forms_collapsed`: The desired records IDs, collapsed into a single
  string, separated by commas.

- `fields_collapsed`: The desired field names, collapsed into a single
  string, separated by commas.

- `elapsed_seconds`: The duration of the function.

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (*i.e.*,
<https://redcap.vumc.org/community/post.php?id=456> and
<https://redcap.vumc.org/community/post.php?id=462> ). If you do not
have an account for the wiki, please ask your campus REDCap
administrator to send you the static material.

## Author

Will Beasley

## Examples

``` r
if (FALSE) { # \dontrun{
uri   <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

# A simple project
token <- "9A068C425B1341D69E83064A2D273A70" # simple
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)

# A longitudinal project
token <- "0434F0E9CF53ED0587847AB6E51DE762" # longitudinal
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)

# A repeating measures
token <- "77842BD8C18D3408819A21DD0154CCF4" # vignette-repeating
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)
} # }
```
