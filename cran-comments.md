Description
===============================================

This submission is primarily to address a change in the REDCap server.  A lot of packages additions in the meantime were building up.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley

Test environments
-----------------------------------------------

1. Local Ubuntu, R 4.4.1
2. Local Win11, R 4.4.1 patched
3. R-hub
    1. [Ubuntu Linux, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/10748844649/job/29817754743)
    2. [Windows Server, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/10748844649/job/29817754878)
    3. [MacOS, R-devel](https://github.com/OuhscBbmc/REDCapR/actions/runs/10748844649/job/29817754969)
4. [win-builder](https://win-builder.r-project.org/6a44Y48qLSlw/), development version.
5. [GiHub Actions R-CMD-check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/check-release.yaml), Ubuntu 22.04 LTS

R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.
* One one Ubuntu build, there was this warning.  
  I don't understand the source.  I'm not calling any function called `tidy()` when I search.  And the two hyperlinks containing "tidy" look fine to my eye.
  
  ```
  ❯ checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  ```

Downstream dependencies
-----------------------------------------------

With one exception,
packages that depend/import/suggest REDCapR pass the 
[Reverse dependency check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/recheck.yml)s.

I worked with **tidyREDCap** team and they accepted a PR that fixes the problem:
<https://github.com/RaymondBalise/tidyREDCap/pull/61>.
It completes successfully on my local machine.

```
------- Check results summary ------
Check status summary:
                  ERROR NOTE OK
  Source packages     0    0  1
  Reverse depends     1    2  3

Check results summary:
REDCapR ... OK
rdepends_REDCapCAST ... OK
rdepends_REDCapDM ... NOTE
* checking data for non-ASCII characters ... NOTE
rdepends_REDCapTidieR ... OK
rdepends_ReviewR ... NOTE
* checking data for non-ASCII characters ... NOTE
rdepends_codified ... OK
rdepends_tidyREDCap ... ERROR
* checking tests ... ERROR
```

Results: <https://github.com/OuhscBbmc/REDCapR/blob/main/revdep/cran.md>
