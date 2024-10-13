#' @title
#' Read records from a REDCap project in subsets, and stacks them
#' together before returning a dataset
#'
#' @description
#' From an external perspective, this function is similar to
#' [redcap_read_oneshot()].  The internals differ in that `redcap_read`
#' retrieves subsets of the data, and then combines them before returning
#' (among other objects) a single [tibble::tibble()].  This function can
#' be more appropriate than [redcap_read_oneshot()] when returning large
#' datasets that could tie up the server.
#'
#' @param batch_size The maximum number of subject records a single batch
#' should contain.  The default is 100.
#' @param interbatch_delay The number of seconds the function will wait
#' before requesting a new subset from REDCap. The default is 0.5 seconds.
#' @param continue_on_error If an error occurs while reading, should records
#' in subsequent batches be attempted.  The default is `FALSE`, which prevents
#' subsequent batches from running.  Required.
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param records An array, where each element corresponds to the ID of a
#' desired record.  Optional.
#' @param fields An array, where each element corresponds to a desired project
#' field.  Optional.
#' @param forms An array, where each element corresponds to a desired project
#' form.  Optional.
#' @param events An array, where each element corresponds to a desired project
#' event.  Optional.
#' @param raw_or_label A string (either `'raw'` or `'label'` that specifies
#' whether to export the raw coded values or the labels for the options of
#' multiple choice fields.  Default is `'raw'`.
#' @param raw_or_label_headers A string (either `'raw'` or `'label'` that
#' specifies for the CSV headers whether to export the variable/field names
#' (raw) or the field labels (label).  Default is `'raw'`.
#' @param export_checkbox_label specifies the format of checkbox field values
#' specifically when exporting the data as labels.  If `raw_or_label` is
#' `'label'` and `export_checkbox_label` is TRUE, the values will be the text
#' displayed to the users.  Otherwise, the values will be 0/1.
#  placeholder: returnFormat
#' @param export_survey_fields A boolean that specifies whether to export the
#' survey identifier field (e.g., 'redcap_survey_identifier') or survey
#' timestamp fields (e.g., instrument+'_timestamp').
#' The timestamp outputs reflect the survey's *completion* time
#' (according to the time and timezone of the REDCap server.)
#' @param export_data_access_groups A boolean value that specifies whether or
#' not to export the `redcap_data_access_group` field when data access groups
#' are utilized in the project. Default is `FALSE`. See the details below.
#' @param filter_logic String of logic text (e.g., `[gender] = 'male'`) for
#' filtering the data to be returned by this API method, in which the API
#' will only return the records (or record-events, if a longitudinal project)
#' where the logic evaluates as TRUE.   An blank/empty string returns all records.
#' @param datetime_range_begin To return only records that have been created or
#' modified *after* a given datetime, provide a
#' [POSIXct](https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html)
#' value.
#' If not specified, REDCap will assume no begin time.
#' @param datetime_range_end To return only records that have been created or
#' modified *before* a given datetime, provide a
#' [POSIXct](https://stat.ethz.ch/R-manual/R-devel/library/base/html/as.POSIXlt.html)
#' value.
#' If not specified, REDCap will assume no end time.
#' @param blank_for_gray_form_status A boolean value that specifies whether
#' or not to export blank values for instrument complete status fields that have
#' a gray status icon. All instrument complete status fields having a gray icon
#' can be exported either as a blank value or as "0" (Incomplete). Blank values
#' are recommended in a data export if the data will be re-imported into a
#' REDCap project. Default is `FALSE`.
#' @param col_types A [readr::cols()] object passed internally to
#' [readr::read_csv()].  Optional.
#' @param na A [character] vector passed internally to [readr::read_csv()].
#' Defaults to `c("", "NA")`.
#' @param guess_type A boolean value indicating if all columns should be
#' returned as character.  If true, [readr::read_csv()] guesses the intended
#' data type for each column.  Ignored if `col_types` is not null.
#' @param guess_max Deprecated.
#' @param http_response_encoding  The encoding value passed to
#' [httr::content()].  Defaults to 'UTF-8'.
#' @param locale a [readr::locale()] object to specify preferences like
#' number, date, and time formats.  This object is passed to
#' [readr::read_csv()].  Defaults to [readr::default_locale()].
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options A list of options passed to [httr::POST()].
#' See details at [httr::httr_options()]. Optional.
#' @param handle_httr The value passed to the `handle` parameter of
#' [httr::POST()].
#' This is useful for only unconventional authentication approaches.  It
#' should be `NULL` for most institutions.  Optional.
#' @param id_position  The column position of the variable that unique
#' identifies the subject (typically `record_id`).
#' This defaults to the first variable in the dataset.
#'
#' @return
#' Currently, a list is returned with the following elements:
#' * `data`: A [tibble::tibble()] of the desired records and columns.
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_codes`: A collection of
#' [http status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
#' separated by semicolons.  There is one code for each batch attempted.
#' * `outcome_messages`: A collection of human readable strings indicating the
#' operations' semicolons.  There is one code for each batch attempted.  In an
#' unsuccessful operation, it should contain diagnostic information.
#' * `records_collapsed`: The desired records IDs, collapsed into a single
#' string, separated by commas.
#' * `fields_collapsed`: The desired field names, collapsed into a single
#' string, separated by commas.
#' * `filter_logic`: The filter statement passed as an argument.
#' * `elapsed_seconds`: The duration of the function.
#'
#' If no records are retrieved (such as no records meet the filter criteria),
#' a zero-row tibble is returned.
#' Currently the empty tibble has zero columns, but that may change in the future.
#'
#' @section Batching subsets of data:
#'
#' [redcap_read()] internally uses multiple calls to [redcap_read_oneshot()]
#' to select and return data.  Initially, only the primary key is queried
#' through the REDCap API.  The long list is then subsetted into batches,
#' whose sizes are determined by the `batch_size` parameter.  REDCap is then
#' queried for all variables of the subset's subjects.  This is repeated for
#' each subset, before returning a unified [tibble::tibble()].
#'
#' The function allows a delay between calls, which allows the server to
#' attend to other users' requests (such as the users entering data in a
#' browser).  In other words, a delay between batches does not bog down
#' the webserver when exporting/importing a large dataset.
#'
#' A second benefit is less RAM is required on the webserver.  Because
#' each batch is smaller than the entire dataset, the webserver
#' tackles more manageably sized objects in memory.  Consider batching
#' if you encounter the error:
#'
#' ```
#' ERROR: REDCap ran out of server memory. The request cannot be processed.
#' Please try importing/exporting a smaller amount of data.
#' ```
#'
#' A third benefit (compared to [redcap_read()]) is that important fields are
#' included, even if not explicitly requested.  As a result:
#' 1. `record_id` (or it's customized name) will always be returned
#' 1. `redcap_event_name` will be returned for longitudinal projects
#' 1. `redcap_repeat_instrument` and `redcap_repeat_instance` will be returned
#'   for projects with repeating instruments
#'
#' @section Export permissions:
#'
#' For [redcap_read_oneshot()] to function properly, the user must have Export
#' permissions for the 'Full Data Set'.  Users with only 'De-Identified'
#' export privileges can still use `redcap_read_oneshot`.  To grant the
#' appropriate permissions:
#' * go to 'User Rights' in the REDCap project site,
#' * select the desired user, and then select 'Edit User Privileges',
#' * in the 'Data Exports' radio buttons, select 'Full Data Set'.
#'
#' @section Pseudofields:
#'
#' The REDCap project may contain "pseudofields", depending on its structure.
#' Pseudofields are exported for certain project structures, but are not
#' defined by users and do not appear in the codebook.
#' If a recognized pseudofield is passed to the `fields` api parameter,
#' it is suppressed by [REDCapR::redcap_read()] and [REDCapR::redcap_read_oneshot()]
#' so the server doesn't throw an error.
#' Requesting a pseudofield is discouraged, so a message is returned to the user.
#'
#' Pseudofields include:
#' * `redcap_event_name`: for longitudinal projects or multi-arm projects.
#' * `redcap_repeat_instrument`:  for projects with repeating instruments.
#' * `redcap_repeat_instance`:   for projects with repeating instruments.
#' * `redcap_data_access_group`: for projects with DAGs when the
#'   `export_data_access_groups` api parameter is TRUE.
#' * `redcap_survey_identifier`:  for projects with surveys when the
#'   `export_survey_fields` api parameter is TRUE.
#' * *instrument_name*`_timestamp`: for projects with surveys.
#'   For example, an instrument called "demographics" will have a pseudofield
#'   named `demographics_timestamp`.
#'   REDCapR does not suppress requests for timestamps, so the server will
#'   throw an error like
#'
#'   ```
#'   ERROR: The following values in the parameter fields are not valid: 'demographics_timestamp'
#'   ```
#'
#' @section Events:
#' The `event` argument is a vector of characters passed to the server.
#' It is the "event-name", not the "event-label".
#' The event-label is the value presented to the users,
#' which contains uppercase letters and spaces,
#' while the event-name can contain only lowercase letters, digits,
#' and underscores.
#'
#' If `event` is nonnull and the project is not longitudinal,
#' [redcap_read()] will throw an error.
#' Similarly, if a value in the `event` vector is not a current
#' event-name, [redcap_read()] will throw an error.
#'
#' The simpler [redcap_read_oneshot()] function does not
#' check for invalid event values, and will not throw errors.
#'
#' @author
#' Will Beasley
#'
#' @references
#' The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html
#' and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' uri     <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token   <- "9A068C425B1341D69E83064A2D273A70"
#'
#' # Return the entire dataset
#' REDCapR::redcap_read(batch_size=2, redcap_uri=uri, token=token)$data
#'
#' # Return a subset of columns while also specifying the column types.
#' col_types <- readr::cols(
#'   record_id  = readr::col_integer(),
#'   race___1   = readr::col_logical(),
#'   race___2   = readr::col_logical(),
#'   race___3   = readr::col_logical(),
#'   race___4   = readr::col_logical(),
#'   race___5   = readr::col_logical(),
#'   race___6   = readr::col_logical()
#' )
#' REDCapR::redcap_read(
#'   redcap_uri = uri,
#'   token      = token,
#'   col_types  = col_types,
#'   batch_size = 2
#' )$data
#' }

#' @importFrom magrittr %>%
#' @export
redcap_read <- function(
  batch_size                    = 100L,
  interbatch_delay              = 0.5,
  continue_on_error             = FALSE,
  redcap_uri,
  token,
  records                       = NULL,
  fields                        = NULL,
  forms                         = NULL,
  events                        = NULL,
  raw_or_label                  = "raw",
  raw_or_label_headers          = "raw",
  export_checkbox_label         = FALSE,
  # placeholder: returnFormat
  export_survey_fields          = FALSE,
  export_data_access_groups     = FALSE,
  filter_logic                  = "",
  datetime_range_begin          = as.POSIXct(NA),
  datetime_range_end            = as.POSIXct(NA),
  blank_for_gray_form_status    = FALSE,

  col_types                     = NULL,
  na                            = c("", "NA"),
  guess_type                    = TRUE,
  guess_max                     = NULL, # Deprecated parameter
  http_response_encoding        = "UTF-8",
  locale                        = readr::default_locale(),
  verbose                       = TRUE,
  config_options                = NULL,
  handle_httr                   = NULL,
  id_position                   = 1L
) {

  # Validate incoming parameters ----------------------------
  checkmate::assert_character(redcap_uri                , any.missing=FALSE,     len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=FALSE,     len=1, pattern="^.{1,}$")
  checkmate::assert_atomic(  records                    , any.missing=TRUE, min.len=0)
  checkmate::assert_character(fields                    , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE)
  checkmate::assert_character(forms                     , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE)
  checkmate::assert_character(events                    , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE)
  checkmate::assert_character(raw_or_label              , any.missing=FALSE,     len=1)
  checkmate::assert_subset(   raw_or_label              , c("raw", "label"))
  checkmate::assert_character(raw_or_label_headers      , any.missing=FALSE,     len=1)
  checkmate::assert_subset(   raw_or_label_headers      , c("raw", "label"))
  checkmate::assert_logical(  export_checkbox_label     , any.missing=FALSE,     len=1)
  # placeholder: returnFormat
  checkmate::assert_logical(  export_survey_fields      , any.missing=FALSE,     len=1)
  checkmate::assert_logical(  export_data_access_groups , any.missing=FALSE,     len=1)
  checkmate::assert_posixct(  datetime_range_begin      , any.missing=TRUE , len=1, null.ok=TRUE)
  checkmate::assert_posixct(  datetime_range_end        , any.missing=TRUE , len=1, null.ok=TRUE)
  checkmate::assert_logical( blank_for_gray_form_status , any.missing=FALSE, len=1)

  checkmate::assert_character(na                        , any.missing=FALSE)
  checkmate::assert_logical(  guess_type                , any.missing=FALSE,     len=1)
  if (!is.null(guess_max)) warning("The `guess_max` parameter in `REDCapR::redcap_read()` is deprecated.")

  checkmate::assert_character(http_response_encoding    , any.missing=FALSE,     len=1)
  checkmate::assert_class(    locale, "locale"          , null.ok = FALSE)

  checkmate::assert_logical(  verbose                   , any.missing=FALSE,     len=1, null.ok=TRUE)
  checkmate::assert_list(     config_options            , any.missing=TRUE ,            null.ok=TRUE)
  checkmate::assert_integer(  id_position               , any.missing=FALSE,     len=1, lower=1L)

  assert_field_names(fields)

  token               <- sanitize_token(token)
  filter_logic        <- filter_logic_prepare(filter_logic)
  verbose             <- verbose_prepare(verbose)

  start_time <- Sys.time()

  # Retrieve metadata ------------------------------------------------
  metadata <- redcap_metadata_internal(
    redcap_uri         = redcap_uri,
    token              = token,
    verbose            = verbose,
    config_options     = config_options,
    handle_httr        = handle_httr
  )

  if (!is.null(events)) {
    if (!metadata$longitudinal) {
      "This project is NOT longitudinal, so do not pass a value to the `event` argument." %>%
        stop(call. = FALSE)
    } else {
      events_in_project <-
        redcap_event_read(
          redcap_uri,
          token,
          verbose         = verbose,
          config_options  = config_options,
          handle_httr     = handle_httr
        )$data[["unique_event_name"]]

      events_not_recognized <- setdiff(events, events_in_project)
      if (0L < length(events_not_recognized)) {
        "The following events are not recognized for this project: {%s}.\nMake sure you're using internal `event-name` (lowercase letters & underscores)\ninstead of the user-facing `event-label` (that can have spaces and uppercase letters)." %>%
          sprintf(paste(events_not_recognized, collapse = ", ")) %>%
          stop(call. = FALSE)
      }
    } # end of else
  } # end of !is.null(events)

  if (!is.null(fields) || !is.null(forms)) {
    fields  <- base::union(metadata$record_id_name, fields)
    # fields  <- base::union(metadata$plumbing_variables, fields)
  }

  # Retrieve list of record ids --------------------------------------
  initial_call <- REDCapR::redcap_read_oneshot(
    redcap_uri                 = redcap_uri,
    token                      = token,
    records                    = records,
    fields                     = metadata$record_id_name,
    # forms                    = forms,
    events                     = events,
    filter_logic               = filter_logic,
    datetime_range_begin       = datetime_range_begin,
    datetime_range_end         = datetime_range_end,
    blank_for_gray_form_status = blank_for_gray_form_status,
    guess_type                 = guess_type,
    http_response_encoding     = http_response_encoding,
    locale                     = locale,
    verbose                    = verbose,
    config_options             = config_options,
    handle_httr                = handle_httr
  )

  # Stop and return to the caller if the initial query failed or is empty. --------------
  if (!initial_call$success) { # Call failed
    # nocov start
    outcome_messages  <- paste0("The initial call failed with the code: ", initial_call$status_code, ".")
    elapsed_seconds   <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))

    return(ship_records(
      .data                  = tibble::tibble(),
      .records_collapsed     = "failed in initial batch call",
      .fields_collapsed      = "failed in initial batch call",
      .forms_collapsed       = "failed in initial batch call",
      .events_collapsed      = "failed in initial batch call",
      .filter_logic          = "failed in initial batch call",
      .datetime_range_begin  = "failed in initial batch call",
      .datetime_range_end    = "failed in initial batch call",
      .elapsed_seconds       = elapsed_seconds,
      .status_codes          = initial_call$status_code,
      .outcome_messages      = outcome_messages,
      .success               = initial_call$success
    ))
    # nocov end
  } else if (0L == nrow(initial_call$data)) { # zero rows
    outcome_messages  <- "The initial call completed, but zero rows match the criteria."
    elapsed_seconds   <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))

    return(ship_records(
      .data                    = tibble::tibble(), # 0x0 tibble
      .success                 = initial_call$success,
      .status_codes            = as.character(initial_call$status_code),
      .outcome_messages        = outcome_messages,
      .records_collapsed       = collapse_vector(records),
      .fields_collapsed        = "No records were returned so the fields weren't determined.",
      .forms_collapsed         = "No records were returned so the forms weren't determined.",
      .events_collapsed        = "No records were returned so the events weren't determined.",
      .filter_logic            = filter_logic,
      .datetime_range_begin    = datetime_range_begin,
      .datetime_range_end      = datetime_range_end,
      .elapsed_seconds         = elapsed_seconds
    ))
  }

  # Continue as intended if the initial query succeeded. --------------------
  unique_ids <-
    if (0L == nrow(initial_call$data)) {
      character(0)
    } else {
      sort(unique(initial_call$data[[id_position]]))
    }

  if (0L < length(unique_ids) && all(nchar(unique_ids)==32L))
    warn_hash_record_id()  # nocov

  ds_glossary            <- REDCapR::create_batch_glossary(row_count=length(unique_ids), batch_size=batch_size)
  lst_batch              <- NULL
  lst_status_code        <- NULL
  # lst_status_message placeholder
  lst_outcome_message    <- NULL
  success_combined       <- TRUE

  if (verbose) {
    message(
      "Starting to read ",
      format(length(unique_ids), big.mark=",", scientific=FALSE, trim=TRUE),
      " records  at ", Sys.time(), "."
    )
  }

  # Loop through batches  ------------------------------------------------
  for (i in ds_glossary$id) {
    selected_index  <- seq(from=ds_glossary$start_index[i], to=ds_glossary$stop_index[i])
    selected_ids    <- unique_ids[selected_index]

    if (0L < i) Sys.sleep(time = interbatch_delay)
    if (verbose) {
      message(
        "Reading batch ", i, " of ", nrow(ds_glossary), ", with subjects ",
        min(selected_ids), " through ", max(selected_ids),
        " (ie, ", length(selected_ids), " unique subject records)."
      )
    }

    read_result <- REDCapR::redcap_read_oneshot(
      redcap_uri                  = redcap_uri,
      token                       = token,
      records                     = selected_ids,
      fields                      = fields,
      events                      = events,
      forms                       = forms,
      raw_or_label                = raw_or_label,
      raw_or_label_headers        = raw_or_label_headers,
      export_checkbox_label       = export_checkbox_label,
      # placeholder: return_format
      export_survey_fields        = export_survey_fields,
      export_data_access_groups   = export_data_access_groups,
      filter_logic                = filter_logic,
      datetime_range_begin        = datetime_range_begin,
      datetime_range_end          = datetime_range_end,
      blank_for_gray_form_status  = blank_for_gray_form_status,

      na                          = na,
      col_types                   = col_types,
      guess_type                  = FALSE,
      # guess_max                 # Not used, because guess_type is FALSE
      http_response_encoding      = http_response_encoding,
      locale                      = locale,
      verbose                     = verbose,
      config_options              = config_options,
      handle_httr                 = handle_httr
    )

    lst_status_code[[i]]      <- read_result$status_code
    lst_outcome_message[[i]]  <- read_result$outcome_message

    if (!read_result$success) {
      # nocov start
      error_message <- sprintf(
        "The `redcap_read()` call failed on iteration %i.",
        i
      )
      error_message <- paste(
        error_message,
        ifelse(
          !verbose,
          "Set the `verbose` parameter to TRUE and rerun for additional information.",
          ""
        )
      )

      if (continue_on_error) warning(error_message)
      else stop(error_message)
      # nocov end
    }

    lst_batch[[i]]   <- read_result$data
    success_combined <- success_combined & read_result$success
  } # end of for loop

  # Stack batches ------------------------------------------------
  ds_stacked  <- dplyr::bind_rows(lst_batch)

  # Guess data types if requested --------------------------------
  if (is.null(col_types) && guess_type) {
    ds_stacked <-
      ds_stacked %>%
      readr::type_convert(
        locale = locale,
        col_types = readr::cols(.default = readr::col_guess())
      )
  }

  # Identify if rows are missing --------------------------------
  unique_ids_actual <- sort(unique(ds_stacked[[id_position]]))
  ids_missing_rows  <- setdiff(unique_ids, unique_ids_actual)

  if (0L < length(ids_missing_rows)) {
    # nocov start
    message_template <-
      paste0(
        "There are %i subject(s) that are missing rows in the returned dataset. ",
        "REDCap's PHP code is likely trying to process too much text in one bite.\n\n",
        "Common solutions this problem are:\n",
        "  - specifying only the records you need (w/ `records`)\n",
        "  - specifying only the fields you need (w/ `fields`)\n",
        "  - specifying only the forms you need (w/ `forms`)\n",
        "  - specifying a subset w/ `filter_logic`\n",
        "  - reduce `batch_size`\n\n",
        "The missing ids are:\n",
        "%s."
      )
    stop(sprintf(
      message_template,
      length(ids_missing_rows),
      paste(ids_missing_rows, collapse = ",")
    ))
    # nocov end
  }

  # Return values
  elapsed_seconds          <- as.numeric(difftime( Sys.time(), start_time, units="secs"))
  status_code_combined     <- paste(lst_status_code    , collapse="; ")
  outcome_message_combined <- paste(lst_outcome_message, collapse="; ")

  ship_records(
    .data                    = ds_stacked,
    .success                 = success_combined,
    .status_codes            = status_code_combined,
    .outcome_messages        = outcome_message_combined,
    .records_collapsed       = collapse_vector(records),
    .fields_collapsed        = read_result$fields_collapsed,     # From the last call
    .forms_collapsed         = read_result$forms_collapsed,      # From the last call
    .events_collapsed        = read_result$events_collapsed,     # From the last call
    .filter_logic            = filter_logic,
    .datetime_range_begin    = datetime_range_begin,
    .datetime_range_end      = datetime_range_end,
    .elapsed_seconds         = elapsed_seconds
  )
}

ship_records <- function(
  .data,
  .success,
  .status_codes,
  .outcome_messages,
  .records_collapsed,
  .fields_collapsed,
  .forms_collapsed,
  .events_collapsed,
  .filter_logic,
  .datetime_range_begin,
  .datetime_range_end,
  .elapsed_seconds
) {
  list(
    data                    = .data,
    success                 = .success,
    status_codes            = .status_codes,
    outcome_messages        = .outcome_messages,
    records_collapsed       = .records_collapsed,
    fields_collapsed        = .fields_collapsed,
    forms_collapsed         = .forms_collapsed,
    events_collapsed        = .events_collapsed,
    filter_logic            = .filter_logic,
    datetime_range_begin    = .datetime_range_begin,
    datetime_range_end      = .datetime_range_end,
    elapsed_seconds         = .elapsed_seconds
  )
}

warn_hash_record_id <- function( )  {
  warning(
    "It appears that the REDCap record IDs have been hashed.\n",
    "For `REDCapR::redcap_read()` to function properly, the user
    must have Export permissions for the 'Full Data Set'.\n",
    "To grant the appropriate permissions:\n",
    "(1) go to 'User Rights' in the REDCap project site,\n",
    "(2) select the desired user, and then select 'Edit User Privileges',\n",
    "(3) in the 'Data Exports' radio buttons, select 'Full Data Set'.\n",
    "Users with only `De-Identified` export privileges can still use\n",
    "`redcap_read_oneshot()` and `redcap_write_oneshot()`."
  )
}
