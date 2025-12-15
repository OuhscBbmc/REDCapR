# Read a token and other credentials from a (non-REDCap) database or file

These functions are not essential to calling the REDCap API, but instead
are functions that help manage tokens securely.

## Usage

``` r
retrieve_credential_local(
  path_credential,
  project_id,
  check_url            = TRUE,
  check_username       = FALSE,
  check_token_pattern  = TRUE,
  username             = NA_character_
)

retrieve_credential_mssql(
  project_id,
  instance,
  dsn,
  channel    = NULL
)

create_credential_local(
  path_credential
)
```

## Arguments

- path_credential:

  The file path to the CSV containing the credentials. Required.

- project_id:

  The ID assigned to the project withing REDCap. This allows the user to
  store tokens to multiple REDCap projects in one file. Required

- check_url:

  A `logical` value indicates if the url in the credential file should
  be checked to have approximately the correct form. Defaults to TRUE.
  `retrieve_credential_local()`.

- check_username:

  A `logical` value indicates if the username in the credential file
  should be checked against the username returned by R. Defaults to
  FALSE.

- check_token_pattern:

  A `logical` value indicates if the token in the credential file is a
  32-character hexadecimal string. Defaults to FALSE.

- username:

  A character value used to retrieve a credential. See the Notes below.
  Optional.

- instance:

  The casual name associated with the REDCap instance on campus. This
  allows one credential system to accommodate multiple instances on
  campus. Required

- dsn:

  A [DSN](https://en.wikipedia.org/wiki/Data_source_name) on the local
  machine that points to the desired MSSQL database. Required.

- channel:

  An *optional* connection handle as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).
  See Details below. Optional.

## Value

A list of the following elements are returned from
`retrieve_credential_local()` and `retrieve_credential_mssql()`:

- `redcap_uri`: The URI of the REDCap Server.

- `username`: Username.

- `project_id`: The ID assigned to the project within REDCap.

- `token`: The token to pass to the REDCap server

- `comment`: An optional string that is ignored by REDCapR but can be
  helpful for humans.

## Details

If the database elements are created with the script provided in
package's 'Security Database' vignette, the default values will work.

The `create_credential_local()` function copies a [static
file](https://github.com/OuhscBbmc/REDCapR/blob/master/inst/misc/skeleton.credentials)
to the location specified in the `path_credential` argument. Each record
represents one accessible project per user. Follow these steps to adapt
to your desired REDCap project(s):

1.  Modify the credential file for the REDCap API with a text editor
    like [Notepad++](https://notepad-plus-plus.org/), Visual Studio
    Code, or [nano](https://www.nano-editor.org/). Replace existing
    records with the information from your projects. Delete the
    remaining example records.

2.  Make sure that the file (with the sensitive password-like) tokens is
    stored securely!

3.  Contact your REDCap admin to request the URI & token and discuss
    institutional policies.

4.  Ask your institution's IT security team for their recommendation

5.  For more info, see
    https://ouhscbbmc.github.io/REDCapR/articles/workflow-read.html and
    https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.html

6.  Double-check the file is secured and not accessible by other users.

## Note

*Storing credentials on a server is preferred*

Although we strongly encourage storing all the tokens on a central
server (*e.g.*, see the `retrieve_credential_mssql()` function and the
"SecurityDatabase" vignette), there are times when this approach is not
feasible and the token must be stored locally. Please contact us if your
institution is using something other than SQL Server, and would like
help adapting this approach to your infrastructure.

*Storing credentials locally*

When storing credentials locally, typically the credential file should
be dedicated to just one user. Occasionally it makes sense to store
tokens for multiple users –usually it's for the purpose of testing.

The `username` field is connected only in the local credential file. It
does not need to be the same as the official username in REDCap.

## Author

Will Beasley

## Examples

``` r
# \dontrun{
# ---- Local File Example ----------------------------
path <- system.file("misc/dev-2.credentials", package = "REDCapR")
(p1  <- REDCapR::retrieve_credential_local(path, 33L))
#> $redcap_uri
#> [1] "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#> 
#> $username
#> [1] "myusername"
#> 
#> $project_id
#> [1] 33
#> 
#> $token
#> [1] "9A068C425B1341D69E83064A2D273A70"
#> 
#> $comment
#> [1] "simple"
#> 
(p2  <- REDCapR::retrieve_credential_local(path, 34L))
#> $redcap_uri
#> [1] "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#> 
#> $username
#> [1] "myusername"
#> 
#> $project_id
#> [1] 34
#> 
#> $token
#> [1] "DA6F2BB23146BD5A7EA3408C1A44A556"
#> 
#> $comment
#> [1] "longitudinal"
#> 


# Create a skeleton of the local credential file to modify
path_demo <- base::tempfile(pattern = "temp", fileext = ".credentials")

create_credential_local(path_demo)
#> [1] TRUE

base::unlink(path_demo) # This is just a demo; don't delete the real file!
# }
```
