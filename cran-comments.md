Description
===============================================

This submission is primarily to address a unit test that is lacking a `testthat::skip_on_cran()` call.  It also includes a few new features.

Periodically there is a [single CRAN daily note](https://cran.rstudio.com/web/checks/check_results_REDCapR.html); it has been addressed (<https://github.com/OuhscBbmc/REDCapR/issues/352>).

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.2.1 patched
1. Local Win10, R 4.2.1 patched
1. R-hub
    1. [Ubuntu Linux 20.04 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapR_1.0.0.tar.gz-d554cfab8fed4acba83ca159d2a14a7b)
    1. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapR_1.0.0.tar.gz-80a6d6b66bb84847b61d31f6029f5628)
    1. [Windows Server](https://builder.r-hub.io/status/REDCapR_1.0.0.tar.gz-b5b0cb95fb4746f9b354071b89caaafa)
1. [win-builder](https://win-builder.r-project.org/BwNz2bnHxuse), development version.
1. [GiHub Actions](https://github.com/OuhscBbmc/REDCapR/actions), Ubuntu 20.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
  * One ignorable exception:  the win-builder and Windows Server R-hub builds don't yet have the newest version of readr.  I see they're using readr 1.4.0 and returns the error "Package required and available but unsuitable version: 'readr'".  But it runs well on my two local Windows machines.
  * A second ignorable exception: R-hub refers to Bioconductor, which REDCapR doesn't use: "Error : Bioconductor does not yet build and check packages for R version 4.2;"

* A NOTE is returned for a few websites.  All are accessible by browser.
  * https://grantome.com/grant/NIH/P01-AG043362
  * https://grantome.com/grant/NIH/U54-GM104938
  * https://taggs.hhs.gov/Detail/AwardDetail?arg_AwardNum=U54GM104938&arg_ProgOfficeCode=127
  * https://www.researchgate.net/profile/William-Beasley-5

Downstream dependencies
-----------------------------------------------

No downstream pakcages are affected.  The two packages that depends/imports/suggests REDCapR passes checks with `revdepcheck::revdep_check()`.  Results: https://github.com/OuhscBbmc/REDCapR/blob/master/revdep/cran.md
  
    * [codified](https://CRAN.R-project.org/package=codified)
    * [ReviewR](https://CRAN.R-project.org/package=ReviewR)
