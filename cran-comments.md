This release is in response to Kurt's request last week to fix a break due ot httr's slightly differen configuration parameter.

I also made some updates to reflect newer CRAN policies (eg, using `requireNamespace()` instead of `require()`) snd some change regarding how S4 and RC classes are documented.

I've checked it on two local machines (one Win7, and one Ubuntu), as well as a Linux build on Travis-CI (https://travis-ci.org/OuhscBbmc/REDCapR), a Windows build on AppVeyor (https://ci.appveyor.com/project/wibeasley/redcapr/history) and Uwe's win-builder (http://win-builder.r-project.org/py6pNOb1gyLR/).  Please tell me if there's something else I should do for CRAN.

-Will Beasley
