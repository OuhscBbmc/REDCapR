# Download REDCap Instruments

Download instruments as a pdf, with or without responses.

## Usage

``` r
redcap_instrument_download(
  file_name = NULL,
  directory = NULL,
  overwrite = FALSE,
  redcap_uri,
  token,
  record = character(0),
  instrument = "",
  event = "",
  verbose = TRUE,
  config_options = NULL,
  handle_httr = NULL
)
```

## Arguments

- file_name:

  The name of the file where the downloaded pdf is saved. Optional.

- directory:

  The directory where the file is saved. By default current directory.
  Optional.

- overwrite:

  Boolean value indicating if existing files should be overwritten.
  Optional.

- redcap_uri:

  The
  [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
  of the REDCap server typically formatted as
  "https://server.org/apps/redcap/api/". Required.

- token:

  The user-specific string that serves as the password for a project.
  Required.

- record:

  The record ID of the instrument(s). If empty, the responses are blank.
  Optional.

- instrument:

  The instrument(s) to download. If empty, all instruments are returned.
  Optional.

- event:

  The unique event name. For a longitudinal project, if record is not
  blank and event is blank, it will return data for all events from that
  record. If record is not blank and event is not blank, it will return
  data only for the specified event from that record. Optional.

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

- `record_id`: The record_id of the instrument.

- `elapsed_seconds`: The duration of the function.

- `raw_text`: If an operation is NOT successful, the text returned by
  REDCap. If an operation is successful, the `raw_text` is returned as
  an empty string to save RAM.

- `file_name`: The name of the file persisted to disk. This is useful if
  the name stored in REDCap is used (which is the default).

## Details

Currently, the function doesn't modify any variable types to conform to
REDCap's supported variables. See
[`validate_for_write()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
for a helper function that checks for some common important conflicts.

The function `redcap_download_instrument()` is soft-deprecated as of
REDCapR 1.2.0. Please rename to `redcap_instrument_download()`.

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
# \dontrun{
uri     <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token   <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write

# event <- "" # only for longitudinal projects

(full_name <- base::tempfile(pattern="instruments-all-records-all", fileext = ".pdf"))
#> [1] "/var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/instruments-all-records-all1ab97c56401b.pdf"
result_1   <- REDCapR::redcap_instrument_download(
  file_name     = full_name,
  redcap_uri    = uri,
  token         = token
)
#> Preparing to download the file `/var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/instruments-all-records-all1ab97c56401b.pdf`.
#> text/html; charset=UTF-8 successfully downloaded in 0.2 seconds, and saved as /var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/instruments-all-records-all1ab97c56401b.pdf.
base::unlink(full_name)

(full_name <- base::tempfile(pattern="instruments-all-record-1-", fileext = ".pdf"))
#> [1] "/var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/instruments-all-record-1-1ab928aec63.pdf"
result_2   <- REDCapR::redcap_instrument_download(
  record        = 5,
  file_name     = full_name,
  redcap_uri    = uri,
  token         = token
)
#> Preparing to download the file `/var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/instruments-all-record-1-1ab928aec63.pdf`.
#> text/html; charset=UTF-8 successfully downloaded in 0.2 seconds, and saved as /var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/instruments-all-record-1-1ab928aec63.pdf.
base::unlink(full_name)
(full_name <- base::tempfile(pattern="instrument-1-record-1-", fileext=".pdf"))
#> [1] "/var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/instrument-1-record-1-1ab96ea558e2.pdf"
result_3   <- REDCapR::redcap_instrument_download(
  record        = 5,
  instrument    = "health",
  file_name     = full_name,
  redcap_uri    = uri,
  token         = token
)
#> Preparing to download the file `/var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/instrument-1-record-1-1ab96ea558e2.pdf`.
#> text/html; charset=UTF-8 successfully downloaded in 0.2 seconds, and saved as /var/folders/bp/kmfmhnl95kx1c8x321z7twbw0000gn/T//Rtmp8xFghB/instrument-1-record-1-1ab96ea558e2.pdf.
base::unlink(full_name)
# }
```
