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

Currently, a list is returned with the following elements:

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
if (FALSE) { # \dontrun{
uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token    <- "0BF920AAF9566A8E603F528A498A5729" # dag

result   <- REDCapR::redcap_users_export(redcap_uri=uri, token=token)
result$data_user
result$data_user_form
} # }
```
