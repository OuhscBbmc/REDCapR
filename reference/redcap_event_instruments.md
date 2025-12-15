# Enumerate the instruments to event mappings

Export the instrument-event mappings for a project (i.e., how the data
collection instruments are designated for certain events in a
longitudinal project). (Copied from "Export Instrument-Event Mappings"
method of REDCap API documentation, v.10.5.1)

## Usage

``` r
redcap_event_instruments(
  redcap_uri,
  token,
  arms = NULL,
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

- arms:

  A character string of arms to retrieve. Defaults to all arms of the
  project.

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

Currently, a list is returned with the following elements,

- `data`: A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  where each row represents one column in the REDCap dataset.

- `success`: A boolean value indicating if the operation was apparently
  successful.

- `status_code`: The [http status
  code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the
  operation.

- `outcome_message`: A human readable string indicating the operation's
  outcome.

- `elapsed_seconds`: The duration of the function.

- `raw_text`: If an operation is NOT successful, the text returned by
  REDCap. If an operation is successful, the `raw_text` is returned as
  an empty string to save RAM.

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (*i.e.*,
https://community.projectredcap.org/articles/456/api-documentation.html
and https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus
REDCap administrator to send you the static material.

## See also

[`redcap_instruments()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_instruments.md)

## Author

Victor Castro, Will Beasley

## Examples

``` r
# \dontrun{
uri                 <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

# Longitudinal project with one arm
token_1  <- "76B4A71A0158BD34C98F10DA72D5F27C" # "arm-single-longitudinal" test project
REDCapR::redcap_arm_export(redcap_uri=uri, token=token_1)$data
#> The list of arms was retrieved from the REDCap project in 0.1 seconds. The http status code was 200.
#> # A tibble: 1 × 2
#>   arm_number arm_name
#>        <int> <chr>   
#> 1          1 Arm 1   
REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_1)$data
#> 3 event instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 3 × 3
#>   arm_num unique_event_name form      
#>     <int> <chr>             <chr>     
#> 1       1 intake_arm_1      collection
#> 2       1 dischage_arm_1    collection
#> 3       1 follow_up_arm_1   collection

# Project with two arms
token_2  <- "DA6F2BB23146BD5A7EA3408C1A44A556" # "longitudinal" test project
REDCapR::redcap_arm_export(redcap_uri=uri, token=token_2)$data
#> The list of arms was retrieved from the REDCap project in 0.1 seconds. The http status code was 200.
#> # A tibble: 2 × 2
#>   arm_number arm_name
#>        <int> <chr>   
#> 1          1 Drug A  
#> 2          2 Drug B  
REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_2)$data
#> 25 event instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 25 × 3
#>    arm_num unique_event_name form                        
#>      <int> <chr>             <chr>                       
#>  1       1 enrollment_arm_1  demographics                
#>  2       1 enrollment_arm_1  contact_info                
#>  3       1 enrollment_arm_1  baseline_data               
#>  4       1 dose_1_arm_1      patient_morale_questionnaire
#>  5       1 visit_1_arm_1     visit_lab_data              
#>  6       1 visit_1_arm_1     patient_morale_questionnaire
#>  7       1 visit_1_arm_1     visit_blood_workup          
#>  8       1 visit_1_arm_1     visit_observed_behavior     
#>  9       1 dose_2_arm_1      patient_morale_questionnaire
#> 10       1 visit_2_arm_1     visit_lab_data              
#> # ℹ 15 more rows
REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_2, arms = c("1", "2"))$data
#> 25 event instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 25 × 3
#>    arm_num unique_event_name form                        
#>      <int> <chr>             <chr>                       
#>  1       1 enrollment_arm_1  demographics                
#>  2       1 enrollment_arm_1  contact_info                
#>  3       1 enrollment_arm_1  baseline_data               
#>  4       1 dose_1_arm_1      patient_morale_questionnaire
#>  5       1 visit_1_arm_1     visit_lab_data              
#>  6       1 visit_1_arm_1     patient_morale_questionnaire
#>  7       1 visit_1_arm_1     visit_blood_workup          
#>  8       1 visit_1_arm_1     visit_observed_behavior     
#>  9       1 dose_2_arm_1      patient_morale_questionnaire
#> 10       1 visit_2_arm_1     visit_lab_data              
#> # ℹ 15 more rows
REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_2, arms = "2")$data
#> 10 event instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 10 × 3
#>    arm_num unique_event_name        form                            
#>      <int> <chr>                    <chr>                           
#>  1       2 enrollment_arm_2         demographics                    
#>  2       2 enrollment_arm_2         contact_info                    
#>  3       2 enrollment_arm_2         baseline_data                   
#>  4       2 deadline_to_opt_ou_arm_2 contact_info                    
#>  5       2 first_dose_arm_2         patient_morale_questionnaire    
#>  6       2 first_visit_arm_2        patient_morale_questionnaire    
#>  7       2 first_visit_arm_2        visit_observed_behavior         
#>  8       2 final_visit_arm_2        visit_observed_behavior         
#>  9       2 final_visit_arm_2        completion_project_questionnaire
#> 10       2 deadline_to_return_arm_2 contact_info                    

# Classic project (without arms) throws an error
token_3  <- "9A068C425B1341D69E83064A2D273A70" # "simple" test project
REDCapR::redcap_arm_export(redcap_uri=uri, token=token_3)$data
#> A 'classic' REDCap project has no arms.  Retrieved in 0.1 seconds. The http status code was 400.
#> # A tibble: 0 × 2
#> # ℹ 2 variables: arm_number <int>, arm_name <chr>
# REDCapR::redcap_event_instruments(redcap_uri=uri, token=token_3)$data
# }
```
