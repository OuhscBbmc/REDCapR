Description
===============================================

This submission includes new features and also addresses recent breaking tests from readr 2.0 (<https://github.com/OuhscBbmc/REDCapR/issues/343>).

The [single existing CRAN daily note](https://cran.rstudio.com/web/checks/check_results_REDCapR.html) has been addressed (ie, 'LazyData' is specified without a 'data' directory).

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.1.0 patched
1. Local Win8, R 4.1.0 patched
1. r-hub
    1. [Ubuntu Linux 16.04 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapR_0.10.2.9006.tar.gz-71151f2f04454bc18c16430e5d62610b)
    1. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapR_0.10.2.9006.tar.gz-2f619028b765442f9dc1c34373443d2a)
    1. [Windows Server](https://builder.r-hub.io/status/REDCapR_0.10.2.9006.tar.gz-80133501925a411da4c3cf3be8205e29)
1. [win-builder](https://win-builder.r-project.org/xYyWrC1uFjXH), development version.
1. [GiHub Actions](https://github.com/OuhscBbmc/REDCapR/actions), Ubuntu 20.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.

* Two notes are returned for Health Dept sites, but they work in a browser.

Downstream dependencies
-----------------------------------------------

No downstream pakcages are affected.  The two packages that depends/imports/suggests REDCapR passes checks with `revdepcheck::revdep_check()`.  Results: https://github.com/OuhscBbmc/REDCapR/blob/master/revdep/cran.md
  
    * [codified](https://CRAN.R-project.org/package=codified)
    * [ReviewR](https://CRAN.R-project.org/package=ReviewR)
