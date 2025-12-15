# Manipulate and interpret the metadata of a REDCap project

A collection of functions that assists handling REDCap project metadata.

## Usage

``` r
regex_named_captures(pattern, text, perl = TRUE)

checkbox_choices(select_choices)
```

## Arguments

- pattern:

  The regular expression pattern. Required.

- text:

  The text to apply the regex against. Required.

- perl:

  Indicates if perl-compatible regexps should be used. Default is
  `TRUE`. Optional.

- select_choices:

  The text containing the choices that should be parsed to determine the
  `id` and `label` values. Required.

## Value

Currently, a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
is returned a row for each match, and a column for each *named* group
within a match. For the `retrieve_checkbox_choices()` function, the
columns will be.

- `id`: The numeric value assigned to each choice (in the data
  dictionary).

- `label`: The label assigned to each choice (in the data dictionary).

## Details

The `regex_named_captures()` function is general, and not specific to
REDCap; it accepts any arbitrary regular expression. It returns a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with as many columns as named matches.

The `checkbox_choices()` function is specialized, and accommodates the
"select choices" for a *single* REDCap checkbox group (where multiple
boxes can be selected). It returns a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with two columns, one for the numeric id and one for the text label.

The parse will probably fail if a label contains a pipe (*i.e.*, `|`),
since that the delimiter REDCap uses to separate choices presented to
the user.

## References

See the official documentation for permissible characters in a checkbox
label. *I'm bluffing here, because I don't know where this is located.
If you know, please tell me.*

## Author

Will Beasley

## Examples

``` r
# The weird ranges are to avoid the pipe character;
#   PCRE doesn't support character negation.
pattern_boxes <- "(?<=\\A| \\| )(?<id>\\d{1,}), (?<label>[\x20-\x7B\x7D-\x7E]{1,})(?= \\| |\\Z)"

choices_1 <- paste0(
  "1, American Indian/Alaska Native | ",
  "2, Asian | ",
  "3, Native Hawaiian or Other Pacific Islander | ",
  "4, Black or African American | ",
  "5, White | ",
  "6, Unknown / Not Reported"
)

# This calls the general function, and requires the correct regex pattern.
REDCapR::regex_named_captures(pattern=pattern_boxes, text=choices_1)
#> # A tibble: 6 × 2
#>   id    label                                    
#>   <chr> <chr>                                    
#> 1 1     American Indian/Alaska Native            
#> 2 2     Asian                                    
#> 3 3     Native Hawaiian or Other Pacific Islander
#> 4 4     Black or African American                
#> 5 5     White                                    
#> 6 6     Unknown / Not Reported                   

# This function is designed specifically for the checkbox values.
REDCapR::checkbox_choices(select_choices=choices_1)
#> # A tibble: 6 × 2
#>   id    label                                    
#>   <chr> <chr>                                    
#> 1 1     American Indian/Alaska Native            
#> 2 2     Asian                                    
#> 3 3     Native Hawaiian or Other Pacific Islander
#> 4 4     Black or African American                
#> 5 5     White                                    
#> 6 6     Unknown / Not Reported                   

# \dontrun{
uri         <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token       <- "9A068C425B1341D69E83064A2D273A70"

ds_metadata <- redcap_metadata_read(uri, token)$data
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
choices_2   <- ds_metadata[ds_metadata$field_name == "race", ]$select_choices_or_calculations

REDCapR::regex_named_captures(pattern = pattern_boxes, text = choices_2)
#> # A tibble: 1 × 2
#>   id    label
#>   <chr> <chr>
#> 1 ""    ""   
# }

path_3     <- system.file(package = "REDCapR", "test-data/projects/simple/metadata.csv")
ds_metadata_3  <- read.csv(path_3)
choices_3  <- ds_metadata_3[ds_metadata_3$field_name=="race", "select_choices_or_calculations"]
REDCapR::regex_named_captures(pattern = pattern_boxes, text = choices_3)
#> # A tibble: 6 × 2
#>   id    label                                    
#>   <chr> <chr>                                    
#> 1 1     American Indian/Alaska Native            
#> 2 2     Asian                                    
#> 3 3     Native Hawaiian or Other Pacific Islander
#> 4 4     Black or African American                
#> 5 5     White                                    
#> 6 6     Unknown / Not Reported                   
```
