[REDCapR](https://github.com/OuhscBbmc/REDCapR)  <img src="man/figures/logo.png" align="right" width="130" />
=======

We’ve been using R with [REDCap](https://projectredcap.org/)’s API since 2012 and have developed   [`REDCapR`](https://github.com/OuhscBbmc/REDCapR).  Before encapsulating these functions in a package, we were replicating 50+ lines of code to contact REDCap and robustly transform the returned [csv](https://en.wikipedia.org/wiki/Comma-separated_values) into an R `data.frame`; it took twice that much to implement batching.  All this can be done in one call to [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html):

```r
ds <- redcap_read(redcap_uri=uri, token=token)$data
```

The [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html) function also accepts values for subsetting/filtering the records and fields.  Here are two examples; the first selects only a portion of the rows, while the second selects only a portion of the columns.  Documentation for the additional 20+ functions are found at [ouhscbbmc.github.io/REDCapR/reference](https://ouhscbbmc.github.io/REDCapR/reference/).

```r
# Return only records with IDs of 1 and 4
desired_records <- c(1, 4)
ds_some_rows <- redcap_read(
  redcap_uri   = uri,
  token        = token,
  records      = desired_records
)$data

# Return only the fields record_id, name_first, and age
desired_fields <- c("record_id", "name_first", "age")
ds_some_fields <- redcap_read(
  redcap_uri  = uri,
  token       = token,
  fields      = desired_fields
)$data
```

The `REDCapR` package includes the SSL certificate retrieved by [`httr::find_cert_bundle()`](https://github.com/r-lib/httr/blob/master/R/utils.r).  Your REDCap server's identity is always verified, unless the setting is overridden (alternative certificates can also be provided).

To keep our maintenance efforts manageable, the package implements only the REDCap API functions that have been requested.  If there's a feature that would help your projects, please tell us in a new issue in REDCapR's [GitHub repository](https://github.com/OuhscBbmc/REDCapR/issues).  A [troubleshooting](https://ouhscbbmc.github.io/REDCapR/articles/TroubleshootingApiCalls.html) document helps diagnose issues with the API.


### Installation and Documentation

The *release* version can be installed from [CRAN](https://cran.r-project.org/package=REDCapR).
```r
install.packages("REDCapR")
```

The *development* version can be installed from [GitHub](https://github.com/OuhscBbmc/REDCapR) after installing the `remotes` package.

```r
install.packages("remotes") # Run this line if the 'remotes' package isn't installed already.
remotes::install_github(repo="OuhscBbmc/REDCapR")
```
The  [ouhscbbmc.github.io/REDCapR](https://ouhscbbmc.github.io/REDCapR) site describes the package functions, and includes documents involving [basic operations](https://ouhscbbmc.github.io/REDCapR/articles/BasicREDCapROperations.html), [advanced operations](https://ouhscbbmc.github.io/REDCapR/articles/advanced-redcapr-operations.html), [token security](https://ouhscbbmc.github.io/REDCapR/articles/SecurityDatabase.html), and
[troubleshooting](https://ouhscbbmc.github.io/REDCapR/articles/TroubleshootingApiCalls.html).

Also checkout the other packages that exist for communicating with REDCap, which are listed in the [REDCap Tools](http://redcap-tools.github.io/projects/) directory.


### Collaborative Development
We encourage input and collaboration.  If you're familiar with GitHub and R packages, feel free to submit a [pull request](https://github.com/OuhscBbmc/REDCapR/pulls).  If you'd like to report a bug or make a suggestion, please create a GitHub [issue](https://github.com/OuhscBbmc/REDCapR/issues); issues are a usually a good place to ask public questions too.  However, feel free to email Will (<wibeasley@hotmail.com>).  Please note that this project is released with a [Contributor Code of Conduct](https://github.com/OuhscBbmc/REDCapR/blob/master/CONDUCT.md); by participating in this project you agree to abide by its terms.  We have some starting material described in the [`./documentation-for-developers/`](https://github.com/OuhscBbmc/REDCapR/tree/master/documentation-for-developers) directory.  

We'd like to thank the following developers for their [advice](https://github.com/OuhscBbmc/REDCapR/issues?q=is%3Aissue+is%3Aclosed) and [code contributions](https://github.com/OuhscBbmc/REDCapR/graphs/contributors): [Benjamin Nutter](https://github.com/nutterb), [Rollie Parrish](https://github.com/rparrish), [Scott Burns](https://github.com/sburns), [John Aponte](https://github.com/johnaponte), [Andrew Peters](https://github.com/ARPeters), and [Hao Zhu](https://github.com/haozhu233).

### Funders

Much of this package has been developed to support the needs of the following projects.  We appreciate the support.  (So far) the primary developers of REDCapR are the external evaluators for [Oklahoma's MIECHV](https://www.ok.gov/health/Family_Health/Family_Support_and_Prevention_Service/index.html) program.  See the preliminary CQI reports (many of which use REDCapR) at http://ouhscbbmc.github.io/MReportingPublic/.

* *OUHSC CCAN Independent Evaluation of the State of Oklahoma Competitive Maternal, Infant, and Early Childhood Home Visiting ([MIECHV](http://mchb.hrsa.gov/programs/homevisiting/)) Project*. [HRSA/ACF D89MC23154](https://grants6.hrsa.gov/MCHB/DGISReports/Abstract/AbstractDetails.aspx?cbAbstractSummary=D89MC23154_2012_NonResearch_4).  David Bard, PI, OUHSC; 2011-2015.
* *Independent Evaluation of the State of OK MIECHV Evidence Based Home Visitation Project*, [NIH](https://www.nih.gov/)-sponsored collaboration with [OSDH](https://ok.gov/health/). David Bard, PI, OUHSC; 2015-2017.
* *OSDH ParentPRO Pilot Evaluation*, federally-sponsored collaboration with [OSDH](https://ok.gov/health/).  David Bard, PI, OUHSC; 2015-2017.
* *Title IV-E Waiver Project*, [HRSA/MCHB](http://mchb.hrsa.gov/)-sponsored collaboration with [OKDHS](http://www.okdhs.org/); David Bard, PI, OUHSC; 2014-2017.
* *Integrative Analysis of Longitudinal Studies of Aging (IALSA)*, sponsored by [NIH 5P01AG043362](http://grantome.com/grant/NIH/P01-AG043362).  Scott Hofer, PI, University of Victoria; Will Beasley, PI of site-award, OUHSC; 2013-2018.
* *Oklahoma Shared Clinical and Translational Resources*, sponsored by [NIH NIGMS; U54 GM104938](http://grantome.com/grant/NIH/U54-GM104938). Judith A. James, PI, OUHSC; 2013-2018.
* Additional Institutional Support from OUHSC [Dept of Pediatrics](https://www.oumedicine.com/department-of-pediatrics); 2013-2017.

Thanks,
[Will Beasley](https://www.researchgate.net/profile/William_Beasley2), David Bard, & Thomas Wilson<br/>
[University of Oklahoma Health Sciences Center](http://ouhsc.edu/),
[Department of Pediatrics](https://www.oumedicine.com/department-of-pediatrics),
[Biomedical & Behavioral Research Core](http://ouhsc.edu/BBMC/).

### Build Status and Package Characteristics

| [GitHub](https://github.com/OuhscBbmc/REDCapR) | [Travis-CI](https://travis-ci.org/OuhscBbmc/REDCapR/builds) | [AppVeyor](https://ci.appveyor.com/project/wibeasley/redcapr/history) | [Coveralls](https://coveralls.io/r/OuhscBbmc/REDCapR) | [Codecov](https://codecov.io/gh/OuhscBbmc/REDCapR) |
| :----- | :---------------------------: | :-----------------------------: | :-------: | :-------: |
| [Master](https://github.com/OuhscBbmc/REDCapR/tree/master) | [![Build Status](https://travis-ci.org/OuhscBbmc/REDCapR.svg?branch=master)](https://travis-ci.org/OuhscBbmc/REDCapR) | [![Build status](https://ci.appveyor.com/api/projects/status/0i41tn0n2jo4pd2k/branch/master?svg=true)](https://ci.appveyor.com/project/wibeasley/redcapr/branch/master) | [![Coverage Status](https://coveralls.io/repos/github/OuhscBbmc/REDCapR/badge.svg?branch=master)](https://coveralls.io/github/OuhscBbmc/REDCapR?branch=master) | [![codecov](https://codecov.io/gh/OuhscBbmc/REDCapR/branch/master/graph/badge.svg)](https://codecov.io/gh/OuhscBbmc/REDCapR) |
| [Dev](https://github.com/OuhscBbmc/REDCapR/tree/dev) | [![Build Status](https://travis-ci.org/OuhscBbmc/REDCapR.svg?branch=dev)](https://travis-ci.org/OuhscBbmc/REDCapR) | [![Build status](https://ci.appveyor.com/api/projects/status/0i41tn0n2jo4pd2k/branch/dev?svg=true)](https://ci.appveyor.com/project/wibeasley/redcapr/branch/dev) | [![Coverage Status](https://coveralls.io/repos/github/OuhscBbmc/REDCapR/badge.svg?branch=dev)](https://coveralls.io/github/OuhscBbmc/REDCapR?branch=dev) | [![codecov](https://codecov.io/gh/OuhscBbmc/REDCapR/branch/dev/graph/badge.svg)](https://codecov.io/gh/OuhscBbmc/REDCapR/branch/dev) |
| | *Ubuntu LTS* | *Windows Server* | *Test Coverage* | *Test Coverage* |

| Key | Value |
| :--- | :----- |
| [License](https://choosealicense.com/) | [![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html) |
| [CRAN Version](https://cran.r-project.org/package=REDCapR) | [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/REDCapR)](https://cran.r-project.org/package=REDCapR) |
| [CRAN Rate](http://cranlogs.r-pkg.org/) | ![CRAN Pace](http://cranlogs.r-pkg.org/badges/REDCapR) |
| [Zenodo Archive](https://zenodo.org/search?ln=en&p=redcapr) | [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.61990.svg)](https://doi.org/10.5281/zenodo.61990) |
| [Production Doc](https://www.rdocumentation.org/) | [![Rdoc](http://www.rdocumentation.org/badges/version/REDCapR)](http://www.rdocumentation.org/packages/REDCapR) |
| [Development Doc](https://www.rdocumentation.org/) | [![Rdoc](https://img.shields.io/badge/pkgdown-GitHub.io-orange.svg?longCache=true&style=style=for-the-badge)](https://ouhscbbmc.github.io/REDCapR/) |
