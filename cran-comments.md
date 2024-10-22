Description
===============================================

This submission is primarily to address a failing test.
One of the test (out of hundreds) was missing `testthat::skip_on_cran()`.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.4.1
2. Local Win11, R 4.4.1 patched
3. R-hub
    1. [Ubuntu Linux, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/11469699615/job/31917444604)
    2. [Windows Server, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/11469699615/job/31917445020)
    3. [MacOS, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/11469699615/job/31917445170)
4. [win-builder](https://win-builder.r-project.org/7m12AMR9sIC2//), development version.
5. [GiHub Actions R-CMD-check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/check-release.yaml), Ubuntu 22.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
* One NOTE:
  * <https://www.hhs.gov/answers/hipaa/what-is-phi/index.html> produced a 403 in the check, but it resolves fine in the browser.

Downstream dependencies
-----------------------------------------------

All packages that depend/import/suggest REDCapR pass the
[Reverse dependency check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/recheck.yml)s.
