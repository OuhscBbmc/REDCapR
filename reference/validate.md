# Inspect a dataset to anticipate problems before writing to a REDCap project

This set of functions inspect a data frame to anticipate problems before
writing with REDCap's API.

## Usage

``` r
validate_for_write( d, convert_logical_to_integer, record_id_name )

validate_data_frame_inherits( d )

validate_no_logical( d, stop_on_error = FALSE )

validate_field_names( d, stop_on_error = FALSE )

validate_record_id_name( d, record_id_name = "record_id", stop_on_error = FALSE )

validate_repeat_instance( d, stop_on_error = FALSE )

validate_uniqueness( d, record_id_name, stop_on_error = FALSE)
```

## Arguments

- d:

  The [`base::data.frame()`](https://rdrr.io/r/base/data.frame.html) or
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  containing the dataset used to update the REDCap project.

- record_id_name:

  The name of the field that represents one record. The default name in
  REDCap is "record_id".

- stop_on_error:

  If `TRUE`, an error is thrown for violations. Otherwise, a dataset
  summarizing the problems is returned.

- convert_logical_to_integer:

  This mimics the `convert_logical_to_integer` parameter in
  [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.md)
  when checking for potential importing problems. Defaults to `FALSE`.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html),
where each potential violation is a row. The two columns are:

- `field_name`: The name of the field/column/variable that might cause
  problems during the upload.

- `field_index`: The position of the field. (For example, a value of '1'
  indicates the first column, while a '3' indicates the third column.)

- `concern`: A description of the problem potentially caused by the
  `field`.

- `suggestion`: A *potential* solution to the concern.

## Details

All functions listed in the Usage section above inspect a specific
aspect of the dataset. The `validate_for_write()` function executes all
these individual validation checks. It allows the client to check
everything with one call.

Currently, the individual checks include:

1.  `validate_data_frame_inherits(d)`: `d` inherits from
    [`base::data.frame()`](https://rdrr.io/r/base/data.frame.html)

2.  `validate_field_names(d)`: The columns of `d` start with a lowercase
    letter, and subsequent optional characters are a sequence of (a)
    lowercase letters, (b) digits 0-9, and/or (c) underscores. (The
    exact regex is `^[a-z][0-9a-z_]*$`.)

3.  `validate_record_id_name(d)`: `d` contains a field called
    "record_id", or whatever value was passed to `record_id_name`.

4.  `validate_no_logical(d)` (unless `convert_logical_to_integer` is
    TRUE): `d` does not contain
    [logical](https://stat.ethz.ch/R-manual/R-devel/library/base/html/logical.html)
    values (because REDCap typically wants `0`/`1` values instead of
    `FALSE`/`TRUE`).

5.  `validate_repeat_instance(d)`: `d` has an integer for
    `redcap_repeat_instance`, if the column is present.

6.  `validate_uniqueness(d, record_id_name = record_id_name)`: `d` does
    not contain multiple rows with duplicate values of `record_id`,
    `redcap_event_name`, `redcap_repeat_instrument`, and
    `redcap_repeat_instance` (depending on the longitudinal & repeating
    structure of the project).

    Technically duplicate rows are not errors, but we feel that this
    will almost always be unintentional, and lead to an irrecoverable
    corruption of the data.

If you encounter additional types of problems when attempting to write
to REDCap, please tell us by creating a [new
issue](https://github.com/OuhscBbmc/REDCapR/issues), and we'll
incorporate a new validation check into this function.

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
d1 <- data.frame(
  record_id      = 1:4,
  flag_logical   = c(TRUE, TRUE, FALSE, TRUE),
  flag_Uppercase = c(4, 6, 8, 2)
)
REDCapR::validate_for_write(d = d1)
#> # A tibble: 2 × 4
#>   field_name     field_index concern                                  suggestion
#>   <chr>          <chr>       <chr>                                    <chr>     
#> 1 flag_Uppercase 3           A REDCap project does not allow field n… Change th…
#> 2 flag_logical   2           The REDCap API does not automatically c… Convert t…

REDCapR::validate_for_write(d = d1, convert_logical_to_integer = TRUE)
#> # A tibble: 1 × 4
#>   field_name     field_index concern                                  suggestion
#>   <chr>          <chr>       <chr>                                    <chr>     
#> 1 flag_Uppercase 3           A REDCap project does not allow field n… Change th…

# If `d1` is not a data.frame, the remaining validation checks are skipped:
# REDCapR::validate_for_write(as.matrix(mtcars))
# REDCapR::validate_for_write(c(mtcars, iris))

d2 <- tibble::tribble(
  ~record_id, ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance,
  1L, "e1", "i1", 1L,
  1L, "e1", "i1", 2L,
  1L, "e1", "i1", 3L,
  1L, "e1", "i1", 4L,
  1L, "e1", "i2", 1L,
  1L, "e1", "i2", 2L,
  1L, "e1", "i2", 3L,
  1L, "e1", "i2", 4L,
  2L, "e1", "i1", 1L,
  2L, "e1", "i1", 2L,
  2L, "e1", "i1", 3L,
  2L, "e1", "i1", 4L,
)
validate_uniqueness(d2)
#> # A tibble: 0 × 4
#> # ℹ 4 variables: field_name <chr>, field_index <chr>, concern <chr>,
#> #   suggestion <chr>
validate_for_write(d2)
#> # A tibble: 0 × 4
#> # ℹ 4 variables: field_name <chr>, field_index <chr>, concern <chr>,
#> #   suggestion <chr>

d3 <- tibble::tribble(
  ~record_id, ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance,
  1L, "e1", "i1", 1L,
  1L, "e1", "i1", 3L,
  1L, "e1", "i1", 3L, # Notice this duplicates the row above
)
# validate_uniqueness(d3)
# Throws error:
# validate_uniqueness(d3, stop_on_error = TRUE)
```
