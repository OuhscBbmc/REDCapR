Description
-----------------------------------------------
This submission addresses breaking builds related to changing packages underneath.  It also adds new features.

Thank you for taking the time to review my submission, and please tell me if there's something else I should do for CRAN.  -Will Beasley


Test environments
-----------------------------------------------

* Local Ubuntu, R 3.3.1 patched
* Local Win8, R 3.3.1 patched
* Local Win8, R 3.4.0 devel
* [win-builder](http://win-builder.r-project.org/Y7BvJp8BAiH2/) (version="R-devel")
* [Travis CI](https://travis-ci.org/OuhscBbmc/REDCapR), Ubuntu 12.04 LTS
* [AppVeyor](https://ci.appveyor.com/project/wibeasley/REDCapR), Windows Server 2012


R CMD check results
-----------------------------------------------

* No ERRORs or WARNINGs on any builds.

* No NOTEs on win-builder.

* No other unexplainable NOTEs on the other builds.

* It doesn't appear to be an official "NOTE", but there is a message about 1 invalid URLs producing a "libcurl error code 6".  This is a fake url that demonstrates how to built one to their own REDCap server: `http://<*your server name*>/redcap/api/help`.

* It doesn't appear to be an official "NOTE", but there is a message about 2 invalid URLs producing a 403-Forbidden status. These are links to the private REDCap forums. These URLs are intentional and unavoidable; they lead to some very good information that's secured by the REDCap server developers. Almost everyone using this REDCapR package will have access to the REDCap forums. And if they're not in contact with an admin on their campus who has access to the wiki, there's a decent chance they're using the server without a license agreement. I've kept the count of the invalid links to a minimum (once per function), and suggested how the user should preocde if they don't have access.  These URL messages appear in the checks on some machines/builds, but not all.
    * https://community.projectredcap.org/articles/456/api-documentation.html
    * https://community.projectredcap.org/articles/462/api-examples.html

Downstream dependencies
-----------------------------------------------

No other packages depend/import this one.
