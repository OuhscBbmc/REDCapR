Description
===============================================

This submission is primarily to add new features added since October

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.6.1
2. Local Win11, R 4.6.1 patched
3. R-hub
    1. [Ubuntu Linux, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/18323818727/job/52183210338)
    2. [Windows Server, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/18323818727/job/52183210404)
    3. [MacOS, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/18323818727/job/52183210334)
4. win-builder: I haven't gotten a response during this afternoon.
5. [GitHub Actions R-CMD-check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/check-release.yaml), Ubuntu 24.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
* One NOTE:
  * On some builds, three urls produced a 403 in the check, but they resolve fine in the browser.
    * <http://osctr.ouhsc.edu>
    * <https://grantome.com/grant/NIH/P01-AG043362-05>
    * <https://grantome.com/grant/NIH/U54-GM104938>

Downstream dependencies
-----------------------------------------------

All packages that depend/import/suggest REDCapR pass the
[Reverse dependency check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/recheck.yml)s.
