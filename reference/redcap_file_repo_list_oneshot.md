# Export a List of Files/Folders from the File Repository

Allows you to export a list of all files and sub-folders from a specific
folder in a project's File Repository. Each sub-folder will have an
associated folder_id number, and each file will have an associated
doc_id number.

## Usage

``` r
redcap_file_repo_list_oneshot(
  redcap_uri,
  token,
  folder_id = NA_integer_,
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

- folder_id:

  the integer of a specific folder in the File Repository for which you
  wish to export a list of its files and sub-folders. If `NA` (the
  default), the top-level directory of the File Repository will be used.

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

- `data`: A
  [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
  with the following columns: `folder_id`, `doc_id`, and (file) `name`.
  Each sub-folder will have an associated `folder_id` integer, and each
  file will have an associated `doc_id` integer.

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

This functions requires API Export privileges and File Repository
privileges in the project. (Note: Until [v14.7.3
Standard](https://redcap.vumc.org/community/post.php?id=243161), API
*import* privileges too.)

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
token   <- "589740603423E92BC79BAC2811B1F82A" # file-repo

# Top-level directory
REDCapR::redcap_file_repo_list_oneshot(
  redcap_uri    = uri,
  token         = token
)$data
#> The file repository structure describing 6 elements was read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 6 × 3
#>   folder_id doc_id name         
#>       <int>  <int> <chr>        
#> 1         1     NA the-state    
#> 2        NA   6652 mugshot-1.jpg
#> 3        NA   6653 mugshot-2.jpg
#> 4        NA   6654 mugshot-3.jpg
#> 5        NA   6655 mugshot-4.jpg
#> 6        NA   6656 mugshot-5.jpg

# First subdirectory
REDCapR::redcap_file_repo_list_oneshot(
  redcap_uri    = uri,
  token         = token,
  folder_id     = 1
)$data
#> The file repository structure describing 1 elements was read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 1 × 3
#>   folder_id doc_id name               
#>       <int>  <int> <chr>              
#> 1        NA   6651 levon-and-barry.jpg
# }
```
