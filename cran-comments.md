This release is in response to Kurt's request last week to fix a break due ot httr's slightly differen configuration parameter.

I also made some updates to reflect newer CRAN policies (eg, using `requireNamespace()` instead of `require()`).

I've checked it on three local machines (one Win7, one Ubuntu, and one Red Hat server), as well as a Linux build on Travis-CI (https://travis-ci.org/OuhscBbmc/REDCapR), a Windows build on AppVeyor (https://ci.appveyor.com/project/wibeasley/redcapr/history) and Uwe's win-builder (http://win-builder.r-project.org/7fR2E6Q3F1FJ/).  Please tell me if there's something else I should do for CRAN.

On some machines, I receive the warning "Undocumented S4 classes: 'redcap_project' All user-level objects in a package (including S4 classes and methods) should have documentation entries.".  I believe this is a false positive, because this class appears in the reference manual, around page 10: https://github.com/OuhscBbmc/REDCapR/blob/master/documentation_peek.pdf.

-Will Beasley
