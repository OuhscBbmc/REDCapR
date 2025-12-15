# Advanced REDCapR Operations

This vignette covers the the less-typical uses of
[REDCapR](https://github.com/OuhscBbmc/REDCapR) to interact with
[REDCap](https://projectredcap.org/) through its API.

## Next Steps

## Set project-wide values

There is some information that is specific to a REDCap project, as
opposed to an individual operation. This includes the (1) uri of the
server, and the (2) token for the user’s project. This is hosted on a
machine used in REDCapR’s public test suite, so you can run this example
from any computer. Unless tests are running.

*Other than PHI-free demos, we strongly suggest storing tokens securely
and avoiding hard-coding them like below. Our recommendation is to store
tokens [in a
database](https://ouhscbbmc.github.io/REDCapR/articles/SecurityDatabase.html).
If that is not feasible for your institution, consider storing them in a
secured csv and retrieving with
[`REDCapR::retrieve_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.html).*

``` r
library(REDCapR) #Load the package into the current R session.
uri                   <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
token_simple          <- "9A068C425B1341D69E83064A2D273A70"
token_longitudinal    <- "DA6F2BB23146BD5A7EA3408C1A44A556"
```

## Converting from tall/long to wide

*Disclaimer*: Occasionally we’re asked for a longitudinal dataset to be
converted from a “long/tall format” (where typically each row is one
observation for a participant) to a “wide format” (where each row is on
participant). Usually we advise against it. Besides all the database
benefits of a long structure, a wide structure restricts your options
with the stat routine. No modern longitudinal analysis procedures
(*e.g.*, growth curve models or multilevel/hierarchical models) accept
wide. You’re pretty much stuck with repeated measures anova, which is
very inflexible for real-world medical-ish analyses. It requires a
patient to have a measurement at every time point; otherwise the anova
excludes the patient entirely.

However we like going wide to produce visual tables for publications,
and here’s one way to do it in R. First retrieve the dataset from
REDCap.

``` r
library(magrittr)
suppressPackageStartupMessages(requireNamespace("dplyr"))
suppressPackageStartupMessages(requireNamespace("tidyr"))
events_to_retain  <- c("dose_1_arm_1", "visit_1_arm_1", "dose_2_arm_1", "visit_2_arm_1")

ds_long <- REDCapR::redcap_read_oneshot(redcap_uri = uri, token = token_longitudinal)$data
```

    #> 18 records and 125 columns were read from REDCap in 0.2 seconds.  The http status code was 200.

``` r
ds_long %>%
  dplyr::select(study_id, redcap_event_name, pmq1, pmq2, pmq3, pmq4)
```

    #> # A tibble: 18 × 6
    #>    study_id redcap_event_name         pmq1  pmq2  pmq3  pmq4
    #>       <dbl> <chr>                    <dbl> <dbl> <dbl> <dbl>
    #>  1      100 enrollment_arm_1            NA    NA    NA    NA
    #>  2      100 dose_1_arm_1                 2     2     1     1
    #>  3      100 visit_1_arm_1                1     0     0     0
    #>  4      100 dose_2_arm_1                 3     1     0     0
    #>  5      100 visit_2_arm_1                0     1     0     0
    #>  6      100 final_visit_arm_1           NA    NA    NA    NA
    #>  7      220 enrollment_arm_1            NA    NA    NA    NA
    #>  8      220 dose_1_arm_1                 0     1     0     2
    #>  9      220 visit_1_arm_1                0     3     1     0
    #> 10      220 dose_2_arm_1                 1     2     0     1
    #> 11      220 visit_2_arm_1                3     4     1     0
    #> 12      220 final_visit_arm_1           NA    NA    NA    NA
    #> 13      304 enrollment_arm_2            NA    NA    NA    NA
    #> 14      304 deadline_to_opt_ou_arm_2    NA    NA    NA    NA
    #> 15      304 first_dose_arm_2             0     1     0     0
    #> 16      304 first_visit_arm_2            2     0     0     0
    #> 17      304 final_visit_arm_2           NA    NA    NA    NA
    #> 18      304 deadline_to_return_arm_2    NA    NA    NA    NA

When widening only one variable (*e.g.*, `pmq1`), the code’s pretty
simple:

``` r
ds_wide <-
  ds_long %>%
  dplyr::select(study_id, redcap_event_name, pmq1) %>%
  dplyr::filter(redcap_event_name %in% events_to_retain) %>%
  tidyr::pivot_wider(
    id_cols     = study_id,
    names_from  = redcap_event_name,
    values_from = pmq1
  )
ds_wide
```

    #> # A tibble: 2 × 5
    #>   study_id dose_1_arm_1 visit_1_arm_1 dose_2_arm_1 visit_2_arm_1
    #>      <dbl>        <dbl>         <dbl>        <dbl>         <dbl>
    #> 1      100            2             1            3             0
    #> 2      220            0             0            1             3

In some scenarios, multiple variables (*e.g.*, `pmq1` - `pmq4`) can be
widened in a single
[`tidyr::pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
operation. This example contains the additional wrinkle that the REDCap
event names “first_dose” and “first_visit” are renamed “dose_1” and
“visit_1”, which will help all the values be dose and visit values be
proper numbers.

``` r
pattern <- "^(\\w+?)_arm_(\\d)$"
ds_wide <-
  ds_long %>%
  dplyr::select(study_id, redcap_event_name, pmq1, pmq2, pmq3, pmq4) %>%
  dplyr::mutate(
    event = sub(pattern, "\\1", redcap_event_name),
    event = dplyr::recode(event, "first_dose"="dose_1", "first_visit"="visit_1"),
    arm   = as.integer(sub(pattern, "\\2", redcap_event_name))
  ) %>%
  dplyr::select(study_id, event, arm, pmq1, pmq2, pmq3, pmq4) %>%
  dplyr::filter(!(event %in%
    c("enrollment", "final_visit", "deadline_to_return", "deadline_to_opt_ou")
  )) %>%
  tidyr::pivot_wider(
    id_cols     = c(study_id, arm),
    names_from  = event,
    values_from = c(pmq1, pmq2, pmq3, pmq4)
  )

ds_wide
```

    #> # A tibble: 3 × 18
    #>   study_id   arm pmq1_dose_1 pmq1_visit_1 pmq1_dose_2 pmq1_visit_2 pmq2_dose_1
    #>      <dbl> <int>       <dbl>        <dbl>       <dbl>        <dbl>       <dbl>
    #> 1      100     1           2            1           3            0           2
    #> 2      220     1           0            0           1            3           1
    #> 3      304     2           0            2          NA           NA           1
    #> # ℹ 11 more variables: pmq2_visit_1 <dbl>, pmq2_dose_2 <dbl>,
    #> #   pmq2_visit_2 <dbl>, pmq3_dose_1 <dbl>, pmq3_visit_1 <dbl>,
    #> #   pmq3_dose_2 <dbl>, pmq3_visit_2 <dbl>, pmq4_dose_1 <dbl>,
    #> #   pmq4_visit_1 <dbl>, pmq4_dose_2 <dbl>, pmq4_visit_2 <dbl>

However, in other widening scenarios, it can be easier to go even
longer/taller (*e.g.*, `ds_eav`) before reversing direction and going
wide.

``` r
ds_eav <-
  ds_long %>%
  dplyr::select(study_id, redcap_event_name, pmq1, pmq2, pmq3, pmq4) %>%
  dplyr::mutate(
    event = sub(pattern, "\\1", redcap_event_name),
    event = dplyr::recode(event, "first_dose" = "dose_1", "first_visit" = "visit_1"),
    arm   = as.integer(sub(pattern, "\\2", redcap_event_name))
  ) %>%
  dplyr::select(study_id, event, arm, pmq1, pmq2, pmq3, pmq4) %>%
  tidyr::pivot_longer(
    cols      = c(pmq1, pmq2, pmq3, pmq4),
    names_to  = "key",
    values_to = "value"
  ) %>%
  # For old versions of tidyr that predate `pivot_wider()`:
  # tidyr::gather(key=key, value=value, pmq1, pmq2, pmq3, pmq4) %>%
  dplyr::filter(!(event %in% c(
    "enrollment", "final_visit", "deadline_to_return", "deadline_to_opt_ou")
  )) %>%
  dplyr::mutate( # Simulate correcting for mismatched names across arms:
    key = paste0(key, "_", event)
  ) %>%
  dplyr::select(-event)

# Show the first 10 rows of the EAV table.
ds_eav %>%
  head(10)
```

    #> # A tibble: 10 × 4
    #>    study_id   arm key          value
    #>       <dbl> <int> <chr>        <dbl>
    #>  1      100     1 pmq1_dose_1      2
    #>  2      100     1 pmq2_dose_1      2
    #>  3      100     1 pmq3_dose_1      1
    #>  4      100     1 pmq4_dose_1      1
    #>  5      100     1 pmq1_visit_1     1
    #>  6      100     1 pmq2_visit_1     0
    #>  7      100     1 pmq3_visit_1     0
    #>  8      100     1 pmq4_visit_1     0
    #>  9      100     1 pmq1_dose_2      3
    #> 10      100     1 pmq2_dose_2      1

``` r
# Spread the EAV to wide.
ds_wide_2 <-
  ds_eav %>%
  tidyr::pivot_wider(
    id_cols     = c(study_id, arm),
    names_from  = key,
    values_from = value
  )
# For old versions of tidyr that predate `pivot_wider()`:
# tidyr::spread(key=key, value=value)
ds_wide_2
```

    #> # A tibble: 3 × 18
    #>   study_id   arm pmq1_dose_1 pmq2_dose_1 pmq3_dose_1 pmq4_dose_1 pmq1_visit_1
    #>      <dbl> <int>       <dbl>       <dbl>       <dbl>       <dbl>        <dbl>
    #> 1      100     1           2           2           1           1            1
    #> 2      220     1           0           1           0           2            0
    #> 3      304     2           0           1           0           0            2
    #> # ℹ 11 more variables: pmq2_visit_1 <dbl>, pmq3_visit_1 <dbl>,
    #> #   pmq4_visit_1 <dbl>, pmq1_dose_2 <dbl>, pmq2_dose_2 <dbl>,
    #> #   pmq3_dose_2 <dbl>, pmq4_dose_2 <dbl>, pmq1_visit_2 <dbl>,
    #> #   pmq2_visit_2 <dbl>, pmq3_visit_2 <dbl>, pmq4_visit_2 <dbl>

Lots of packages and documentation exist. Our current preference is the
[tidyverse approach](https://tidyr.tidyverse.org/articles/pivot.html) to
pivoting, but the [data.table
approach](https://www.r-bloggers.com/2019/03/creating-blazing-fast-pivot-tables-from-r-with-data-table-now-with-subtotals-using-grouping-sets/)
is worth considering if you’re comfortable with that package. This
[Stack Overflow
post](https://stackoverflow.com/questions/10589693/convert-data-from-long-format-to-wide-format-with-multiple-measure-columns/)
describes several ways. We recommend against the
[reshape](https://CRAN.R-project.org/package=reshape) and
[reshape2](https://CRAN.R-project.org/package=reshape2) packages,
because their developers have replaced them with the
[tidyr](https://CRAN.R-project.org/package=tidyr) functions described
above.

## Query the Underlying MySQL Database

If you require a feature that is not available from your instance’s API,
first upgrade your institution’s REDCap instance and see if the feature
has been added recently. Second, check if someone has released the
desired API-like features as an [REDCap External
Module](https://redcap.vanderbilt.edu/consortium/modules/).

Third, you may need to query the database underneath REDCap’s web
server. The [Transfer
Credentials](https://ouhscbbmc.github.io/REDCapR/articles/SecurityDatabase.html#transfer-credentials)
section of the [Security Database
Vignette](https://ouhscbbmc.github.io/REDCapR/articles/SecurityDatabase.html#transfer-credentials)
provides a complete example of using R to query the MySQL database
through odbc.

We find it’s best to develop the query in [MySQL
Workbench](https://www.mysql.com/products/workbench/), then copy the
code to R (or alternatively, use
[`OuhscMunge::execute_sql_file()`](https://ouhscbbmc.github.io/OuhscMunge/reference/execute_sql_file.html)).

Here is an example that retrieves the `first_submit_time`, which is
helpful if you need a timestamp from surveys that were not marked as
completed. Replace ‘444’ with your pid, and 1001 through 1003 with the
desired events.

``` sql
SELECT
  p.participant_id      as participant_survey_id
  ,r.record             as record_id
  ,p.event_id
  ,e.descrip            as event_name
  ,r.first_submit_time
  ,r.completion_time

  -- ,p.*
  -- ,r.*
FROM redcapv3.redcap_surveys_participants     as p
  left  join redcapv3.redcap_surveys_response as r on p.participant_id = r.participant_id
  left  join redcapv3.redcap_events_metadata  as e on p.event_id       = e.event_id
WHERE
  p.survey_id = 444
  and
  p.event_id in (
    1001, -- start of the year
    1002, -- mid term
    1003  -- end of year
  )
```

## SSL Options

The official [cURL site](https://curl.se/) discusses the process of
using SSL to verify the server being connected to.

Use the SSL cert file that come with the `openssl` package.

``` r
cert_location <- system.file("cacert.pem", package = "openssl")
if (file.exists(cert_location)) {
  config_options         <- list(cainfo = cert_location)
  ds_different_cert_file <- redcap_read_oneshot(
    redcap_uri     = uri,
    token          = token_simple,
    config_options = config_options
  )$data
}
```

    #> 5 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

Force the connection to use SSL=3 (which is not preferred, and possibly
insecure).

``` r
config_options <- list(sslversion = 3)
ds_ssl_3 <- redcap_read_oneshot(
  redcap_uri     = uri,
  token          = token_simple,
  config_options = config_options
)$data
```

    #> 5 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

``` r
config_options <- list(ssl.verifypeer = FALSE)
ds_no_ssl <- redcap_read_oneshot(
  redcap_uri     = uri,
  token          = token_simple,
  config_options = config_options
)$data
```

    #> 5 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.

## Convert SPSS Output to REDCap data dictionary

The solution <https://stackoverflow.com/a/51013678/1082435> converts
levels specified in SPSS output like

    SEX       0 Male
              1 Female

    LANGUAGE  1 English
              2 Spanish
              3 Other
              6 Unknown

to a dropdown choices in a REDCap data dictionary like

``` csv
Variable Values
SEX      0, Male | 1, Female
LANGUAGE 1, English | 2, Spanish | 3, Other | 6, Unknown
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
    #>  purrr          1.2.0      2025-11-04 [1] CRAN (R 4.5.0)
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
    #>  tidyr          1.3.1      2024-01-24 [1] CRAN (R 4.5.0)
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

Report rendered by runner at 2025-12-15, 19:47 +0000 in 2 seconds.
