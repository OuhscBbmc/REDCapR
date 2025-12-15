# Collapse a vector of values into a single string when necessary

REDCap's API frequently specifies a series of values separated by
commas. In the R world, it's easier to keep these values as separate
elements in a vector. This functions squashes them together in a single
character element (presumably right before the return value is passed to
the API)

## Usage

``` r
collapse_vector(elements)
```

## Arguments

- elements:

  An array of values. Can be `NULL`. Required.

## Value

A single character element, where the values are separated by commas.
Can be blank. (*i.e.*, `""`).

## Author

Will Beasley

## Examples

``` r
library(REDCapR) # Load the package into the current R session.
REDCapR:::collapse_vector(elements = NULL   )
#> [1] ""
REDCapR:::collapse_vector(elements = letters)
#> [1] "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
```
