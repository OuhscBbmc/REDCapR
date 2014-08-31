[![Build Status](https://travis-ci.org/OuhscBbmc/REDCapR.png?branch=master)](https://travis-ci.org/OuhscBbmc/REDCapR)

REDCapR
=======
We’ve been using R with REDCap’s API since the Fall 2012 and have developed a few functions that we're assembling in an R package: [REDCapR](https://github.com/OuhscBbmc/REDCapR).

It was taking us about 50 lines of code to contact REDCap and robustly transform the returned CSV into an R `data.frame`.  The same thing can be done in one line of code with the package's `redcap_read()` function:
```
ds <- redcap_read(redcap_uri=uri, token=token)$data
```

The `REDCapR` package includes the [Bundle of CA Root Certificates](http://curl.haxx.se/ca/cacert.pem) from the official [cURL site](http://curl.haxx.se).  Your REDCap server's identity is always verified, unless the setting is overridden (or alternative certificates can also be provided).

The `redcap_read()` function also accepts values for subsetting/filtering the records and fields.  The [current documentation](https://github.com/OuhscBbmc/REDCapR/blob/master/DocumentationPeek.pdf) can be found in the [GitHub repository](https://github.com/OuhscBbmc/REDCapR).  A [vignette](http://htmlpreview.github.io/?https://github.com/OuhscBbmc/REDCapR/blob/master/inst/doc/BasicREDCapROperations.html) has also been started.
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

Once the `redcap_write()` function is tested and documented, we'll release it on [CRAN](http://cran.r-project.org/web/packages/).  In the next few months, we hope to implement everything exposed by the REDCap API.  If there's a feature that would help your projects, feel free to post something here in the forums, or create an issue in REDCapR's [GitHub repository](https://github.com/OuhscBbmc/REDCapR/issues).  

Our group has benefited so much from REDCap and the surrounding community, and we'd like to contribute back.  Suggestions, criticisms, and code contributions are welcome.  And if anyone is interested in trying a direction that suits them better, we'll be happy to explain the package's internals and help you fork your own version.  We have some starting material described in the [`./documentation_for_developers/`](https://github.com/OuhscBbmc/REDCapR/tree/master/documentation_for_developers) directory.  Also two other libraries exist for communicating with REDCap: [redcap](https://github.com/nutterb/redcap) and its current [fork](https://github.com/nutterb/redcap) written for R, and [PyCap](http://sburns.org/PyCap/) written for Python.

Thanks, 
Will Beasley, David Bard, & Thomas Wilson

[University of Oklahoma Health Sciences Center](http://ouhsc.edu/),
[Department of Pediatrics](https://www.oumedicine.com/pediatrics),
[Biomedical & Behavioral Research Core](http://ouhsc.edu/BBMC/).

<!-- The development version of REDCapR can be installed from [R-Forge](https://r-forge.r-project.org/projects/redcapr/),
```
install.packages("REDCapR", repos="http://R-Forge.R-project.org")
``` -->

The development version of REDCapR can be installed from [GitHub](https://github.com/OuhscBbmc/REDCapR) after installing the `devtools` package.
```
install.packages("devtools")
devtools::install_github(repo="OuhscBbmc/REDCapR")
```
