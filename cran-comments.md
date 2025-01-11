Description
===============================================

This submission is primarily to address vignettes were calling an external server.
When that dev server had maintenance on
[Dec 13](https://www.stats.ox.ac.uk/pub/bdr/Rblas/MKL/REDCapR.out), Brian Ripley requested that
the vignettes be modified to comply with the CRAN policy that states
no external sources should be called.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.4.2
2. Local Win11, R 4.4.2 patched
3. R-hub
    1. [Ubuntu Linux, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/12719261459/job/35459171237)
    2. [Windows Server, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/12719261459/job/35459171426)
    3. [MacOS, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/12719261459/job/35459171708)
4. [win-builder](https://win-builder.r-project.org/O603j9cGa700), development version.
5. [GiHub Actions R-CMD-check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/check-release.yaml), Ubuntu 24.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
* One NOTE:
  * <https://www.hhs.gov/answers/hipaa/what-is-phi/index.html> produced a 403 in the check, but it resolves fine in the browser.

Downstream dependencies
-----------------------------------------------

All packages that depend/import/suggest REDCapR pass the
[Reverse dependency check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/recheck.yml)s.
