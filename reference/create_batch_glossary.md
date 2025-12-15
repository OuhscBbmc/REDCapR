# Creates a dataset that help batching long-running read and writes

The function returns a
[`base::data.frame()`](https://rdrr.io/r/base/data.frame.html) that
other functions use to separate long-running read and write REDCap calls
into multiple, smaller REDCap calls. The goal is to (1) reduce the
chance of time-outs, and (2) introduce little breaks between batches so
that the server isn't continually tied up.

## Usage

``` r
create_batch_glossary(row_count, batch_size)
```

## Arguments

- row_count:

  The number records in the large dataset, before it's split.

- batch_size:

  The maximum number of subject records a single batch should contain.

## Value

Currently, a
[`base::data.frame()`](https://rdrr.io/r/base/data.frame.html) is
returned with the following columns,

- `id`: an `integer` that uniquely identifies the batch, starting at
  `1`.

- `start_index`: the index of the first row in the batch. `integer`.

- `stop_index`: the index of the last row in the batch. `integer`.

- `id_pretty`: a `character` representation of `id`, but padded with
  zeros.

- `start_index`: a `character` representation of `start_index`, but
  padded with zeros.

- `stop_index`: a `character` representation of `stop_index`, but padded
  with zeros.

- `label`: a `character` concatenation of `id_pretty`, `start_index`,
  and `stop_index_pretty`.

## Details

This function can also assist splitting and saving a large data frame to
disk as smaller files (such as a .csv). The padded columns allow the OS
to sort the batches/files in sequential order.

## See also

See
[`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
for a function that uses `create_batch_glossary`.

## Author

Will Beasley

## Examples

``` r
REDCapR::create_batch_glossary(100, 50)
#> # A tibble: 2 × 7
#>      id start_index stop_index index_pretty start_index_pretty stop_index_pretty
#>   <int>       <int>      <int> <chr>        <chr>              <chr>            
#> 1     1           1         50 1            001                050              
#> 2     2          51        100 2            051                100              
#> # ℹ 1 more variable: label <chr>
REDCapR::create_batch_glossary(100, 25)
#> # A tibble: 4 × 7
#>      id start_index stop_index index_pretty start_index_pretty stop_index_pretty
#>   <int>       <int>      <int> <chr>        <chr>              <chr>            
#> 1     1           1         25 1            001                025              
#> 2     2          26         50 2            026                050              
#> 3     3          51         75 3            051                075              
#> 4     4          76        100 4            076                100              
#> # ℹ 1 more variable: label <chr>
REDCapR::create_batch_glossary(100,  3)
#> # A tibble: 34 × 7
#>       id start_index stop_index index_pretty start_index_pretty
#>    <int>       <int>      <int> <chr>        <chr>             
#>  1     1           1          3 01           001               
#>  2     2           4          6 02           004               
#>  3     3           7          9 03           007               
#>  4     4          10         12 04           010               
#>  5     5          13         15 05           013               
#>  6     6          16         18 06           016               
#>  7     7          19         21 07           019               
#>  8     8          22         24 08           022               
#>  9     9          25         27 09           025               
#> 10    10          28         30 10           028               
#> # ℹ 24 more rows
#> # ℹ 2 more variables: stop_index_pretty <chr>, label <chr>
REDCapR::create_batch_glossary(  0,  3)
#> # A tibble: 0 × 7
#> # ℹ 7 variables: id <int>, start_index <int>, stop_index <int>,
#> #   index_pretty <chr>, start_index_pretty <chr>, stop_index_pretty <chr>,
#> #   label <chr>
d <- data.frame(
  record_id = 1:100,
  iv        = sample(x=4, size=100, replace=TRUE),
  dv        = rnorm(n=100)
)
REDCapR::create_batch_glossary(nrow(d), batch_size=40)
#> # A tibble: 3 × 7
#>      id start_index stop_index index_pretty start_index_pretty stop_index_pretty
#>   <int>       <int>      <int> <chr>        <chr>              <chr>            
#> 1     1           1         40 1            001                040              
#> 2     2          41         80 2            041                080              
#> 3     3          81        100 3            081                100              
#> # ℹ 1 more variable: label <chr>
```
