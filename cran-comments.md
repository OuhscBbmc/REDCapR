Description
-----------------------------------------------
This submission includes new features and also addresses some (soon-to-be) breaking changes in the libraries underneath.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

The win-builder and a local machine have used the CRAN version of dplyr.  The others have used the current GitHub master version of dplyr.

* Local Ubuntu, R 3.6.1 patched
* Local Win8, R 3.6.1 patched
* [r-hub](https://builder.r-hub.io/status/REDCapR_0.10.1.tar.gz-b2178285b2ac4196bce254c553eaab50)
    * Ubuntu Linux 16.04 LTS, R-release, GCC
    * Fedora Linux, R-devel, clang, gfortran
* [win-builder](https://win-builder.r-project.org/3wAMI67afYVu/), development version.
* [Travis CI](https://travis-ci.org/OuhscBbmc/REDCapR), Ubuntu 14.04 LTS
* [AppVeyor](https://ci.appveyor.com/project/wibeasley/REDCapR), Windows Server 2012


R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
* There is one NOTE related to the url `https://bbmc.ouhsc.edu/redcap/api/`.  This url is the root of the API, and not intended to be navigated to by humans.


Downstream dependencies
-----------------------------------------------

No other packages depend/import this one.
