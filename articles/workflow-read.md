# Typical REDCap Workflow for a Data Analyst

The REDCap API facilitates repetitive tasks. If you’re sure you’ll
download and analyze a project only once, then it may make sense to
avoid the API and instead download a CSV through the browser.

But that single-shot scenario almost never happens in my life:

1.  the patient dataset is updated with relevant & fresh information
    daily, or
2.  you run it on a different computer a few months later, or *and this
    is the heart of reproducibility:*
3.  you want someone else to be able to unambiguously & effortlessly
    produce the same analysis.

Instead of telling your students or colleagues “first go to REDCap, then
go to project 55, then click”Data Exports”, then click “Export Data”,
then download these files, then move the files to this subdirectory, and
finally convert them to this format before you run these models” …say it
with a few lines of R code.

For people running your code on their machines …the API is so integrated
and responsive that they may not even realize their computer is
connecting to the outside world. If they’re not looking closely, they
may think it’s a dataset that’s included locally in a package they’ve
already installed.

For beginners, most of the work is related to passing security
credentials …which is something that is a reality of working with PHI.

## Part 1 - Pre-requisites

### Verify REDCapR is installed

First confirm that the REDCapR package is installed on your local
machine. If not, the following line will throw the error
`Loading required namespace: REDCapR. Failed with error: ‘there is no package called ‘REDCapR’’`.
If this call fails, follow the installation instructions on the
[REDCapR](https://ouhscbbmc.github.io/REDCapR/) website.

``` r
requireNamespace("REDCapR")

# If this fails, run `install.packages("REDCapR")` or `remotes::install_github(repo="OuhscBbmc/REDCapR")`
```

If you’re a workshop attendee, you can use this vignette to copy
snippets of code to your local machine to follow along with the
examples:
<https://ouhscbbmc.github.io/REDCapR/articles/workflow-read.html>.

### Verify REDCap Access

Check with your institution’s REDCap administrator to ensure you have

1.  access to the REDCap server,
2.  access to the specific REDCap project, and
3.  an API token with appropriate privileges to the specific REDCap
    project.

This might be the first time you’ve ever needed to request a token, and
your institution may have a formal process for API approval. Your REDCap
admin can help.

For this vignette, we’ll use a fake dataset hosted at
`https://redcap-dev-2.ouhsc.edu/redcap/api/` and accessible with the
token “9A068C425B1341D69E83064A2D273A70”.

Note to REDCap Admins:

> For
> [`REDCapR::redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html)
> to function properly, the user must have Export permissions for the
> ‘Full Data Set’. Users with only ‘De-Identified’ export privileges can
> still use
> [`REDCapR::redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.html).
> To grant the appropriate permissions:
>
> - go to ‘User Rights’ in the REDCap project site,
> - select the desired user, and then select ‘Edit User Privileges’,
> - in the ‘Data Exports’ radio buttons, select ‘Full Data Set’.

### Review Codebook

Before developing any REDCap or analysis code, spend at least 10 minutes
to review the codebook, whose link is near the top left corner of the
REDCap project page, under the “Project Home and Design” heading.
Learning the details will save you time later and improve the quality of
the research.

If you’re new to the project, meet with the investigator for at least 30
minutes to learn the context, collection process, and idiosyncrasies of
the dataset. During that conversation, develop a plan for grooming the
dataset to be ready for analysis. This is part of the standard advice
that the analyst’s involvement should start early in the investigation’s
life span.

## Part 2 - Retrieve Protected Token

The REDCap API token is essentially a combination of a personal password
and the ID of the specific project you’re requesting data from. Protect
it like any other password to PHI ([protected health
information](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html)).
For a project with PHI, **never hard-code the password directly in an R
file**. In other words, no PHI project should be accessed with an R file
that includes the line

``` r
my_secret_token <- "9A81268476645C4E5F03428B8AC3AA7B"
```

Instead, we suggest storing the token in a location that can be accessed
by only you. We have two recommendations.

### Security Method 1: Token File

The basic goals are (a) separate the secret values from the R file into
a dedicated file and (b) secure the dedicated file. If using a git
repository, prevent the file from being committed with an entry in
[`.gitignore`](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files).
Ask your institution’s IT security team for their recommendation.

The
[`retrieve_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.html)
function in the [REDCapR](https://ouhscbbmc.github.io/REDCapR/) package
loads relevant information from a csv into R. The plain-text file might
look like this:

``` csv
redcap_uri,username,project_id,token,comment
"https://redcap-dev-2.ouhsc.edu/redcap/api/","myusername","33","9A068C425B1341D69E83064A2D273A70","simple"
"https://redcap-dev-2.ouhsc.edu/redcap/api/","myusername","34","DA6F2BB23146BD5A7EA3408C1A44A556","longitudinal"
"https://redcap-dev-2.ouhsc.edu/redcap/api/","myusername","36","F9CBFFF78C3D78F641BAE9623F6B7E6A","simple-write"
```

To retrieve the credentials for the first project listed above, pass the
value of “33” to `project_id`.

``` r
path_credential <- system.file("misc/dev-2.credentials", package = "REDCapR")
credential  <- REDCapR::retrieve_credential_local(
  path_credential = path_credential,
  project_id      = 33
)

credential
#> $redcap_uri
#> [1] "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#> 
#> $username
#> [1] "myusername"
#> 
#> $project_id
#> [1] 33
#> 
#> $token
#> [1] "9A068C425B1341D69E83064A2D273A70"
#> 
#> $comment
#> [1] "simple"
```

A credential file is already created for this vignette. In your next
real project, call
[`create_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.html)
to start a well-formed csv file that can contain tokens.

Compared to the method below, this one is less secure but easier to
establish.

### Security Method 2: Token Server

Our preferred method involves saving the tokens in a separate database
that uses something like Active Directory to authenticate requests. This
method is described in detail in the [Security
Database](https://ouhscbbmc.github.io/REDCapR/articles/SecurityDatabase.html)
vignette.

This approach realistically requires someone in your institution to have
at least basic database administration experience.

## Part 3 - Read Data: Unstructured Approach

The `redcap_uri` and `token` fields are the only required arguments of
[`REDCapR::redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html);
both are in the credential object created in the previous section.

``` r
ds_1 <-
  REDCapR::redcap_read(
    redcap_uri  = credential$redcap_uri,
    token       = credential$token
  )$data
#> 24 variable metadata records were read from REDCap in 0.3 seconds.  The http status code was 200.
#> The data dictionary describing 17 fields was read from REDCap in 0.1 seconds.  The http status code was 200.
#> 3 instrument metadata records were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 1 rows were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 2 data access groups were read from REDCap in 0.1 seconds.  The http status code was 200.
#> 5 records and 1 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
#> Starting to read 5 records  at 2025-12-15 19:48:29.154479.
#> Reading batch 1 of 1, with subjects 1 through 5 (ie, 5 unique subject records).
#> 5 records and 25 columns were read from REDCap in 0.1 seconds.  The http status code was 200.
```

At this point, the data.frame `ds_1` has everything you need to start
analyzing the project.

``` r
ds_1
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

hist(ds_1$weight)
```

![histogram of patient
weight](workflow-read_files/figure-html/unstructured-2-1.png)

``` r

summary(ds_1)
#>    record_id  name_first         name_last           address         
#>  Min.   :1   Length:5           Length:5           Length:5          
#>  1st Qu.:2   Class :character   Class :character   Class :character  
#>  Median :3   Mode  :character   Mode  :character   Mode  :character  
#>  Mean   :3                                                           
#>  3rd Qu.:4                                                           
#>  Max.   :5                                                           
#>                                                                      
#>   telephone            email                dob                  age      
#>  Length:5           Length:5           Min.   :1934-04-09   Min.   :11.0  
#>  Class :character   Class :character   1st Qu.:1952-11-02   1st Qu.:11.0  
#>  Mode  :character   Mode  :character   Median :1955-04-15   Median :59.0  
#>                                        Mean   :1969-11-06   Mean   :44.4  
#>                                        3rd Qu.:2003-03-10   3rd Qu.:61.0  
#>                                        Max.   :2003-08-30   Max.   :80.0  
#>                                                                           
#>       sex      demographics_complete     height          weight   
#>  Min.   :0.0   Min.   :2             Min.   :  6.0   Min.   :  1  
#>  1st Qu.:0.0   1st Qu.:2             1st Qu.:  7.0   1st Qu.:  1  
#>  Median :1.0   Median :2             Median :165.0   Median : 54  
#>  Mean   :0.6   Mean   :2             Mean   :110.2   Mean   : 48  
#>  3rd Qu.:1.0   3rd Qu.:2             3rd Qu.:180.0   3rd Qu.: 80  
#>  Max.   :1.0   Max.   :2             Max.   :193.0   Max.   :104  
#>                                                                   
#>       bmi          comments           mugshot          health_complete
#>  Min.   : 19.8   Length:5           Length:5           Min.   :0      
#>  1st Qu.: 24.7   Class :character   Class :character   1st Qu.:0      
#>  Median : 27.9   Mode  :character   Mode  :character   Median :1      
#>  Mean   :110.9                                         Mean   :1      
#>  3rd Qu.:204.1                                         3rd Qu.:2      
#>  Max.   :277.8                                         Max.   :2      
#>                                                                       
#>     race___1      race___2      race___3      race___4      race___5  
#>  Min.   :0.0   Min.   :0.0   Min.   :0.0   Min.   :0.0   Min.   :0.0  
#>  1st Qu.:0.0   1st Qu.:0.0   1st Qu.:0.0   1st Qu.:0.0   1st Qu.:1.0  
#>  Median :0.0   Median :0.0   Median :0.0   Median :0.0   Median :1.0  
#>  Mean   :0.2   Mean   :0.2   Mean   :0.2   Mean   :0.2   Mean   :0.8  
#>  3rd Qu.:0.0   3rd Qu.:0.0   3rd Qu.:0.0   3rd Qu.:0.0   3rd Qu.:1.0  
#>  Max.   :1.0   Max.   :1.0   Max.   :1.0   Max.   :1.0   Max.   :1.0  
#>                                                                       
#>     race___6     ethnicity interpreter_needed race_and_ethnicity_complete
#>  Min.   :0.0   Min.   :0   Min.   :0.00       Min.   :0.0                
#>  1st Qu.:0.0   1st Qu.:1   1st Qu.:0.00       1st Qu.:2.0                
#>  Median :0.0   Median :1   Median :0.00       Median :2.0                
#>  Mean   :0.2   Mean   :1   Mean   :0.25       Mean   :1.6                
#>  3rd Qu.:0.0   3rd Qu.:1   3rd Qu.:0.25       3rd Qu.:2.0                
#>  Max.   :1.0   Max.   :2   Max.   :1.00       Max.   :2.0                
#>                            NA's   :1

summary(lm(age ~ 1 + sex + bmi, data = ds_1))
#> 
#> Call:
#> lm(formula = age ~ 1 + sex + bmi, data = ds_1)
#> 
#> Residuals:
#>       1       2       3       4       5 
#>  -2.491   1.954   9.132   2.491 -11.086 
#> 
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)  
#> (Intercept) 63.34496    8.89980   7.118   0.0192 *
#> sex         13.55626    9.62958   1.408   0.2945  
#> bmi         -0.24426    0.04337  -5.632   0.0301 *
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 10.55 on 2 degrees of freedom
#> Multiple R-squared:  0.9442, Adjusted R-squared:  0.8884 
#> F-statistic: 16.92 on 2 and 2 DF,  p-value: 0.05581
```

*Pause here in the workshop for a few minutes. Raise hand if you’re
having trouble.*

## Part 4 - Read Data: Choosing Columns and Rows

When you read a dataset for the first time, you probably haven’t decided
which columns are needed so it makes sense to retrieve everything. As
you gain familiarity with the data and with the analytic objectives,
consider being more selective with the variables and rows transported
from the remote server to your local machine.

Advantages include:

1.  A server is almost always more efficient filtering than a language
    like R or Python.
2.  REDCap’s PHP code retrieves less data from REDCap’s database and
    translates less to a text format (like csv or json).
3.  Fewer bytes are transmitted across your network.
4.  Your local machine will have better performance, because R has a
    smaller dataset to manage.
5.  Your brain doesn’t have to look past unnecessary columns.
6.  Your R code doesn’t have filter what the server already removed.
7.  Highly-sensitive PHI columns that are unnecessary for an analysis
    remain on the server.

### Specify Record IDs

The most basic operation to limit rows is passing the exact record
identifiers.

``` r
# Return only records with IDs of 1 and 4
desired_records <- c(1, 4)
REDCapR::redcap_read(
  redcap_uri  = credential$redcap_uri,
  token       = credential$token,
  records     = desired_records,
  verbose     = FALSE
)$data
#> # A tibble: 2 × 25
#>   record_id name_first name_last address  telephone email dob          age   sex
#>       <dbl> <chr>      <chr>     <chr>    <chr>     <chr> <date>     <dbl> <dbl>
#> 1         1 Nutmeg     Nutmouse  "14 Ros… (405) 32… nutt… 2003-08-30    11     0
#> 2         4 Trudy      DAG       "342 El… (405) 32… pero… 1952-11-02    61     0
#> # ℹ 16 more variables: demographics_complete <dbl>, height <dbl>, weight <dbl>,
#> #   bmi <dbl>, comments <chr>, mugshot <chr>, health_complete <dbl>,
#> #   race___1 <dbl>, race___2 <dbl>, race___3 <dbl>, race___4 <dbl>,
#> #   race___5 <dbl>, race___6 <dbl>, ethnicity <dbl>, interpreter_needed <dbl>,
#> #   race_and_ethnicity_complete <dbl>
```

### Specify Row Filter

A more useful operation to limit rows is passing an expression to filter
the records before returning. See your server’s documentation for the
syntax rules of the filter statements. Remember to enclose your variable
names in square brackets. Also be aware of differences between strings
and numbers.

``` r
# Return only records with a birth date after January 2003
REDCapR::redcap_read(
  redcap_uri    = credential$redcap_uri,
  token         = credential$token,
  filter_logic  = "'2003-01-01' < [dob]",
  verbose       = FALSE
)$data
#> # A tibble: 2 × 25
#>   record_id name_first name_last address  telephone email dob          age   sex
#>       <dbl> <chr>      <chr>     <chr>    <chr>     <chr> <date>     <dbl> <dbl>
#> 1         1 Nutmeg     Nutmouse  "14 Ros… (405) 32… nutt… 2003-08-30    11     0
#> 2         2 Tumtum     Nutmouse  "14 Ros… (405) 32… tumm… 2003-03-10    11     1
#> # ℹ 16 more variables: demographics_complete <dbl>, height <dbl>, weight <dbl>,
#> #   bmi <dbl>, comments <chr>, mugshot <chr>, health_complete <dbl>,
#> #   race___1 <dbl>, race___2 <dbl>, race___3 <dbl>, race___4 <dbl>,
#> #   race___5 <dbl>, race___6 <dbl>, ethnicity <dbl>, interpreter_needed <dbl>,
#> #   race_and_ethnicity_complete <dbl>
```

### Specify Column Names

Limit the returned fields by passing a vector of the desired names.

``` r
# Return only the fields record_id, name_first, and age
desired_fields <- c("record_id", "name_first", "age")
REDCapR::redcap_read(
  redcap_uri  = credential$redcap_uri,
  token       = credential$token,
  fields      = desired_fields,
  verbose     = FALSE
)$data
#> # A tibble: 5 × 3
#>   record_id name_first   age
#>       <dbl> <chr>      <dbl>
#> 1         1 Nutmeg        11
#> 2         2 Tumtum        11
#> 3         3 Marcus        80
#> 4         4 Trudy         61
#> 5         5 John Lee      59
```

## Part 5 - Read Data: Structured Approach

As the automation of your scripts matures and institutional resources
depend on its output, its output should be stable. One way to make it
more predictable is to specify the column names *and* the column data
types. In the previous example, notice that R (specifically
[`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html))
made its best guess and reported it in the “Column specification”
section.

In the following example, REDCapR passes `col_types` to
[`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
as it converts the plain-text output returned from REDCap into an R data
frame. (To be precise, a [tibble](https://tibble.tidyverse.org/) is
returned.)

When readr sees a column with values like 1, 2, 3, and 4, it will make
the reasonable guess that the column should be a double precision
floating-point data type. However we [recommend using the simplest data
type
reasonable](https://ouhscbbmc.github.io/data-science-practices-1/coding.html#coding-simplify-types)
because a simpler data type is less likely contain unintended values and
it’s typically faster, consumes less memory, and translates more cleanly
across platforms. As specifically for identifiers like `record_id`
specify either an integer or character.

### Specify Column Names & Types

``` r
# Specify the column types.
desired_fields <- c("record_id", "race")
col_types <- readr::cols(
  record_id  = readr::col_integer(),
  race___1   = readr::col_logical(),
  race___2   = readr::col_logical(),
  race___3   = readr::col_logical(),
  race___4   = readr::col_logical(),
  race___5   = readr::col_logical(),
  race___6   = readr::col_logical()
)
REDCapR::redcap_read(
  redcap_uri  = credential$redcap_uri,
  token       = credential$token,
  fields      = desired_fields,
  verbose     = FALSE,
  col_types   = col_types
)$data
#> # A tibble: 5 × 7
#>   record_id race___1 race___2 race___3 race___4 race___5 race___6
#>       <int> <lgl>    <lgl>    <lgl>    <lgl>    <lgl>    <lgl>   
#> 1         1 FALSE    FALSE    FALSE    FALSE    TRUE     FALSE   
#> 2         2 FALSE    FALSE    TRUE     FALSE    TRUE     FALSE   
#> 3         3 FALSE    FALSE    FALSE    TRUE     TRUE     FALSE   
#> 4         4 FALSE    TRUE     FALSE    FALSE    TRUE     FALSE   
#> 5         5 TRUE     FALSE    FALSE    FALSE    FALSE    TRUE
```

### Specify Everything is a Character

REDCap internally stores every value as a string. To accept full
responsibility of the data types, tell
[`readr::cols()`](https://readr.tidyverse.org/reference/cols.html) to
keep them as strings.

``` r
# Specify the column types.
desired_fields <- c("record_id", "race")
col_types <- readr::cols(.default = readr::col_character())
REDCapR::redcap_read(
  redcap_uri  = credential$redcap_uri,
  token       = credential$token,
  fields      = desired_fields,
  verbose     = FALSE,
  col_types   = col_types
)$data
#> # A tibble: 5 × 7
#>   record_id race___1 race___2 race___3 race___4 race___5 race___6
#>   <chr>     <chr>    <chr>    <chr>    <chr>    <chr>    <chr>   
#> 1 1         0        0        0        0        1        0       
#> 2 2         0        0        1        0        1        0       
#> 3 3         0        0        0        1        1        0       
#> 4 4         0        1        0        0        1        0       
#> 5 5         1        0        0        0        0        1
```

## Part 6 - Next Steps

### Other REDCapR Resources

In addition to documentation [for each
function](https://ouhscbbmc.github.io/REDCapR/reference/) the REDCapR
package contains a handful of
[vignettes](https://ouhscbbmc.github.io/REDCapR/articles/) including a
[troubleshooting
guide](https://ouhscbbmc.github.io/REDCapR/articles/TroubleshootingApiCalls.html).

### Create an Arch for Reuse

When multiple R files use REDCapR call the same REDCap dataset, consider
refactoring your scripts so that extraction code is written once, and
called by the multiple analysis files. This “arch” pattern is described
in slides 9-16 of the 2014
[REDCapCon](https://projectredcap.org/about/redcapcon/) presentation,
[Literate Programming Patterns and Practices for Continuous Quality
Improvement
(CQI)](https://github.com/OuhscBbmc/RedcapExamplesAndPatterns/blob/master/Publications/Presentation-2014-09-REDCapCon/LiterateProgrammingPatternsAndPracticesWithREDCap.pptx).

### Downstream Reproducible Reports

Once the dataset is in R, take advantage of all the reproducible
research tools available. Tomorrow,
[R/Medicine](https://events.linuxfoundation.org/r-medicine/) has a
workshop on this topic using the exciting new
[Quarto](https://quarto.org/) program that’s similar to R Markdown. Also
see the relevant [R/Medicine 2020 presentation
videos](https://www.youtube.com/playlist?list=PL4IzsxWztPdljYo7uE5G_R2PtYw3fUReo).
And of course, [any book by Yihui Xie and
colleagues](https://www.amazon.com/Yihui-Xie/e/B00E9CQJGY?ref=sr_ntt_srch_lnk_1&qid=1625895927&sr=1-1).

### Batching

By default,
[`REDCapR::redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
requests datasets of 100 patients as a time, and stacks the resulting
subsets together before returning a data.frame. This can be adjusted to
improve performance; the ‘Details’ section of
[`REDCapR::redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html#details)
discusses the trade offs.

### Writing to the Server

Reading record data is only one API capability. REDCapR [exposes 20+ API
functions](https://ouhscbbmc.github.io/REDCapR/reference/), such as
reading metadata, retrieving survey links, and writing records back to
REDCap. This last operation is relevant in [Kenneth
McLean](https://orcid.org/0000-0001-6482-9086)’s presentation following
a five-minute break.

## Notes

This vignette was originally designed for a 2021 R/Medicine REDCap
workshop with [Peter
Higgins](https://scholar.google.com/citations?user=UGJGFaAAAAAJ&hl=en),
[Amanda
Miller](https://coloradosph.cuanschutz.edu/resources/directory/directory-profile/Miller-Amanda-UCD6000053152),
and [Kenneth McLean](https://orcid.org/0000-0001-6482-9086).

This work was made possible in part by the NIH grant
[U54GM104938](https://taggs.hhs.gov/Detail/AwardDetail?arg_AwardNum=U54GM104938&arg_ProgOfficeCode=127)
to the [Oklahoma Shared Clinical and Translational
Resource)](http://osctr.ouhsc.edu).

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
    #>  package     * version    date (UTC) lib source
    #>  backports     1.5.0      2024-05-23 [1] CRAN (R 4.5.0)
    #>  bit           4.6.0      2025-03-06 [1] CRAN (R 4.5.0)
    #>  bit64         4.6.0-1    2025-01-16 [1] CRAN (R 4.5.0)
    #>  bslib         0.9.0      2025-01-30 [1] CRAN (R 4.5.0)
    #>  cachem        1.1.0      2024-05-16 [1] CRAN (R 4.5.0)
    #>  checkmate     2.3.3      2025-08-18 [1] CRAN (R 4.5.0)
    #>  cli           3.6.5      2025-04-23 [1] CRAN (R 4.5.0)
    #>  crayon        1.5.3      2024-06-20 [1] CRAN (R 4.5.0)
    #>  curl          7.0.0      2025-08-19 [1] CRAN (R 4.5.0)
    #>  desc          1.4.3      2023-12-10 [1] CRAN (R 4.5.0)
    #>  digest        0.6.39     2025-11-19 [1] CRAN (R 4.5.2)
    #>  dplyr         1.1.4      2023-11-17 [1] CRAN (R 4.5.0)
    #>  evaluate      1.0.5      2025-08-27 [1] CRAN (R 4.5.0)
    #>  fastmap       1.2.0      2024-05-15 [1] CRAN (R 4.5.0)
    #>  fs            1.6.6      2025-04-12 [1] CRAN (R 4.5.0)
    #>  generics      0.1.4      2025-05-09 [1] CRAN (R 4.5.0)
    #>  glue          1.8.0      2024-09-30 [1] CRAN (R 4.5.0)
    #>  hms           1.1.4      2025-10-17 [1] CRAN (R 4.5.0)
    #>  htmltools     0.5.9      2025-12-04 [1] CRAN (R 4.5.2)
    #>  httr          1.4.7      2023-08-15 [1] CRAN (R 4.5.0)
    #>  jquerylib     0.1.4      2021-04-26 [1] CRAN (R 4.5.0)
    #>  jsonlite      2.0.0      2025-03-27 [1] CRAN (R 4.5.0)
    #>  knitr         1.50       2025-03-16 [1] CRAN (R 4.5.0)
    #>  lifecycle     1.0.4      2023-11-07 [1] CRAN (R 4.5.0)
    #>  magrittr      2.0.4      2025-09-12 [1] CRAN (R 4.5.0)
    #>  pillar        1.11.1     2025-09-17 [1] CRAN (R 4.5.0)
    #>  pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 4.5.0)
    #>  pkgdown       2.2.0      2025-11-06 [1] CRAN (R 4.5.0)
    #>  R6            2.6.1      2025-02-15 [1] CRAN (R 4.5.0)
    #>  ragg          1.5.0      2025-09-02 [1] CRAN (R 4.5.0)
    #>  readr         2.1.6      2025-11-14 [1] CRAN (R 4.5.2)
    #>  REDCapR       1.6.0.9000 2025-12-15 [1] local
    #>  rlang         1.1.6      2025-04-11 [1] CRAN (R 4.5.0)
    #>  rmarkdown     2.30       2025-09-28 [1] CRAN (R 4.5.0)
    #>  sass          0.4.10     2025-04-11 [1] CRAN (R 4.5.0)
    #>  sessioninfo   1.2.3      2025-02-05 [1] CRAN (R 4.5.0)
    #>  systemfonts   1.3.1      2025-10-01 [1] CRAN (R 4.5.0)
    #>  textshaping   1.0.4      2025-10-10 [1] CRAN (R 4.5.0)
    #>  tibble        3.3.0      2025-06-08 [1] CRAN (R 4.5.0)
    #>  tidyselect    1.2.1      2024-03-11 [1] CRAN (R 4.5.0)
    #>  tzdb          0.5.0      2025-03-15 [1] CRAN (R 4.5.0)
    #>  utf8          1.2.6      2025-06-08 [1] CRAN (R 4.5.0)
    #>  vctrs         0.6.5      2023-12-01 [1] CRAN (R 4.5.0)
    #>  vroom         1.6.7      2025-11-28 [1] CRAN (R 4.5.2)
    #>  withr         3.0.2      2024-10-28 [1] CRAN (R 4.5.0)
    #>  xfun          0.54       2025-10-30 [1] CRAN (R 4.5.0)
    #>  yaml          2.3.12     2025-12-10 [1] CRAN (R 4.5.2)
    #> 
    #>  [1] /Users/runner/work/_temp/Library
    #>  [2] /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library
    #> 
    #> ──────────────────────────────────────────────────────────────────────────────
