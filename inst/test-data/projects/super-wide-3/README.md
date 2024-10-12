super-wide-3
===============

The project.xml file is too large to include in an R package (500Kb compressed, 100MB uncompressed).

So perform these manual steps to create the project on a new server.

1. Create blank project
1. Create user role "api" with API import & export privileges
1. Add user "unittestphifree" to role
1. Create token
1. Run <generate-project.R> to
   1. generate the dictionary (then upload it)
   1. upload the data via the api
