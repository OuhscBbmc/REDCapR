Description
===============================================

This submission is primarily to add new features added since October

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.6.1
2. Local Win11, R 4.6.1 patched
3. [R-hub](https://github.com/OuhscBbmc/REDCapR/actions/runs/31197522139)
    * Ubuntu Linux, R-devel
    * Windows Server, R-devel
    * MacOS, R-devel
4. [win-builder](https://win-builder.r-project.org/YUxp940bDu6Z)
5. [GitHub Actions R-CMD-check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/check-release.yaml), Ubuntu

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
* One NOTE:
  * On some builds, a few urls produced a note in the check, but they resolve fine in the browser.
    * <https://www.amazon.com/stores/Yihui-Xie/author/B00E9CQJGY>
    * The <https://grantome.com/> pages

Downstream dependencies
-----------------------------------------------

All packages that depend/import/suggest REDCapR pass the
[Reverse dependency check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/recheck.yml)s.
