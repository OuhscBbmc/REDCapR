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
https://community.projectredcap.org/articles/456/api-documentation.html
and https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus
REDCap administrator to send you the static material.

## Author

Will Beasley

## Examples

``` r
# \dontrun{
uri   <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

# A simple project
token <- "9A068C425B1341D69E83064A2D273A70" # simple
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> $data
#> # A tibble: 17 × 18
#>    field_name         form_name          section_header   field_type field_label
#>    <chr>              <chr>              <chr>            <chr>      <chr>      
#>  1 record_id          demographics       NA               text       Study ID   
#>  2 name_first         demographics       Contact Informa… text       First Name 
#>  3 name_last          demographics       NA               text       Last Name  
#>  4 address            demographics       NA               notes      Street, Ci…
#>  5 telephone          demographics       NA               text       Phone numb…
#>  6 email              demographics       NA               text       E-mail     
#>  7 dob                demographics       NA               text       Date of bi…
#>  8 age                demographics       NA               text       Age (years)
#>  9 sex                demographics       NA               radio      Gender     
#> 10 height             health             NA               text       Height (cm)
#> 11 weight             health             NA               text       Weight (ki…
#> 12 bmi                health             NA               calc       BMI        
#> 13 comments           health             General Comments notes      Comments   
#> 14 mugshot            health             NA               file       Mugshot    
#> 15 race               race_and_ethnicity NA               checkbox   Race (Sele…
#> 16 ethnicity          race_and_ethnicity NA               radio      Ethnicity  
#> 17 interpreter_needed race_and_ethnicity NA               truefalse  Are interp…
#> # ℹ 13 more variables: select_choices_or_calculations <chr>, field_note <chr>,
#> #   text_validation_type_or_show_slider_number <chr>,
#> #   text_validation_min <chr>, text_validation_max <chr>, identifier <chr>,
#> #   branching_logic <chr>, required_field <chr>, custom_alignment <chr>,
#> #   question_number <chr>, matrix_group_name <chr>, matrix_ranking <chr>,
#> #   field_annotation <chr>
#> 
#> $success
#> [1] TRUE
#> 
#> $status_code
#> [1] 200
#> 
#> $outcome_message
#> [1] "The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200."
#> 
#> $forms_collapsed
#> [1] ""
#> 
#> $fields_collapsed
#> [1] ""
#> 
#> $elapsed_seconds
#> [1] 0.128912
#> 
#> $raw_text
#> [1] ""
#> 

# A longitudinal project
token <- "0434F0E9CF53ED0587847AB6E51DE762" # longitudinal
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)
#> The REDCapR metadata export operation was not successful.  The error message was:
#> {"error":"You do not have permissions to use the API"}
#> $data
#> # A tibble: 0 × 0
#> 
#> $success
#> [1] FALSE
#> 
#> $status_code
#> [1] 403
#> 
#> $outcome_message
#> [1] "The REDCapR metadata export operation was not successful.  The error message was:\n{\"error\":\"You do not have permissions to use the API\"}"
#> 
#> $forms_collapsed
#> [1] ""
#> 
#> $fields_collapsed
#> [1] ""
#> 
#> $elapsed_seconds
#> [1] 0.08918309
#> 
#> $raw_text
#> [1] "{\"error\":\"You do not have permissions to use the API\"}"
#> 

# A repeating measures
token <- "77842BD8C18D3408819A21DD0154CCF4" # vignette-repeating
REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)
#> The data dictionary describing 9 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> $data
#> # A tibble: 9 × 18
#>   field_name    form_name      section_header field_type field_label            
#>   <chr>         <chr>          <chr>          <chr>      <chr>                  
#> 1 record_id     intake         NA             text       Record ID              
#> 2 height        intake         NA             text       patient height         
#> 3 weight        intake         NA             text       patient weight         
#> 4 bmi           intake         NA             text       patient bmi            
#> 5 sbp           blood_pressure NA             text       systolic blood pressure
#> 6 dbp           blood_pressure NA             text       diastolic blood pressu…
#> 7 lab           laboratory     NA             text       lab value              
#> 8 conc          laboratory     NA             text       concentration          
#> 9 image_profile image          NA             file       Picture of Patient     
#> # ℹ 13 more variables: select_choices_or_calculations <chr>, field_note <chr>,
#> #   text_validation_type_or_show_slider_number <chr>,
#> #   text_validation_min <chr>, text_validation_max <chr>, identifier <chr>,
#> #   branching_logic <chr>, required_field <chr>, custom_alignment <chr>,
#> #   question_number <chr>, matrix_group_name <chr>, matrix_ranking <chr>,
#> #   field_annotation <chr>
#> 
#> $success
#> [1] TRUE
#> 
#> $status_code
#> [1] 200
#> 
#> $outcome_message
#> [1] "The data dictionary describing 9 fields was read from REDCap in 0.1 seconds.  The http status code was 200."
#> 
#> $forms_collapsed
#> [1] ""
#> 
#> $fields_collapsed
#> [1] ""
#> 
#> $elapsed_seconds
#> [1] 0.1072869
#> 
#> $raw_text
#> [1] ""
#> 
# }
```
