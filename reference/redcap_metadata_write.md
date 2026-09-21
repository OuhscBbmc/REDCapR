# Import metadata of a REDCap project

Import metadata (*i.e.*, data dictionary) into a project. Because of
this method's destructive nature, it works for only projects in
Development status.

## Usage

``` r
redcap_metadata_write(
  ds,
  redcap_uri,
  token,
  verbose = TRUE,
  config_options = NULL,
  handle_httr = NULL
)
```

## Arguments

- ds:

  The [`base::data.frame()`](https://rdrr.io/r/base/data.frame.html) or
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  to be imported into the REDCap project. Required.

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

- `success`: A boolean value indicating if the operation was apparently
  successful.

- `status_code`: The [http status
  code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the
  operation.

- `outcome_message`: A human readable string indicating the operation's
  outcome.

- `field_count`: Number of fields imported.

- `elapsed_seconds`: The duration of the function.

- `raw_text`: If an operation is NOT successful, the text returned by
  REDCap. If an operation is successful, the `raw_text` is returned as
  an empty string to save RAM.

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki. If you do not have an account for
the wiki, please ask your campus REDCap administrator to send you the
static material.

## Author

Will Beasley

## Examples

``` r
if (FALSE) { # \dontrun{
# Please don't run this example without changing the token to
# point to your server.  It could interfere with our testing suite.
uri            <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token          <- "06C38F6D76B3863DFAE84069D8DBCFFC" # metadata-write

# Read in the dictionary in R's memory from a csv file.
ds_to_write <-
  readr::read_csv(
    file = system.file(
      "test-data/projects/simple/metadata.csv",
      package = "REDCapR"
    ),
    col_types = readr::cols(.default = readr::col_character())
  )
ds_to_write

# Import the dictionary into the REDCap project
REDCapR::redcap_metadata_write(
  ds          = ds_to_write,
  redcap_uri  = uri,
  token       = token
)
} # }
```
