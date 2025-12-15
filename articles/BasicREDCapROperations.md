# Basic REDCapR Operations

This vignette covers the the basic functions exposed by the
[httr](https://github.com/r-lib/httr) and
[curl](https://cran.r-project.org/package=curl) packages which allow you
to interact with [REDCap](https://projectredcap.org/) through its API.

## Reading REDCap Data

The functions
[`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html)
and
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.html)
use the [httr](https://cran.r-project.org/package=httr) package to call
the REDCap API.

    ## Loading required namespace: kableExtra

### Set project-wide values

There is some information that is specific to the REDCap project, as
opposed to an individual operation. This includes the (1) uri of the
server, and the (2) token for the user’s project.

``` r
library(REDCapR) # Load the package into the current R session.
uri   <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token <- "9A068C425B1341D69E83064A2D273A70" # simple
```

### Read all records and fields

If no information is passed about the desired records or fields, then
the entire data set is returned. Only two parameters are required,
`redcap_uri` and `token`. Unless the `verbose` parameter is set to
`FALSE`, a message will be printed on the R console with the number of
records and fields returned.

``` r
# Return all records and all variables.
ds_all_rows_all_fields <- redcap_read(redcap_uri = uri, token = token)$data
#> 24 variable metadata records were read from REDCap in 0.2 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 5 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 5 records  at 2025-12-15 19:48:02.331602.
#> Reading batch 1 of 1, with subjects 1 through 5 (ie, 5 unique subject records).
#> 5 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
ds_all_rows_all_fields # Inspect the returned dataset
#> # A tibble: 5 × 25
#>   record_id name_first name_last address  telephone email dob          age   sex
#>       <dbl> <chr>      <chr>     <chr>    <chr>     <chr> <date>     <dbl> <dbl>
#> 1         1 Nutmeg     Nutmouse  "14 Ros… (405) 32… nutt… 2003-08-30    11     0
#> 2         2 Tumtum     Nutmouse  "14 Ros… (405) 32… tumm… 2003-03-10    11     1
#> 3         3 Marcus     Wood      "243 Hi… (405) 32… mw@m… 1934-04-09    80     1
#> 4         4 Trudy      DAG       "342 El… (405) 32… pero… 1952-11-02    61     0
#> 5         5 John Lee   Walker    "Hotel … (405) 32… left… 1955-04-15    59     1
#> # ℹ 16 more variables: demographics_complete <dbl>, height <dbl>, weight <dbl>,
#> #   bmi <dbl>, comments <chr>, mugshot <chr>, health_complete <dbl>,
#> #   race___1 <dbl>, race___2 <dbl>, race___3 <dbl>, race___4 <dbl>,
#> #   race___5 <dbl>, race___6 <dbl>, ethnicity <dbl>, interpreter_needed <dbl>,
#> #   race_and_ethnicity_complete <dbl>
```

### Read a subset of the records

If only a subset of the **records** is desired, the two approaches are
shown below. The first is to pass an array (where each element is an ID)
to the `records` parameter. The second is to pass a single string (where
the elements are separated by commas) to the `records_collapsed`
parameter.

The first format is more natural for more R users. The second format is
what is expected by the REDCap API. If a value for `records` is
specified, but `records_collapsed` is not specified, then
`redcap_read_oneshot` automatically converts the array into the format
needed by the API.

``` r
# Return only records with IDs of 1 and 3
desired_records <- c(1, 3)
ds_some_rows_v1 <- redcap_read(
  redcap_uri = uri,
  token      = token,
  records    = desired_records
)$data
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 2 records  at 2025-12-15 19:48:03.963718.
#> Reading batch 1 of 1, with subjects 1 through 3 (ie, 2 unique subject records).
#> 2 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
```

### Read a subset of the fields

If only a subset of the **fields** is desired, then two approaches
exist. The first is to pass an array (where each element is an field) to
the `fields` parameter. The second is to pass a single string (where the
elements are separated by commas) to the `fields_collapsed` parameter.
Like with `records` and `records_collapsed` described above, this
function converts the more natural format (*i.e.*, `fields`) to the
format required by the API (*i.e.*, `fields_collapsed`) if `fields` is
specified and `fields_collapsed` is not.

``` r
# Return only the fields record_id, name_first, and age
desired_fields <- c("record_id", "name_first", "age")
ds_some_fields <- redcap_read(
  redcap_uri = uri,
  token      = token,
  fields     = desired_fields
)$data
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 5 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 5 records  at 2025-12-15 19:48:05.516466.
#> Reading batch 1 of 1, with subjects 1 through 5 (ie, 5 unique subject records).
#> 5 records and 3 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
```

### Read a subset of records, conditioned on the values in some variables

The two techniques above can be combined when your datasets are large
and you don’t want to pull records with certain values. Suppose you want
to select subjects from the previous dataset *if* the were born before
1960 and their weight was over 70kg. Two calls to the server are
required. The **first call** to REDCap pulls all the records, but for
only three columns: `record_id`, `dob`, and `weight`. From this subset,
identify the records that you want to pull all the data for; in this
case, the desired `record_id` values are `3` & `5`. The **second call**
to REDCap pulls all the columns, but only for the identified records.

``` r
######
## Step 1: First call to REDCap
desired_fields_v3 <- c("record_id", "dob", "weight")
ds_some_fields_v3 <- redcap_read(
  redcap_uri = uri,
  token      = token,
  fields     = desired_fields_v3
)$data
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 5 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 5 records  at 2025-12-15 19:48:07.100637.
#> Reading batch 1 of 1, with subjects 1 through 5 (ie, 5 unique subject records).
#> 5 records and 3 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

ds_some_fields_v3 #Examine the these three variables.
#> # A tibble: 5 × 3
#>   record_id dob        weight
#>       <dbl> <date>      <dbl>
#> 1         1 2003-08-30      1
#> 2         2 2003-03-10      1
#> 3         3 1934-04-09     80
#> 4         4 1952-11-02     54
#> 5         5 1955-04-15    104

######
## Step 2: identify desired records, based on age & weight
before_1960 <- (ds_some_fields_v3$dob <= as.Date("1960-01-01"))
heavier_than_70_kg <- (ds_some_fields_v3$weight > 70)
desired_records_v3 <- ds_some_fields_v3[before_1960 & heavier_than_70_kg, ]$record_id

desired_records_v3 #Peek at IDs of the identified records
#> [1] 3 5

######
## Step 3: second call to REDCap
#Return only records that met the age & weight criteria.
ds_some_rows_v3 <- redcap_read(
  redcap_uri = uri,
  token      = token,
  records    = desired_records_v3
)$data
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 2 records  at 2025-12-15 19:48:08.588017.
#> Reading batch 1 of 1, with subjects 3 through 5 (ie, 2 unique subject records).
#> 2 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

ds_some_rows_v3 #Examine the results.
#> # A tibble: 2 × 25
#>   record_id name_first name_last address  telephone email dob          age   sex
#>       <dbl> <chr>      <chr>     <chr>    <chr>     <chr> <date>     <dbl> <dbl>
#> 1         3 Marcus     Wood      "243 Hi… (405) 32… mw@m… 1934-04-09    80     1
#> 2         5 John Lee   Walker    "Hotel … (405) 32… left… 1955-04-15    59     1
#> # ℹ 16 more variables: demographics_complete <dbl>, height <dbl>, weight <dbl>,
#> #   bmi <dbl>, comments <chr>, mugshot <chr>, health_complete <dbl>,
#> #   race___1 <dbl>, race___2 <dbl>, race___3 <dbl>, race___4 <dbl>,
#> #   race___5 <dbl>, race___6 <dbl>, ethnicity <dbl>, interpreter_needed <dbl>,
#> #   race_and_ethnicity_complete <dbl>
```

### Additional Returned Information

The examples above have shown only the resulting data frame, by
specifying `$data` at the end of the call. However, more is available to
those wanting additional information, such as:

1.  The `data` object has the data frame, as in the previous examples.
2.  The `success` boolean value indicates if `redcap_read_oneshot`
    believes the operation completed as intended.
3.  The `status_codes` is a collection of [http status
    codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
    separated by semicolons. There is one code for each batch attempted.
4.  The `outcome_messages`: A collection of human readable strings
    indicating the operations’ semicolons. There is one code for each
    batch attempted. In an unsuccessful operation, it should contain
    diagnostic information.
5.  The `records_collapsed` field passed to the API. This shows which
    record subsets, if any, were requested.
6.  The `fields_collapsed` fields passed to the API. This shows which
    field subsets, if any, were requested.
7.  The `elapsed_seconds` measures the duration of the call.

``` r
#Return only the fields record_id, name_first, and age
all_information <- redcap_read(
  redcap_uri = uri,
  token      = token,
  fields     = desired_fields
)
#> 24 variable metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 5 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 5 records  at 2025-12-15 19:48:10.177431.
#> Reading batch 1 of 1, with subjects 1 through 5 (ie, 5 unique subject records).
#> 5 records and 3 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
all_information #Inspect the additional information
#> $data
#> # A tibble: 5 × 3
#>   record_id name_first   age
#>       <dbl> <chr>      <dbl>
#> 1         1 Nutmeg        11
#> 2         2 Tumtum        11
#> 3         3 Marcus        80
#> 4         4 Trudy         61
#> 5         5 John Lee      59
#> 
#> $success
#> [1] TRUE
#> 
#> $status_codes
#> [1] "200"
#> 
#> $outcome_messages
#> [1] "5 records and 3 columns were read from REDCap in 0.1 seconds.  The http status code was 200."
#> 
#> $records_collapsed
#> [1] ""
#> 
#> $fields_collapsed
#> [1] "record_id,name_first,age"
#> 
#> $forms_collapsed
#> [1] ""
#> 
#> $events_collapsed
#> [1] ""
#> 
#> $filter_logic
#> [1] ""
#> 
#> $datetime_range_begin
#> [1] NA
#> 
#> $datetime_range_end
#> [1] NA
#> 
#> $elapsed_seconds
#> [1] 1.500452
```

## Session Information

For the sake of documentation and reproducibility, the current report
was rendered in the following environment. Click the line below to
expand.

Environment

    #> ─ Session info ───────────────────────────────────────────────────────────────
    #>  setting  value
    #>  version  R version 4.5.2 (2025-10-31)
    #>  os       macOS Sequoia 15.7.2
    #>  system   aarch64, darwin20
    #>  ui       X11
    #>  language en-US
    #>  collate  en_US.UTF-8
    #>  ctype    en_US.UTF-8
    #>  tz       UTC
    #>  date     2025-12-15
    #>  pandoc   3.1.11 @ /usr/local/bin/ (via rmarkdown)
    #>  quarto   NA
    #> 
    #> ─ Packages ───────────────────────────────────────────────────────────────────
    #>  package      * version    date (UTC) lib source
    #>  backports      1.5.0      2024-05-23 [1] CRAN (R 4.5.0)
    #>  bit            4.6.0      2025-03-06 [1] CRAN (R 4.5.0)
    #>  bit64          4.6.0-1    2025-01-16 [1] CRAN (R 4.5.0)
    #>  bslib          0.9.0      2025-01-30 [1] CRAN (R 4.5.0)
    #>  cachem         1.1.0      2024-05-16 [1] CRAN (R 4.5.0)
    #>  checkmate      2.3.3      2025-08-18 [1] CRAN (R 4.5.0)
    #>  cli            3.6.5      2025-04-23 [1] CRAN (R 4.5.0)
    #>  crayon         1.5.3      2024-06-20 [1] CRAN (R 4.5.0)
    #>  curl           7.0.0      2025-08-19 [1] CRAN (R 4.5.0)
    #>  desc           1.4.3      2023-12-10 [1] CRAN (R 4.5.0)
    #>  digest         0.6.39     2025-11-19 [1] CRAN (R 4.5.2)
    #>  dplyr          1.1.4      2023-11-17 [1] CRAN (R 4.5.0)
    #>  evaluate       1.0.5      2025-08-27 [1] CRAN (R 4.5.0)
    #>  farver         2.1.2      2024-05-13 [1] CRAN (R 4.5.0)
    #>  fastmap        1.2.0      2024-05-15 [1] CRAN (R 4.5.0)
    #>  fs             1.6.6      2025-04-12 [1] CRAN (R 4.5.0)
    #>  generics       0.1.4      2025-05-09 [1] CRAN (R 4.5.0)
    #>  glue           1.8.0      2024-09-30 [1] CRAN (R 4.5.0)
    #>  hms            1.1.4      2025-10-17 [1] CRAN (R 4.5.0)
    #>  htmltools      0.5.9      2025-12-04 [1] CRAN (R 4.5.2)
    #>  httr           1.4.7      2023-08-15 [1] CRAN (R 4.5.0)
    #>  jquerylib      0.1.4      2021-04-26 [1] CRAN (R 4.5.0)
    #>  jsonlite       2.0.0      2025-03-27 [1] CRAN (R 4.5.0)
    #>  kableExtra     1.4.0      2024-01-24 [1] CRAN (R 4.5.0)
    #>  knitr        * 1.50       2025-03-16 [1] CRAN (R 4.5.0)
    #>  lifecycle      1.0.4      2023-11-07 [1] CRAN (R 4.5.0)
    #>  magrittr     * 2.0.4      2025-09-12 [1] CRAN (R 4.5.0)
    #>  pillar         1.11.1     2025-09-17 [1] CRAN (R 4.5.0)
    #>  pkgconfig      2.0.3      2019-09-22 [1] CRAN (R 4.5.0)
    #>  pkgdown        2.2.0      2025-11-06 [1] CRAN (R 4.5.0)
    #>  R6             2.6.1      2025-02-15 [1] CRAN (R 4.5.0)
    #>  ragg           1.5.0      2025-09-02 [1] CRAN (R 4.5.0)
    #>  RColorBrewer   1.1-3      2022-04-03 [1] CRAN (R 4.5.0)
    #>  readr          2.1.6      2025-11-14 [1] CRAN (R 4.5.2)
    #>  REDCapR      * 1.6.0.9000 2025-12-15 [1] local
    #>  rlang          1.1.6      2025-04-11 [1] CRAN (R 4.5.0)
    #>  rmarkdown      2.30       2025-09-28 [1] CRAN (R 4.5.0)
    #>  rstudioapi     0.17.1     2024-10-22 [1] CRAN (R 4.5.0)
    #>  sass           0.4.10     2025-04-11 [1] CRAN (R 4.5.0)
    #>  scales         1.4.0      2025-04-24 [1] CRAN (R 4.5.0)
    #>  sessioninfo    1.2.3      2025-02-05 [1] CRAN (R 4.5.0)
    #>  stringi        1.8.7      2025-03-27 [1] CRAN (R 4.5.0)
    #>  stringr        1.6.0      2025-11-04 [1] CRAN (R 4.5.0)
    #>  svglite        2.2.2      2025-10-21 [1] CRAN (R 4.5.0)
    #>  systemfonts    1.3.1      2025-10-01 [1] CRAN (R 4.5.0)
    #>  textshaping    1.0.4      2025-10-10 [1] CRAN (R 4.5.0)
    #>  tibble         3.3.0      2025-06-08 [1] CRAN (R 4.5.0)
    #>  tidyselect     1.2.1      2024-03-11 [1] CRAN (R 4.5.0)
    #>  tzdb           0.5.0      2025-03-15 [1] CRAN (R 4.5.0)
    #>  utf8           1.2.6      2025-06-08 [1] CRAN (R 4.5.0)
    #>  vctrs          0.6.5      2023-12-01 [1] CRAN (R 4.5.0)
    #>  viridisLite    0.4.2      2023-05-02 [1] CRAN (R 4.5.0)
    #>  vroom          1.6.7      2025-11-28 [1] CRAN (R 4.5.2)
    #>  withr          3.0.2      2024-10-28 [1] CRAN (R 4.5.0)
    #>  xfun           0.54       2025-10-30 [1] CRAN (R 4.5.0)
    #>  xml2           1.5.1      2025-12-01 [1] CRAN (R 4.5.2)
    #>  yaml           2.3.12     2025-12-10 [1] CRAN (R 4.5.2)
    #> 
    #>  [1] /Users/runner/work/_temp/Library
    #>  [2] /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library
    #>  * ── Packages attached to the search path.
    #> 
    #> ──────────────────────────────────────────────────────────────────────────────

Report rendered by runner at 2025-12-15, 19:48 +0000 in 10 seconds.
