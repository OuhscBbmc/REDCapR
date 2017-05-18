| [GitHub](https://github.com/OuhscBbmc/REDCapR) | [Travis-CI](https://travis-ci.org/OuhscBbmc/REDCapR/builds) | [AppVeyor](https://ci.appveyor.com/project/wibeasley/redcapr/history) | [Coveralls](https://coveralls.io/r/OuhscBbmc/REDCapR) |
| :----- | :---------------------------: | :-----------------------------: | :-------: |
| [Master](https://github.com/OuhscBbmc/REDCapR/tree/master) | [![Build Status](https://travis-ci.org/OuhscBbmc/REDCapR.svg?branch=master)](https://travis-ci.org/OuhscBbmc/REDCapR) | [![Build status](https://ci.appveyor.com/api/projects/status/0i41tn0n2jo4pd2k/branch/master?svg=true)](https://ci.appveyor.com/project/wibeasley/redcapr/branch/master) | [![Coverage Status](https://coveralls.io/repos/OuhscBbmc/REDCapR/badge.svg?branch=master)](https://coveralls.io/r/OuhscBbmc/REDCapR?branch=master) |
| [Dev](https://github.com/OuhscBbmc/REDCapR/tree/dev) | [![Build Status](https://travis-ci.org/OuhscBbmc/REDCapR.svg?branch=dev)](https://travis-ci.org/OuhscBbmc/REDCapR) | [![Build status](https://ci.appveyor.com/api/projects/status/0i41tn0n2jo4pd2k/branch/dev?svg=true)](https://ci.appveyor.com/project/wibeasley/redcapr/branch/dev) | [![Coverage Status](https://coveralls.io/repos/OuhscBbmc/REDCapR/badge.svg?branch=dev)](https://coveralls.io/r/OuhscBbmc/REDCapR?branch=dev) | -- |
| | *Ubuntu 12.04 LTS* | *Windows Server 2012* | *Test Coverage* | *Independently-hosted Archive* |


[REDCapR](https://github.com/OuhscBbmc/REDCapR)
=======
We’ve been using R with [REDCap](https://projectredcap.org/)’s API since the Fall 2012 and have developed some functions that we're assembling in an R package: [`REDCapR`](https://github.com/OuhscBbmc/REDCapR).  The release version and documentation is on [CRAN](https://cran.r-project.org/package=REDCapR), while the development site for collaboration is on [GitHub](https://github.com/OuhscBbmc/REDCapR).

It was taking 50+ lines of code to contact REDCap and robustly transform the returned CSV into an R `data.frame`; it took twice that much to implement batching.  All this can be done in one line of R code with the package's [`redcap_read()`](https://www.rdocumentation.org/packages/REDCapR/topics/redcap_read) function:
```r
ds <- redcap_read(redcap_uri=uri, token=token)$data
```

The [`redcap_read()`](https://www.rdocumentation.org/packages/REDCapR/topics/redcap_read) function also accepts values for subsetting/filtering the records and fields.  The [development version's documentation](https://github.com/OuhscBbmc/REDCapR/blob/master/documentation-peek.pdf) can be found in the [GitHub repository](https://github.com/OuhscBbmc/REDCapR).  A [vignette](https://cdn.rawgit.com/OuhscBbmc/REDCapR/master/inst/doc/BasicREDCapROperations.html) has also been started.  Here's are two examples; the first selects only a portion of the rows, while the second selects only a portion of the columns.
```r
#Return only records with IDs of 1 and 4
desired_records <- c(1, 4)
ds_some_rows <- redcap_read(
  redcap_uri   = uri,
  token        = token,
  records      = desired_records
)$data

#Return only the fields record_id, name_first, and age
desired_fields <- c("record_id", "name_first", "age")
ds_some_fields <- redcap_read(
  redcap_uri  = uri,
  token       = token,
  fields      = desired_fields
)$data
```

The `REDCapR` package includes the SSL certificate retrieved by [`httr`'s `find_cert_bundle()`](https://github.com/hadley/httr/blob/master/R/utils.r).  Your REDCap server's identity is always verified, unless the setting is overridden (or alternative certificates can also be provided).

To keep our maintence efforts managable, the package implements only the REDCap API functions that have been requested.  If there's a feature that would help your projects, please tell us about it in a new issue in REDCapR's [GitHub repository](https://github.com/OuhscBbmc/REDCapR/issues).  A [troubleshooting](https://cdn.rawgit.com/OuhscBbmc/REDCapR/master/inst/doc/TroubleshootingApiCalls.html) document helps diagnose issues with the API.

Our group has benefited from REDCap and the surrounding community, and we'd like to contribute back.  Suggestions, criticisms, and code contributions are welcome.  And if anyone is interested in trying a direction that suits them better, we'll be happy to explain the package's internals and help you fork your own version.  We have some starting material described in the [`./documentation_for_developers/`](https://github.com/OuhscBbmc/REDCapR/tree/master/documentation-for-developers) directory.  Also checkout the other libraries that exist for communicating with REDCap, which are listed in the [REDCap Tools](http://redcap-tools.github.io/projects/) directory.

We'd like to thank the following developers for their [advice](https://github.com/OuhscBbmc/REDCapR/issues?q=is%3Aissue+is%3Aclosed) and [code contributions](https://github.com/OuhscBbmc/REDCapR/graphs/contributors): [Rollie Parrish](https://github.com/rparrish), [Scott Burns](https://github.com/sburns), [Benjamin Nutter](https://github.com/nutterb), [John Aponte](https://github.com/johnaponte), [Andrew Peters](https://github.com/ARPeters), and [Hao Zhu](https://github.com/haozhu233).

Thanks,
[Will Beasley](https://www.researchgate.net/profile/William_Beasley2), David Bard, & Thomas Wilson

[University of Oklahoma Health Sciences Center](http://ouhsc.edu/),
[Department of Pediatrics](https://www.oumedicine.com/department-of-pediatrics),
[Biomedical & Behavioral Research Core](http://ouhsc.edu/BBMC/).

### Download and Installation Instructions

#### All Operating Systems

| [CRAN](https://cran.r-project.org/) | [Version](https://cran.r-project.org/package=REDCapR) | [Rate](http://cranlogs.r-pkg.org/) | [Zenodo](https://zenodo.org/search?ln=en&p=redcapr) | [RDocumentation](https://www.rdocumentation.org/) |
|  :---- | :----: | :----: | :----: | :----: | 
| [Latest](https://cran.r-project.org/package=REDCapR) | [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/REDCapR)](https://cran.r-project.org/package=REDCapR) | ![CRANPace](http://cranlogs.r-pkg.org/badges/REDCapR) | [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.61990.svg)](http://dx.doi.org/10.5281/zenodo.61990) | [![Rdoc](http://www.rdocumentation.org/badges/version/REDCapR)](http://www.rdocumentation.org/packages/REDCapR) |
|   | *Latest CRAN version* | *CRAN Downloads* | *Independently-hosted Archive* | *HTML Documentation* |

The *release* version of REDCapR can be installed from [CRAN](https://cran.r-project.org/package=REDCapR).
```r
install.packages("REDCapR")
```

The *development* version of REDCapR can be installed from [GitHub](https://github.com/OuhscBbmc/REDCapR) after installing the `devtools` package.
```r
install.packages("devtools")
devtools::install_github(repo="OuhscBbmc/REDCapR")
```

#### Linux

If installing on Linux, the default R CHECK command will try (and fail) to install the (nonvital) RODBC package.  While this package isn't necessary to interact with your REDCap server (and thus not necesssary for the core features of REDCapR).  To check REDCapR's installation on Linux, run the following R code.  Make sure the working directory is set to the root of the REDCapR directory; this will happen automatically when you use RStudio to open the `REDCapR.Rproj` file.
```r
devtools::check(force_suggests = FALSE)
```

Alternatively, the [RODBC](https://CRAN.R-project.org/package=RODBC) package can be installed from your distribution's repository using the shell.  Here are instructions for [Ubuntu](https://cran.r-project.org/bin/linux/ubuntu/README.html) and [Red Hat](https://cran.r-project.org/bin/linux/redhat/README).  `unixodbc` is necessary for the [`RODBCext`](https://CRAN.R-project.org/package=RODBCext) R package to be built.

```shell
#From Ubuntu terminal
sudo apt-get install r-cran-rodbc unixodbc-dev

#From Red Hat terminal
sudo yum install R-RODBC unixODBC-devel
```

### Collaborative Development
We encourage input and collaboration from the overall community.  If you're familar with GitHub and R packages, feel free to submit a [pull request](https://github.com/OuhscBbmc/REDCapR/pulls).  If you'd like to report a bug or make a suggestion, please create a GitHub [issue](https://github.com/OuhscBbmc/REDCapR/issues); issues are a usually a good place to ask public questions too.  However, feel free to email Will (<wibeasley@hotmail.com>).  Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md); by participating in this project you agree to abide by its terms.

### Thanks to Funders

Much of this package has been developed to support the needs of the following projects.  We appreciate the support.

* *OUHSC CCAN Independent Evaluation of the State of Oklahoma Competitive Maternal, Infant, and Early Childhood Home Visiting ([MIECHV](http://mchb.hrsa.gov/programs/homevisiting/)) Project*. [HRSA/ACF D89MC23154](https://perf-data.hrsa.gov/mchb/DGISReports/Abstract/AbstractDetails.aspx?Source=TVIS&GrantNo=D89MC23154&FY=2012).  David Bard, PI, OUHSC; 2011-2015.

* *Independent Evaluation of the State of OK MIECHV Evidence Based Home Visitation Project*, [NIH](https://www.nih.gov/)-sponsored collaboration with [OSDH](https://www.ok.gov/health/). David Bard, PI, OUHSC; 2015-2017.

* *OSDH ParentPRO Pilot Evaluation*, federally-sponsored collaboration with [OSDH](https://www.ok.gov/health/).  David Bard, PI, OUHSC; 2015-2017.

* *Title IV-E Waiver Project*, [HRSA/MCHB](http://mchb.hrsa.gov/)-sponsored collaboration with [OKDHS](http://www.okdhs.org/); David Bard, PI, OUHSC; 2014-2017.

* *Integrative Analysis of Longitudinal Studies of Aging (IALSA)*, sponsored by [NIH 5P01AG043362](http://grantome.com/grant/NIH/P01-AG043362).  Scott Hofer, PI, University of Victoria; Will Beasley, PI of site-award, OUHSC; 2013-2018.

* *Oklahoma Shared Clinical and Translational Resources*, sponsored by [NIH NIGMS; U54 GM104938](http://grantome.com/grant/NIH/U54-GM104938). Judith A. James, PI, OUHSC; 2013-2018.

* Additional Insitutional Support from OUHSC [Dept of Pediatrics](https://www.oumedicine.com/department-of-pediatrics); 2013-2017.

(So far) the primary developers of REDCapR are the external evaluators for [Oklahoma's MIECHV](https://www.ok.gov/health/Community_&_Family_Health/Family_Support_and_Prevention_Service/MIECHV_Program_-_Federal_Home_Visiting_Grant/MIECHV_Program_Resources/index.html) program.  See the prelimary CQI reports (many of which use REDCapR) at http://ouhscbbmc.github.io/MReportingPublic/.
