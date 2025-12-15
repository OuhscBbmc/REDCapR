# Retrieving Longitudinal and Repeating Structures

## Background

This vignette pertains to reading REDCap records from a project that (a)
has longitudinal events or (b) has a repeating measure. The first
section conceptually discusses how REDCap stores complex structures. The
remaining sections describe how to best retrieve complex structures with
the [REDCapTidyieR](https://chop-cgtinformatics.github.io/REDCapTidieR/)
and [REDCapR](https://ouhscbbmc.github.io/REDCapR/) packages.

- If you are new to R or REDCap, consider start with the [Typical REDCap
  Workflow for a Data
  Analyst](https://ouhscbbmc.github.io/REDCapR/articles/workflow-read.html)
  and [Basic REDCapR
  Operations](https://ouhscbbmc.github.io/REDCapR/articles/BasicREDCapROperations.html)
  vignettes and then return to this document.
- If you are reading from a *simple* project, just call REDCapR’s
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html).
- If you want to perform some other operation (such as writing records
  to REDCap), review the [Reference of REDCapR
  functions](https://ouhscbbmc.github.io/REDCapR/reference/index.html)
  to see what is currently available.

If your REDCap project is longitudinal or contains repeating measures, a
single call to the API (or a single export through the browser) will
return a dataset that is not readily analyzed. Instead, the dataset will
resemble Table 5. This isn’t because of a software bug, but because you
haven’t told the software how you would like the data structured. There
isn’t a good way to jam this multidimensional space into a rectangle of
points. Our advice for querying REDCap is the same as querying any
database system: request separate datasets that have a natural “grain”
and assemble them as to fit your analyses.

## Illustration of How Data Points are Structured

### Possible Table Structures

Suppose you have two patients (*i.e.*, “1” and “2”) with three intake
variables (*i.e.*, `height`, `weight`, and `bmi`). If you record this on
a piece of paper, it would probably look like Table 1. The table’s
*grain* is “patient”, because each row represents a distinct patient.
Understanding the grain of each structure below will help you understand
how the structures are re-expressions of the same set of observations.

#### Table 1: patient grain

[TABLE]

This patient-grain structure is how the data points are most comfortably
inputted by humans into REDCap, and it is the default when exported
through the browser and API. However it is stored differently by
REDCap’s internal database.

REDCap’s flexibility is a driver of its success. Once a research team
learns REDCap, it can reuse the knowledge to capture anything from
leukemia to lunch orders. But to achieve this flexibility in the world
of REDCap and EMRs, data are stored along the observation grain. In
computer science, this is commonly called an EAV structure (which stands
for entity-attribute-value). The patient’s ID is the entity, the
variable type is the attribute, and the observed point is the value. It
can also be thought of as a “key-value store” nested within a patient
(where “key” is a synonym of “attribute”). Notice that the two wider
rows have morphed into six skinnier rows –one row per observation. If
you are a curious database administrator, peek at the the structure and
rows of the `redcap_data` table. It is the most important table in the
database.

#### Table 2: observation grain for `intake` instrument

REDCap and EMR databases store observations in their underlying table.
This table is a simplification of the `redcap_data` table, which is the
heart of the REDCap’s internal database.

[TABLE]

If the investigation gains a longitudinal or repeating component, it
becomes necessary to include the dimension of time. Suppose the protocol
specifies five time points; the blood pressure instrument is captured at
times 1, 2, & 3 while the laboratory instrument is captured at times 1 &
2. If you record this stage on paper, it will likely resemble Tables 3a
& 3b: one for vitals and one for labs.

#### Table 3a: patient-time grain for `blood_pressure` instrument

[TABLE]

#### Table 3b: patient-time grain for `laboratory` instrument

[TABLE]

When these measurements are added to REDCap’s observation table, it
resembles Table 4. Two new columns are required to uniquely distinguish
the instrument and its ordinal position. Notice the first six rows are
copied from Table 2; they have empty values for the repeating structure.

#### Table 4: observation grain for `intake`, `blood_pressure`, and `laboratory` instruments

[TABLE]

As mentioned above, there isn’t a universally good way to coerce Tables
1, 3a, and 3b into a single rectangle because the rows represent
different things. Or from REDCap’s perspective, there’s not a good
transformation of `redcap_data` (*i.e.*, Table 4) that is appropriate
for most statistical programs.

When forced to combine the different entities, the best option is
probably Table 5. We call this a “block dataset”, borrowing from linear
algebra’s [block matrix](https://mathworld.wolfram.com/BlockMatrix.html)
term. You can see the mishmash of tables masquerading as a unified
dataset. The rows lack the conceptual coherency of Tables 1, 3a, & 3b.

#### Table 5: mishmashed grain

[TABLE]

A block dataset is not inherently bad. After all, Table 5 can be
unambiguously transformed to and from Table 4.

Table 5’s primary limitation is that a block dataset is not understood
by analysis software used in conventional medical research. At best, the
dataset always will require additional preparation. At worst, the
analyst will model the rows inappropriately, which will produce
misleading conclusions.

Table 5’s secondary limitation is inefficiency. The empty cells aren’t
computationally free. Every cell must be queried from the database and
concatenated in REDCap’s web server in order to return Table 5 in the
plain-text csv, json, or xml format. In our simple example, more than
half of the block dataset’s cells are wasted. The emptiness frequently
exceeds 90% in real-world REDCap projects (because they tend to have
many more variables and repeating instances). The emptiness always
exceeds 99.9% in real-world EMRs.

For this reason, REDCap and EMR design their observation table to
resemble the computational structure of a [sparse
matrix](https://en.wikipedia.org/wiki/Sparse_matrix). (The only
important difference is that REDCap’s unspecified cells are interpreted
as null/empty, while a sparse matrix’s unspecified cells are interpreted
as zero.)

> In the case of a sparse matrix, substantial memory requirement
> reductions can be realized by storing only the non-zero entries.
> Depending on the number and distribution of the non-zero entries,
> different data structures can be used and yield huge savings in memory
> when compared to the basic approach. The trade-off is that accessing
> the individual elements becomes more complex and additional structures
> are needed to be able to recover the original matrix unambiguously.
> (source: [Wikipedia: Sparse matrix -
> storage](https://en.wikipedia.org/wiki/Sparse_matrix#Storage))

### Terminology

#### observation

The term “observation” in the world of [medical
databases](https://ohdsi.github.io/CommonDataModel/cdm60.html#OBSERVATION)
has a different and more granular meaning than it does in the [tidyverse
literature](https://r4ds.had.co.nz/tidy-data.html#tidy-data-1). In
REDCap and medical databases, an observation is typically a single point
(such as a heart rate or systolic blood pressure) with contextual
variables (such as the the associated date, unit, visit ID, and patient
ID); see Tables 2 and 4 above. In the tidyverse publications, an
observation is roughly equivalent to a REDCap instrument (which is a
collection of associated values); see Tables 1, 3a, and 3b.

(We use the medical terminology in this vignette. We’d love to hear if
someone has another term that’s unambiguous.)

| Concept                           | REDCap & Medical World | Tidyverse Literature |
|:----------------------------------|:-----------------------|:---------------------|
| A single measured point           | observation            | value                |
| A collection of associated points | instrument             | observation          |

## Retrieving from REDCap

Many new REDCap users will submit a single API call and unintentionally
obtain something like Table 5; they then try to extract something
resembling Tables 1, 3a, & 3b. Although this can be successful, we
strongly discourage it. The code is difficult to maintain and is not
portable to REDCap projects with different instruments. (The code is
really slow and ugly too.)

Our advice is to start before Table 5 is assembled –retrieve the
information in a better way. Like other database systems, request the
three tables separately from the server and then combine them on your
desktop to fit your analyses if necessary.

Two approaches are appropriate for most scenarios:

1.  multiple calls to REDCapR’s
    [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html),
    or
2.  a single call to REDCapTidieR’s
    [`redcap_read_tidy()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap_tidy.html).

The code in the vignette requires the magrittr package for the `%>%`
(alternatively you can use `|>` if you’re using R 4.0.2 or later).

The vignette uses these credentials to retrieve the practice/fake
dataset. **This is not appropriate for datasets containing PHI or other
sensitive information.** Please see [Part 2 - Retrieve Protected
Token](https://ouhscbbmc.github.io/REDCapR/articles/workflow-read.html#part-2---retrieve-protected-token)
of the [Typical REDCap Workflow for a Data
Analyst](https://ouhscbbmc.github.io/REDCapR/articles/workflow-read.html)
vignette for secure approaches.

``` r
# Support pipes
library(magrittr)

# Retrieve token
path_credential <- system.file("misc/dev-2.credentials", package = "REDCapR")
credential  <- REDCapR::retrieve_credential_local(
  path_credential = path_credential,
  project_id      = 62
)
```

### One REDCapR Call for Each Table

The tidy datasets represented in Tables 1, 3a, and 3b can be obtained by
calling REDCapR three times –one call per table. Using the `forms`
parameter, pass “intake” to get Table 1, “blood_pressure” to get Table
3a, and “laboratory” to get Table 3b.

Although it is not required, we recommend specifying a
[`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
object to ensure the desired variable data types.

#### Retrieve patient-level table (corresponding to Table 1)

``` r
col_types_intake <-
  readr::cols_only(
    record_id                 = readr::col_integer(),
    height                    = readr::col_double(),
    weight                    = readr::col_double(),
    bmi                       = readr::col_double()
  )

ds_intake <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri, # From the previous code snippet.
    token       = credential$token,
    forms       = c("intake"),
    col_types   = col_types_intake,
    verbose     = FALSE,
  )$data

ds_intake
```

[TABLE]

#### Retrieve patient-time-level tables (corresponding to Tables 3a & 3b)

``` r
col_types_blood_pressure <-
  readr::cols(
    record_id                 = readr::col_integer(),
    redcap_repeat_instrument  = readr::col_character(),
    redcap_repeat_instance    = readr::col_integer(),
    sbp                       = readr::col_double(),
    dbp                       = readr::col_double(),
    blood_pressure_complete   = readr::col_integer()
  )

ds_blood_pressure <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token,
    forms       = c("blood_pressure"),
    col_types   = col_types_blood_pressure,
    verbose     = FALSE
  )$data

ds_blood_pressure %>%
  tidyr::drop_na(redcap_repeat_instrument)
```

[TABLE]

``` r

col_types_laboratory  <-
  readr::cols(
    record_id                 = readr::col_integer(),
    redcap_repeat_instrument  = readr::col_character(),
    redcap_repeat_instance    = readr::col_integer(),
    lab                       = readr::col_character(),
    conc                      = readr::col_character(),
    laboratory_complete       = readr::col_integer()
  )

ds_laboratory  <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token,
    forms       = c("laboratory"),
    col_types   = col_types_laboratory,
    verbose     = FALSE
  )$data

ds_laboratory %>%
  tidyr::drop_na(redcap_repeat_instrument)
```

[TABLE]

#### Retrieve block tables (corresponding to Table 5)

If for some reason you need the block dataset through the API, one call
will retrieve it.

``` r
ds_block <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token,
    col_types   = readr::cols(.default = readr::col_character()),
    verbose     = FALSE,
  )$data

ds_block
```

[TABLE]

### One REDCapTidieR Call for All Tables

[REDCapTidieR](https://chop-cgtinformatics.github.io/REDCapTidieR/)’s
initial motivation is to facilitate longitudinal analyses and promote
[tidy](https://r4ds.hadley.nz/data-tidy.html) data hygiene.

{Stephan Kadauke & Richard Hanna, please represent your package as you
wish. Tell me if I’ve positioned it differently than you would have.}

### Choosing between the Approaches

When retrieving data from REDCap, we recommend calling
[REDCapTidieR](https://chop-cgtinformatics.github.io/REDCapTidieR/) in
many scenarios, such as:

- you are new to managing or analyzing data with R, or
- your analyses will require most of the dataset’s rows or columns, or
- you’d benefit from some of the auxiliary information in
  [REDCapTidieR’s
  supertibble](https://chop-cgtinformatics.github.io/REDCapTidieR/articles/REDCapTidieR.html#tidying-redcap-exports),
  such as the instrument’s structure.

However we recommend calling
[REDCapR](https://ouhscbbmc.github.io/REDCapR/) in other scenarios. It
could be worth calling REDCapR multiple times if:

- you are performing some operation other than retrieving/reading data
  from REDCap,
- you are comfortable with managing and analyzing data with R, or
- your analyses require only a fraction of the data (such as (a) you
  need only the first event, or (b) the analyses don’t involve most of
  the instruments), or
- you want to specify the variables’ data types with
  [`readr::cols()`](https://readr.tidyverse.org/reference/cols.html).

If in doubt, start with REDCapTidieR. Escalate to REDCapR if your
download time is too long and might be decreased by reducing the
information retrieved from the server and transported across the
network.

And of course many scenarios are solved best with a combination of both
packages, such as (a) [REDCapR](https://ouhscbbmc.github.io/REDCapR/)
populates the initial demographics in REDCap, (b) research staff enter
measures collected from patients over time, (c)
[REDCapTidieR](https://chop-cgtinformatics.github.io/REDCapTidieR/)
retrieves the complete longitudinal dataset, (d)
[dplyr](https://dplyr.tidyverse.org/) joins the tibbles, and finally (e)
[lme4](https://cran.r-project.org/package=lme4/vignettes/lmer.pdf) tests
hypotheses involving [patient
trajectories](https://datascienceplus.com/analysing-longitudinal-data-multilevel-growth-models-i/)
over time.

### Escalating to REDCapR

Even if you think you’ll need REDCapR’s low-level control, consider
starting with REDCapTidieR anyway. …particularly if you are unsure how
to specify the grain of each table. The structure of REDCapTidieR’s
tables easily compatible with conventional analyses. If you need the
performance of REDCapR but are unsure how the tables should look, simply
execute something like
`REDCapTidieR::redcap_read_tidy(url, project_token)` and study its
output. Then try to mimic it exactly with
[`REDCapR::redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
calls.

Finally, cull unwanted cells using the parameters of
[`REDCapR::redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md).
These data points will not even leave the REDCap instance, which will
improve performance. Some possible strategies include passing
[arguments](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html#arguments)
to

- `forms`: this will retrieve only the specified instruments/forms.
  Beginners should start here. It is easy to conceptualize and usually
  has a big increase in speed for just a little development work.
- `events`: this will retrieve only the desired events within a
  longitudinal project. For instance if the analyses involve only the
  “intake” and “follow up \#1” events, leave follow ups \#2, \#3, and
  \#4 on the server.
- `fields`: this is more granular than `forms`. It can be combined with
  calls to `forms`, such as passing `"bmi"` to fields and
  `c("blood_pressure", "laboratory")` to forms.
- `records`: in the example scenario, this will pluck individual
  patients and their associated events and repeating instances. To be
  useful in research, it’s usually combined with other REDCapR calls.
  See the [Read a subset of records, conditioned on the values in some
  variables](https://ouhscbbmc.github.io/REDCapR/articles/BasicREDCapROperations.html#read-a-subset-of-records-conditioned-on-the-values-in-some-variables)
  section of REDCapR’s [Basic REDCapR
  Operations](https://ouhscbbmc.github.io/REDCapR/articles/BasicREDCapROperations.html)
  vignette.
- `filter_logic`: this will leverage the observation values to limit the
  rows returned. Because the underlying table does not index the obs
  values, this will be less computationally efficient than the options
  above.
- `datetime_range_begin` & `datetime_range_end`: this will return only
  the records that have been created or modified during the specified
  window.

Note that the efficiency gain from moving from the block dataset to
REDCapTidieR is different than the gain from moving from REDCapTidieR to
REDCapR. When moving to from Table 5 to a [REDCapTidieR
Supertibble](https://chop-cgtinformatics.github.io/REDCapTidieR/articles/glossary.html#supertibble),
you are eliminating empty cells that will never contain worthwhile data.
When moving from a REDCapTidieR Supertibble call to a collection of
REDCapR calls, you are eliminating cells that contain data, but may not
be relevant to your analysis (such as a patient’s name or the time a lab
specimen was collected). {This paragraph needs work.}

## Advanced

### Longitudinal

{TODO: Generalize the argument to longitudinal events}

[TABLE]

### Caching Results to Improve Performance

If escalating to REDCapR didn’t decrease the duration enough, consider
the strategy of calling REDCap only once per day (with either package)
and saving the results to a secured disk. This will be efficient when
the analyses require a *large* dataset, but not a *real-time* dataset.

In many retrospective projects, multiple analyses during the day can
reuse the same dataset retrieved the night before (with a function like
[`readr::write_rds()`](https://readr.tidyverse.org/reference/read_rds.html)).
This has helped our complicated investigations when multiple
statisticians frantically tackle overlapping aspects before a funder’s
deadline.

Essentially you are transferring security responsibilities from REDCap
to the file server. To balance its advantages, the approach’s drawbacks
include:

- extra effort is required to create, secure, and maintain a networked
  drive that is accessible to only authorized analysts. This will take
  15-60 minutes, depending on your institution.
- extra effort is required to create an automated program to retrieve
  and cache the dataset every night. See \[CDS\] for a head start.
- REDCap’s logs will not support a meaningful audit because no human is
  accessing the API. User access audits are now the responsibility of
  the file system.

### Caching Results for other Languages

Packages for other programming languages have been developed that access
REDCap’s API, such [PyCap](http://redcap-tools.github.io/PyCap/) and
[PhpCap](https://github.com/iuredcap/phpcap). Please see a more complete
list at <https://redcap-tools.github.io/projects/>. The caching strategy
described above may also benefit your investigation if:

- it uses a language like SAS that does not support packages. We
  strongly discourage deploying loose scripts that call the API. When
  something is fixed in the original script, it must be distributed by
  the developer to the ~50 client institutions, then it must by copied
  to the ~100 projects within each institution. In contrast, when a
  developer updates a package distributed through a repository like
  CRAN, the client needs to run only
  [`base::update.packages()`](https://stat.ethz.ch/R-manual/R-devel/library/utils/html/update.packages.html)
  once per machine to update all its packages –not just REDCap packages.
  Data scientists already do this regularly.

- it uses a language like Julia that lacks a stable or updated package.
  The REDCap developers are always releasing useful features (*e.g.*,
  repeated measures) that improve the quality and efficiency of your
  research. Leverage them.

- your investigation incorporates multiple programming languages and you
  would like the analysis team to use a consistent dataset. In this
  scenario, we recommend the code save the same R dataset in multiple
  file formats, such as a csv file and a feather file.

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
    #>  REDCapR        1.6.0.9000 2025-12-15 [1] local
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
