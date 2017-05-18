Description
-----------------------------------------------
This submission addresses breaking tests related to changing packages underneath (mostly the curl package I think; described in #154).  Kurt had requested that I update the CRAN version a few weeks ago.  I made the changes and was waiting until [dplyr 0.6.0](https://blog.rstudio.org/2017/04/13/dplyr-0-6-0-coming-soon/) was released on CRAN, since dplyr is used in several important places.  But the release date appears to have been pushed back, and the RTools checks are working with the dev version anyway.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

The win-builder and a local machine have used the CRAN version of dplyr.  The others have used the current GitHub master version of dplyr.

* Local Ubuntu, R 3.4.0 patched
* Local Win8, R 3.4.0 patched
* Local Win8, R 3.4.0 devel
* [win-builder](https://win-builder.r-project.org/3wAMI67afYVu/) (version="R-devel")
* [Travis CI](https://travis-ci.org/OuhscBbmc/REDCapR), Ubuntu 12.04 LTS
* [AppVeyor](https://ci.appveyor.com/project/wibeasley/REDCapR), Windows Server 2012


R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.

* No NOTEs on win-builder.

* No other unexplainable NOTEs on the other builds.


Downstream dependencies
-----------------------------------------------

No other packages depend/import this one.
