Description
===============================================

This submission includes new features and also addresses recent breaking tests from readr 2.0 (<https://github.com/OuhscBbmc/REDCapR/issues/343>).

The [single existing CRAN daily note](https://cran.rstudio.com/web/checks/check_results_REDCapR.html) has been addressed (ie, 'LazyData' is specified without a 'data' directory).

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.1.0 patched
1. Local Win8, R 4.1.0 patched
1. R-hub
    1. [Ubuntu Linux 20.04 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapR_1.0.0.tar.gz-d554cfab8fed4acba83ca159d2a14a7b)
    1. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapR_1.0.0.tar.gz-80a6d6b66bb84847b61d31f6029f5628)
    1. [Windows Server](https://builder.r-hub.io/status/REDCapR_1.0.0.tar.gz-b5b0cb95fb4746f9b354071b89caaafa)
1. [win-builder](https://win-builder.r-project.org/BwNz2bnHxuse), development version.
1. [GiHub Actions](https://github.com/OuhscBbmc/REDCapR/actions), Ubuntu 20.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
  * One ignorable exception:  the win-builder and Windows Server R-hub builds don't yet have the newest version of readr.  I see they're using 1.4.0 and returns the error "Package required and available but unsuitable version: 'readr'".  But it runs well on my two local Windows machines.
  * A second ignorable exception: R-hub refers to Bioconductor, which REDCapR doesn't use: "Error : Bioconductor does not yet build and check packages for R version 4.2;"

* A NOTE is returned for the Zenodo.org URL being possibly invalid.  It resolves in a browser, but is takes a while; I'm guessing their website's slow today.

Downstream dependencies
-----------------------------------------------

No downstream pakcages are affected.  The two packages that depends/imports/suggests REDCapR passes checks with `revdepcheck::revdep_check()`.  Results: https://github.com/OuhscBbmc/REDCapR/blob/master/revdep/cran.md
  
    * [codified](https://CRAN.R-project.org/package=codified)
    * [ReviewR](https://CRAN.R-project.org/package=ReviewR)
