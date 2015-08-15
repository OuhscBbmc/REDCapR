This release is in response to Kurt's request last week to fix a break due ot httr's slightly different configuration parameter.

Yesterday I submitted something that was flagged on one of the builds for (a) an export issue (fixed with the roxygen command `@importFrom methods new`) and (b) for two invalid URLs.  Those URLs are intentional and unavoidable; they lead to some very good information that's secured by the REDCap server developer.  Almost everyone using this REDCapR package will have access to the REDCap wiki.

Today I added a `skip_on_cran()` to the 'sanitize_last_names' test, b/c apparently the `base::iconv()` gives different results on platforms/configurations that I can't test.

I also made some updates to reflect newer CRAN policies (eg, using `requireNamespace()` instead of `require()`) and some change regarding how S4 and RC classes are documented.

I've checked it on two local machines (one Win7, and one Ubuntu), as well as a Linux build on Travis-CI (https://travis-ci.org/OuhscBbmc/REDCapR), a Windows build on AppVeyor (https://ci.appveyor.com/project/wibeasley/redcapr/history) and Uwe's win-builder (http://win-builder.r-project.org/DMn8pdP1W36K/).  Please tell me if there's something else I should do for CRAN.

-Will Beasley
