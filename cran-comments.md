Description
===============================================

This submission is primarily to address a change in the REDCap server.  A lot of packages additions in the meantime were building up.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.2.2
2. Local Win11, R 4.3.1 patched
3. R-hub
    1. [Ubuntu Linux, R-release, GCC](https://builder.r-hub.io/status/REDCapR_1.1.9005.tar.gz-6f45462d131a4ac49833c0c7c014bad0)
    2. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapR_1.1.9005.tar.gz-2e9560e6fcdb4467af8e9ea8d22c165d)
    3. [Windows Server](https://builder.r-hub.io/status/REDCapR_1.1.9005.tar.gz-3ec1ed8fac734d24a16cc5ecf238cf47)
4. [win-builder](https://win-builder.r-project.org/N3n87tj2ky0v/), development version.
5. [GiHub Actions](https://github.com/OuhscBbmc/REDCapR/actions), Ubuntu 22.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.

* There are two NOTEs across the R-hub builds:

  ```txt
  * checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'
  ```
  As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this could be due to a bug/crash in MiKTeX and can likely be ignored.

  ```txt
  * checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  ```

  Based on [this discussion](https://groups.google.com/g/r-sig-mac/c/7u_ivEj4zhM?pli=1)
  and [this SO answer](https://stackoverflow.com/a/75007979/1082435),
  it sounds like a problem with the testing environment and not the package code.

Downstream dependencies
-----------------------------------------------

With one exception,
packages that depend/import/suggest REDCapR pass checks with `revdepcheck::revdep_check()`.

I worked with **tidyREDCap** team and they accepted a PR that fixes the problem:
<https://github.com/RaymondBalise/tidyREDCap/pull/61>.

package                                  | E        | W        | N
-------                                  | -        | -        | -
codified 0.3.0                           | E: 0     | W: 0     | N: 0
REDCapDM 0.7.0                           | E: 0     | W: 0     | N: 1
REDCapCAST 23.6.2                        | E: 0     | W: 0     | N: 0
REDCapTidieR 0.4.0                       | E: 1     | W: 0     | N: 0
tidyREDCap 1.1.1                         | E: 0  +1 | W: 0     | N: 0
ReviewR 2.3.8                            | E: 0     | W: 0     | N: 1

Results: <https://github.com/OuhscBbmc/REDCapR/blob/main/revdep/cran.md>
