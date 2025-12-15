# A Reference Class to make later calls to REDCap more convenient

This `Reference Class` represents a REDCap project. Once some values are
set that are specific to a REDCap project (such as the URI and token),
later calls are less verbose (such as reading and writing data).

## Fields

- `redcap_uri`:

  The URI (uniform resource identifier) of the REDCap project. Required.

- `token`:

  token The user-specific string that serves as the password for a
  project. Required.

## Methods

- `read( batch_size = 100L, interbatch_delay = 0, records = NULL, fields = NULL, forms = NULL, events = NULL, raw_or_label = "raw", raw_or_label_headers = "raw", export_checkbox_label = FALSE, export_survey_fields = FALSE, export_data_access_groups = FALSE, filter_logic = "", col_types = NULL, guess_type = TRUE, guess_max = 1000, verbose = TRUE, config_options = NULL )`:

  Exports records from a REDCap project.

- `write( ds_to_write, batch_size = 100L, interbatch_delay = 0, continue_on_error = FALSE, verbose = TRUE, config_options = NULL )`:

  Imports records to a REDCap project.

## Examples

``` r
# \dontrun{
uri     <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token   <- "9A068C425B1341D69E83064A2D273A70"

project <- REDCapR::redcap_project$new(redcap_uri=uri, token=token)
ds_all  <- project$read()
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 5 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 5 records  at 2025-12-15 19:47:37.062334.
#> Reading batch 1 of 1, with subjects 1 through 5 (ie, 5 unique subject records).
#> 5 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

# Demonstrate how repeated calls are more concise when the token and
#   url aren't always passed.
ds_skinny <- project$read(fields=c("record_id", "sex", "height"))$data
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 5 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 5 records  at 2025-12-15 19:47:37.959764.
#> Reading batch 1 of 1, with subjects 1 through 5 (ie, 5 unique subject records).
#> 5 records and 3 columns were read from REDCap in 0.2 seconds.  The http status code was 200.

ids_of_males    <- ds_skinny$record_id[ds_skinny$sex==1]
ids_of_shorties <- ds_skinny$record_id[ds_skinny$height < 40]

ds_males        <- project$read(records=ids_of_males, batch_size=2)$data
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 3 records  at 2025-12-15 19:47:38.842753.
#> Reading batch 1 of 2, with subjects 2 through 3 (ie, 2 unique subject records).
#> 2 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Reading batch 2 of 2, with subjects 5 through 5 (ie, 1 unique subject records).
#> 1 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
ds_shorties     <- project$read(records=ids_of_shorties)$data
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 2 records  at 2025-12-15 19:47:39.890908.
#> Reading batch 1 of 1, with subjects 1 through 2 (ie, 2 unique subject records).
#> 2 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

# }
if (FALSE) {
# Switch the Genders
sex_original   <- ds_skinny$sex
ds_skinny$sex  <- (1 - ds_skinny$sex)
project$write(ds_skinny)

# Switch the Genders back
ds_skinny$sex <- sex_original
project$write(ds_skinny)
}
```
