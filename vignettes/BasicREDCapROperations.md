<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Basic REDCapR Operations}
-->

<!-- rmarkdown v1 -->

# Basic REDCapR Operations
This vignette covers the the basic functions exposed by the [`REDCapR`](https://github.com/OuhscCcanMiechvEvaluation/REDCapR) package which allow you to interact with [REDCap](http://www.project-redcap.org/) through its API.

## Reading REDCap Data
The function `redcap_read_oneshot` uses the [`RCurl`](http://cran.r-project.org/web/packages/RCurl/index.html) package to call the REDCap API.


### Set project-wide values.
There is some information that is specific to the REDCap project, as opposed to an individual operation.  This includes the (1) uri of the server, the (2) token for the user's project, and the (3) location of the SSL certification store, which is necessary to verify the identity of the REDCap webserver.  

The `REDCapR` package includes a recent version of the [Bundle of CA Root Certificates](http://curl.haxx.se/ca/cacert.pem) from the official [cURL site](http://curl.haxx.se).  This version is used by default, unless the `cert_location` parameter is given another location.


```r
library(REDCapR) #Load the package into the current R session.
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B"
```

### Read all records and fields.
If no information is passed about the desired records or fields, then the entire data set is returned.  Only two parameters are required, `redcap_uri` and `token`.  Unless the `verbose` parameter is set to `FALSE`, a message will be printed on the R console with the number of records and fields returned.


```r
#Return all records and all variables.
ds_all_rows_all_fields <- redcap_read_oneshot(redcap_uri=uri, token=token)$data
```

```
5 records and 16 columns were read from REDCap in 1.15 seconds.  The http status code was 200.
```

```r
ds_all_rows_all_fields #Inspect the returned dataset
```

```
  record_id first_name last_name                                 address      telephone               email        dob
1         1     Nutmeg  Nutmouse 14 Rose Cottage St.\nKenning UK, 323232 (432) 456-4848     nutty@mouse.com 2003-08-30
2         2     Tumtum  Nutmouse 14 Rose Cottage Blvd.\nKenning UK 34243 (234) 234-2343    tummy@mouse.comm 2003-03-10
3         3     Marcus      Wood          243 Hill St.\nGuthrie OK 73402 (433) 435-9865        mw@mwood.net 1934-04-09
4         4      Trudy       DAG          342 Elm\nDuncanville TX, 75116 (987) 654-3210 peroxide@blonde.com 1952-11-02
5         5   John Lee    Walker      Hotel Suite\nNew Orleans LA, 70115 (333) 333-4444  left@hippocket.com 1955-04-15
  age ethnicity race sex height weight   bmi
1  10         1    2   0      5      1 400.0
2  11         1    6   1      6      1 277.8
3  79         0    4   1    180     80  24.7
4  61         1    4   0    165     54  19.8
5  58         1    4   1    193    104  27.9
                                                                                                     comments
1                                                                     Character in a book, with some guessing
2                                                                          A mouse character from a good book
3                                                                                          completely made up
4 This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail
5                 Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache
  demographics_complete
1                     2
2                     2
3                     2
4                     2
5                     2
```

### Read a subset of the records.
If only a subset of the **records** is desired, the two approaches are shown below.  The first is to pass an array (where each element is an ID) to the `records` parameter.  The second is to pass a single string (where the elements are separated by commas) to the `records_collapsed` parameter.  

The first format is more natural for more R users.  The second format is what is expected by the REDCap API.  If a value for `records` is specified, but `records_collapsed` is missing, then `redcap_read_oneshot` automatically converts the array into the format needed by the API.


```r
#Return only records with IDs of 1 and 3
desired_records_v1 <- c(1, 3)
ds_some_rows_v1 <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   records = desired_records_v1
)$data
```

```
2 records and 16 columns were read from REDCap in 0.56 seconds.  The http status code was 200.
```

```r
#Return only records with IDs of 1 and 3 (alternate way)
desired_records_v2 <- "1, 3"
ds_some_rows_v2 <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   records_collapsed = desired_records_v2
)$data
```

```
2 records and 16 columns were read from REDCap in 0.33 seconds.  The http status code was 200.
```

```r
ds_some_rows_v2 #Inspect the returned dataset
```

```
  record_id first_name last_name                                 address      telephone           email        dob age
1         1     Nutmeg  Nutmouse 14 Rose Cottage St.\nKenning UK, 323232 (432) 456-4848 nutty@mouse.com 2003-08-30  10
2         3     Marcus      Wood          243 Hill St.\nGuthrie OK 73402 (433) 435-9865    mw@mwood.net 1934-04-09  79
  ethnicity race sex height weight   bmi                                comments demographics_complete
1         1    2   0      5      1 400.0 Character in a book, with some guessing                     2
2         0    4   1    180     80  24.7                      completely made up                     2
```

### Read a subset of the fields.
If only a subset of the **fields** is desired, then two approaches exist.  The first is to pass an array (where each element is an field) to the `fields` parameter.  The second is to pass a single string (where the elements are separated by commas) to the `fields_collapsed` parameter. Like with `records` and `records_collapsed` described above, this function converts the more natural format (*ie*, `fields`) to the format required by the API (*ie*, `fields_collapsed`) if `fields` is specified and `fields_collapsed` is not.


```r
#Return only the fields recordid, first_name, and age
desired_fields_v1 <- c("recordid", "first_name", "age")
ds_some_fields_v1 <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   fields = desired_fields_v1
)$data
```

```
5 records and 3 columns were read from REDCap in 0.3 seconds.  The http status code was 200.
```

```r
#Return only the fields recordid, first_name, and age (alternate way)
desired_fields_v2 <- "recordid, first_name, age"
ds_some_fields_v2 <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   fields_collapsed = desired_fields_v2
)$data
```

```
5 records and 3 columns were read from REDCap in 0.31 seconds.  The http status code was 200.
```

```r
ds_some_fields_v2 #Inspect the returned dataset
```

```
  record_id first_name age
1         1     Nutmeg  10
2         2     Tumtum  11
3         3     Marcus  79
4         4      Trudy  61
5         5   John Lee  58
```

### Additional Returned Information
The examples above have shown only the resulting `data.frame`, by specifying `$data` at the end of the call.  However, more is available to those wanting additional information, such as
 1. The `data` object has the `data.frame`, as in the previous examples.
 1. The `success` boolean value indicates if `redcap_read_oneshot` believes the operation completed as intended.
 1. The `status_codes` is a collection of [http status codes](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes), separated by semicolons.  There is one code for each batch attempted.
 1. The `outcome_messages`: A collection of human readable strings indicating the operations' semicolons.  There is one code for each batch attempted.  In an unsuccessful operation, it should contain diagnostic information.
 1. The `records_collapsed` field passed to the API.  This shows which record subsets, if any, were requested.
 1. The `fields_collapsed` fields passed to the API.  This shows which field subsets, if any, were requested.
 1. The `elapsed_seconds` measures the duration of the call. 


```r
#Return only the fields recordid, first_name, and age
all_information <- redcap_read_oneshot(
   redcap_uri = uri, 
   token = token, 
   fields = desired_fields_v1
)
```

```
5 records and 3 columns were read from REDCap in 0.31 seconds.  The http status code was 200.
```

```r
all_information #Inspect the additional information
```

```
$data
  record_id first_name age
1         1     Nutmeg  10
2         2     Tumtum  11
3         3     Marcus  79
4         4      Trudy  61
5         5   John Lee  58

$success
[1] TRUE

$status_code
[1] 200

$outcome_message
[1] "5 records and 3 columns were read from REDCap in 0.31 seconds.  The http status code was 200."

$records_collapsed
[1] ""

$fields_collapsed
[1] "recordid,first_name,age"

$elapsed_seconds
[1] 0.3131

$raw_text
[1] ""
```

## Session Info
For the sake of documentation and reproducibility, the current vignette was build on a system using the following software.


```
Report created by Will at 2014-09-03, 17:16:09 -0500
```

```
R version 3.1.1 Patched (2014-08-27 r66482)
Platform: x86_64-w64-mingw32/x64 (64-bit)

locale:
[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252    LC_MONETARY=English_United States.1252
[4] LC_NUMERIC=C                           LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] REDCapR_0.4-04 knitr_1.6     

loaded via a namespace (and not attached):
 [1] devtools_1.5   digest_0.6.4   evaluate_0.5.5 formatR_1.0    httr_0.5       memoise_0.2.1  parallel_3.1.1
 [8] RCurl_1.95-4.3 stringr_0.6.2  tools_3.1.1    whisker_0.3-2 
```
