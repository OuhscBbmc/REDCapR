# Determine free available record ID

Determines the next available record ID.

## Usage

``` r
redcap_next_free_record_name(
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

a [base::character](https://rdrr.io/r/base/character.html) vector of
either length 1 (if successful) or length 0 (if not successful).

## Details

If the API call is unsuccessful, a value of `character(0)` will be
returned (*i.e.*, an empty vector). This ensures that a the function
will always return an object of class
[base::character](https://rdrr.io/r/base/character.html).

## Note

**Documentation in REDCap 8.4.0**

To be used by projects with record auto-numbering enabled, this method
exports the next potential record ID for a project. It generates the
next record name by determining the current maximum numerical record ID
and then incrementing it by one.

    Note: This method does not create a new record, but merely determines what
    the next record name would be.

    If using Data Access Groups (DAGs) in the project, this method accounts for
    the special formatting of the record name for users in DAGs (e.g., DAG-ID);
    in this case, it only assigns the next value for ID for all numbers inside
    a DAG. For example, if a DAG has a corresponding DAG number of 223 wherein
    records 223-1 and 223-2 already exist, then the next record will be 223-3
    if the API user belongs to the DAG that has DAG number 223. (The DAG number
    is auto-assigned by REDCap for each DAG when the DAG is first created.)

    When generating a new record name in a DAG, the method considers all records
    in the entire project when determining the maximum record ID, including
    those that might have been originally created in that DAG but then later
    reassigned to another DAG.

    Note: This method functions the same even for projects that do not have
    record auto-numbering enabled.

## Examples

``` r
# \dontrun{
uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token    <- "9A068C425B1341D69E83064A2D273A70"
# Returns 6
REDCapR::redcap_next_free_record_name(redcap_uri = uri, token = token)
#> The next free record name in REDCap was successfully determined in 0.1 seconds.  The http status code was 200.  Is is 6.
#> [1] "6"
# }
```
