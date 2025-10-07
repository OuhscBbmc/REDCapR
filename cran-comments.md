Description
===============================================

This submission is primarily to address an example that called an external server.
Brian Ripley requested that it be modified to comply with the CRAN policy that states
no external sources should be called.

This is the second time this year an example has slipped through like this.
I have done two things that should prevent this from happening again:

1. I reviewed all 40 instances of the `@example` tag.  About half call a server
2. I standardized their appearance, and made sure they all are wrapped with `\dontrun{}` from beginning to end.

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
    These seem to be related to the government shutdown.
    Withholding any political commentary that will get our funding cut further,
    here is a banner on an HHS page: "Mission-critical activities of HHS will continue during the Democrat-led government shutdown. Please use this site as a resource as the Trump Administration works to reopen the government for the American people."

Downstream dependencies
-----------------------------------------------

All packages that depend/import/suggest REDCapR pass the
[Reverse dependency check](https://github.com/OuhscBbmc/REDCapR/actions/workflows/recheck.yml)s.
