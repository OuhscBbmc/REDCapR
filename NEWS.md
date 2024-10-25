# REDCapR (development version)

Release History
==========================================================

<!-- pkgdown won't show this section because the header doesn't match a pattern. -->
Quick links:

* [CRAN Archive of older versions](https://cran.r-project.org/src/contrib/Archive/REDCapR/)
* [Current & previous GitHub Issues](https://github.com/OuhscBbmc/REDCapR/issues?q=is%3Aissue)
* [Documentation for current GitHub version](https://ouhscbbmc.github.io/REDCapR/)

Version 1.4.x  (Not yet released on CRAN)
==========================================================

These features are not yet on CRAN.  Install with `remotes::install_github("OuhscBbmc/REDCapR")`

### New Features

* `redcap_file_repo_list_oneshot()` export a list of files/folders from the file repository (requested by @agdamsbo, #549)

Version 1.3.0  (released 2024-10-22)
==========================================================

### Minor Enhancements

* Redirection layer for test suite allows you to plug in your own server (#539, #542, #544)
* Skip a test when checked on CRAN servers (but not on local or GitHub Action machines)

Version 1.2.0  (released 2024-09-08)
==========================================================

### Possibly Breaking Change

These changes could possibly break existing code --but it's very unlikely.  We feel they will (directly and indirectly) improve the package considerably.

* `redcap_read()`, `redcap_read_oneshot()`, `redcap_dag_read()`, `redcap_log_read()`, and `redcap_report()` return a [tibble](https://tibble.tidyverse.org/) instead of a [data.frame](https://stat.ethz.ch/R-manual/R-devel/library/base/html/data.frame.html).  (#415)

    This should affect client code only if you expect a call like `ds[, 3]` to return a vector instead of a single-column data.frame/tibble.  One solution is to upcast the tibble to a data.frame (with something like `as.data.frame()`).  We recommend using an approach that works for both data.frames and tibbles, such as `ds[[3]]` or `dplyr::pull(ds, "gender")`.

    For more information, read the short chapter in [*R for Data Science*](https://r4ds.had.co.nz/tibbles.html).

* The `*_collapsed` parameters are deprecated.  When your want to limit on records/fields/forms/events, pass the vector of characters, not the scalar character separated by commas (which I think everyone does already).  In other words use `c("demographics", "blood_pressure")` instead of `"demographics,blood_pressure"`.

    Here are the relationships between the four pairs of variables:

    ```r
    records_collapsed   <- collapse_vector(records  , records_collapsed)
    fields_collapsed    <- collapse_vector(fields   , fields_collapsed)
    forms_collapsed     <- collapse_vector(forms    , forms_collapsed)
    events_collapsed    <- collapse_vector(events   , events_collapsed)
    ```

    If someone is using the *_collapsed parameter, they can programmatically convert it to a vector like:

    ```r
    field_names <- trimws(unlist(strsplit(field_names_collapsed, ",")))
    ```

* `redcap_read()` will automatically include the "plumbing" variables, even if they're not included the list of requested fields & forms.  (#442).  Specifically:

    * `record_id` (or it's customized name) will always be returned
    * `redcap_event_name` will be returned for longitudinal projects
    * `redcap_repeat_instrument` and `redcap_repeat_instance` will be returned for projects with repeating instruments

This will help extract forms from longitudinal & repeating projects.

* `redcap_read()` and `redcap_read_oneshot()` now return an empty dataset if no records are retrieved (such as no records meet the filter criteria).  Currently a 0x0 tibble is returned, but that may change in the future.  Until now an error was deliberately thrown.  (#452)

* `redcap_event_instruments()` now by default returns mappings for all arms.  The previous default was to return the mappings for only the first arm.  To recreate the previous behavior use a call like `REDCapR::redcap_event_instruments(uri, token_2, arms = "1")`.  (Suggested by @januz, #482)

* `redcap_users_export()` used to return a boolean for `user_rights`, but now it can be 0, 1, or 2. (#523)

### New Features

* New `redcap_metadata_coltypes()` function.  Inspects the fields types and validation text of each field to generate a suggested `readr::col_types` object that reflects the project's current data dictionary.  The object then can be passed to the `col_types` parameter of `redcap_read()` or `redcap_read_oneshot()`.  (Suggested and discussed with @pbchase, @nutterb, @skadauke, & others, #405 & #294)
* New `redcap_log_read()` function.  Exports a project's log.  (Thanks @joundso, #383, #320)
* New `redcap_project_info_read()` function.  Exports a project's information, such as its language and production status.  (Suggested by @skadauke, @timothytsai, @pbchase, #236, #410)
* New parameter `blank_for_gray_form_status` in the functions `redcap_read()`, `redcap_read_oneshot()`, and `redcap_read_oneshot_eav()`. (@greg-botwin, #386, #389)
* A `httr::handle` value is accepted by functions that contact the server.  This will accommodate some institutions with unconventional environments.  (Suggested by @brandonpotvin, #429)
* `sanitized_token()` now accepts an alternative regex pattern.  (Suggested by @maeon & @michalkouril, #370)
* `redcap_read_eav_oneshot()` is an UNexported function that returns data in an EAV format (#437)
* `redcap_metadata_read()` now correctly subsets the forms (identified & corrected by @ezraporter, #431 & #445)
* New `redcap_event_read()` function. Exports metadata associated with a project's longitudinal events (@ezraporter, #457 & #460)

### Minor Enhancements

* Better documentation for the server url (suggested by @sutzig #395)
* `read_read_oneshot()`'s parameter `guess_max` now allows floating point values to support `readr::read_csv()` ability to accept a Inf value.  (Suggested by @eveyp, #392)
* pkgdown pages run & display the examples, but CRAN still doesn't run them. It's illegal to call external resources/APIs from CRAN computers --mostly because they are occasionally unavailable, so the code breaks. (#419)
* Renamed some functions to follow a consistent pattern.  Old names will be soft-deprecated for a while before being removed. (#416)
  * `redcap_download_file_oneshot()` to `redcap_file_download_oneshot()`
  * `redcap_file_upload_oneshot()` to `redcap_file_upload_oneshot()`
  * `redcap_download_instrument()` to `redcap_instrument_download()`

* `redcap_dag_read()` has new `data_access_group_id` field (introduced maybe in [13.1.0](https://redcap.vanderbilt.edu/community/post.php?id=13)) (#459)
* `redcap_users_export()` has new `mycap_participants` field (introduced maybe in [13.0.0](https://redcap.vanderbilt.edu/community/post.php?id=13)) (#459)
* Accommodate older versions of REDCap that don't return project-level variable, like `has_repeating_instruments_or_events`, `missing_data_codes`, `external_modules`, `bypass_branching_erase_field_prompt` (@the-mad-statter, #465, #466)
* `redcap_meta_coltypes()` correctly determines data type for autonumber `record_id` fields. It suggests a character if the project has DAGs, and an integer if not. (@pwildenhain, #472)
* `redcap_log_read()` now returns a new column reflecting the affected record id value (ref #478)
* `redcap_read()` and `redcap_read_oneshot()` now remove "pseudofields" (e.g., `redcap_event_name`, `redcap_repeat_instrument`, & `redcap_repeat_instance`) from the `fields` parameter.  Starting with REDCap v13.4.10, an error is thrown by the server.  REDCap will return a message if a common pseudofield is requested explicitly by the user. (#477)
* `redcap_event_instruments()` now can return mappings for all arms, instead of one arm per call.(Suggested by @januz, #482)
* `validate_for_write()` contains a few more checks. (#485)  The complete list is now:
  * `validate_data_frame_inherits()`
  * `validate_field_names()`
  * `validate_record_id_name()`
  * `validate_uniqueness()`
  * `validate_repeat_instance()`
  * `validate_no_logical()`
* `redcap_read()` checks the `event` parameter and throws an error if a value is not recognized, or the project is not longitudinal (#493)
* The regex in `regex_named_captures()` is forgiving if there's an unnecessary leading space (@BlairCooper, #495, #501)
* `redcap_log_read()` assumes all columns are character, except for `timestamp` (#525)
* `redcap_file_download_oneshot()` no longer asks for the unnecessary parameter for `repeating_instrument` (that the REDCap server ignores).  (@BlairCooper, #506, #530)
* `redcap_read()` and `redcap_read_oneshot()` accommodate `readr::read_csv()`'s parameter of `na`.  (Suggested by @rmtrane in #529)

Version 1.1.0 (released 2022-08-10)
==========================================================

### New Features

* New `redcap_delete()` function.  It deletes a vector of records.  (Thanks @joundso, #372, #373)
* New `redcap_arm_export()` function.  It retrieves a list of REDCap project arms.  (#375)
* `redcap_read()` and `redcap_read_oneshot()` accept a new `locale` parameter that specifies date, time, and number formats, like using a comma as the decimal separator.  It is a [`readr::locale`](https://readr.tidyverse.org/reference/locale.html) object.  (#377, suggested by @joundso)
* New `redcap_instruments()` function exports a list of the data collection instruments for a project.  (#381, @vcastro)
* New `redcap_event_instruments()` function exports the instrument-event mappings for a project (i.e., how the data collection instruments are designated for certain events in a longitudinal project).  (#381, @vcastro)
* New `redcap_dag_read()` function returns the Data Access Groups for a project (#382, @joundso)
* New detection when REDCap has trouble with a large request and drops records. (#400 w/ @TimMonahan)

### Minor Enhancements

* `sanitize_token()` now allows lowercase characters --in addition to uppercase characters & digits. (#347, @jmbarbone)
* `redcap_metadata_read()` now uses json (instead of csv) to transfer the dictionary between server & client.  This accommodates super-wide dictionaries with 35k+ variables.  The user shouldn't notice a difference, and still will receive a data.frame. (#335, @januz & @datalorax)
* Include a few more `testthat::skip_on_cran()` calls to comply with CRAN's ["fail gracefully"](https://cran.r-project.org/web/packages/policies.html) policy.  Similarly, skip remaining examples that depend on external resources. (#352)
* `retrieve_credential_local()` can now user `username` to identify the desired credential row (#364)
* `redcap_read()` and `redcap_read_oneshot()` gain the `http_response_encoding` parameter that's passed to [`httr::content()`](https://httr.r-lib.org/reference/content.html).  The default value remains "UTF-8".  (#354, @lrasmus)
* Accommodate single-character REDCap variable names (#367 & #368, @daynefiler)
* Modify  `redcap_users_export()` (which calls REDCap's user export).  The API dropped the `data_export` variable and added the `forms_export` variable. (#396)
* For `redcap_read_oneshot_eav()`: if the project isn't longitudinal, a dummy value for `event_id` is used internally (#396)
* For the testing server & projects, the http errors are a little different, so the testing code was adjusted (#396)
* Set `httr::user_agent`, following the advice of httr's vignette (#397)

### Test Suite

* Added two more dictionaries that are super wide -5k & 35k variables  (#335 & #360, @januz & @datalorax)
* Read, modify, & read projects with DAGs (#353, daniela.wolkersdorfer, #353)

Version 1.0.0 (released 2021-07-21)
==========================================================

The package has been stable for years and should be reflected in the major version number.

### Minor Enhancements

* When writing records to the server, the functions `redcap_write()` and `redcap_write_oneshot()` have a new parameter that converts R's `logical`/boolean columns to integers.  This meshes well with T/F and Y/N items that are coded as 1/0 underneath. The default will be FALSE (ie, the integers are not converted by default), so it doesn't break existing code. (#305)
* When writing records to the server, the functions `redcap_write()` and `redcap_write_oneshot()` can toggle the ability to overwrite with blank/NA cells (suggested by @auricap, #315)
* The functions `redcap_read_oneshot()`, `redcap_read()`, & `redcap_read_oneshot_eav()` now support the parameters `datetime_range_begin` and `datetime_range_end`.  The are passed to the REDCap parameters `dateRangeBegin` and `dateRangeEnd`, which restricts records returned, based on their last modified date in the server.  (Thanks @pbchase, #321 & #323.)
* Better documentation about the `export_survey_fields` parameter in the functions `redcap_read()` & `redcap_read_oneshot()`.  (Thanks @isaactpetersen, #333)
* New function [`redcap_report()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_report.html) export records that populate a REDCap report. (#326.)
* New vignette [Typical REDCap Workflow for a Data Analyst](https://ouhscbbmc.github.io/REDCapR/articles/workflow-read.html) developed to support a workshop for the 2021 [R/Medicine Conference](https://events.linuxfoundation.org/r-medicine/) (#332, with  @higgi13425, @kamclean, & Amanda Miller)
* New function [`create_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.html) starts a well-formed csv file that can contain tokens. (#340, after conversations with @higgi13425 & @kamclean.)

### Stability Features

* update for newer version of testthat -v3.0.0 (#312)
* update for newer version of readr 2.0.0 (#343)
* update for newer version of readr 1.4.0 (#313)
* update for newer version of REDCap on test server (#310)
* save expected datasets as files -instead of included in the actual test code (#308)

### Corrections & Bug Fixes

* Accepts more than one `config_option` element.  (Proposed by @BastienRance, #307)
* Fixed calculation of `success` value returned by `redcap_read()` and `redcap_write()` when the parameter `continue_on_error` is true.  (Bug found by @llrs, #317)
* [`redcap_survey_link_export_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_survey_link_export_oneshot.html) documentation corrected & improved (@jrob95, #526)

Version 0.11.0 (Released 2020-04-20)
==========================================================

### Breaking Changes (possible, but unlikely)

* [`kernel_api()`](https://ouhscbbmc.github.io/REDCapR/reference/kernel_api.html) defaults to "text/csv" and UTF-8 encoding.  Formerly, the function would decide on the content-type and encoding.  More details are below in the 'Stability Features' subsection.

* [`constant()`](https://ouhscbbmc.github.io/REDCapR/reference/constant.html) no longer accepts `simplify` as an options.  An integer vector is always returned.  (#280)

### New Features

* It's now possible to specify the exact `col_types` (a [`readr::cols`](https://readr.tidyverse.org/reference/cols.html) object) that is passed to `readr::read_csv()` inside [`redcap_read_oneshot()`](https://github.com/OuhscBbmc/REDCapR/blob/master/R/redcap-read-oneshot.R). (#258)

* [`reader::type_convert()`](https://readr.tidyverse.org/reference/type_convert.html) is used *after* all the batches are stacked on top of each other.  This way, batches cannot have incompatible data types as they're combined. (#257; thanks @isaactpetersen #245)  Consequently, the `guess_max` parameter in `redcap_read()` no longer serves a purpose, and has been soft-deprecated. (#267)

* [`redcap_metadata_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_write.html) writes to the project's metadata. (#274, @felixetorres)

* [`redcap_survey_link_export_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_survey_link_export_oneshot.html) retrieves the URL to a specific record's survey (*e.g.*, "https://redcap-dev-2.ouhsc.edu/redcap/surveys/?s=8KuzSLMHf6") (#293)

* `convert_logical_to_integer` is a new parameter for [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.html) and [`redcap_write_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write_oneshot.html). If `TRUE`, all [base::logical] columns in `ds` are cast to an integer before uploading to REDCap.  Boolean values are typically represented as 0/1 in REDCap radio buttons.  Defaults to `FALSE` to maintain backwards compatibility. (#305)

### Stability Features

* `httr::content()` (which is inside `kernel_api()`) now processes the returned value as "text/csv", by default.  This should prevent strange characters from tricking the process as the internal variable `raw_text` is being formed. See the [httr::content()`](https://httr.r-lib.org/reference/content.html) documentation for a list of possible values for the `content_type` parameter.  (Thanks to great debugging by @vortexing #269, @sybandrew #272, & @begavett, #290)

* Similarly, `kernel_api()` now has an `encoding` parameter, which defaults to "UTF-8".  (#270)

### Minor Enhancements

* check for bad field names passed to the read records functions (#288)

### Corrections

* 'checkmate' package is now imported, not suggested (Thanks @dtenenba, #255).

* Allow more than one `httr::config()` parameter to be passed (Thanks @BastienRance, #307).

Version 0.10.2 (Released 2019-09-22)
==========================================================

### Minor New Features

* export survey time-stamps optionally (Issue #159)
* `redcap_next_free_record_name()`: API call for 'Generate Next Record Name', which returns the next available record ID (Issue #237)
* `redcap_read()` and `redcap_read_oneshot()` allow the user to specify if all variables
  should be returned with the `character` data type.  The default is to allow `readr::read_csv()` to guess the data type. (#194)
* `redcap_read_oneshot()` allows use to specify how many rows should be considered when `readr::read_csv()` guesses the data type. (#194)
* `redcap_read()`, `redcap_read_oneshot()`, and `redcap_read_oneshot_eav()` always return Linux-style line endings (ie `\n`) instead of Windows style line endings (ie, `\r\n`) on all OSes.  (#198)
* `read_metadata()` always returns `character` vectors for all variables.  With readr 1.2.0, some column were returned differently than before.  (#193)
* 'raw_or_label_headers' now supported (Thanks Hatem Hosny - hatemhosny, #183 & #203)
* 'export_checkbox_labels' now supported (#186)
* `redcap_users_export()` now included (#163)
* 'forms' now supported for `redcap_read()`, `redcap_read_oneshot()`, & `redcap_read_oneshot_eav()`(#206).  It was already implemented for `redcap_metadata_read()`.
* If no records are affected, a zero-length *character* vector is returned (instead of sometimes a zero-length *numeric* vector)  (#212)
* New function (called `constants()`) easily exposes REDCap-specific constants.  (#217)
* `id_position` allows user to specify if the record_id isn't in the first position (#207).  However, we recommend that all REDCap projects keep this important variable first in the data dictionary.
* Link to new secure Zenodo DOI resolver (@katrinleinweber #191)
* parameters in `redcap_read()` and `redcap_read_oneshot()` are more consistent with the order in raw REDCap API. (#204)
* When the `verbose` parameter is NULL, then the value from getOption("verbose") is used. (#215)
* `guess_max` parameter provided in `redcap_read()` (no longer just `redcap_read_oneshot()`).  Suggested by @isaactpetersen in #245.
* Documentation website constructed with pkgdown (#224).
* `redcap_variables()` now throws an error when passed a bad URI (commit e542155639bbb7).

### Modified Internals

* All interaction with the REDCap server goes through the new `kernal_api()` function, which uses the 'httr' and 'curl' packages underneath.  Until now, each function called those packages directly. (#213)
* When converting REDCap's CSV to R's data.frame, `readr::read_csv()` is used instead of `utils::read.csv()` (Issue #127).
* updated to readr 1.2.0 (#200).  This changed how some data variables were assigned a data types.
* uses `odbc` package to retrieve credentials from the token server.  Remove RODBC and RODBCext (#188).  Thanks to @krlmlr for error checking advice in <https://stackoverflow.com/a/50419403/1082435>.
* `data.table::rbindlist()` replaced by `dplyr::bind_rows()`
* the checkmate package inspects most function parameters now (instead of `testit::assert()` and `base:stop()` ) (#190 & #208).
* `collapse_vector()` is refactored and tested (#209)
* remove dependency on `pkgload` package (#218)
* Update Markdown syntax to new formatting problems (#253)

### Deprecated Features

* `retrieve_token_mssql()`, because `retrieve_credential_mssql()` is more general and more useful.

Version 0.9.8 (Released 2017-05-18)
==========================================================

### New Features

* Enumerate the exported variables. with `redcap_variables()`.
* Experimental EAV export in `redcap_read_oneshot_eav()`, which can be accessed with a triple colon (ie, `REDCapR::redcap_read_oneshot_eav()`).

### Bug Fixes

* Adapted to new 2.4 version of curl (see #154)

Versions 0.9.7 (Released 2017-09-09)
==========================================================

### New Features

* Support for filtering logic in `redcap_read()` and `redcap_read_oneshot()` (PR #126)
* New functions `retrieve_credential_mssql()` and `retrieve_credential_local()`.  These transition from storing & retrieving just the token (ie, `retrieve_token_mssql()`) to storing & retrieving more information.  `retrieve_credential_local()` facilitates a standard way of storing tokens locally, which should make it easier to follow practices of keeping it off the repository.
* Using parameterized queries with the RODBCext package.  (Thanks @nutterb in issues #115 & #116.)
* Remove line breaks from token (Thanks @haozhu233 in issues #103 & #104)

### Minor Updates

* When combining batches into a single data.frame, `data.table::rbindlist()` is used.  This should prevent errors with the first batch's data type (for a column) isn't compatible with a later batch.  For instance, this occurs when the first batch has only integers for `record_id`, but a subsequent batch has values like `aa-test-aa`.  The variable for the combined dataset should be a character. (Issue #128 & <https://stackoverflow.com/questions/39377370/bind-rows-of-different-data-types>; Thanks @arunsrinivasan)
* Uses the `dplyr` package instead of `plyr`.  This shouldn't affect callers, because immediately before returning the data, `REDCapR::redcap_read()` coerces the `tibble::tibble` (which was formerly called `dplyr::tbl_df`) back to a vanilla `data.frame` with `as.data.frame()`.
* A few more instances of validating input parameters to read functions. (Issue #8).

Versions 0.9.3 (Released 2015-08-25)
==========================================================

### Minor Updates

* The `retrieve-token()` tests now account for the (OS X) builds where the RODBC package isn't available.

Versions 0.9.0 (Released 2015-08-14)
==========================================================

### New Features

* Adapted for version 1.0.0 of httr (which is now based on the `curl` package, instead of `RCurl`).

### Minor Updates

* Uses `requireNamespace()` instead of `require()`.
* By default, uses the SSL cert files used by httr, which by default, uses those packaged with R.
* Added warning if it appears `readcap_read()` is being used without 'Full Data Set' export privileges.  The problem involves the record IDs are hashed.
* Reconnected code that reads only the `id_position` in the first stage of batching.  The metadata needed to be read before that, after the updates for REDCap Version 6.0.x.
* `retrieve_token_mssql()` uses regexes to validate parameters

Version 0.7-1 (Released 2014-12-17)
==========================================================

### New Features

* Updated for Version 6.0.x of REDCap (which introduced a lot of improvements to API behavior).

Version 0.6 (Released 2014-11-03)
==========================================================

### New Features

* The `config_options` in the httr package are exposed to the REDCapR user.  See issues #55 & #58; thanks to @rparrish and @nutterb for their contributions (<https://github.com/OuhscBbmc/REDCapR/issues/55> & <https://github.com/OuhscBbmc/REDCapR/issues/58>).


Version 0.5 (Released 2014-10-19)
==========================================================

### New Features

* `redcap_metadata_read()` are tested and public.

### Minor Updates

* Test suite now uses `testthat::skip_on_cran()` before any call involving OUHSC's REDCap server.
* Vignette example of subsetting, conditioned on a second variable's value.


Version 0.4-28 (Released 2014-09-20)
==========================================================

### New Features

* `redcap_write()` and `redcap_write_oneshot()` are now tested and public.
* `redcap_write()` and `redcap_write_oneshot()` are now tested and public.
* `redcap_download_file_oneshot()` function contributed by John Aponte (@johnaponte; Pull request #35)
* `redcap_upload_file_oneshot()` function contributed by @johnaponte (Pull request #34)
* Users can specify if an operation should continue after an error occurs on a batch read or write.  Regardless of their choice, more debugging output is written to the console if `verbose==TRUE`.  Follows advice of @johnaponte, Benjamin Nutter (@nutterb), and Rollie Parrish (@rparrish). Closes #43.

### Breaking Changes

* The `records_collapsed` default empty value is now an empty string (*i.e.*, `""`) instead of `NULL`.  This applies when `records_collapsed` is either a parameter, or a returned value.

### Updates

* By default, the SSL certs come from the httr package.  However, REDCapR will continue to maintain a copy in case httr's version on CRAN gets out of date.
* The tests are split into two collections: one that's run by the CRAN checks, and the other run manually.  [Thanks, Gabor Csardi](https://stackoverflow.com/questions/25595487/testthat-pattern-for-long-running-tests).  Any test with a dependency outside the package code (especially the REDCap test projects) is run manually so changes to the test databases won't affect the success of building the previous version on CRAN.
* Corrected typo in `redcap_download_file_oneshot()` documentation, thanks to Andrew Peters (@ARPeters #45).


Version 0.3 (Released 2014-09-01)
==========================================================

### New Features

* Relies on the `httr` package, which provides benefits like the status code message can be captured (eg, 200-OK, 403-Forbidden, 404-NotFound).  See <https://cran.r-project.org/package=httr>.

### Updates

* Renamed the former `status_message` to `outcome_message`. This is because the message associated with http code returned is conventionally called the 'status messages' (eg, OK, Forbidden, Not Found).
* If an operation is successful, the `raw_text` value (which was formerly called `raw_csv`) is returned as an empty string to save RAM.  It's not really necessary with httr's status message exposed.

### Bug Fixes

* Correct batch reads with longitudinal schema #27

Version 0.2 (Released 2014-07-02)
==========================================================

### New Features

* Added `redcap_column_sanitize()` function to address non-ASCII characters
* Added `redcap_write()` (as an internal function).
* The `redcap_project()` object reduces repeatedly passing parameters like the server URL, the user token, and the SSL cert location.

### Updates

* New Mozilla SSL Certification Bundles released on cURL (released 2013-12-05)
* Renamed `redcap_read_batch()`  to `redcap_read()`. These changes reflect our suggestion that reads should typically be batched.
* Renamed `redcap_read()` to `redcap_read_oneshot()`
* Renamed `redcap_write()` to `redcap_write_oneshot()` (which is an internal function).
* Small renames to parameters

Version 0.1 (Released 2014-01-14)
==========================================================

### New Features

* Introduces `redcap_read()` and `redcap_read_batch()` with documentation
* SSL verify peer by default, using cert file included in package
* Initial submission to GitHub

### Enhancements

* `redcap_read()` takes parameter for `raw_or_label` (Thanks Rollie Parrish #3)
* `redcap_read()` takes parameter for `export_data_access_groups` thanks to Rollie Parrish (@rparrish #4)

----------------------------------------

GitHub Commits and Releases

* For a detailed change log, please see <https://github.com/OuhscBbmc/REDCapR/commits/main>.
* For a list of the major releases, please see <https://github.com/OuhscBbmc/REDCapR/releases>.
