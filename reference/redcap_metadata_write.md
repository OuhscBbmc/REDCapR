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
# \dontrun{
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
#> # A tibble: 16 × 18
#>    field_name form_name          section_header      field_type field_label     
#>    <chr>      <chr>              <chr>               <chr>      <chr>           
#>  1 record_id  demographics       NA                  text       Study ID        
#>  2 name_first demographics       Contact Information text       First Name      
#>  3 name_last  demographics       NA                  text       Last Name       
#>  4 address    demographics       NA                  notes      Street, City, S…
#>  5 telephone  demographics       NA                  text       Phone number    
#>  6 email      demographics       NA                  text       E-mail          
#>  7 dob        demographics       NA                  text       Date of birth   
#>  8 age        demographics       NA                  calc       Age (years)     
#>  9 sex        demographics       NA                  radio      Gender          
#> 10 height     health             NA                  text       Height (cm)     
#> 11 weight     health             NA                  text       Weight (kilogra…
#> 12 bmi        health             NA                  calc       BMI             
#> 13 comments   health             General Comments    notes      Comments        
#> 14 mugshot    health             NA                  file       Mugshot         
#> 15 race       race_and_ethnicity NA                  checkbox   Race (Select al…
#> 16 ethnicity  race_and_ethnicity NA                  radio      Ethnicity       
#> # ℹ 13 more variables: select_choices_or_calculations <chr>, field_note <chr>,
#> #   text_validation_type_or_show_slider_number <chr>,
#> #   text_validation_min <chr>, text_validation_max <chr>, identifier <chr>,
#> #   branching_logic <chr>, required_field <chr>, custom_alignment <chr>,
#> #   question_number <chr>, matrix_group_name <chr>, matrix_ranking <chr>,
#> #   field_annotation <chr>

# Import the dictionary into the REDCap project
REDCapR::redcap_metadata_write(
  ds          = ds_to_write,
  redcap_uri  = uri,
  token       = token
)
#> 16 fields were written to the REDCap dictionary in 0.2 seconds.
#> $success
#> [1] TRUE
#> 
#> $status_code
#> [1] 200
#> 
#> $outcome_message
#> [1] "16 fields were written to the REDCap dictionary in 0.2 seconds."
#> 
#> $field_count
#> [1] 16
#> 
#> $elapsed_seconds
#> [1] 0.193269
#> 
#> $raw_text
#> [1] ""
#> 
# }
```
