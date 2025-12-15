# Collection of REDCap-specific constants

Collection of constants defined by the REDCap developers.

## Usage

``` r
constant(name)
```

## Arguments

- name:

  Name of constant. Required character.

## Value

The constant's value. Currently all are single integers, but that could
be expanded in the future.

## Details

**Form Completeness**

The current constants relate to the 'complete' variable at the end of
each form.

- `form_incomplete`: 0L (*i.e.*, an integer)

- `form_unverified`: 1L

- `form_complete`: 2L

**Export Rights**

See https://your-server/redcap/api/help/?content=exp_users.

- `data_export_rights_no_access` : 0L

- `data_export_rights_deidentified` : 1L

- `data_export_rights_full` : 2L

**Form Rights**

See https://your-server/redcap/api/help/?content=exp_users. The order of
these digits may be unexpected.

- `form_rights_no_access` : 0L

- `form_rights_readonly` : 2L

- `form_rights_edit_form` : 1L

- `form_rights_edit_survey` : 3L

**Access Rights**

See https://your-server/redcap/api/help/?content=exp_users.

- `access_no` : 0L

- `access_yes` : 1L

To add more, please for and edit
[constant.R](https://github.com/OuhscBbmc/REDCapR/blob/master/R/constant.R)
on GitHub and submit a pull request. For instructions, please see
[Editing files in another user's
repository](https://docs.github.com/articles/editing-files-in-another-user-s-repository/)
\# nolint in the GitHub documentation.

## Author

Will Beasley

## Examples

``` r
REDCapR::constant("form_incomplete")  # Returns 0L
#> [1] 0
REDCapR::constant("form_unverified")  # Returns 1L
#> [1] 1
REDCapR::constant("form_complete"  )  # Returns 2L
#> [1] 2

REDCapR::constant("data_export_rights_no_access"   )  # Returns 0L
#> [1] 0
REDCapR::constant("data_export_rights_deidentified")  # Returns 1L
#> [1] 1
REDCapR::constant("data_export_rights_full"        )  # Returns 2L
#> [1] 2

REDCapR::constant("form_rights_no_access")   # Returns 0L
#> [1] 0
REDCapR::constant("form_rights_readonly" )   # Returns 2L --Notice the order
#> [1] 2
REDCapR::constant("form_rights_edit_form")   # Returns 1L
#> [1] 1
REDCapR::constant("form_rights_edit_survey") # Returns 3L
#> [1] 3

REDCapR::constant("access_no" )  # Returns 0L
#> [1] 0
REDCapR::constant("access_yes")  # Returns 1L
#> [1] 1

REDCapR::constant(c(
  "form_complete",
  "form_complete",
  "form_incomplete"
)) # Returns c(2L, 2L, 0L)
#> [1] 2 2 0
REDCapR::constant(c(
  "form_rights_no_access",
  "form_rights_readonly",
  "form_rights_edit_form",
  "form_rights_edit_survey"
)) # Returns c(0L, 2L, 1L, 3L)
#> [1] 0 2 1 3


constant_to_form_completion( c(0, 2, 1, 2, NA))
#> [1] incomplete complete   unverified complete   unknown   
#> Levels: incomplete unverified complete unknown
constant_to_form_rights(     c(0, 2, 1, 2, NA))
#> [1] no_access readonly  edit_form readonly  unknown  
#> Levels: no_access readonly edit_form edit_survey unknown
constant_to_export_rights(   c(0, 2, 1, 3, NA))
#> [1] no_access    rights_full  deidentified <NA>         unknown     
#> Levels: no_access deidentified rights_full unknown
constant_to_access(          c(0, 1, 1, 0, NA))
#> [1] no      yes     yes     no      unknown
#> Levels: no yes unknown

# \dontrun{
# The following line returns an error:
#     Assertion on 'name' failed: Must be a subset of
#     {'form_complete','form_incomplete','form_unverified'},
#     but is {'bad-name'}.

REDCapR::constant("bad-name")    # Returns an error
#> Error in REDCapR::constant("bad-name"): Assertion on 'name' failed: Must be a subset of {'form_incomplete','form_unverified','form_complete','data_export_rights_no_access','data_export_rights_deidentified','data_export_rights_full','form_rights_no_access','form_rights_readonly','form_rights_edit_form','form_rights_edit_survey','access_no','access_yes'}, but has additional elements {'bad-name'}.

REDCapR::constant(c("form_complete", "bad-name")) # Returns an error
#> Error in REDCapR::constant(c("form_complete", "bad-name")): Assertion on 'name' failed: Must be a subset of {'form_incomplete','form_unverified','form_complete','data_export_rights_no_access','data_export_rights_deidentified','data_export_rights_full','form_rights_no_access','form_rights_readonly','form_rights_edit_form','form_rights_edit_survey','access_no','access_yes'}, but has additional elements {'bad-name'}.
# }
```
