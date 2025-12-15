# Convert a vector to the array format expected by the REDCap API

Utility function to convert a vector into the array format expected by
the some REDCap API calls. It is called internally by REDCapR functions,
and is not intended to be called directly.

## Usage

``` r
to_api_array(x, element_names)
```

## Arguments

- x:

  A vector to convert to array format. Can be `NULL`.

- element_names:

  A string containing the name of the API request parameter for the
  array. Must be either "fields" or "forms".

## Value

If `x` is not `NULL` a list is returned with one element for each
element of x in the format:
`` list(`element_names[0]` = x[1], `element_names[1]` = x[2], ...) ``.

If `x` is `NULL` then `NULL` is returned.
