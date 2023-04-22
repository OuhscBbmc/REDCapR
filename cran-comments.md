Description
===============================================

This submission is primarily to address a recent change in the REDCap server.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.2.2
2. Local Win10, R 4.2.3 patched
3. R-hub
    1. [Ubuntu Linux 20.04 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapR_1.1.9005.tar.gz-aa1d5ab8d07d453db1f07927d1ad23f4)
    2. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapR_1.1.9005.tar.gz-a56bc6477bbb48d2a4aa5d1872481dac)
    3. [Windows Server](https://builder.r-hub.io/status/REDCapR_1.1.9005.tar.gz-34917c524b674b82860b920d177844f1)
4. [win-builder](https://win-builder.r-project.org/eG6x3HZ9ITqN), development version.
5. [GiHub Actions](https://github.com/OuhscBbmc/REDCapR/actions), Ubuntu 20.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.

* A NOTE is returned for a few websites.  All are accessible by browser.
  * <https://community.projectredcap.org> is a site accessible only to REDCap administrators
  * <https://grantome.com/grant/NIH/P01-AG043362>
  * <https://grantome.com/grant/NIH/U54-GM104938>
  * <https://taggs.hhs.gov/Detail/AwardDetail?arg_AwardNum=U54GM104938&arg_ProgOfficeCode=127>
  * <https://www.researchgate.net/profile/William-Beasley-5>

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

No downstream packages are affected.  The package that depends/imports/suggests REDCapR passes checks with `revdepcheck::revdep_check()`.  Results: https://github.com/OuhscBbmc/REDCapR/blob/main/revdep/cran.md

* [ReviewR](https://CRAN.R-project.org/package=ReviewR)
