Description
-----------------------------------------------
This submission addresses breaking builds related to changing packages underneath.  It also adds new features.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

* Local Win8, R 3.3.1 patched
* Local Win8, R 3.4.0 devel
* [win-builder](http://win-builder.r-project.org/BDqs64SUjccd/) (version="R-devel")
* [Travis CI](https://travis-ci.org/OuhscBbmc/REDCapR), Ubuntu 12.04 LTS
* [AppVeyor](https://ci.appveyor.com/project/wibeasley/REDCapR), Windows Server 2012


R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.

* No NOTEs on win-builder.

* No other unexplainable NOTEs on the other builds.

* It doesn't appear to be an official "NOTE", but there is a message about 1 invalid URLs producing a "libcurl error code 6".  This is a fake url that demonstrates how to built one to their own REDCap server: `http://<*your server name*>/redcap/api/help`.


Downstream dependencies
-----------------------------------------------

No other packages depend/import this one.
