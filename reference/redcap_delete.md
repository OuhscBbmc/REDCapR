# Delete records in a REDCap project

Delete existing records by their ID from REDCap.

## Usage

``` r
redcap_delete(
  redcap_uri,
  token,
  records_to_delete,
  arm_of_records_to_delete = NULL,
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

- records_to_delete:

  A character vector of the project's `record_id` values to delete.
  Required.

- arm_of_records_to_delete:

  A single integer reflecting the arm containing the records to be
  deleted. Leave it as NULL if the project has no arms and is not
  longitudinal. Required if the REDCap project has arms. See Details
  below.

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

- `elapsed_seconds`: The duration of the function.

- `raw_text`: If an operation is NOT successful, the text returned by
  REDCap. If an operation is successful, the `raw_text` is returned as
  an empty string to save RAM.

## Details

REDCap requires that at least one `record_id` value be passed to the
delete call.

When the project has arms, REDCapR has stricter requirements than
REDCap. If the REDCap project has arms, a value must be passed to
`arm_of_records_to_delete`. This is a different behavior than calling
the server through cURL –which if no arm number is specified, then all
arms are cleared of the specified `record_id`s.

Note that all longitudinal projects technically have arms, even if only
one arm is defined. Therefore a value of `arm_number` must be specified
for all longitudinal projects.

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (*i.e.*,
https://community.projectredcap.org/articles/456/api-documentation.html
and https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus
REDCap administrator to send you the static material.

## Author

Jonathan Mang, Will Beasley

## Examples

``` r
if (FALSE) {
records_to_delete <- c(102, 103, 105, 120)

# Deleting from a non-longitudinal project with no defined arms:
REDCapR::redcap_delete(
  redcap_uri               = uri,
  token                    = token,
  records_to_delete        = records_to_delete,
)

# Deleting from a project that has arms or is longitudinal:
arm_number <- 2L # Not the arm name
REDCapR::redcap_delete(
  redcap_uri               = uri,
  token                    = token,
  records_to_delete        = records_to_delete,
  arm_of_records_to_delete = arm_number
)
}
```
