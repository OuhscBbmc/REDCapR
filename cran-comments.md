Description
-----------------------------------------------
This submission is a slight improvement over last week's.  In my tests, I didn't account for the OS X builds where RODBC wasn't available, which resulted in build errors.  These six tests now begin with `testthat::skip_if_not_installed(pkg = "RODBC")`.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

* Local Win8, R 3.2.2 patched
* [win-builder](http://win-builder.r-project.org/4cRj9cDqXPBe) (version="R-devel")
* [Travis CI](https://travis-ci.org/OuhscBbmc/REDCapR), Ubuntu 12.04 LTS
* [AppVeyor](https://ci.appveyor.com/project/wibeasley/REDCapR), Windows Server 2012


R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.

* No NOTEs on win-builder.

* No other unexplainable NOTEs on the other builds.

* It doesn't appear to be an official "NOTE", but there is a message about 2 invalid URLs producing a 403-Forbidden status.  These are links to the private REDCap wiki.  These URLs are intentional and unavoidable; they lead to some very good information that's secured by the REDCap server developers.  Almost everyone using this REDCapR package will have access to the [REDCap wiki](https://iwg.devguard.com/trac/redcap/).  And if they're not in contact with an admin on their campus who has access to the wiki, there's a decent chance they're using the server without a license agreement.  I've kept the count of the invalid links to a minimum (once per function), and suggested how the user should preocde if they don't have access.
    1. https://iwg.devguard.com/trac/redcap/wiki/ApiDocumentation
    2. https://iwg.devguard.com/trac/redcap/wiki/ApiExamples


Downstream dependencies
-----------------------------------------------

No other packages depend/import this one.
