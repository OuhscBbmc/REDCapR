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
    1. [Ubuntu Linux 20.04 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapR_1.1.0.tar.gz-65720cf9ae694996b81294e2ade39175)
    1. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapR_1.1.0.tar.gz-dfbf2b851e0c48aeaaf8e85c9c34c332)
    1. [Windows Server](https://builder.r-hub.io/status/REDCapR_1.1.0.tar.gz-6fe170ebb60e41469336c822ca3465da)
1. [win-builder](https://win-builder.r-project.org/BwNz2bnHxuse), development version.
1. [GiHub Actions](https://github.com/OuhscBbmc/REDCapR/actions), Ubuntu 20.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.

* A NOTE is returned for a few websites.  All are accessible by browser.
  * https://grantome.com/grant/NIH/P01-AG043362
  * https://grantome.com/grant/NIH/U54-GM104938
  * https://taggs.hhs.gov/Detail/AwardDetail?arg_AwardNum=U54GM104938&arg_ProgOfficeCode=127
  * https://www.researchgate.net/profile/William-Beasley-5

* There is one NOTE that is only found on R-hub Windows (Server 2022, R-devel 64-bit):

  ```txt
  * checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'
  As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this could be due to a bug/crash in MiKTeX and can likely be ignored.
  ```

* There is one NOTE that is only found on the R-hub Fedora:

  ```txt
  * checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  ```

  Based on [this discussion](https://groups.google.com/g/r-sig-mac/c/7u_ivEj4zhM?pli=1), it sounds like a problem with the testing environment, and not the package code.

Downstream dependencies
-----------------------------------------------

No downstream packages are affected.  The two packages that depends/imports/suggests REDCapR passes checks with `revdepcheck::revdep_check()`.  Results: https://github.com/OuhscBbmc/REDCapR/blob/master/revdep/cran.md

    * [codified](https://CRAN.R-project.org/package=codified)
    * [ReviewR](https://CRAN.R-project.org/package=ReviewR)
