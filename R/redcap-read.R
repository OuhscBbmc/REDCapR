#' @title Read records from a REDCap project in subsets, and stacks them
#' together before returning a dataset
#'
#' @description From an external perspective, this function is similar to
#' [redcap_read_oneshot()].  The internals differ in that `redcap_read`
#' retrieves subsets of the data, and then combines them before returning
#' (among other objects) a single [base::data.frame()].  This function can
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
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap
#' project.  Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param records An array, where each element corresponds to the ID of a
#' desired record.  Optional.
#' @param records_collapsed A single string, where the desired ID values are
#' separated by commas.  Optional.
#' @param fields An array, where each element corresponds to a desired project
#' field.  Optional.
#' @param fields_collapsed A single string, where the desired field names are
#' separated by commas.  Optional.
#' @param forms An array, where each element corresponds to a desired project
#' form.  Optional.
#' @param forms_collapsed A single string, where the desired form names are
#' separated by commas.  Optional.
#' @param events An array, where each element corresponds to a desired project
#' event.  Optional.
#' @param events_collapsed A single string, where the desired event names are
#' separated by commas.  Optional.
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
#' timestamp fields (e.g., instrument+'_timestamp') .
#' @param export_data_access_groups A boolean value that specifies whether or
#' not to export the `redcap_data_access_group` field when data access groups
#' are utilized in the project. Default is `FALSE`. See the details below.
#' @param filter_logic String of logic text (e.g., `[gender] = 'male'`) for
#' filtering the data to be returned by this API method, in which the API
#' will only return the records (or record-events, if a longitudinal project)
#' where the logic evaluates as TRUE.   An blank/empty string returns all records.
#' @param col_types A [readr::cols()] object passed internally to
#' [readr::read_csv()].  Optional.
#' @param guess_type A boolean value indicating if all columns should be
#' returned as character.  If true, [readr::read_csv()] guesses the intended
#' data type for each column.
#' @param guess_max Deprecated.
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the
#' `httr` package.  See the details in `redcap_read_oneshot()` Optional.
#' @param id_position  The column position of the variable that unique
#' identifies the subject (typically `record_id`).
#' This defaults to the first variable in the dataset.
#'
#' @return Currently, a list is returned with the following elements:
#' * `data`: An R [base::data.frame()] of the desired records and columns.
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_codes`: A collection of
#' [http status codes](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
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
#' @details
#' Specifically, it internally uses multiple calls to [redcap_read_oneshot()]
#' to select and return data.  Initially, only the primary key is queried
#' through the REDCap API.  The long list is then subsetted into batches,
#' whose sizes are determined by the `batch_size` parameter.  REDCap is then
#' queried for all variables of the subset's subjects.  This is repeated for
#' each subset, before returning a unified [base::data.frame()].
#'
#' The function allows a delay between calls, which allows the server to
#' attend to other users' requests (such as the users entering data in a
#' browser).  In other words, a delay between batches does not bog down
#' the webserver when exporting/importing a large dataset.
#'
#' A second benefit is less RAM is required on the webserver.  Because
#' each batch is smaller than the entire dataset, the webserver
#' tackles more manageably sized objects in memory.  Consider batching
#' if you encounter the error
#'
#' ```
#' ERROR: REDCap ran out of server memory. The request cannot be processed.
#' Please try importing/exporting a smaller amount of data.
#' ```
#'
#' For [redcap_read()] to function properly, the user must have Export
#' permissions for the 'Full Data Set'.  Users with only 'De-Identified'
#' export privileges can still use `redcap_read_oneshot`.  To grant the
#' appropriate permissions:
#' * go to 'User Rights' in the REDCap project site,
#' * select the desired user, and then select 'Edit User Privileges',
#' * in the 'Data Exports' radio buttons, select 'Full Data Set'.
#'
#' @author Will Beasley
#' @references The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html
#' and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' uri     <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token   <- "9A81268476645C4E5F03428B8AC3AA7B"
#' REDCapR::redcap_read(batch_size=2, redcap_uri=uri, token=token)$data
#'
#' # Specify the column types.
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
#'
#' }

#' @export
redcap_read <- function(
  batch_size                    = 100L,
  interbatch_delay              = 0.5,
  continue_on_error             = FALSE,
  redcap_uri,
  token,
  records                       = NULL, records_collapsed = "",
  fields                        = NULL, fields_collapsed  = "",
  forms                         = NULL, forms_collapsed   = "",
  events                        = NULL, events_collapsed  = "",
  raw_or_label                  = "raw",
  raw_or_label_headers          = "raw",
  export_checkbox_label         = FALSE,
  # placeholder: returnFormat
  export_survey_fields          = FALSE,
  export_data_access_groups     = FALSE,
  filter_logic                  = "",

  col_types                     = NULL,
  guess_type                    = TRUE,
  guess_max                     = NULL, # Deprecated parameter
  verbose                       = TRUE,
  config_options                = NULL,
  id_position                   = 1L
) {

  checkmate::assert_character(redcap_uri                , any.missing=FALSE,     len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=FALSE,     len=1, pattern="^.{1,}$")
  checkmate::assert_atomic(  records                    , any.missing=TRUE, min.len=0)
  checkmate::assert_character(records_collapsed         , any.missing=TRUE ,     len=1, pattern="^.{0,}$", null.ok=TRUE)
  checkmate::assert_character(fields                    , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE)
  checkmate::assert_character(fields_collapsed          , any.missing=TRUE ,     len=1, pattern="^.{0,}$", null.ok=TRUE)
  checkmate::assert_character(forms                     , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE)
  checkmate::assert_character(forms_collapsed           , any.missing=TRUE ,     len=1, pattern="^.{0,}$", null.ok=TRUE)
  checkmate::assert_character(events                    , any.missing=TRUE , min.len=1, pattern="^.{1,}$", null.ok=TRUE)
  checkmate::assert_character(events_collapsed          , any.missing=TRUE ,     len=1, pattern="^.{0,}$", null.ok=TRUE)
  checkmate::assert_character(raw_or_label              , any.missing=FALSE,     len=1)
  checkmate::assert_subset(   raw_or_label              , c("raw", "label"))
  checkmate::assert_character(raw_or_label_headers      , any.missing=FALSE,     len=1)
  checkmate::assert_subset(   raw_or_label_headers      , c("raw", "label"))
  checkmate::assert_logical(  export_checkbox_label     , any.missing=FALSE,     len=1)
  # placeholder: returnFormat
  checkmate::assert_logical(  export_survey_fields      , any.missing=FALSE,     len=1)
  checkmate::assert_logical(  export_data_access_groups , any.missing=FALSE,     len=1)
  #
  checkmate::assert_logical(  guess_type                , any.missing=FALSE,     len=1)

  if (!is.null(guess_max)) warning("The `guess_max` parameter in `REDCapR::redcap_read()` is deprecated.")
  checkmate::assert_logical(  verbose                   , any.missing=FALSE,     len=1, null.ok=TRUE)
  checkmate::assert_list(     config_options            , any.missing=TRUE ,     len=1, null.ok=TRUE)
  checkmate::assert_integer(  id_position               , any.missing=FALSE,     len=1, lower=1L)

  validate_field_names(fields, stop_on_error = TRUE)

  token               <- sanitize_token(token)
  records_collapsed   <- collapse_vector(records  , records_collapsed)
  fields_collapsed    <- collapse_vector(fields   , fields_collapsed)
  forms_collapsed     <- collapse_vector(forms    , forms_collapsed)
  events_collapsed    <- collapse_vector(events   , events_collapsed)
  filter_logic        <- filter_logic_prepare(filter_logic)
  verbose             <- verbose_prepare(verbose)

  if (1L <= nchar(fields_collapsed) )
    validate_field_names_collapsed(fields_collapsed, stop_on_error = TRUE)

  start_time <- Sys.time()

  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri         = redcap_uri,
    token              = token,
    verbose            = verbose,
    config_options     = config_options
  )

  # if (!metadata$success) {
  #   error_message     <- sprintf(
  #     "The REDCapR record export operation was not successful.  The error message was:\n%s",
  #     metadata$raw_text
  #   )
  #   stop(error_message)
  # }

  initial_call <- REDCapR::redcap_read_oneshot(
    redcap_uri         = redcap_uri,
    token              = token,
    records_collapsed  = records_collapsed,
    fields_collapsed   = metadata$data$field_name[id_position],
    forms_collapsed    = forms_collapsed,
    events_collapsed   = events_collapsed,
    filter_logic       = filter_logic,
    guess_type         = guess_type,
    verbose            = verbose,
    config_options     = config_options
  )

  # Stop and return to the caller if the initial query failed. --------------
  if (!initial_call$success) {
    outcome_messages  <- paste0("The initial call failed with the code: ", initial_call$status_code, ".")
    elapsed_seconds   <- as.numeric(difftime(Sys.time(), start_time, units="secs"))
    return(list(
      data                  = data.frame(),
      records_collapsed     = "failed in initial batch call",
      fields_collapsed      = "failed in initial batch call",
      forms_collapsed       = "failed in initial batch call",
      events_collapsed      = "failed in initial batch call",
      filter_logic          = "failed in initial batch call",
      elapsed_seconds       = elapsed_seconds,
      status_code           = initial_call$status_code,
      outcome_messages      = outcome_messages,
      success               = initial_call$success
    ))
  }

  # Continue as intended if the initial query succeeded. --------------------
  unique_ids <- sort(unique(initial_call$data[[id_position]]))

  if (all(nchar(unique_ids)==32L))
    warn_hash_record_id()  # nocov

  ds_glossary            <- REDCapR::create_batch_glossary(row_count=length(unique_ids), batch_size=batch_size)
  lst_batch              <- NULL
  lst_status_code        <- NULL
  # lst_status_message placeholder
  lst_outcome_message    <- NULL
  success_combined       <- TRUE

  message("Starting to read ", format(length(unique_ids), big.mark=",", scientific=FALSE, trim=TRUE), " records  at ", Sys.time(), ".")
  for (i in ds_glossary$id) {
    selected_index  <- seq(from=ds_glossary$start_index[i], to=ds_glossary$stop_index[i])
    selected_ids    <- unique_ids[selected_index]

    if (i > 0) Sys.sleep(time = interbatch_delay)
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
      fields_collapsed            = fields_collapsed,
      events_collapsed            = events_collapsed,
      forms_collapsed             = forms_collapsed,
      raw_or_label                = raw_or_label,
      raw_or_label_headers        = raw_or_label_headers,
      export_checkbox_label       = export_checkbox_label,
      # placeholder: return_format
      export_survey_fields        = export_survey_fields,
      export_data_access_groups   = export_data_access_groups,
      filter_logic                = filter_logic,

      col_types                   = col_types,
      guess_type                  = FALSE,
      # guess_max                   = guess_max, # Not used, because guess_type is FALSE
      verbose                     = verbose,
      config_options              = config_options
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
    success_combined <- success_combined | read_result$success

    rm(read_result) #Admittedly overkill defensiveness.
  }

  ds_stacked               <- as.data.frame(dplyr::bind_rows(lst_batch))

  if (is.null(col_types) && guess_type) {
    ds_stacked <-
      ds_stacked %>%
      readr::type_convert()
  }

  elapsed_seconds          <- as.numeric(difftime( Sys.time(), start_time, units="secs"))
  status_code_combined     <- paste(lst_status_code    , collapse="; ")
  outcome_message_combined <- paste(lst_outcome_message, collapse="; ")

  list(
    data                = ds_stacked,
    success             = success_combined,
    status_codes        = status_code_combined,
    outcome_messages    = outcome_message_combined,
    # data_types          = data_types,
    records_collapsed   = records_collapsed,
    fields_collapsed    = fields_collapsed,
    forms_collapsed     = forms_collapsed,
    events_collapsed    = events_collapsed,
    filter_logic        = filter_logic,
    elapsed_seconds     = elapsed_seconds
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
