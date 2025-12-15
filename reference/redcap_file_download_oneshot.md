# Download a file from a REDCap project record

This function uses REDCap's API to download a file.

## Usage

``` r
redcap_file_download_oneshot(
  file_name = NULL,
  directory = NULL,
  overwrite = FALSE,
  redcap_uri,
  token,
  record,
  field,
  event = "",
  repeat_instance = NULL,
  verbose = TRUE,
  config_options = NULL,
  handle_httr = NULL
)
```

## Arguments

- file_name:

  The name of the file where the downloaded file is saved. If empty the
  original name of the file will be used and saved in the default
  directory. Optional.

- directory:

  The directory where the file is saved. By default current directory.
  Optional

- overwrite:

  Boolean value indicating if existing files should be overwritten.
  Optional

- redcap_uri:

  The
  [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
  of the REDCap server typically formatted as
  "https://server.org/apps/redcap/api/". Required.

- token:

  The user-specific string that serves as the password for a project.
  Required.

- record:

  The record ID where the file is to be imported. Required

- field:

  The name of the field where the file is saved in REDCap. Required

- event:

  The name of the event where the file is saved in REDCap. Optional

- repeat_instance:

  (only for projects with repeating instruments/events) The repeat
  instance number of the repeating event (if longitudinal) or the
  repeating instrument (if classic or longitudinal). Default value is
  '1'. Optional

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

Currently, a list is returned with the following elements,

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

- `file_name`: The name of the file persisted to disk. This is useful if
  the name stored in REDCap is used (which is the default).

## Details

For files in a repeating instrument, don't specify
`repeating_instrument`. The server only needs `field` (name) and
`repeating_instance`.

The function `redcap_download_file_oneshot()` is soft-deprecated as of
REDCapR 1.2.0. Please rename to `redcap_file_download_oneshot()`.

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (*i.e.*,
https://community.projectredcap.org/articles/456/api-documentation.html
and https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus
REDCap administrator to send you the static material.

## Author

Will Beasley, John J. Aponte

## Examples

``` r
# \dontrun{
uri     <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token   <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write

record  <- 1
field   <- "mugshot"
# event <- "" # only for longitudinal projects

result_1 <- REDCapR::redcap_file_download_oneshot(
  record        = record,
  field         = field,
  redcap_uri    = uri,
  token         = token
)
#> Preparing to download the file `mugshot-1.jpg`.
#> image/jpeg; name="mugshot-1.jpg" successfully downloaded in 0.2 seconds, and saved as mugshot-1.jpg.
base::unlink("mugshot-1.jpg")

(full_name <- base::tempfile(pattern="mugshot", fileext = ".jpg"))
#> [1] "/var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/mugshot1ab9564e9090.jpg"
result_2   <- REDCapR::redcap_file_download_oneshot(
  file_name     = full_name,
  record        = record,
  field         = field,
  redcap_uri    = uri,
  token         = token
)
#> Preparing to download the file `/var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/mugshot1ab9564e9090.jpg`.
#> image/jpeg; name="mugshot-1.jpg" successfully downloaded in 0.1 seconds, and saved as /var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/mugshot1ab9564e9090.jpg.
base::unlink(full_name)

(relative_name <- "ssss.jpg")
#> [1] "ssss.jpg"
result_3 <- REDCapR::redcap_file_download_oneshot(
  file_name    = relative_name,
  record       = record,
  field        = field,
  redcap_uri   = uri,
  token        = token
)
#> Preparing to download the file `ssss.jpg`.
#> image/jpeg; name="mugshot-1.jpg" successfully downloaded in 0.1 seconds, and saved as ssss.jpg.
base::unlink(relative_name)
# }
```
