# List authorized users

List users authorized for a project.

## Usage

``` r
redcap_users_export(
  redcap_uri,
  token,
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

- `data_user`: A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  of all users associated with the project. One row represents one user.

- `data_user_form`: A
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  of permissions for users and forms. One row represents a unique
  user-by-form combination.

- `success`: A boolean value indicating if the operation was apparently
  successful.

- `status_codes`: A collection of [http status
  codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
  separated by semicolons. There is one code for each batch attempted.

- `outcome_messages`: A collection of human readable strings indicating
  the operations' semicolons. There is one code for each batch
  attempted. In an unsuccessful operation, it should contain diagnostic
  information.

- `elapsed_seconds`: The duration of the function.

## Note

**Documentation in REDCap 8.4.0**

    This method allows you to export the list of users for a project,
    including their user privileges and also email address, first name,
    and last name.

    Note: If the user has been assigned to a user role, it will return
    the user with the role's defined privileges.

## Examples

``` r
# \dontrun{
uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token    <- "0BF920AAF9566A8E603F528A498A5729" # dag

result   <- REDCapR::redcap_users_export(redcap_uri=uri, token=token)
#> The REDCap users were successfully exported in 0.1 seconds.  The http status code was 200.
result$data_user
#> # A tibble: 2 × 34
#>   username        email          firstname lastname expiration data_access_group
#>   <chr>           <chr>          <chr>     <chr>    <date>     <chr>            
#> 1 itawilliamb     william-beasl… Will      Beasley… NA         NA               
#> 2 unittestphifree whb4@ou.edu    Unit Test Phi Free NA         daga             
#> # ℹ 28 more variables: data_access_group_id <chr>, design <lgl>, alerts <dbl>,
#> #   user_rights <int>, data_access_groups <lgl>, reports <lgl>,
#> #   stats_and_charts <lgl>, manage_survey_participants <lgl>, calendar <lgl>,
#> #   data_import_tool <lgl>, data_comparison_tool <lgl>, logging <lgl>,
#> #   email_logging <lgl>, file_repository <lgl>, data_quality_create <lgl>,
#> #   data_quality_execute <lgl>, api_export <lgl>, api_import <lgl>,
#> #   api_modules <lgl>, mobile_app <lgl>, mobile_app_download_data <lgl>, …
result$data_user_form
#> # A tibble: 2 × 4
#>   username        form_name    permission_id permission
#>   <chr>           <chr>                <int> <fct>     
#> 1 itawilliamb     demographics             1 edit_form 
#> 2 unittestphifree demographics             1 edit_form 
# }
```
