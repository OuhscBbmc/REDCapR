# Create explicit factor level for missing values

Missing values are converted to a factor level. This explicit assignment
can reduce the chances that missing values are inadvertently ignored. It
also allows the presence of a missing to become a predictor in models.

## Usage

``` r
replace_nas_with_explicit(
  scores,
  new_na_label = "Unknown",
  create_factor = FALSE,
  add_unknown_level = FALSE
)
```

## Arguments

- scores:

  An array of values, ideally either factor or character. Required

- new_na_label:

  The factor label assigned to the missing value. Defaults to `Unknown`.

- create_factor:

  Converts `scores` into a factor, if it isn't one already. Defaults to
  `FALSE`.

- add_unknown_level:

  Should a new factor level be created? (Specify `TRUE` if it already
  exists.) Defaults to `FALSE`.

## Value

An array of values, where the `NA` values are now a factor level, with
the label specified by the `new_na_label` value.

## Note

The `create_factor` parameter is respected only if `scores` isn't
already a factor. Otherwise, levels without any values would be lost.

A `stop` error will be thrown if the operation fails to convert all the
`NA` values.

## Author

Will Beasley

## Examples

``` r
library(REDCapR) # Load the package into the current R session.
```
