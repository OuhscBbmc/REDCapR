Description
-----------------------------------------------
This submission includes new features and also addresses some (soon-to-be) breaking changes in the libraries underneath.

I have fixed the three points described in your previous response (documented in [our issue](https://github.com/OuhscBbmc/REDCapR/issues/253)).  For the first point, I fixed some markdown syntax so  the API's url is correctly interpreted.  I'm sorry the test builds below didn't uncover the last two.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

1. Local Ubuntu, R 3.6.1 patched
1. Local Win8, R 3.6.1 patched
1. r-hub
    1. [Ubuntu Linux 16.04 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapR_0.10.1.tar.gz-ffc36a958fe44f3fb3263929670f8138)
    1. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapR_0.10.1.tar.gz-2e2bed0d3cda44429a8f830c2b9d8e92)
    1. [Windows Server](https://builder.r-hub.io/status/REDCapR_0.10.1.tar.gz-0c79ee0f9b3e49f7b381348e9f7283b0)
1. [win-builder](https://win-builder.r-project.org/a9ub2IBAb24W), development version.
1. [Travis CI](https://travis-ci.org/OuhscBbmc/REDCapR), Ubuntu 14.04 LTS
1. [AppVeyor](https://ci.appveyor.com/project/wibeasley/REDCapR), Windows Server 2012


R CMD check results
-----------------------------------------------

* No ERRORs, WARNINGs, or NOTEs on any builds.


Downstream dependencies
-----------------------------------------------

No downstream pakcages are affecteed.  Only one package depends/imports REDCapR, and it passes my local checks.
    * [codified](https://CRAN.R-project.org/package=codified)
