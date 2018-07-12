#' @docType package
#' @name REDCapR-package
#' @aliases REDCapR
#'
#' @title R utilities for interacting with a REDCap data system <http://www.project-redcap.org/>
#'
#' @description
#'
#' Comprehensive documentation is also available at https://ouhscbbmc.github.io/REDCapR/.
#'
#' Much of this package has been developed to support the needs of the following projects.  We appreciate the support.
#' * *OUHSC CCAN Independent Evaluation of the State of Oklahoma Competitive Maternal, Infant, and Early Childhood Home Visiting ([MIECHV](http://mchb.hrsa.gov/programs/homevisiting/)) Project*. [HRSA/ACF D89MC23154](https://perf-data.hrsa.gov/mchb/DGISReports/Abstract/AbstractDetails.aspx?Source=TVIS&GrantNo=D89MC23154&FY=2012).  David Bard, PI, OUHSC; 2011-2015.
#' * *Independent Evaluation of the State of OK MIECHV Evidence Based Home Visitation Project*, [NIH](https://www.nih.gov/)-sponsored collaboration with [OSDH](https://www.ok.gov/health/). David Bard, PI, OUHSC; 2015-2017.
#' * *OSDH ParentPRO Pilot Evaluation*, federally-sponsored collaboration with [OSDH](https://www.ok.gov/health/).  David Bard, PI, OUHSC; 2015-2017.
#' * *Title IV-E Waiver Project*, [HRSA/MCHB](http://mchb.hrsa.gov/)-sponsored collaboration with [OKDHS](http://www.okdhs.org/); David Bard, PI, OUHSC; 2014-2017.
#' * *Integrative Analysis of Longitudinal Studies of Aging (IALSA)*, sponsored by [NIH 5P01AG043362](http://grantome.com/grant/NIH/P01-AG043362).  Scott Hofer, PI, University of Victoria; Will Beasley, PI of site-award, OUHSC; 2013-2018.
#' * *Oklahoma Shared Clinical and Translational Resources*, sponsored by [NIH NIGMS; U54 GM104938](http://grantome.com/grant/NIH/U54-GM104938). Judith A. James, PI, OUHSC; 2013-2018.
#' * Additional Institutional Support from OUHSC [Dept of Pediatrics](https://www.oumedicine.com/department-of-pediatrics); 2013-2017.
#'
#'
#' @note The release version is available through [CRAN](https://cran.r-project.org/package=REDCapR) by
#' running `install.packages('REDCapR')`.
#' The most recent development version is available through [GitHub](https://github.com/OuhscBbmc/REDCapR) by
#' running
#' `devtools::install_github('OuhscBbmc/REDCapR')`
#' (make sure [devtools](https://cran.r-project.org/package=devtools) is already installed).
#' If you're having trouble with the package, please install the development version.  If this doesn't solve
#' your problem, please create a [new issue](https://github.com/OuhscBbmc/REDCapR/issues), or email Will.
#'
#'
#' See REDCapR's advanced vignette for information and examples for overriding the default SSL options.
#'
#' @examples
#' \dontrun{
#' # Install/update REDCapR with the release version from CRAN.
#' install.packages('REDCapR')
#'
#' # Install/update REDCapR with the development version from GitHub
#' #install.packages('devtools') #Uncomment if `devtools` isn't installed already.
#' devtools::install_github('OuhscBbmc/REDCapR')
#' }
NULL
