# Package index

## Records via the API

Reading and writing REDCap records, and files within a record.

- [`redcap_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.md)
  : Read records from a REDCap project in subsets, and stacks them
  together before returning a dataset
- [`redcap_read_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.md)
  : Read/Export records from a REDCap project
- [`redcap_read_oneshot_eav()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot_eav.md)
  : Read/Export records from a REDCap project –still in development
- [`redcap_read_eav_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_eav_oneshot.md)
  : Read/Export records from a REDCap project, returned as eav
- [`redcap_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write.md)
  : Write/Import records to a REDCap project
- [`redcap_write_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_write_oneshot.md)
  : Write/Import records to a REDCap project
- [`redcap_delete()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_delete.md)
  : Delete records in a REDCap project
- [`redcap_report()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_report.md)
  : Read/Export records that populate a REDCap report

## File API Operations

Manipulating files in the REDCap records and in the file repository.

- [`redcap_file_download_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_download_oneshot.md)
  : Download a file from a REDCap project record
- [`redcap_file_upload_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_upload_oneshot.md)
  : Upload a file into to a REDCap project record
- [`redcap_file_repo_list_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_repo_list_oneshot.md)
  : Export a List of Files/Folders from the File Repository

## Additional API Methods

Accessing other information from the REDCap project or server.

- [`redcap_arm_export()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_arm_export.md)
  : Export Arms
- [`redcap_dag_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_dag_read.md)
  : Read data access groups from a REDCap project
- [`redcap_event_instruments()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_event_instruments.md)
  : Enumerate the instruments to event mappings
- [`redcap_event_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_event_read.md)
  : Export Events
- [`redcap_instrument_download()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_instrument_download.md)
  : Download REDCap Instruments
- [`redcap_instruments()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_instruments.md)
  : Enumerate the instruments (forms)
- [`redcap_log_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_log_read.md)
  : Get the logging of a project.
- [`redcap_metadata_coltypes()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_coltypes.md)
  : Suggests a col_type for each field in a REDCap project
- [`redcap_metadata_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_read.md)
  : Export the metadata of a REDCap project
- [`redcap_metadata_write()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_write.md)
  : Import metadata of a REDCap project
- [`redcap_next_free_record_name()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_next_free_record_name.md)
  : Determine free available record ID
- [`redcap_project_info_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_project_info_read.md)
  : Export project information.
- [`redcap_survey_link_export_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_survey_link_export_oneshot.md)
  : Get survey link from REDCap
- [`redcap_users_export()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_users_export.md)
  : List authorized users
- [`redcap_variables()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_variables.md)
  : Enumerate the exported variables
- [`redcap_version()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_version.md)
  : Determine version of REDCap instance

## Internals

Functions and classes used by the methods above.

- [`REDCapR`](https://ouhscbbmc.github.io/REDCapR/reference/REDCapR-package.md)
  [`REDCapR-package`](https://ouhscbbmc.github.io/REDCapR/reference/REDCapR-package.md)
  : REDCapR: Interaction Between R and REDCap
- [`redcap_project`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_project.md)
  : A Reference Class to make later calls to REDCap more convenient
- [`to_api_array()`](https://ouhscbbmc.github.io/REDCapR/reference/to_api_array.md)
  : Convert a vector to the array format expected by the REDCap API
- [`kernel_api()`](https://ouhscbbmc.github.io/REDCapR/reference/kernel_api.md)
  : REDCapR internal function for calling the REDCap API

## Security

Responsibly store and retrieve a user’s project-specific token.

- [`retrieve_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.md)
  [`retrieve_credential_mssql()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.md)
  [`create_credential_local()`](https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.md)
  : Read a token and other credentials from a (non-REDCap) database or
  file

## Utilities

Functions to help the methods above.

- [`collapse_vector()`](https://ouhscbbmc.github.io/REDCapR/reference/collapse_vector.md)
  : Collapse a vector of values into a single string when necessary
- [`constant()`](https://ouhscbbmc.github.io/REDCapR/reference/constant.md)
  : Collection of REDCap-specific constants
- [`create_batch_glossary()`](https://ouhscbbmc.github.io/REDCapR/reference/create_batch_glossary.md)
  : Creates a dataset that help batching long-running read and writes
- [`regex_named_captures()`](https://ouhscbbmc.github.io/REDCapR/reference/metadata_utilities.md)
  [`checkbox_choices()`](https://ouhscbbmc.github.io/REDCapR/reference/metadata_utilities.md)
  : Manipulate and interpret the metadata of a REDCap project
- [`redcap_column_sanitize()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_column_sanitize.md)
  : Sanitize to adhere to REDCap character encoding requirements
- [`replace_nas_with_explicit()`](https://ouhscbbmc.github.io/REDCapR/reference/replace_nas_with_explicit.md)
  : Create explicit factor level for missing values
- [`sanitize_token()`](https://ouhscbbmc.github.io/REDCapR/reference/sanitize_token.md)
  : Validate and sanitize the user's REDCap token
- [`validate_for_write()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  [`validate_data_frame_inherits()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  [`validate_no_logical()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  [`validate_field_names()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  [`validate_record_id_name()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  [`validate_repeat_instance()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  [`validate_uniqueness()`](https://ouhscbbmc.github.io/REDCapR/reference/validate.md)
  : Inspect a dataset to anticipate problems before writing to a REDCap
  project

## Soft Deprecated

Functions that have been renamed and will be removed in future REDCapR
versions.

- [`redcap_file_download_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_download_oneshot.md)
  : Download a file from a REDCap project record
- [`redcap_file_upload_oneshot()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_file_upload_oneshot.md)
  : Upload a file into to a REDCap project record
- [`redcap_instrument_download()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_instrument_download.md)
  : Download REDCap Instruments
