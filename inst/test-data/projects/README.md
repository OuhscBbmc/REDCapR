Test Projects
================

Steps to recreate on a fresh server

1.  Create two accounts for testing:
    Table-based accounts are probably easiest.
    Tests are case-sensitive.
    1. 'unittestphifree': First name = "Unit Test"; Last name "Phi Free".
    1. 'unittestphifree-dag1': First name = "Unit Test"; Last name "PHI Free DAG1"
1.  Copy all the projects to the new server
    (I find it easier to walk down the credential file as I add them.)
1.  Assign the user (created above) to the "api" user role for each project.
1.  Add a token for each project
1.  Create a credential file for the new project
    (examples [1](https://github.com/OuhscBbmc/REDCapR/blob/main/inst/misc/example.credentials) and
    [2](https://github.com/OuhscBbmc/REDCapR/blob/main/inst/misc/dev-2.credentials))
    1.  Update `redcap_uri`
    1.  Update the corresponding `project_id`
    1.  Update the corresponding `token`
    1.  Leave `username` and `comment` untouched
1.  Add new entries to [project-redirection.yml](https://github.com/OuhscBbmc/REDCapR/blob/main/inst/misc/project-redirection.yml)
1.  Install plugins
    1.  Copy from [source](https://github.com/OuhscBbmc/REDCapR/tree/main/utility/plugins)
    1.  Change the `project_id` value at the bottom of each php file.
    1.  Move to destination directory
    1.  Update [plugin-redirection.yml](https://github.com/OuhscBbmc/REDCapR/blob/main/inst/misc/plugin-redirection.yml)
