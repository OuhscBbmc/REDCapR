# Write/Import records to a REDCap project

This function uses REDCap's APIs to select and return data.

## Usage

``` r
redcap_write(
  ds_to_write,
  batch_size = 100L,
  interbatch_delay = 0.5,
  continue_on_error = FALSE,
  redcap_uri,
  token,
  overwrite_with_blanks = TRUE,
  convert_logical_to_integer = FALSE,
  verbose = TRUE,
  config_options = NULL,
  handle_httr = NULL
)
```

## Arguments

- ds_to_write:

  The [`base::data.frame()`](https://rdrr.io/r/base/data.frame.html) or
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  to be imported into the REDCap project. Required.

- batch_size:

  The maximum number of subject records a single batch should contain.
  The default is 100.

- interbatch_delay:

  The number of seconds the function will wait before requesting a new
  subset from REDCap. The default is 0.5 seconds.

- continue_on_error:

  If an error occurs while writing, should records in subsequent batches
  be attempted. The default is `FALSE`, which prevents subsequent
  batches from running. Required.

- redcap_uri:

  The
  [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
  of the REDCap server typically formatted as
  "https://server.org/apps/redcap/api/". Required.

- token:

  The user-specific string that serves as the password for a project.
  Required.

- overwrite_with_blanks:

  A boolean value indicating if blank/`NA` values in the R data frame
  will overwrite data on the server. This is the default behavior for
  REDCapR, which essentially deletes the cell's value If `FALSE`,
  blank/`NA` values in the data.frame will be ignored. Optional.

- convert_logical_to_integer:

  If `TRUE`, all [base::logical](https://rdrr.io/r/base/logical.html)
  columns in `ds` are cast to an integer before uploading to REDCap.
  Boolean values are typically represented as 0/1 in REDCap radio
  buttons. Optional.

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

- `records_affected_count`: The number of records inserted or updated.

- `affected_ids`: The subject IDs of the inserted or updated records.

- `elapsed_seconds`: The duration of the function.

## Details

Currently, the function doesn't modify any variable types to conform to
REDCap's supported variables. See
[`validate_for_write()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
for a helper function that checks for some common important conflicts.

For `redcap_write` to function properly, the user must have Export
permissions for the 'Full Data Set'. Users with only 'De-Identified'
export privileges can still use
[`redcap_write_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write_oneshot.md).
To grant the appropriate permissions:

- go to 'User Rights' in the REDCap project site,

- select the desired user, and then select 'Edit User Privileges',

- in the 'Data Exports' radio buttons, select 'Full Data Set'.

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
if (FALSE) {
# Define some constants
uri           <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token         <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write

# Read the dataset for the first time.
result_read1  <- REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token)
ds1           <- result_read1$data
ds1$telephone

# Manipulate a field in the dataset in a VALID way
ds1$telephone <- paste0("(405) 321-000", seq_len(nrow(ds1)))

ds1 <- ds1[1:3, ]
ds1$age       <- NULL; ds1$bmi <- NULL # Drop the calculated fields before writing.
result_write  <- REDCapR::redcap_write(ds1, redcap_uri=uri, token=token)

# Read the dataset for the second time.
result_read2  <- REDCapR::redcap_read_oneshot(redcap_uri=uri, token=token)
ds2           <- result_read2$data
ds2$telephone

# Manipulate a field in the dataset in an INVALID way.  A US exchange can't be '111'.
ds1$telephone <- paste0("(405) 321-000", seq_len(nrow(ds1)))

# This next line will throw an error.
result_write <- REDCapR::redcap_write(ds1, redcap_uri=uri, token=token)
result_write$raw_text
}
```
