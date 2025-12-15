# Upload a file into to a REDCap project record

This function uses REDCap's API to upload a file.

## Usage

``` r
redcap_file_upload_oneshot(
  file_name,
  record,
  redcap_uri,
  token,
  field,
  event = "",
  verbose = TRUE,
  config_options = NULL,
  handle_httr = NULL
)
```

## Arguments

- file_name:

  The name of the relative or full file to be uploaded into the REDCap
  project. Required.

- record:

  The record ID where the file is to be imported. Required

- redcap_uri:

  The
  [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
  of the REDCap server typically formatted as
  "https://server.org/apps/redcap/api/". Required.

- token:

  The user-specific string that serves as the password for a project.
  Required.

- field:

  The name of the field where the file is saved in REDCap. Required

- event:

  The name of the event where the file is saved in REDCap. Optional

- verbose:

  A boolean value indicating if `message`s should be printed to the R
  console during the operation. Optional.

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

- `raw_text`: If an operation is NOT successful, the text returned by
  REDCap. If an operation is successful, the `raw_text` is returned as
  an empty string to save RAM.

## Details

Currently, the function doesn't modify any variable types to conform to
REDCap's supported variables. See
[`validate_for_write()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
for a helper function that checks for some common important conflicts.

The function `redcap_upload_file_oneshot()` is soft-deprecated as of
REDCapR 1.2.0. Please rename to `redcap_file_upload_oneshot()`.

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (ie,
https://community.projectredcap.org/articles/456/api-documentation.html
and https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus
REDCap administrator to send you the static material.

## Author

Will Beasley, John J. Aponte

## Examples

``` r
# \dontrun{
# Define some constants
uri    <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token  <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write

field  <- "mugshot"
event  <- "" # only for longitudinal events

# Upload a single image file.
record    <- 1
file_path <- system.file("test-data/mugshot-1.jpg", package = "REDCapR")

REDCapR::redcap_file_upload_oneshot(
  file_name  = file_path,
  record     = record,
  field      = field,
  redcap_uri = uri,
  token      = token
)
#> Preparing to upload the file `/Users/runner/work/_temp/Library/REDCapR/test-data/mugshot-1.jpg`.
#> file uploaded to REDCap in 0.2 seconds.
#> $success
#> [1] TRUE
#> 
#> $status_code
#> [1] 200
#> 
#> $outcome_message
#> [1] "file uploaded to REDCap in 0.2 seconds."
#> 
#> $records_affected_count
#> [1] 1
#> 
#> $affected_ids
#> [1] "1"
#> 
#> $elapsed_seconds
#> [1] 0.1915121
#> 
#> $raw_text
#> [1] ""
#> 

# Upload a collection of five images.
records    <- 1:5
file_paths <- system.file(
  paste0("test-data/mugshot-", records, ".jpg"),
  package="REDCapR"
)

for (i in seq_along(records)) {
  record    <- records[i]
  file_path <- file_paths[i]
  REDCapR::redcap_file_upload_oneshot(
    file_name  = file_path,
    record     = record,
    field      = field,
    redcap_uri = uri,
    token      = token
  )
}
#> Preparing to upload the file `/Users/runner/work/_temp/Library/REDCapR/test-data/mugshot-1.jpg`.
#> file uploaded to REDCap in 0.1 seconds.
#> Preparing to upload the file `/Users/runner/work/_temp/Library/REDCapR/test-data/mugshot-2.jpg`.
#> file uploaded to REDCap in 0.1 seconds.
#> Preparing to upload the file `/Users/runner/work/_temp/Library/REDCapR/test-data/mugshot-3.jpg`.
#> file uploaded to REDCap in 0.1 seconds.
#> Preparing to upload the file `/Users/runner/work/_temp/Library/REDCapR/test-data/mugshot-4.jpg`.
#> file uploaded to REDCap in 0.1 seconds.
#> Preparing to upload the file `/Users/runner/work/_temp/Library/REDCapR/test-data/mugshot-5.jpg`.
#> file uploaded to REDCap in 0.1 seconds.
# }
```
