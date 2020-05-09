Description
-----------------------------------------------
This submission includes new features and also addresses a recent breaking change from tibble 3.0.0 (https://github.com/OuhscBbmc/REDCapR/issues/302).

After the first submission, I've changed the links to the HRSA and Health Dept sites.  I guess there is some problem with redirection.  Although the health dept sites work in my browser, they're still returning useful sites in a browser.  I've tried a few variations fo rht eurl that work in a browser, but still get flagged by win-builder.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

1. Local Ubuntu, R 3.6.3 patched
1. Local Win8, R 4.0.0 RC
1. r-hub
    1. [Ubuntu Linux 16.04 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapR_0.10.2.9006.tar.gz-71151f2f04454bc18c16430e5d62610b)
    1. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapR_0.10.2.9006.tar.gz-2f619028b765442f9dc1c34373443d2a)
    1. [Windows Server](https://builder.r-hub.io/status/REDCapR_0.10.2.9006.tar.gz-80133501925a411da4c3cf3be8205e29)
1. [win-builder](https://win-builder.r-project.org/xYyWrC1uFjXH), development version.
1. [Travis CI](https://travis-ci.org/OuhscBbmc/REDCapR), Ubuntu 14.04 LTS
1. [AppVeyor](https://ci.appveyor.com/project/wibeasley/REDCapR), Windows Server 2012 R2


R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGson any builds.

* Two notes are returned for Health Dept sites, but they work in a browser.


Downstream dependencies
-----------------------------------------------

No downstream pakcages are affecteed.  Only one package depends/imports REDCapR, and it passes my local checks.
    * [codified](https://CRAN.R-project.org/package=codified)
