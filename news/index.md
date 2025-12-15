# Changelog

## REDCapR (development version)

## REDCapR 1.6.0 (released 2025-10-07)

CRAN release: 2025-10-08

This release is primarily small changes to comply with a CRAN check. One
of the examples accidentally called an external/test server, which is
against CRAN rules.

#### Minor Enhancements

- Avoid calling server in a CRAN example
  ([\#577](https://github.com/OuhscBbmc/REDCapR/issues/577))
- Add new multilevel model test project to the test suite
  ([\#578](https://github.com/OuhscBbmc/REDCapR/issues/578))

## REDCapR 1.5.0 (released 2025-07-27)

CRAN release: 2025-07-28

This release is primarily small changes to comply with new CRAN checks

#### Minor Enhancements

- Avoid native pipes outside of essential package code
  ([\#572](https://github.com/OuhscBbmc/REDCapR/issues/572)). (Essential
  package code has always used magrittr pipes to allow REDCapR to run on
  version of R before 4.1.0.)
- Avoid calling server in a CRAN example
  ([\#571](https://github.com/OuhscBbmc/REDCapR/issues/571))

## REDCapR 1.4.0 (released 2025-01-11)

CRAN release: 2025-01-11

#### New Features

- [`redcap_file_repo_list_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_repo_list_oneshot.md)
  export a list of files/folders from the file repository (requested by
  [@agdamsbo](https://github.com/agdamsbo),
  [\#549](https://github.com/OuhscBbmc/REDCapR/issues/549))

#### Minor Enhancements

- Vignettes are not run/evaluated on CRAN, to comply with it policies.
  ([\#561](https://github.com/OuhscBbmc/REDCapR/issues/561))
- Alt text for figures.
  ([\#550](https://github.com/OuhscBbmc/REDCapR/issues/550))

## REDCapR 1.3.0 (released 2024-10-22)

CRAN release: 2024-10-23

#### Minor Enhancements

- Redirection layer for test suite allows you to plug in your own server
  ([\#539](https://github.com/OuhscBbmc/REDCapR/issues/539),
  [\#542](https://github.com/OuhscBbmc/REDCapR/issues/542),
  [\#544](https://github.com/OuhscBbmc/REDCapR/issues/544))
- Skip a test when checked on CRAN servers (but not on local or GitHub
  Action machines)

## REDCapR 1.2.0 (released 2024-09-08)

CRAN release: 2024-09-09

#### Possibly Breaking Change

These changes could possibly break existing code –but it’s very
unlikely. We feel they will (directly and indirectly) improve the
package considerably.

- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md),
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md),
  [`redcap_dag_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_dag_read.md),
  [`redcap_log_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_log_read.md),
  and
  [`redcap_report()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_report.md)
  return a [tibble](https://tibble.tidyverse.org/) instead of a
  [data.frame](https://stat.ethz.ch/R-manual/R-devel/library/base/html/data.frame.html).
  ([\#415](https://github.com/OuhscBbmc/REDCapR/issues/415))

  This should affect client code only if you expect a call like
  `ds[, 3]` to return a vector instead of a single-column
  data.frame/tibble. One solution is to upcast the tibble to a
  data.frame (with something like
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html)). We
  recommend using an approach that works for both data.frames and
  tibbles, such as `ds[[3]]` or `dplyr::pull(ds, "gender")`.

  For more information, read the short chapter in [*R for Data
  Science*](https://r4ds.had.co.nz/tibbles.html).

- The `*_collapsed` parameters are deprecated. When your want to limit
  on records/fields/forms/events, pass the vector of characters, not the
  scalar character separated by commas (which I think everyone does
  already). In other words use `c("demographics", "blood_pressure")`
  instead of `"demographics,blood_pressure"`.

  Here are the relationships between the four pairs of variables:

  ``` r
  records_collapsed   <- collapse_vector(records  , records_collapsed)
  fields_collapsed    <- collapse_vector(fields   , fields_collapsed)
  forms_collapsed     <- collapse_vector(forms    , forms_collapsed)
  events_collapsed    <- collapse_vector(events   , events_collapsed)
  ```

  If someone is using the \*\_collapsed parameter, they can
  programmatically convert it to a vector like:

  ``` r
  field_names <- trimws(unlist(strsplit(field_names_collapsed, ",")))
  ```

- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  will automatically include the “plumbing” variables, even if they’re
  not included the list of requested fields & forms.
  ([\#442](https://github.com/OuhscBbmc/REDCapR/issues/442)).
  Specifically:

  - `record_id` (or it’s customized name) will always be returned
  - `redcap_event_name` will be returned for longitudinal projects
  - `redcap_repeat_instrument` and `redcap_repeat_instance` will be
    returned for projects with repeating instruments

This will help extract forms from longitudinal & repeating projects.

- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  now return an empty dataset if no records are retrieved (such as no
  records meet the filter criteria). Currently a 0x0 tibble is returned,
  but that may change in the future. Until now an error was deliberately
  thrown. ([\#452](https://github.com/OuhscBbmc/REDCapR/issues/452))

- [`redcap_event_instruments()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_event_instruments.md)
  now by default returns mappings for all arms. The previous default was
  to return the mappings for only the first arm. To recreate the
  previous behavior use a call like
  `REDCapR::redcap_event_instruments(uri, token_2, arms = "1")`.
  (Suggested by [@januz](https://github.com/januz),
  [\#482](https://github.com/OuhscBbmc/REDCapR/issues/482))

- [`redcap_users_export()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_users_export.md)
  used to return a boolean for `user_rights`, but now it can be 0, 1,
  or 2. ([\#523](https://github.com/OuhscBbmc/REDCapR/issues/523))

#### New Features

- New
  [`redcap_metadata_coltypes()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_coltypes.md)
  function. Inspects the fields types and validation text of each field
  to generate a suggested `readr::col_types` object that reflects the
  project’s current data dictionary. The object then can be passed to
  the `col_types` parameter of
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  or
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md).
  (Suggested and discussed with [@pbchase](https://github.com/pbchase),
  [@nutterb](https://github.com/nutterb),
  [@skadauke](https://github.com/skadauke), & others,
  [\#405](https://github.com/OuhscBbmc/REDCapR/issues/405) &
  [\#294](https://github.com/OuhscBbmc/REDCapR/issues/294))
- New
  [`redcap_log_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_log_read.md)
  function. Exports a project’s log. (Thanks
  [@joundso](https://github.com/joundso),
  [\#383](https://github.com/OuhscBbmc/REDCapR/issues/383),
  [\#320](https://github.com/OuhscBbmc/REDCapR/issues/320))
- New
  [`redcap_project_info_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_project_info_read.md)
  function. Exports a project’s information, such as its language and
  production status. (Suggested by
  [@skadauke](https://github.com/skadauke),
  [@timothytsai](https://github.com/timothytsai),
  [@pbchase](https://github.com/pbchase),
  [\#236](https://github.com/OuhscBbmc/REDCapR/issues/236),
  [\#410](https://github.com/OuhscBbmc/REDCapR/issues/410))
- New parameter `blank_for_gray_form_status` in the functions
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md),
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md),
  and
  [`redcap_read_oneshot_eav()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot_eav.md).
  ([@greg-botwin](https://github.com/greg-botwin),
  [\#386](https://github.com/OuhscBbmc/REDCapR/issues/386),
  [\#389](https://github.com/OuhscBbmc/REDCapR/issues/389))
- A [`httr::handle`](https://httr.r-lib.org/reference/handle.html) value
  is accepted by functions that contact the server. This will
  accommodate some institutions with unconventional environments.
  (Suggested by [@brandonpotvin](https://github.com/brandonpotvin),
  [\#429](https://github.com/OuhscBbmc/REDCapR/issues/429))
- `sanitized_token()` now accepts an alternative regex pattern.
  (Suggested by [@maeon](https://github.com/maeon) &
  [@michalkouril](https://github.com/michalkouril),
  [\#370](https://github.com/OuhscBbmc/REDCapR/issues/370))
- [`redcap_read_eav_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_eav_oneshot.md)
  is an UNexported function that returns data in an EAV format
  ([\#437](https://github.com/OuhscBbmc/REDCapR/issues/437))
- [`redcap_metadata_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_read.md)
  now correctly subsets the forms (identified & corrected by
  [@ezraporter](https://github.com/ezraporter),
  [\#431](https://github.com/OuhscBbmc/REDCapR/issues/431) &
  [\#445](https://github.com/OuhscBbmc/REDCapR/issues/445))
- New
  [`redcap_event_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_event_read.md)
  function. Exports metadata associated with a project’s longitudinal
  events ([@ezraporter](https://github.com/ezraporter),
  [\#457](https://github.com/OuhscBbmc/REDCapR/issues/457) &
  [\#460](https://github.com/OuhscBbmc/REDCapR/issues/460))

#### Minor Enhancements

- Better documentation for the server url (suggested by
  [@sutzig](https://github.com/sutzig)
  [\#395](https://github.com/OuhscBbmc/REDCapR/issues/395))
- `read_read_oneshot()`’s parameter `guess_max` now allows floating
  point values to support
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
  ability to accept a Inf value. (Suggested by
  [@eveyp](https://github.com/eveyp),
  [\#392](https://github.com/OuhscBbmc/REDCapR/issues/392))
- pkgdown pages run & display the examples, but CRAN still doesn’t run
  them. It’s illegal to call external resources/APIs from CRAN computers
  –mostly because they are occasionally unavailable, so the code breaks.
  ([\#419](https://github.com/OuhscBbmc/REDCapR/issues/419))
- Renamed some functions to follow a consistent pattern. Old names will
  be soft-deprecated for a while before being removed.
  ([\#416](https://github.com/OuhscBbmc/REDCapR/issues/416))
  - [`redcap_download_file_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_download_oneshot.md)
    to
    [`redcap_file_download_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_download_oneshot.md)
  - [`redcap_file_upload_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_upload_oneshot.md)
    to
    [`redcap_file_upload_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_upload_oneshot.md)
  - [`redcap_download_instrument()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_instrument_download.md)
    to
    [`redcap_instrument_download()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_instrument_download.md)
- [`redcap_dag_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_dag_read.md)
  has new `data_access_group_id` field (introduced maybe in
  [13.1.0](https://redcap.vanderbilt.edu/community/post.php?id=13))
  ([\#459](https://github.com/OuhscBbmc/REDCapR/issues/459))
- [`redcap_users_export()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_users_export.md)
  has new `mycap_participants` field (introduced maybe in
  [13.0.0](https://redcap.vanderbilt.edu/community/post.php?id=13))
  ([\#459](https://github.com/OuhscBbmc/REDCapR/issues/459))
- Accommodate older versions of REDCap that don’t return project-level
  variable, like `has_repeating_instruments_or_events`,
  `missing_data_codes`, `external_modules`,
  `bypass_branching_erase_field_prompt`
  ([@the-mad-statter](https://github.com/the-mad-statter),
  [\#465](https://github.com/OuhscBbmc/REDCapR/issues/465),
  [\#466](https://github.com/OuhscBbmc/REDCapR/issues/466))
- `redcap_meta_coltypes()` correctly determines data type for autonumber
  `record_id` fields. It suggests a character if the project has DAGs,
  and an integer if not.
  ([@pwildenhain](https://github.com/pwildenhain),
  [\#472](https://github.com/OuhscBbmc/REDCapR/issues/472))
- [`redcap_log_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_log_read.md)
  now returns a new column reflecting the affected record id value (ref
  [\#478](https://github.com/OuhscBbmc/REDCapR/issues/478))
- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  now remove “pseudofields” (e.g., `redcap_event_name`,
  `redcap_repeat_instrument`, & `redcap_repeat_instance`) from the
  `fields` parameter. Starting with REDCap v13.4.10, an error is thrown
  by the server. REDCap will return a message if a common pseudofield is
  requested explicitly by the user.
  ([\#477](https://github.com/OuhscBbmc/REDCapR/issues/477))
- [`redcap_event_instruments()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_event_instruments.md)
  now can return mappings for all arms, instead of one arm per
  call.(Suggested by [@januz](https://github.com/januz),
  [\#482](https://github.com/OuhscBbmc/REDCapR/issues/482))
- [`validate_for_write()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  contains a few more checks.
  ([\#485](https://github.com/OuhscBbmc/REDCapR/issues/485)) The
  complete list is now:
  - [`validate_data_frame_inherits()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  - [`validate_field_names()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  - [`validate_record_id_name()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  - [`validate_uniqueness()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  - [`validate_repeat_instance()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  - [`validate_no_logical()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  checks the `event` parameter and throws an error if a value is not
  recognized, or the project is not longitudinal
  ([\#493](https://github.com/OuhscBbmc/REDCapR/issues/493))
- The regex in
  [`regex_named_captures()`](https://ouhscbbmc.github.io/REDCapR/reference/metadata_utilities.md)
  is forgiving if there’s an unnecessary leading space
  ([@BlairCooper](https://github.com/BlairCooper),
  [\#495](https://github.com/OuhscBbmc/REDCapR/issues/495),
  [\#501](https://github.com/OuhscBbmc/REDCapR/issues/501))
- [`redcap_log_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_log_read.md)
  assumes all columns are character, except for `timestamp`
  ([\#525](https://github.com/OuhscBbmc/REDCapR/issues/525))
- [`redcap_file_download_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_download_oneshot.md)
  no longer asks for the unnecessary parameter for
  `repeating_instrument` (that the REDCap server ignores).
  ([@BlairCooper](https://github.com/BlairCooper),
  [\#506](https://github.com/OuhscBbmc/REDCapR/issues/506),
  [\#530](https://github.com/OuhscBbmc/REDCapR/issues/530))
- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  accommodate
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)’s
  parameter of `na`. (Suggested by
  [@rmtrane](https://github.com/rmtrane) in
  [\#529](https://github.com/OuhscBbmc/REDCapR/issues/529))

## REDCapR 1.1.0 (released 2022-08-10)

CRAN release: 2022-08-10

#### New Features

- New
  [`redcap_delete()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_delete.md)
  function. It deletes a vector of records. (Thanks
  [@joundso](https://github.com/joundso),
  [\#372](https://github.com/OuhscBbmc/REDCapR/issues/372),
  [\#373](https://github.com/OuhscBbmc/REDCapR/issues/373))
- New
  [`redcap_arm_export()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_arm_export.md)
  function. It retrieves a list of REDCap project arms.
  ([\#375](https://github.com/OuhscBbmc/REDCapR/issues/375))
- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  accept a new `locale` parameter that specifies date, time, and number
  formats, like using a comma as the decimal separator. It is a
  [`readr::locale`](https://readr.tidyverse.org/reference/locale.html)
  object. ([\#377](https://github.com/OuhscBbmc/REDCapR/issues/377),
  suggested by [@joundso](https://github.com/joundso))
- New
  [`redcap_instruments()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_instruments.md)
  function exports a list of the data collection instruments for a
  project. ([\#381](https://github.com/OuhscBbmc/REDCapR/issues/381),
  [@vcastro](https://github.com/vcastro))
- New
  [`redcap_event_instruments()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_event_instruments.md)
  function exports the instrument-event mappings for a project (i.e.,
  how the data collection instruments are designated for certain events
  in a longitudinal project).
  ([\#381](https://github.com/OuhscBbmc/REDCapR/issues/381),
  [@vcastro](https://github.com/vcastro))
- New
  [`redcap_dag_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_dag_read.md)
  function returns the Data Access Groups for a project
  ([\#382](https://github.com/OuhscBbmc/REDCapR/issues/382),
  [@joundso](https://github.com/joundso))
- New detection when REDCap has trouble with a large request and drops
  records. ([\#400](https://github.com/OuhscBbmc/REDCapR/issues/400) w/
  [@TimMonahan](https://github.com/TimMonahan))

#### Minor Enhancements

- [`sanitize_token()`](https://ouhscbbmc.github.io/REDCapR/reference/sanitize_token.md)
  now allows lowercase characters –in addition to uppercase characters &
  digits. ([\#347](https://github.com/OuhscBbmc/REDCapR/issues/347),
  [@jmbarbone](https://github.com/jmbarbone))
- [`redcap_metadata_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_read.md)
  now uses json (instead of csv) to transfer the dictionary between
  server & client. This accommodates super-wide dictionaries with 35k+
  variables. The user shouldn’t notice a difference, and still will
  receive a data.frame.
  ([\#335](https://github.com/OuhscBbmc/REDCapR/issues/335),
  [@januz](https://github.com/januz) &
  [@datalorax](https://github.com/datalorax))
- Include a few more
  [`testthat::skip_on_cran()`](https://testthat.r-lib.org/reference/skip.html)
  calls to comply with CRAN’s [“fail
  gracefully”](https://cran.r-project.org/web/packages/policies.html)
  policy. Similarly, skip remaining examples that depend on external
  resources. ([\#352](https://github.com/OuhscBbmc/REDCapR/issues/352))
- [`retrieve_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.md)
  can now user `username` to identify the desired credential row
  ([\#364](https://github.com/OuhscBbmc/REDCapR/issues/364))
- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  gain the `http_response_encoding` parameter that’s passed to
  [`httr::content()`](https://httr.r-lib.org/reference/content.html).
  The default value remains “UTF-8”.
  ([\#354](https://github.com/OuhscBbmc/REDCapR/issues/354),
  [@lrasmus](https://github.com/lrasmus))
- Accommodate single-character REDCap variable names
  ([\#367](https://github.com/OuhscBbmc/REDCapR/issues/367) &
  [\#368](https://github.com/OuhscBbmc/REDCapR/issues/368),
  [@daynefiler](https://github.com/daynefiler))
- Modify
  [`redcap_users_export()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_users_export.md)
  (which calls REDCap’s user export). The API dropped the `data_export`
  variable and added the `forms_export` variable.
  ([\#396](https://github.com/OuhscBbmc/REDCapR/issues/396))
- For
  [`redcap_read_oneshot_eav()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot_eav.md):
  if the project isn’t longitudinal, a dummy value for `event_id` is
  used internally
  ([\#396](https://github.com/OuhscBbmc/REDCapR/issues/396))
- For the testing server & projects, the http errors are a little
  different, so the testing code was adjusted
  ([\#396](https://github.com/OuhscBbmc/REDCapR/issues/396))
- Set
  [`httr::user_agent`](https://httr.r-lib.org/reference/user_agent.html),
  following the advice of httr’s vignette
  ([\#397](https://github.com/OuhscBbmc/REDCapR/issues/397))

#### Test Suite

- Added two more dictionaries that are super wide -5k & 35k variables
  ([\#335](https://github.com/OuhscBbmc/REDCapR/issues/335) &
  [\#360](https://github.com/OuhscBbmc/REDCapR/issues/360),
  [@januz](https://github.com/januz) &
  [@datalorax](https://github.com/datalorax))
- Read, modify, & read projects with DAGs
  ([\#353](https://github.com/OuhscBbmc/REDCapR/issues/353),
  daniela.wolkersdorfer,
  [\#353](https://github.com/OuhscBbmc/REDCapR/issues/353))

## REDCapR 1.0.0 (released 2021-07-21)

CRAN release: 2021-07-22

The package has been stable for years and should be reflected in the
major version number.

#### Minor Enhancements

- When writing records to the server, the functions
  [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.md)
  and
  [`redcap_write_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write_oneshot.md)
  have a new parameter that converts R’s `logical`/boolean columns to
  integers. This meshes well with T/F and Y/N items that are coded as
  1/0 underneath. The default will be FALSE (ie, the integers are not
  converted by default), so it doesn’t break existing code.
  ([\#305](https://github.com/OuhscBbmc/REDCapR/issues/305))
- When writing records to the server, the functions
  [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.md)
  and
  [`redcap_write_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write_oneshot.md)
  can toggle the ability to overwrite with blank/NA cells (suggested by
  [@auricap](https://github.com/auricap),
  [\#315](https://github.com/OuhscBbmc/REDCapR/issues/315))
- The functions
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md),
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md),
  &
  [`redcap_read_oneshot_eav()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot_eav.md)
  now support the parameters `datetime_range_begin` and
  `datetime_range_end`. The are passed to the REDCap parameters
  `dateRangeBegin` and `dateRangeEnd`, which restricts records returned,
  based on their last modified date in the server. (Thanks
  [@pbchase](https://github.com/pbchase),
  [\#321](https://github.com/OuhscBbmc/REDCapR/issues/321) &
  [\#323](https://github.com/OuhscBbmc/REDCapR/issues/323).)
- Better documentation about the `export_survey_fields` parameter in the
  functions
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  &
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md).
  (Thanks [@isaactpetersen](https://github.com/isaactpetersen),
  [\#333](https://github.com/OuhscBbmc/REDCapR/issues/333))
- New function
  [`redcap_report()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_report.html)
  export records that populate a REDCap report.
  ([\#326](https://github.com/OuhscBbmc/REDCapR/issues/326).)
- New vignette [Typical REDCap Workflow for a Data
  Analyst](https://ouhscbbmc.github.io/REDCapR/articles/workflow-read.html)
  developed to support a workshop for the 2021 [R/Medicine
  Conference](https://events.linuxfoundation.org/r-medicine/)
  ([\#332](https://github.com/OuhscBbmc/REDCapR/issues/332), with
  [@higgi13425](https://github.com/higgi13425),
  [@kamclean](https://github.com/kamclean), & Amanda Miller)
- New function
  [`create_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.html)
  starts a well-formed csv file that can contain tokens.
  ([\#340](https://github.com/OuhscBbmc/REDCapR/issues/340), after
  conversations with [@higgi13425](https://github.com/higgi13425) &
  [@kamclean](https://github.com/kamclean).)

#### Stability Features

- update for newer version of testthat -v3.0.0
  ([\#312](https://github.com/OuhscBbmc/REDCapR/issues/312))
- update for newer version of readr 2.0.0
  ([\#343](https://github.com/OuhscBbmc/REDCapR/issues/343))
- update for newer version of readr 1.4.0
  ([\#313](https://github.com/OuhscBbmc/REDCapR/issues/313))
- update for newer version of REDCap on test server
  ([\#310](https://github.com/OuhscBbmc/REDCapR/issues/310))
- save expected datasets as files -instead of included in the actual
  test code ([\#308](https://github.com/OuhscBbmc/REDCapR/issues/308))

#### Corrections & Bug Fixes

- Accepts more than one `config_option` element. (Proposed by
  [@BastienRance](https://github.com/BastienRance),
  [\#307](https://github.com/OuhscBbmc/REDCapR/issues/307))
- Fixed calculation of `success` value returned by
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and
  [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.md)
  when the parameter `continue_on_error` is true. (Bug found by
  [@llrs](https://github.com/llrs),
  [\#317](https://github.com/OuhscBbmc/REDCapR/issues/317))
- [`redcap_survey_link_export_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_survey_link_export_oneshot.html)
  documentation corrected & improved
  ([@jrob95](https://github.com/jrob95),
  [\#526](https://github.com/OuhscBbmc/REDCapR/issues/526))

## REDCapR 0.11.0 (Released 2020-04-20)

CRAN release: 2020-04-21

#### Breaking Changes (possible, but unlikely)

- [`kernel_api()`](https://ouhscbbmc.github.io/REDCapR/reference/kernel_api.html)
  defaults to “text/csv” and UTF-8 encoding. Formerly, the function
  would decide on the content-type and encoding. More details are below
  in the ‘Stability Features’ subsection.

- [`constant()`](https://ouhscbbmc.github.io/REDCapR/reference/constant.html)
  no longer accepts `simplify` as an options. An integer vector is
  always returned.
  ([\#280](https://github.com/OuhscBbmc/REDCapR/issues/280))

#### New Features

- It’s now possible to specify the exact `col_types` (a
  [`readr::cols`](https://readr.tidyverse.org/reference/cols.html)
  object) that is passed to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
  inside
  [`redcap_read_oneshot()`](https://github.com/OuhscBbmc/REDCapR/blob/master/R/redcap-read-oneshot.R).
  ([\#258](https://github.com/OuhscBbmc/REDCapR/issues/258))

- [`reader::type_convert()`](https://readr.tidyverse.org/reference/type_convert.html)
  is used *after* all the batches are stacked on top of each other. This
  way, batches cannot have incompatible data types as they’re combined.
  ([\#257](https://github.com/OuhscBbmc/REDCapR/issues/257); thanks
  [@isaactpetersen](https://github.com/isaactpetersen)
  [\#245](https://github.com/OuhscBbmc/REDCapR/issues/245))
  Consequently, the `guess_max` parameter in
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  no longer serves a purpose, and has been soft-deprecated.
  ([\#267](https://github.com/OuhscBbmc/REDCapR/issues/267))

- [`redcap_metadata_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_write.html)
  writes to the project’s metadata.
  ([\#274](https://github.com/OuhscBbmc/REDCapR/issues/274),
  [@felixetorres](https://github.com/felixetorres))

- [`redcap_survey_link_export_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_survey_link_export_oneshot.html)
  retrieves the URL to a specific record’s survey (*e.g.*,
  “<https://redcap-dev-2.ouhsc.edu/redcap/surveys/?s=8KuzSLMHf6>”)
  ([\#293](https://github.com/OuhscBbmc/REDCapR/issues/293))

- `convert_logical_to_integer` is a new parameter for
  [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.html)
  and
  [`redcap_write_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write_oneshot.html).
  If `TRUE`, all \[base::logical\] columns in `ds` are cast to an
  integer before uploading to REDCap. Boolean values are typically
  represented as 0/1 in REDCap radio buttons. Defaults to `FALSE` to
  maintain backwards compatibility.
  ([\#305](https://github.com/OuhscBbmc/REDCapR/issues/305))

#### Stability Features

- [`httr::content()`](https://httr.r-lib.org/reference/content.html)
  (which is inside
  [`kernel_api()`](https://ouhscbbmc.github.io/REDCapR/reference/kernel_api.md))
  now processes the returned value as “text/csv”, by default. This
  should prevent strange characters from tricking the process as the
  internal variable `raw_text` is being formed. See the
  \[httr::content()`](https://httr.r-lib.org/reference/content.html) documentation for a list of possible values for the`content_type\`
  parameter. (Thanks to great debugging by
  [@vortexing](https://github.com/vortexing)
  [\#269](https://github.com/OuhscBbmc/REDCapR/issues/269),
  [@sybandrew](https://github.com/sybandrew)
  [\#272](https://github.com/OuhscBbmc/REDCapR/issues/272), &
  [@begavett](https://github.com/begavett),
  [\#290](https://github.com/OuhscBbmc/REDCapR/issues/290))

- Similarly,
  [`kernel_api()`](https://ouhscbbmc.github.io/REDCapR/reference/kernel_api.md)
  now has an `encoding` parameter, which defaults to “UTF-8”.
  ([\#270](https://github.com/OuhscBbmc/REDCapR/issues/270))

#### Minor Enhancements

- check for bad field names passed to the read records functions
  ([\#288](https://github.com/OuhscBbmc/REDCapR/issues/288))

#### Corrections

- ‘checkmate’ package is now imported, not suggested (Thanks
  [@dtenenba](https://github.com/dtenenba),
  [\#255](https://github.com/OuhscBbmc/REDCapR/issues/255)).

- Allow more than one
  [`httr::config()`](https://httr.r-lib.org/reference/config.html)
  parameter to be passed (Thanks
  [@BastienRance](https://github.com/BastienRance),
  [\#307](https://github.com/OuhscBbmc/REDCapR/issues/307)).

## REDCapR 0.10.2 (Released 2019-09-22)

CRAN release: 2019-09-23

#### Minor New Features

- export survey time-stamps optionally (Issue
  [\#159](https://github.com/OuhscBbmc/REDCapR/issues/159))
- [`redcap_next_free_record_name()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_next_free_record_name.md):
  API call for ‘Generate Next Record Name’, which returns the next
  available record ID (Issue
  [\#237](https://github.com/OuhscBbmc/REDCapR/issues/237))
- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  allow the user to specify if all variables should be returned with the
  `character` data type. The default is to allow
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
  to guess the data type.
  ([\#194](https://github.com/OuhscBbmc/REDCapR/issues/194))
- [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  allows use to specify how many rows should be considered when
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
  guesses the data type.
  ([\#194](https://github.com/OuhscBbmc/REDCapR/issues/194))
- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md),
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md),
  and
  [`redcap_read_oneshot_eav()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot_eav.md)
  always return Linux-style line endings (ie `\n`) instead of Windows
  style line endings (ie, `\r\n`) on all OSes.
  ([\#198](https://github.com/OuhscBbmc/REDCapR/issues/198))
- `read_metadata()` always returns `character` vectors for all
  variables. With readr 1.2.0, some column were returned differently
  than before.
  ([\#193](https://github.com/OuhscBbmc/REDCapR/issues/193))
- ‘raw_or_label_headers’ now supported (Thanks Hatem Hosny - hatemhosny,
  [\#183](https://github.com/OuhscBbmc/REDCapR/issues/183) &
  [\#203](https://github.com/OuhscBbmc/REDCapR/issues/203))
- ‘export_checkbox_labels’ now supported
  ([\#186](https://github.com/OuhscBbmc/REDCapR/issues/186))
- [`redcap_users_export()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_users_export.md)
  now included
  ([\#163](https://github.com/OuhscBbmc/REDCapR/issues/163))
- ‘forms’ now supported for
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md),
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md),
  &
  [`redcap_read_oneshot_eav()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot_eav.md)([\#206](https://github.com/OuhscBbmc/REDCapR/issues/206)).
  It was already implemented for
  [`redcap_metadata_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_read.md).
- If no records are affected, a zero-length *character* vector is
  returned (instead of sometimes a zero-length *numeric* vector)
  ([\#212](https://github.com/OuhscBbmc/REDCapR/issues/212))
- New function (called `constants()`) easily exposes REDCap-specific
  constants. ([\#217](https://github.com/OuhscBbmc/REDCapR/issues/217))
- `id_position` allows user to specify if the record_id isn’t in the
  first position
  ([\#207](https://github.com/OuhscBbmc/REDCapR/issues/207)). However,
  we recommend that all REDCap projects keep this important variable
  first in the data dictionary.
- Link to new secure Zenodo DOI resolver
  ([@katrinleinweber](https://github.com/katrinleinweber)
  [\#191](https://github.com/OuhscBbmc/REDCapR/issues/191))
- parameters in
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  are more consistent with the order in raw REDCap API.
  ([\#204](https://github.com/OuhscBbmc/REDCapR/issues/204))
- When the `verbose` parameter is NULL, then the value from
  getOption(“verbose”) is used.
  ([\#215](https://github.com/OuhscBbmc/REDCapR/issues/215))
- `guess_max` parameter provided in
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  (no longer just
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)).
  Suggested by [@isaactpetersen](https://github.com/isaactpetersen) in
  [\#245](https://github.com/OuhscBbmc/REDCapR/issues/245).
- Documentation website constructed with pkgdown
  ([\#224](https://github.com/OuhscBbmc/REDCapR/issues/224)).
- [`redcap_variables()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_variables.md)
  now throws an error when passed a bad URI (commit e542155639bbb7).

#### Modified Internals

- All interaction with the REDCap server goes through the new
  `kernal_api()` function, which uses the ‘httr’ and ‘curl’ packages
  underneath. Until now, each function called those packages directly.
  ([\#213](https://github.com/OuhscBbmc/REDCapR/issues/213))
- When converting REDCap’s CSV to R’s data.frame,
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
  is used instead of
  [`utils::read.csv()`](https://rdrr.io/r/utils/read.table.html) (Issue
  [\#127](https://github.com/OuhscBbmc/REDCapR/issues/127)).
- updated to readr 1.2.0
  ([\#200](https://github.com/OuhscBbmc/REDCapR/issues/200)). This
  changed how some data variables were assigned a data types.
- uses `odbc` package to retrieve credentials from the token server.
  Remove RODBC and RODBCext
  ([\#188](https://github.com/OuhscBbmc/REDCapR/issues/188)). Thanks to
  [@krlmlr](https://github.com/krlmlr) for error checking advice in
  <https://stackoverflow.com/a/50419403/1082435>.
- `data.table::rbindlist()` replaced by
  [`dplyr::bind_rows()`](https://dplyr.tidyverse.org/reference/bind_rows.html)
- the checkmate package inspects most function parameters now (instead
  of `testit::assert()` and `base:stop()` )
  ([\#190](https://github.com/OuhscBbmc/REDCapR/issues/190) &
  [\#208](https://github.com/OuhscBbmc/REDCapR/issues/208)).
- [`collapse_vector()`](https://ouhscbbmc.github.io/REDCapR/reference/collapse_vector.md)
  is refactored and tested
  ([\#209](https://github.com/OuhscBbmc/REDCapR/issues/209))
- remove dependency on `pkgload` package
  ([\#218](https://github.com/OuhscBbmc/REDCapR/issues/218))
- Update Markdown syntax to new formatting problems
  ([\#253](https://github.com/OuhscBbmc/REDCapR/issues/253))

#### Deprecated Features

- `retrieve_token_mssql()`, because
  [`retrieve_credential_mssql()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.md)
  is more general and more useful.

## REDCapR 0.9.8 (Released 2017-05-18)

CRAN release: 2017-05-18

#### New Features

- Enumerate the exported variables. with
  [`redcap_variables()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_variables.md).
- Experimental EAV export in
  [`redcap_read_oneshot_eav()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot_eav.md),
  which can be accessed with a triple colon (ie,
  [`REDCapR::redcap_read_oneshot_eav()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot_eav.md)).

#### Bug Fixes

- Adapted to new 2.4 version of curl (see
  [\#154](https://github.com/OuhscBbmc/REDCapR/issues/154))

## REDCapR 0.9.7 (Released 2017-09-09)

CRAN release: 2016-09-09

#### New Features

- Support for filtering logic in
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  (PR [\#126](https://github.com/OuhscBbmc/REDCapR/issues/126))
- New functions
  [`retrieve_credential_mssql()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.md)
  and
  [`retrieve_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.md).
  These transition from storing & retrieving just the token (ie,
  `retrieve_token_mssql()`) to storing & retrieving more information.
  [`retrieve_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.md)
  facilitates a standard way of storing tokens locally, which should
  make it easier to follow practices of keeping it off the repository.
- Using parameterized queries with the RODBCext package. (Thanks
  [@nutterb](https://github.com/nutterb) in issues
  [\#115](https://github.com/OuhscBbmc/REDCapR/issues/115) &
  [\#116](https://github.com/OuhscBbmc/REDCapR/issues/116).)
- Remove line breaks from token (Thanks
  [@haozhu233](https://github.com/haozhu233) in issues
  [\#103](https://github.com/OuhscBbmc/REDCapR/issues/103) &
  [\#104](https://github.com/OuhscBbmc/REDCapR/issues/104))

#### Minor Updates

- When combining batches into a single data.frame,
  `data.table::rbindlist()` is used. This should prevent errors with the
  first batch’s data type (for a column) isn’t compatible with a later
  batch. For instance, this occurs when the first batch has only
  integers for `record_id`, but a subsequent batch has values like
  `aa-test-aa`. The variable for the combined dataset should be a
  character. (Issue
  [\#128](https://github.com/OuhscBbmc/REDCapR/issues/128) &
  <https://stackoverflow.com/questions/39377370/bind-rows-of-different-data-types>;
  Thanks [@arunsrinivasan](https://github.com/arunsrinivasan))
- Uses the `dplyr` package instead of `plyr`. This shouldn’t affect
  callers, because immediately before returning the data,
  [`REDCapR::redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  coerces the
  [`tibble::tibble`](https://tibble.tidyverse.org/reference/tibble.html)
  (which was formerly called
  [`dplyr::tbl_df`](https://dplyr.tidyverse.org/reference/tbl_df.html))
  back to a vanilla `data.frame` with
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).
- A few more instances of validating input parameters to read functions.
  (Issue [\#8](https://github.com/OuhscBbmc/REDCapR/issues/8)).

## REDCapR 0.9.3 (Released 2015-08-25)

CRAN release: 2015-08-26

#### Minor Updates

- The `retrieve-token()` tests now account for the (OS X) builds where
  the RODBC package isn’t available.

## REDCapR 0.9.0 (Released 2015-08-14)

CRAN release: 2015-08-15

#### New Features

- Adapted for version 1.0.0 of httr (which is now based on the `curl`
  package, instead of `RCurl`).

#### Minor Updates

- Uses [`requireNamespace()`](https://rdrr.io/r/base/ns-load.html)
  instead of [`require()`](https://rdrr.io/r/base/library.html).
- By default, uses the SSL cert files used by httr, which by default,
  uses those packaged with R.
- Added warning if it appears `readcap_read()` is being used without
  ‘Full Data Set’ export privileges. The problem involves the record IDs
  are hashed.
- Reconnected code that reads only the `id_position` in the first stage
  of batching. The metadata needed to be read before that, after the
  updates for REDCap Version 6.0.x.
- `retrieve_token_mssql()` uses regexes to validate parameters

## REDCapR 0.7-1 (Released 2014-12-17)

CRAN release: 2014-12-18

#### New Features

- Updated for Version 6.0.x of REDCap (which introduced a lot of
  improvements to API behavior).

## REDCapR 0.6 (Released 2014-11-03)

#### New Features

- The `config_options` in the httr package are exposed to the REDCapR
  user. See issues
  [\#55](https://github.com/OuhscBbmc/REDCapR/issues/55) &
  [\#58](https://github.com/OuhscBbmc/REDCapR/issues/58); thanks to
  [@rparrish](https://github.com/rparrish) and
  [@nutterb](https://github.com/nutterb) for their contributions
  (<https://github.com/OuhscBbmc/REDCapR/issues/55> &
  <https://github.com/OuhscBbmc/REDCapR/issues/58>).

## REDCapR 0.5 (Released 2014-10-19)

#### New Features

- [`redcap_metadata_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_read.md)
  are tested and public.

#### Minor Updates

- Test suite now uses
  [`testthat::skip_on_cran()`](https://testthat.r-lib.org/reference/skip.html)
  before any call involving OUHSC’s REDCap server.
- Vignette example of subsetting, conditioned on a second variable’s
  value.

## REDCapR 0.4-28 (Released 2014-09-20)

CRAN release: 2014-09-20

#### New Features

- [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.md)
  and
  [`redcap_write_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write_oneshot.md)
  are now tested and public.
- [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.md)
  and
  [`redcap_write_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write_oneshot.md)
  are now tested and public.
- [`redcap_download_file_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_download_oneshot.md)
  function contributed by John Aponte
  ([@johnaponte](https://github.com/johnaponte); Pull request
  [\#35](https://github.com/OuhscBbmc/REDCapR/issues/35))
- [`redcap_upload_file_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_upload_oneshot.md)
  function contributed by [@johnaponte](https://github.com/johnaponte)
  (Pull request [\#34](https://github.com/OuhscBbmc/REDCapR/issues/34))
- Users can specify if an operation should continue after an error
  occurs on a batch read or write. Regardless of their choice, more
  debugging output is written to the console if `verbose==TRUE`. Follows
  advice of [@johnaponte](https://github.com/johnaponte), Benjamin
  Nutter ([@nutterb](https://github.com/nutterb)), and Rollie Parrish
  ([@rparrish](https://github.com/rparrish)). Closes
  [\#43](https://github.com/OuhscBbmc/REDCapR/issues/43).

#### Breaking Changes

- The `records_collapsed` default empty value is now an empty string
  (*i.e.*, `""`) instead of `NULL`. This applies when
  `records_collapsed` is either a parameter, or a returned value.

#### Updates

- By default, the SSL certs come from the httr package. However, REDCapR
  will continue to maintain a copy in case httr’s version on CRAN gets
  out of date.
- The tests are split into two collections: one that’s run by the CRAN
  checks, and the other run manually. [Thanks, Gabor
  Csardi](https://stackoverflow.com/questions/25595487/testthat-pattern-for-long-running-tests).
  Any test with a dependency outside the package code (especially the
  REDCap test projects) is run manually so changes to the test databases
  won’t affect the success of building the previous version on CRAN.
- Corrected typo in
  [`redcap_download_file_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_download_oneshot.md)
  documentation, thanks to Andrew Peters
  ([@ARPeters](https://github.com/ARPeters)
  [\#45](https://github.com/OuhscBbmc/REDCapR/issues/45)).

## REDCapR 0.3 (Released 2014-09-01)

#### New Features

- Relies on the `httr` package, which provides benefits like the status
  code message can be captured (eg, 200-OK, 403-Forbidden,
  404-NotFound). See <https://cran.r-project.org/package=httr>.

#### Updates

- Renamed the former `status_message` to `outcome_message`. This is
  because the message associated with http code returned is
  conventionally called the ‘status messages’ (eg, OK, Forbidden, Not
  Found).
- If an operation is successful, the `raw_text` value (which was
  formerly called `raw_csv`) is returned as an empty string to save RAM.
  It’s not really necessary with httr’s status message exposed.

#### Bug Fixes

- Correct batch reads with longitudinal schema
  [\#27](https://github.com/OuhscBbmc/REDCapR/issues/27)

## REDCapR 0.2 (Released 2014-07-02)

#### New Features

- Added
  [`redcap_column_sanitize()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_column_sanitize.md)
  function to address non-ASCII characters
- Added
  [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.md)
  (as an internal function).
- The
  [`redcap_project()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_project.md)
  object reduces repeatedly passing parameters like the server URL, the
  user token, and the SSL cert location.

#### Updates

- New Mozilla SSL Certification Bundles released on cURL (released
  2013-12-05)
- Renamed `redcap_read_batch()` to
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md).
  These changes reflect our suggestion that reads should typically be
  batched.
- Renamed
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  to
  [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
- Renamed
  [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.md)
  to
  [`redcap_write_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write_oneshot.md)
  (which is an internal function).
- Small renames to parameters

## REDCapR 0.1 (Released 2014-01-14)

#### New Features

- Introduces
  [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  and `redcap_read_batch()` with documentation
- SSL verify peer by default, using cert file included in package
- Initial submission to GitHub

#### Enhancements

- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  takes parameter for `raw_or_label` (Thanks Rollie Parrish
  [\#3](https://github.com/OuhscBbmc/REDCapR/issues/3))
- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  takes parameter for `export_data_access_groups` thanks to Rollie
  Parrish ([@rparrish](https://github.com/rparrish)
  [\#4](https://github.com/OuhscBbmc/REDCapR/issues/4))

------------------------------------------------------------------------

GitHub Commits and Releases

- For a detailed change log, please see
  <https://github.com/OuhscBbmc/REDCapR/commits/main>.
- For a list of the major releases, please see
  <https://github.com/OuhscBbmc/REDCapR/releases>.
