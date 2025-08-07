Description
===============================================

This submission is primarily to address an example that called an external server.
Brian Ripley requested that it be modified to comply with the CRAN policy that states
no external sources should be called.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.4.2
2. Local Win11, R 4.4.2 patched
3. R-hub
    1. [Ubuntu Linux, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/16556199643/job/46817960404)
    2. [Windows Server, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/16556199643/job/46817960397)
    3. [MacOS, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/16556199643/job/46817960406)
4. [win-builder](https://win-builder.r-project.org/1P2wqjw560kmrevdepcheck::revdep_check(num_workers = 4)
), development version.
5. [GiHub Actions R-CMD-check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/check-release.yaml), Ubuntu 24.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
* One NOTE:
  * On some builds, five urls produced a 403 in the check, but they resolve fine in the browser.

Downstream dependencies
-----------------------------------------------

All packages that depend/import/suggest REDCapR pass the
[Reverse dependency check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/recheck.yml)s.
