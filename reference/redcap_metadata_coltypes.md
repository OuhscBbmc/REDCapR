# Suggests a col_type for each field in a REDCap project

This function inspects a REDCap project to determine a
[`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
object that is compatible with the the project's current definition. It
can be copied and pasted into the R code so future calls to the server
will produce a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with an equivalent set of data types.

## Usage

``` r
redcap_metadata_coltypes(
  redcap_uri,
  token,
  print_col_types_to_console = TRUE,
  http_response_encoding = "UTF-8",
  locale = readr::default_locale(),
  verbose = FALSE,
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

- print_col_types_to_console:

  Should the
  [`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
  object be printed to the console?

- http_response_encoding:

  The encoding value passed to
  [`httr::content()`](https://httr.r-lib.org/reference/content.html).
  Defaults to 'UTF-8'.

- locale:

  a
  [`readr::locale()`](https://readr.tidyverse.org/reference/locale.html)
  object to specify preferences like number, date, and time formats.
  This object is passed to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).
  Defaults to
  [`readr::default_locale()`](https://readr.tidyverse.org/reference/locale.html).

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

A [`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
object is returned, which can be passed to
[`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
or
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md).

Additionally objected is printed to the console, see the Details below.

## Details

`redcap_metadata_coltypes()` returns a
[`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
object in two ways. First, a literal object is returned that can be
passed to
[`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
or
[`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md).

Second, the function acts as a code generator. It prints text to the
console so that it can be copied and pasted into an R file. This is
useful to (a) document what fields and data types are expected, and (b)
adjust those fields and data types if the defaults can be customized for
your needs. For instance, you may choose to exclude some variables or
tweak a data type (*e.g.*, changing a patient's height from an integer
to a double).

When printing to the console, each data type decision is accompanied by
an explanation on the far right. See the output from the examples below.
Please file an [issue](https://github.com/OuhscBbmc/REDCapR/issues) if
you think something is too restrictive or can be improved.

The overall heuristic is assign a data type down a waterfall of
decisions:

1.  Is the field built into REDCap? This includes an autonumber
    `record_id`, `redcap_event_name`, `redcap_repeat_instrument`,
    `redcap_repeat_instance`, and an instrument's completion status.

2.  What is the field's type? For example, sliders should be an
    [integer](https://stat.ethz.ch/R-manual/R-devel/library/base/html/integer.html),
    while check marks should be
    [logical](https://rdrr.io/r/base/logical.html)(https://stat.ethz.ch/R-manual/R-devel/library/base/html/logical.html.

3.  If the field type is "text", what is the validation type? For
    instance, a postal code should be a
    [character](https://stat.ethz.ch/R-manual/R-devel/library/base/html/character.html)
    (even though it looks like a number), a "mdy" should be cast to a
    [date](https://stat.ethz.ch/R-manual/R-devel/library/base/html/date.html),
    and a "number_2dp" should be cast to a [floating
    point](https://stat.ethz.ch/R-manual/R-devel/library/base/html/double.html)

4.  If the field type or validation type is not recognized, the field
    will be cast to
    [character](https://stat.ethz.ch/R-manual/R-devel/library/base/html/character.html).
    This will happen when REDCap develops & releases a new type. If you
    see something like, "# validation doesn't have an associated
    col_type. Tell us in a new REDCapR issue", please make sure REDCapR
    is running the newest [GitHub
    release](https://ouhscbbmc.github.io/REDCapR/index.html#installation-and-documentation)
    and file a new [issue](https://github.com/OuhscBbmc/REDCapR/issues)
    if it's still not recognized.

For details of the current implementation, the decision logic starts
about half-way down in the [function's source
code](https://github.com/OuhscBbmc/REDCapR/blob/HEAD/R/redcap-metadata-coltypes.R)

\**Validation does NOT Guarantee Conformity*

If you're coming to REDCap from a database world, this will be
unexpected. A validation type does NOT guarantee that all retrieved
values will conform to complementary the data type. The validation
setting affects only the values entered *after* the validation was set.

For example, if values like "abcd" where entered in a field for a few
months, then the project manager selected the "integer" validation
option, all those "abcd" values remain untouched.

This is one reason `redcap_metadata_coltypes()` prints it suggestions to
the console. It allows the developer to adjust the specifications to
match the values returned by the API. The the "abcd" scenario, consider
(a) changing the type from `col_integer` to `col_character`, (b)
excluding the trash values, then (c) in a
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)
statement, use
[`readr::parse_integer()`](https://readr.tidyverse.org/reference/parse_atomic.html)
to cast it to the desired type.

## References

The official documentation can be found on the 'API Help Page' and 'API
Examples' pages on the REDCap wiki (*i.e.*,
https://community.projectredcap.org/articles/456/api-documentation.html
and https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus
REDCap administrator to send you the static material.

## Author

Will Beasley, Philip Chase

## Examples

``` r
# \dontrun{
uri      <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"

# A simple project
token      <- "9A068C425B1341D69E83064A2D273A70" # simple
col_types  <- redcap_metadata_coltypes(uri, token)
#> # col_types <- readr::cols_only( # Use `readr::cols_only()` to restrict the retrieval to only these columns
#> col_types <- readr::cols( # Use `readr::cols()` to include unspecified columns
#>   # [field]                       [readr col_type]            [explanation for col_type]
#>   record_id                     = readr::col_character()  , # DAGs are enabled for the project
#>   name_first                    = readr::col_character()  , # field_type is text and validation isn't set
#>   name_last                     = readr::col_character()  , # field_type is text and validation isn't set
#>   address                       = readr::col_character()  , # field_type is note
#>   telephone                     = readr::col_character()  , # validation is 'phone'
#>   email                         = readr::col_character()  , # validation is 'email'
#>   dob                           = readr::col_date()       , # validation is 'date_ymd'
#>   age                           = readr::col_character()  , # field_type is text and validation isn't set
#>   sex                           = readr::col_character()  , # field_type is radio
#>   demographics_complete         = readr::col_integer()    , # completion status of form/instrument
#>   height                        = readr::col_double()     , # validation is 'number'
#>   weight                        = readr::col_integer()    , # validation is 'integer'
#>   bmi                           = readr::col_character()  , # field_type is calc
#>   comments                      = readr::col_character()  , # field_type is note
#>   mugshot                       = readr::col_character()  , # field_type is file
#>   health_complete               = readr::col_integer()    , # completion status of form/instrument
#>   race___1                      = readr::col_logical()    , # field_type is checkbox
#>   race___2                      = readr::col_logical()    , # field_type is checkbox
#>   race___3                      = readr::col_logical()    , # field_type is checkbox
#>   race___4                      = readr::col_logical()    , # field_type is checkbox
#>   race___5                      = readr::col_logical()    , # field_type is checkbox
#>   race___6                      = readr::col_logical()    , # field_type is checkbox
#>   ethnicity                     = readr::col_character()  , # field_type is radio
#>   interpreter_needed            = readr::col_logical()    , # field_type is truefalse
#>   race_and_ethnicity_complete   = readr::col_integer()    , # completion status of form/instrument
#> )
redcap_read_oneshot(uri, token, col_types = col_types)$data
#> 5 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> # A tibble: 5 × 25
#>   record_id name_first name_last address  telephone email dob        age   sex  
#>   <chr>     <chr>      <chr>     <chr>    <chr>     <chr> <date>     <chr> <chr>
#> 1 1         Nutmeg     Nutmouse  "14 Ros… (405) 32… nutt… 2003-08-30 11    0    
#> 2 2         Tumtum     Nutmouse  "14 Ros… (405) 32… tumm… 2003-03-10 11    1    
#> 3 3         Marcus     Wood      "243 Hi… (405) 32… mw@m… 1934-04-09 80    1    
#> 4 4         Trudy      DAG       "342 El… (405) 32… pero… 1952-11-02 61    0    
#> 5 5         John Lee   Walker    "Hotel … (405) 32… left… 1955-04-15 59    1    
#> # ℹ 16 more variables: demographics_complete <int>, height <dbl>, weight <int>,
#> #   bmi <chr>, comments <chr>, mugshot <chr>, health_complete <int>,
#> #   race___1 <lgl>, race___2 <lgl>, race___3 <lgl>, race___4 <lgl>,
#> #   race___5 <lgl>, race___6 <lgl>, ethnicity <chr>, interpreter_needed <lgl>,
#> #   race_and_ethnicity_complete <int>

# A longitudinal project
token      <- "DA6F2BB23146BD5A7EA3408C1A44A556" # longitudinal
col_types  <- redcap_metadata_coltypes(uri, token)
#> # col_types <- readr::cols_only( # Use `readr::cols_only()` to restrict the retrieval to only these columns
#> col_types <- readr::cols( # Use `readr::cols()` to include unspecified columns
#>   # [field]                                     [readr col_type]            [explanation for col_type]
#>   study_id                                    = readr::col_character()  , # field_type is text and validation isn't set
#>   redcap_event_name                           = readr::col_character()  , # longitudinal event_name
#>   date_enrolled                               = readr::col_date()       , # validation is 'date_ymd'
#>   patient_document                            = readr::col_character()  , # field_type is file
#>   first_name                                  = readr::col_character()  , # field_type is text and validation isn't set
#>   last_name                                   = readr::col_character()  , # field_type is text and validation isn't set
#>   telephone_1                                 = readr::col_character()  , # validation is 'phone'
#>   email                                       = readr::col_character()  , # validation is 'email'
#>   dob                                         = readr::col_date()       , # validation is 'date_ymd'
#>   age                                         = readr::col_character()  , # field_type is text and validation isn't set
#>   ethnicity                                   = readr::col_character()  , # field_type is radio
#>   race                                        = readr::col_character()  , # field_type is dropdown
#>   sex                                         = readr::col_character()  , # field_type is radio
#>   given_birth                                 = readr::col_logical()    , # field_type is yesno
#>   num_children                                = readr::col_integer()    , # validation is 'integer'
#>   gym___0                                     = readr::col_logical()    , # field_type is checkbox
#>   gym___1                                     = readr::col_logical()    , # field_type is checkbox
#>   gym___2                                     = readr::col_logical()    , # field_type is checkbox
#>   gym___3                                     = readr::col_logical()    , # field_type is checkbox
#>   gym___4                                     = readr::col_logical()    , # field_type is checkbox
#>   aerobics___0                                = readr::col_logical()    , # field_type is checkbox
#>   aerobics___1                                = readr::col_logical()    , # field_type is checkbox
#>   aerobics___2                                = readr::col_logical()    , # field_type is checkbox
#>   aerobics___3                                = readr::col_logical()    , # field_type is checkbox
#>   aerobics___4                                = readr::col_logical()    , # field_type is checkbox
#>   eat___0                                     = readr::col_logical()    , # field_type is checkbox
#>   eat___1                                     = readr::col_logical()    , # field_type is checkbox
#>   eat___2                                     = readr::col_logical()    , # field_type is checkbox
#>   eat___3                                     = readr::col_logical()    , # field_type is checkbox
#>   eat___4                                     = readr::col_logical()    , # field_type is checkbox
#>   drink___0                                   = readr::col_logical()    , # field_type is checkbox
#>   drink___1                                   = readr::col_logical()    , # field_type is checkbox
#>   drink___2                                   = readr::col_logical()    , # field_type is checkbox
#>   drink___3                                   = readr::col_logical()    , # field_type is checkbox
#>   drink___4                                   = readr::col_logical()    , # field_type is checkbox
#>   specify_mood                                = readr::col_integer()    , # field_type is slider
#>   meds___1                                    = readr::col_logical()    , # field_type is checkbox
#>   meds___2                                    = readr::col_logical()    , # field_type is checkbox
#>   meds___3                                    = readr::col_logical()    , # field_type is checkbox
#>   meds___4                                    = readr::col_logical()    , # field_type is checkbox
#>   meds___5                                    = readr::col_logical()    , # field_type is checkbox
#>   height                                      = readr::col_double()     , # validation is 'number'
#>   weight                                      = readr::col_integer()    , # validation is 'integer'
#>   bmi                                         = readr::col_character()  , # field_type is calc
#>   comments                                    = readr::col_character()  , # field_type is note
#>   demographics_complete                       = readr::col_integer()    , # completion status of form/instrument
#>   ec_phone                                    = readr::col_character()  , # validation is 'phone'
#>   ec_confirmed                                = readr::col_character()  , # field_type is radio
#>   next_of_kin_contact_name                    = readr::col_character()  , # field_type is text and validation isn't set
#>   next_of_kin_contact_address                 = readr::col_character()  , # field_type is note
#>   next_of_kin_contact_phone                   = readr::col_character()  , # validation is 'phone'
#>   next_of_kin_confirmed                       = readr::col_character()  , # field_type is radio
#>   contact_info_complete                       = readr::col_integer()    , # completion status of form/instrument
#>   height2                                     = readr::col_double()     , # validation is 'number'
#>   weight2                                     = readr::col_integer()    , # validation is 'integer'
#>   bmi2                                        = readr::col_character()  , # field_type is calc
#>   prealb_b                                    = readr::col_double()     , # validation is 'number'
#>   creat_b                                     = readr::col_double()     , # validation is 'number'
#>   npcr_b                                      = readr::col_double()     , # validation is 'number'
#>   chol_b                                      = readr::col_double()     , # validation is 'number'
#>   transferrin_b                               = readr::col_double()     , # validation is 'number'
#>   baseline_data_complete                      = readr::col_integer()    , # completion status of form/instrument
#>   vld1                                        = readr::col_double()     , # validation is 'number'
#>   vld2                                        = readr::col_double()     , # validation is 'number'
#>   vld3                                        = readr::col_double()     , # validation is 'number'
#>   vld4                                        = readr::col_double()     , # validation is 'number'
#>   vld5                                        = readr::col_double()     , # validation is 'number'
#>   visit_lab_data_complete                     = readr::col_integer()    , # completion status of form/instrument
#>   pmq1                                        = readr::col_character()  , # field_type is dropdown
#>   pmq2                                        = readr::col_character()  , # field_type is dropdown
#>   pmq3                                        = readr::col_character()  , # field_type is radio
#>   pmq4                                        = readr::col_character()  , # field_type is dropdown
#>   patient_morale_questionnaire_complete       = readr::col_integer()    , # completion status of form/instrument
#>   vbw1                                        = readr::col_double()     , # validation is 'number'
#>   vbw2                                        = readr::col_double()     , # validation is 'number'
#>   vbw3                                        = readr::col_double()     , # validation is 'number'
#>   vbw4                                        = readr::col_double()     , # validation is 'number'
#>   vbw5                                        = readr::col_double()     , # validation is 'number'
#>   vbw6                                        = readr::col_character()  , # field_type is radio
#>   vbw7                                        = readr::col_character()  , # field_type is radio
#>   vbw8                                        = readr::col_character()  , # field_type is dropdown
#>   vbw9                                        = readr::col_character()  , # field_type is dropdown
#>   visit_blood_workup_complete                 = readr::col_integer()    , # completion status of form/instrument
#>   vob1                                        = readr::col_character()  , # field_type is radio
#>   vob2                                        = readr::col_character()  , # field_type is radio
#>   vob3                                        = readr::col_character()  , # field_type is radio
#>   vob4                                        = readr::col_character()  , # field_type is radio
#>   vob5                                        = readr::col_character()  , # field_type is radio
#>   vob6                                        = readr::col_character()  , # field_type is radio
#>   vob7                                        = readr::col_character()  , # field_type is note
#>   vob8                                        = readr::col_character()  , # field_type is radio
#>   vob9                                        = readr::col_character()  , # field_type is radio
#>   vob10                                       = readr::col_character()  , # field_type is radio
#>   vob11                                       = readr::col_character()  , # field_type is radio
#>   vob12                                       = readr::col_character()  , # field_type is radio
#>   vob13                                       = readr::col_character()  , # field_type is radio
#>   vob14                                       = readr::col_character()  , # field_type is note
#>   visit_observed_behavior_complete            = readr::col_integer()    , # completion status of form/instrument
#>   study_comments                              = readr::col_character()  , # field_type is note
#>   complete_study                              = readr::col_character()  , # field_type is dropdown
#>   withdraw_date                               = readr::col_date()       , # validation is 'date_ymd'
#>   date_visit_4                                = readr::col_date()       , # validation is 'date_ymd'
#>   alb_4                                       = readr::col_double()     , # validation is 'number'
#>   prealb_4                                    = readr::col_double()     , # validation is 'number'
#>   creat_4                                     = readr::col_date()       , # validation is 'date_ymd'
#>   discharge_date_4                            = readr::col_date()       , # validation is 'date_ymd'
#>   discharge_summary_4                         = readr::col_character()  , # field_type is dropdown
#>   npcr_4                                      = readr::col_integer()    , # validation is 'integer'
#>   chol_4                                      = readr::col_integer()    , # validation is 'integer'
#>   withdraw_reason                             = readr::col_character()  , # field_type is dropdown
#>   completion_data_complete                    = readr::col_integer()    , # completion status of form/instrument
#>   cpq1                                        = readr::col_date()       , # validation is 'date_ymd'
#>   cpq2                                        = readr::col_integer()    , # validation is 'integer'
#>   cpq3                                        = readr::col_integer()    , # validation is 'integer'
#>   cpq4                                        = readr::col_integer()    , # validation is 'integer'
#>   cpq5                                        = readr::col_integer()    , # validation is 'integer'
#>   cpq6                                        = readr::col_character()  , # field_type is dropdown
#>   cpq7                                        = readr::col_character()  , # field_type is dropdown
#>   cpq8                                        = readr::col_character()  , # field_type is dropdown
#>   cpq9                                        = readr::col_date()       , # validation is 'date_ymd'
#>   cpq10                                       = readr::col_character()  , # field_type is dropdown
#>   cpq11                                       = readr::col_character()  , # field_type is dropdown
#>   cpq12                                       = readr::col_character()  , # field_type is radio
#>   cpq13                                       = readr::col_character()  , # field_type is dropdown
#>   completion_project_questionnaire_complete   = readr::col_integer()    , # completion status of form/instrument
#> )
redcap_read_oneshot(uri, token, col_types = col_types)$data
#> 18 records and 125 columns were read from REDCap in 0.2 seconds.  The http status code was 200.
#> # A tibble: 18 × 125
#>    study_id redcap_event_name        date_enrolled patient_document   first_name
#>    <chr>    <chr>                    <date>        <chr>              <chr>     
#>  1 100      enrollment_arm_1         2015-04-02    NA                 Zharko    
#>  2 100      dose_1_arm_1             NA            NA                 NA        
#>  3 100      visit_1_arm_1            NA            NA                 NA        
#>  4 100      dose_2_arm_1             NA            NA                 NA        
#>  5 100      visit_2_arm_1            NA            NA                 NA        
#>  6 100      final_visit_arm_1        NA            NA                 NA        
#>  7 220      enrollment_arm_1         2015-04-02    NA                 Milivoj   
#>  8 220      dose_1_arm_1             NA            NA                 NA        
#>  9 220      visit_1_arm_1            NA            NA                 NA        
#> 10 220      dose_2_arm_1             NA            NA                 NA        
#> 11 220      visit_2_arm_1            NA            NA                 NA        
#> 12 220      final_visit_arm_1        NA            NA                 NA        
#> 13 304      enrollment_arm_2         2015-04-02    levon_and_barry.j… Melech    
#> 14 304      deadline_to_opt_ou_arm_2 NA            NA                 NA        
#> 15 304      first_dose_arm_2         NA            NA                 NA        
#> 16 304      first_visit_arm_2        NA            NA                 NA        
#> 17 304      final_visit_arm_2        NA            NA                 NA        
#> 18 304      deadline_to_return_arm_2 NA            NA                 NA        
#> # ℹ 120 more variables: last_name <chr>, telephone_1 <chr>, email <chr>,
#> #   dob <date>, age <chr>, ethnicity <chr>, race <chr>, sex <chr>,
#> #   given_birth <lgl>, num_children <int>, gym___0 <lgl>, gym___1 <lgl>,
#> #   gym___2 <lgl>, gym___3 <lgl>, gym___4 <lgl>, aerobics___0 <lgl>,
#> #   aerobics___1 <lgl>, aerobics___2 <lgl>, aerobics___3 <lgl>,
#> #   aerobics___4 <lgl>, eat___0 <lgl>, eat___1 <lgl>, eat___2 <lgl>,
#> #   eat___3 <lgl>, eat___4 <lgl>, drink___0 <lgl>, drink___1 <lgl>, …

# A repeating instruments project
token      <- "64720C527CA236880FBA785C9934F02A" # repeating-instruments-sparse
col_types  <- redcap_metadata_coltypes(uri, token)
#> # col_types <- readr::cols_only( # Use `readr::cols_only()` to restrict the retrieval to only these columns
#> col_types <- readr::cols( # Use `readr::cols()` to include unspecified columns
#>   # [field]                     [readr col_type]            [explanation for col_type]
#>   record_id                   = readr::col_integer()    , # record_autonumbering is enabled and DAGs are disabled for the project
#>   redcap_repeat_instrument    = readr::col_character()  , # repeat_instrument
#>   redcap_repeat_instance      = readr::col_integer()    , # repeat_instance
#>   date_enrolled               = readr::col_date()       , # validation is 'date_ymd'
#>   first_name                  = readr::col_character()  , # field_type is text and validation isn't set
#>   dob                         = readr::col_date()       , # validation is 'date_ymd'
#>   age                         = readr::col_character()  , # field_type is text and validation isn't set
#>   ethnicity                   = readr::col_character()  , # field_type is radio
#>   race                        = readr::col_character()  , # field_type is dropdown
#>   sex                         = readr::col_character()  , # field_type is radio
#>   demographics_complete       = readr::col_integer()    , # completion status of form/instrument
#>   date_bp                     = readr::col_date()       , # validation is 'date_ymd'
#>   bp_systolic                 = readr::col_integer()    , # validation is 'integer'
#>   bp_diastolic                = readr::col_integer()    , # validation is 'integer'
#>   bp_complete                 = readr::col_integer()    , # completion status of form/instrument
#> )
redcap_read_oneshot(uri, token, col_types = col_types)$data
#> 9 records and 15 columns were read from REDCap in 0.2 seconds.  The http status code was 200.
#> # A tibble: 9 × 15
#>   record_id redcap_repeat_instrument redcap_repeat_instance date_enrolled
#>       <int> <chr>                                     <int> <date>       
#> 1         1 NA                                           NA 2019-10-14   
#> 2         1 bp                                            1 NA           
#> 3         1 bp                                            2 NA           
#> 4         1 bp                                            3 NA           
#> 5         2 NA                                           NA 2019-02-02   
#> 6         2 bp                                            1 NA           
#> 7         3 NA                                           NA 2021-11-04   
#> 8         4 NA                                           NA 2021-11-04   
#> 9         5 NA                                           NA NA           
#> # ℹ 11 more variables: first_name <chr>, dob <date>, age <chr>,
#> #   ethnicity <chr>, race <chr>, sex <chr>, demographics_complete <int>,
#> #   date_bp <date>, bp_systolic <int>, bp_diastolic <int>, bp_complete <int>

# A project with every field type and validation type.
#   Notice it throws a warning that some fields use a comma for a decimal,
#   while other fields use a period/dot as a decimal
token      <- "EB1FD5DDE583364AE605629AB7619397" # validation-types-1
col_types  <- redcap_metadata_coltypes(uri, token)
#> Warning: The metadata for the REDCap project has validation types for at least one field that specifies a comma for a decimal for at least one field that specifies a period for a decimal.  Mixing these two formats in the same project can cause confusion and problems.  Consider passing `readr::col_character()` for this field (to REDCapR's `col_types` parameter) and then convert the desired fields to R's numeric type.  The function `readr::parse_double()` is useful for this.
#> # col_types <- readr::cols_only( # Use `readr::cols_only()` to restrict the retrieval to only these columns
#> col_types <- readr::cols( # Use `readr::cols()` to include unspecified columns
#>   # [field]                       [readr col_type]                              [explanation for col_type]
#>   record_id                     = readr::col_integer()                      , # record_autonumbering is enabled and DAGs are disabled for the project
#>   f_calculated                  = readr::col_character()                    , # field_type is calc
#>   f_checkbox___0                = readr::col_logical()                      , # field_type is checkbox
#>   f_checkbox___1                = readr::col_logical()                      , # field_type is checkbox
#>   f_checkbox___2                = readr::col_logical()                      , # field_type is checkbox
#>   f_dropdown                    = readr::col_character()                    , # field_type is dropdown
#>   f_file_upload                 = readr::col_character()                    , # field_type is file
#>   f_notes                       = readr::col_character()                    , # field_type is note
#>   f_radio                       = readr::col_character()                    , # field_type is radio
#>   f_signature                   = readr::col_character()                    , # field_type is file
#>   f_slider                      = readr::col_integer()                      , # field_type is slider
#>   f_sql                         = readr::col_character()                    , # field_type is sql
#>   f_text                        = readr::col_character()                    , # field_type is text and validation isn't set
#>   f_true_false                  = readr::col_logical()                      , # field_type is truefalse
#>   f_yes_no                      = readr::col_logical()                      , # field_type is yesno
#>   v_alpha_only                  = readr::col_character()                    , # validation is 'alpha_only'
#>   v_date_dmy                    = readr::col_date()                         , # validation is 'date_dmy'
#>   v_date_mdy                    = readr::col_date()                         , # validation is 'date_mdy'
#>   v_date_ymd                    = readr::col_date()                         , # validation is 'date_ymd'
#>   v_datetime_dmy                = readr::col_datetime("%Y-%m-%d %H:%M")     , # validation is 'datetime_dmy'
#>   v_datetime_mdy                = readr::col_datetime("%Y-%m-%d %H:%M")     , # validation is 'datetime_mdy'
#>   v_datetime_seconds_dmy        = readr::col_datetime("%Y-%m-%d %H:%M:%S")  , # validation is 'datetime_seconds_dmy'
#>   v_datetime_seconds_mdy        = readr::col_datetime("%Y-%m-%d %H:%M:%S")  , # validation is 'datetime_seconds_mdy'
#>   v_datetime_seconds_ymd        = readr::col_datetime("%Y-%m-%d %H:%M:%S")  , # validation is 'datetime_seconds_ymd'
#>   v_datetime_ymd                = readr::col_datetime("%Y-%m-%d %H:%M")     , # validation is 'datetime_ymd'
#>   v_email                       = readr::col_character()                    , # validation is 'email'
#>   v_integer                     = readr::col_integer()                      , # validation is 'integer'
#>   v_mrn_10d                     = readr::col_character()                    , # validation is 'mrn_10d'
#>   v_mrn_generic                 = readr::col_character()                    , # validation is 'mrn_generic'
#>   v_number                      = readr::col_double()                       , # validation is 'number'
#>   v_number_1dp                  = readr::col_double()                       , # validation is 'number_1dp'
#>   v_number_2dp                  = readr::col_double()                       , # validation is 'number_2dp'
#>   v_number_3dp                  = readr::col_double()                       , # validation is 'number_3dp'
#>   v_number_4dp                  = readr::col_double()                       , # validation is 'number_4dp'
#>   v_number_comma_decimal        = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_comma_decimal'
#>   v_number_1dp_comma_decimal    = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_1dp_comma_decimal'
#>   v_number_2dp_comma_decimal    = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_2dp_comma_decimal'
#>   v_number_3dp_comma_decimal    = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_3dp_comma_decimal'
#>   v_number_4dp_comma_decimal    = readr::col_character()                    , # locale's decimal mark isn't a comma, yet validation is 'number_4dp_comma_decimal'
#>   v_phone                       = readr::col_character()                    , # validation is 'phone'
#>   v_phone_australia             = readr::col_character()                    , # validation is 'phone_australia'
#>   v_postalcode_australia        = readr::col_character()                    , # validation is 'postalcode_australia'
#>   v_postalcode_canada           = readr::col_character()                    , # validation is 'postalcode_canada'
#>   v_postalcode_french           = readr::col_character()                    , # validation is 'postalcode_french'
#>   v_postalcode_germany          = readr::col_character()                    , # validation is 'postalcode_germany'
#>   v_ssn                         = readr::col_character()                    , # validation is 'ssn'
#>   v_time_hh_mm                  = readr::col_time("%H:%M")                  , # validation is 'time'
#>   v_time_hh_mm_ss               = readr::col_time("%H:%M:%S")               , # validation is 'time_hh_mm_ss'
#>   v_time_mm_ss                  = readr::col_time("%M:%S")                  , # validation is 'time_mm_ss'
#>   v_vmrn                        = readr::col_character()                    , # validation is 'vmrn'
#>   v_zipcode                     = readr::col_character()                    , # validation is 'zipcode'
#>   form_1_complete               = readr::col_integer()                      , # completion status of form/instrument
#> )
redcap_read_oneshot(uri, token, col_types = col_types)$data
#> 1 records and 52 columns were read from REDCap in 0.2 seconds.  The http status code was 200.
#> # A tibble: 1 × 52
#>   record_id f_calculated f_checkbox___0 f_checkbox___1 f_checkbox___2 f_dropdown
#>       <int> <chr>        <lgl>          <lgl>          <lgl>          <chr>     
#> 1         1 7            FALSE          FALSE          FALSE          NA        
#> # ℹ 46 more variables: f_file_upload <chr>, f_notes <chr>, f_radio <chr>,
#> #   f_signature <chr>, f_slider <int>, f_sql <chr>, f_text <chr>,
#> #   f_true_false <lgl>, f_yes_no <lgl>, v_alpha_only <chr>, v_date_dmy <date>,
#> #   v_date_mdy <date>, v_date_ymd <date>, v_datetime_dmy <dttm>,
#> #   v_datetime_mdy <dttm>, v_datetime_seconds_dmy <dttm>,
#> #   v_datetime_seconds_mdy <dttm>, v_datetime_seconds_ymd <dttm>,
#> #   v_datetime_ymd <dttm>, v_email <chr>, v_integer <int>, v_mrn_10d <chr>, …
# }
```
