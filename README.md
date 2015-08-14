<!-- rmarkdown v1 -->

| [GitHub](https://github.com/OuhscBbmc/REDCapR) | [Travis-CI](https://travis-ci.org/OuhscBbmc/REDCapR/builds) | [AppVeyor](https://ci.appveyor.com/project/wibeasley/redcapr/history) | [Coveralls](https://coveralls.io/r/OuhscBbmc/REDCapR) |
| :----- | :---------------------------: | :-----------------------------: | :-------: |
| [Master](https://github.com/OuhscBbmc/REDCapR/tree/master) | [![Build Status](https://travis-ci.org/OuhscBbmc/REDCapR.svg?branch=master)](https://travis-ci.org/OuhscBbmc/REDCapR) | [![Build status](https://ci.appveyor.com/api/projects/status/0i41tn0n2jo4pd2k/branch/master?svg=true)](https://ci.appveyor.com/project/wibeasley/redcapr/branch/master) | [![Coverage Status](https://coveralls.io/repos/OuhscBbmc/REDCapR/badge.svg?branch=master)](https://coveralls.io/r/OuhscBbmc/REDCapR?branch=master) |
| [Dev](https://github.com/OuhscBbmc/REDCapR/tree/dev) | [![Build Status](https://travis-ci.org/OuhscBbmc/REDCapR.svg?branch=dev)](https://travis-ci.org/OuhscBbmc/REDCapR) | [![Build status](https://ci.appveyor.com/api/projects/status/0i41tn0n2jo4pd2k/branch/dev?svg=true)](https://ci.appveyor.com/project/wibeasley/redcapr/branch/dev) | [![Coverage Status](https://coveralls.io/repos/OuhscBbmc/REDCapR/badge.svg?branch=dev)](https://coveralls.io/r/OuhscBbmc/REDCapR?branch=dev) | -- |
| | *Ubuntu 12.04 LTS* | *Windows Server 2012* | *Test Coverage* | *Independently-hosted Archive* |


REDCapR
=======
We’ve been using R with REDCap’s API since the Fall 2012 and have developed some functions that we're assembling in an R package: `REDCapR`.  The release version and documentation is on [CRAN](http://cran.r-project.org/package=REDCapR), while the development site for collaboration is on [GitHub](https://github.com/OuhscBbmc/REDCapR).

It was taking us a minimum of 50 lines of code to contact REDCap and robustly transform the returned CSV into an R `data.frame`.  It took more than twice that much code to implement batching.  All this can be done in one line of R code with the package's `redcap_read()` function:
```r
ds <- redcap_read(redcap_uri=uri, token=token)$data
```

The `REDCapR` package includes the [Bundle of CA Root Certificates](http://curl.haxx.se/ca/cacert.pem) from the official [cURL site](http://curl.haxx.se).  Your REDCap server's identity is always verified, unless the setting is overridden (or alternative certificates can also be provided).

The `redcap_read()` function also accepts values for subsetting/filtering the records and fields.  The [most recent documentation](https://github.com/OuhscBbmc/REDCapR/blob/master/documentation_peek.pdf) can be found in the [GitHub repository](https://github.com/OuhscBbmc/REDCapR).  A [vignette](http://htmlpreview.github.io/?https://github.com/OuhscBbmc/REDCapR/blob/master/inst/doc/BasicREDCapROperations.html) has also been started.  Here's are two examples; the first selects only a portion of the rows, while the second selects only a portion of the columns.
```r
#Return only records with IDs of 1 and 4
desired_records <- c(1, 4)
ds_some_rows <- redcap_read(
   redcap_uri = uri, 
   token = token, 
   records = desired_records
)$data

#Return only the fields record_id, name_first, and age
desired_fields <- c("record_id", "name_first", "age")
ds_some_fields <- redcap_read(
   redcap_uri = uri, 
   token = token, 
   fields = desired_fields
)$data
```

In the next year, we hope to implement everything exposed by the REDCap API.  If there's a feature that would help your projects, feel free to post something here in the forums, or create an issue in REDCapR's [GitHub repository](https://github.com/OuhscBbmc/REDCapR/issues).  A [troubleshooting](http://htmlpreview.github.io/?https://github.com/OuhscBbmc/REDCapR/blob/master/inst/doc/TroubleshootingApiCalls.html) document helps diagnose issues with the API.

Our group has benefited so much from REDCap and the surrounding community, and we'd like to contribute back.  Suggestions, criticisms, and code contributions are welcome.  And if anyone is interested in trying a direction that suits them better, we'll be happy to explain the package's internals and help you fork your own version.  We have some starting material described in the [`./documentation_for_developers/`](https://github.com/OuhscBbmc/REDCapR/tree/master/documentation_for_developers) directory.  Also a few other libraries exist for communicating with REDCap: [redcapAPI](https://github.com/nutterb/redcapAPI) written in R (which is a fork of [redcap](https://github.com/jeffreyhorner/redcap)), [RedcapAPI](https://github.com/eugyev/RedcapAPI) written in Ruby, [REDCap_API](https://github.com/james2012/REDCap_API) written in JavaScript, [PyCap](http://sburns.org/PyCap/) written in Python, and [PhpCap](https://github.com/aarenson/PhpCap) written in PHP. (When you're choosing a library, consider if you need one that's been updated since REDCap's version 6.0.0 changes in Sept 2014).

We'd like to thank the following developers for their [advice](https://github.com/OuhscBbmc/REDCapR/issues?q=is%3Aissue+is%3Aclosed) and [code contributions](https://github.com/OuhscBbmc/REDCapR/graphs/contributors): [Rollie Parrish](https://github.com/rparrish), [Scott Burns](https://github.com/sburns), [Benjamin Nutter](https://github.com/nutterb), [John Aponte](https://github.com/johnaponte), and [Andrew Peters](https://github.com/ARPeters).

Thanks, 
[Will Beasley](https://www.researchgate.net/profile/William_Beasley2), David Bard, & Thomas Wilson

[University of Oklahoma Health Sciences Center](http://ouhsc.edu/),
[Department of Pediatrics](https://www.oumedicine.com/pediatrics),
[Biomedical & Behavioral Research Core](http://ouhsc.edu/BBMC/).

### Download and Installation Instructions

#### All Operating Systems

| [CRAN](http://cran.rstudio.com/) | [Version](http://cran.r-project.org/package=REDCapR) | [Rate](http://cranlogs.r-pkg.org/) | [Zenodo](https://zenodo.org/search?ln=en&p=redcapr) | 
|  :---- | :----: | :----: | :----: |
| [Latest](http://cran.r-project.org/package=REDCapR) | [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/REDCapR)](http://cran.r-project.org/package=REDCapR) | ![CRANPace](http://cranlogs.r-pkg.org/badges/REDCapR) | [![DOI](https://zenodo.org/badge/4971/OuhscBbmc/REDCapR.svg)](http://dx.doi.org/10.5281/zenodo.13326) |
|   | *Latest CRAN version* | *CRAN Downloads* | *Independently-hosted Archive* |

<!-- The development version of REDCapR can be installed from [R-Forge](https://r-forge.r-project.org/projects/redcapr/),
```r
install.packages("REDCapR", repos="http://R-Forge.R-project.org")
``` -->

The *release* version of REDCapR can be installed from [CRAN](http://cran.r-project.org/package=REDCapR).
```r
install.packages("REDCapR")
```

The *development* version of REDCapR can be installed from [GitHub](https://github.com/OuhscBbmc/REDCapR) after installing the `devtools` package.
```r
install.packages("devtools")
devtools::install_github(repo="OuhscBbmc/REDCapR")
```

#### Linux

If installing on Linux, the default R CHECK command will try (and fail) to install the (nonvital) RODBC package.  While this package isn't available for Windows, isn't necessary to interact with your REDCap server (and thus not necesssary for the core features of REDCapR).  To check REDCapR's installation on Linux, run the following R code.  Make sure the working directory is set to the root of the REDCapR directory; this will happen automatically when you use RStudio to open the `REDCapR.Rproj` file.
```r
devtools::check(force_suggests = FALSE)
```

Alternatively, the RODBC package can be installed from your distribution's repository using the shell.  Here are instructions for [Ubuntu](http://cran.r-project.org/bin/linux/ubuntu/README.html) and [Red Hat](http://cran.r-project.org/bin/linux/redhat/README).
```shell
#From Ubuntu terminal
sudo apt-get install r-cran-rodbc

#From Red Hat terminal
sudo yum install R-RODBC
```

### Collaborative Development
We encourage input and collaboration from the overall community.  If you're familar with GitHub and R packages, feel free to submit a [pull request](https://github.com/OuhscBbmc/REDCapR/pulls).  If you'd like to report a bug or make a suggestion, please create a GitHub [issue](https://github.com/OuhscBbmc/REDCapR/issues); issues are a usually a good place to ask public questions too.  However, feel free to email Will (<wibeasley@hotmail.com>).  Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

### Thanks to Funders
*OUHSC CCAN Independent Evaluation of the State of Oklahoma Competitive Maternal, Infant, and Early Childhood Home Visiting ([MIECHV](http://mchb.hrsa.gov/programs/homevisiting/)) Project.*: Evaluates MIECHV expansion and enhancement of Evidence-based Home Visitation programs in four Oklahoma counties. [HRSA/ACF D89MC23154](https://perf-data.hrsa.gov/mchb/DGISReports/Abstract/AbstractDetails.aspx?Source=TVIS&GrantNo=D89MC23154&FY=2012).  

(So far) the primary developers of REDCapR are the external evaluators for [Oklahoma's MIECHV](http://www.ok.gov/health/Child_and_Family_Health/Family_Support_and_Prevention_Service/MIECHV_Program_-_Federal_Home_Visiting_Grant/MIECHV_Program_Resources/index.html) program.  See the prelimary CQI reports (many of which use REDCapR) at http://ouhscbbmc.github.io/MReportingPublic/.
