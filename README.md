REDCapR
=======
We’ve been using R with REDCap’s API since the Fall 2012 and have developed a few functions that we're assembling in an R package.

It was taking us about 50 lines of code to contact REDCap and robustly transform the returned CSV into an R `data.frame`.  The same thing can be done in one line of code with the package's `redcap_read()` function:
```
ds_all_rows_all_fields <- redcap_read(redcap_uri=uri, token=token)$data
```

The `REDCapR` package includes the [Bundle of CA Root Certificates](http://curl.haxx.se/ca/cacert.pem) from the official [cURL site](http://curl.haxx.se).  Your REDCap server's identity is always verified, unless the setting is overridden (alternative certificates can also be provided).

The `redcap_read()` function also accepts values for subsetting/filtering the records and fields.  The [current documentation](https://github.com/OuhscBbmc/REDCapR/blob/master/REDCapRDocumentationPeek.pdf) can be found in the [GitHub repository](https://github.com/OuhscBbmc/REDCapR).  A [vignette](http://htmlpreview.github.io/?https://github.com/OuhscBbmc/REDCapR/blob/master/inst/doc/BasicREDCapROperations.html) has also been started.
```
#Return only records with IDs of 1 and 4
desired_records <- c(1, 4)
ds_some_rows <- redcap_read(
   redcap_uri = uri, 
   token = token, 
   records = desired_records
)$data

#Return only the fields recordid, first_name, and age
desired_fields <- c("recordid", "first_name", "age")
ds_some_fields <- redcap_read(
   redcap_uri = uri, 
   token = token, 
   fields = desired_fields
)$data
```

We have completed `redcap_write()`, but aren't releasing it until appropriate unit/regression/integration tests are written.  We first need a way to automate deleting the newly inserted records, so the database's state is cleaned up before subsequent tests.

Once the `redcap_write()` function is tested and documented, we'll release it on [CRAN](http://cran.r-project.org/web/packages/).  In th next few months, we hope to implement everything exposed by the REDCap API.  If there's a feature that would help your projects, feel free to post something here in the forums, or create an issue in REDCapR's [GitHub repository](https://github.com/OuhscBbmc/REDCapR/issues).  

Our group has benefitted so much from REDCap and the surrounding community, we'd like to contribute back.  Suggestions and criticisms are welcome.  

Thanks, 
Will Beasley, David Bard, & Thomas Wilson

University of Oklahoma Health Sciences Center,
Department of Pediatrics,
Biomedical & Behavioral Research Core.

For those interested in use the development version of REDCapR, run the following two lines:
```
install.packages("devtools")
devtools::install_github(repo="REDCapR", username="OuhscBbmc")
```
