super-wide-3
===============

The project.xml file is too large to include in an R package (500Kb compressed, 100MB uncompressed).

So perform these manual steps to create the project on a new server.

1. Create blank project
1. Create user role "api" with only these privileges:
   1. API import
   1. API export
   1. Data Access Groups
1. Add user "unittestphifree" to role
1. Create token and copy it to the server's credential file
1. Run <generate-project.R>
   1. to generate the dictionary to this test project's directory, then
   1. wait for the script to hit a `stop()` command, next
   1. upload <super-wide-3-dictionary.csv> via the browser, and finally
   1. run the rest of the R file to upload the data via the api.
      (This takes ~25 min to upload.)
1. Delete <super-wide-3-dictionary.csv>, if desired.
   This file is ignored/blocked from being committed to the repo
