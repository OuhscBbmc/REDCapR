#' @name redcap_read
#' @export redcap_read
#' @title Read records from a REDCap project in subsets, and stacks them together before returning a [base::data.frame()].
#'
#' @description From an external perspective, this function is similar to [redcap_read_oneshot()].  The internals
#' differ in that `redcap_read` retrieves subsets of the data, and then combines them before returning
#' (among other objects) a single [base::data.frame()].  This function can be more appropriate than
#' [redcap_read_oneshot()] when returning large datasets that could tie up the server.
#'
#' @param batch_size The maximum number of subject records a single batch should contain.  The default is 100.
#' @param interbatch_delay The number of seconds the function will wait before requesting a new subset from REDCap. The default is 0.5 seconds.
#' @param continue_on_error If an error occurs while reading, should records in subsequent batches be attempted.  The default is `FALSE`, which prevents subsequent batches from running.  Required.
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param records An array, where each element corresponds to the ID of a desired record.  Optional.
#' @param records_collapsed A single string, where the desired ID values are separated by commas.  Optional.
#' @param fields An array, where each element corresponds a desired project field.  Optional.
#' @param fields_collapsed A single string, where the desired field names are separated by commas.  Optional.
#' @param filter_logic String of logic text (e.g., `[gender] = 'male'`) for filtering the data to be returned by this API method, in which the API will only return the records (or record-events, if a longitudinal project) where the logic evaluates as TRUE.   An blank/empty string returns all records.
#' @param events An array, where each element corresponds a desired project event  Optional.
#' @param events_collapsed A single string, where the desired event names are separated by commas.  Optional.
#' @param export_data_access_groups A boolean value that specifies whether or not to export the `redcap_data_access_group` field when data access groups are utilized in the project. Default is `FALSE`. See the details below.
#' @param raw_or_label A string (either 'raw` or 'label' that specifies whether to export the raw coded values or the labels for the options of multiple choice fields.  Default is `'raw'`.
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  The verbose output might contain sensitive information (*e.g.* PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the `httr` package.  See the details in `redcap_read_oneshot()` Optional.
#' @param id_position  The column position of the variable that unique identifies the subject.  This defaults to the first variable in the dataset.
#'
#' @return Currently, a list is returned with the following elements,
#' * `data`: An R [base::data.frame()] of the desired records and columns.
#' * `success`: A boolean value indicating if the operation was apparently successful.
#' * `status_codes`: A collection of [http status codes](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes), separated by semicolons.  There is one code for each batch attempted.
#' * `outcome_messages`: A collection of human readable strings indicating the operations' semicolons.  There is one code for each batch attempted.  In an unsuccessful operation, it should contain diagnostic information.
#' * `records_collapsed`: The desired records IDs, collapsed into a single string, separated by commas.
#' * `fields_collapsed`: The desired field names, collapsed into a single string, separated by commas.
#' * `filter_logic`: The filter statement passed as an argument.
#' * `elapsed_seconds`: The duration of the function.
#' @details
#' Specifically, it internally uses multiple calls to [redcap_read_oneshot()] to select and return data.
#' Initially, only primary key is queried through the REDCap API.  The long list is then subsetted into partitions,
#' whose sizes are determined by the `batch_size` parameter.  REDCap is then queried for all variables of
#' the subset's subjects.  This is repeated for each subset, before returning a unified [base::data.frame()].
#'
#' The function allows a delay between calls, which allows the server to attend to other users' requests.
#'
#' For [redcap_read()] to function properly, the user must have Export permissions for the
#' 'Full Data Set'.  Users with only 'De-Identified' export privileges can still use
#' `redcap_read_oneshot`.  To grant the appropriate permissions:
#' * go to 'User Rights' in the REDCap project site,
#' * select the desired user, and then select 'Edit User Privileges',
#' * in the 'Data Exports' radio buttons, select 'Full Data Set'.
#'
#' @author Will Beasley
#' @references The official documentation can be found on the 'API Help Page' and 'API Examples' pages
#' on the REDCap wiki (ie, https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html). If you do not have an account
#' for the wiki, please ask your campus REDCap administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' library(REDCapR) #Load the package into the current R session.
#' uri     <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token   <- "9A81268476645C4E5F03428B8AC3AA7B"
#' redcap_read(batch_size=2, redcap_uri=uri, token=token)
#' }
#'

redcap_read <- function(
  batch_size=100L, interbatch_delay=0.5, continue_on_error=FALSE,
  redcap_uri, token, records=NULL, records_collapsed="",
  fields=NULL, fields_collapsed="",
  events=NULL, events_collapsed="",
  export_data_access_groups=FALSE,
  filter_logic="",
  raw_or_label='raw',
  verbose=TRUE, config_options=NULL, id_position=1L
) {

  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_read()`.")

  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_read()`.")

  token <- sanitize_token(token)
  validate_field_names(fields)

  if( all(nchar(records_collapsed)==0) )
    records_collapsed <- ifelse(is.null(records), "", paste0(records, collapse=",")) #This is an empty string if `records` is NULL.
  if( (length(fields_collapsed)==0L) | is.null(fields_collapsed) | all(nchar(fields_collapsed)==0) )
    fields_collapsed <- ifelse(is.null(fields), "", paste0(fields, collapse=",")) #This is an empty string if `fields` is NULL.
  if( all(nchar(events_collapsed)==0) )
    events_collapsed <- ifelse(is.null(events), "", paste0(events, collapse=",")) #This is an empty string if `events` is NULL.
  if( all(nchar(filter_logic)==0) )
    filter_logic <- ifelse(is.null(filter_logic), "", filter_logic) #This is an empty string if `filter_logic` is NULL.

  start_time <- Sys.time()

  metadata <- REDCapR::redcap_metadata_read(
    redcap_uri         = redcap_uri,
    token              = token,
    verbose            = verbose,
    config_options     = config_options
  )

  initial_call <- REDCapR::redcap_read_oneshot(
    redcap_uri         = redcap_uri,
    token              = token,
    records_collapsed  = records_collapsed,
    fields_collapsed   = metadata$data[1, "field_name"],
    filter_logic       = filter_logic,
    events_collapsed   = events_collapsed,
    verbose            = verbose,
    config_options     = config_options
  )

  # Stop and return to the caller if the initial query failed. --------------
  if( !initial_call$success ) {
    outcome_messages <- paste0("The initial call failed with the code: ", initial_call$status_code, ".")
    elapsed_seconds <- as.numeric(difftime(Sys.time(), start_time, units="secs"))
    return( list(
      data                  = data.frame(),
      records_collapsed     = "failed in initial batch call",
      fields_collapsed      = "failed in initial batch call",
      filter_logic          = "failed in initial batch call",
      events_collapsed      = "failed in initial batch call",
      elapsed_seconds       = elapsed_seconds,
      status_code           = initial_call$status_code,
      outcome_messages      = outcome_messages,
      success               = initial_call$success
    ) )
  }

  # Continue as intended if the initial query succeeded. --------------------
  uniqueIDs <- sort(unique(initial_call$data[, 1]))

  if( all(nchar(uniqueIDs)==32L) )
    warning(
      "It appears that the REDCap record IDs have been hashed. ",
      "For `redcap_read` to function properly, the user must have Export permissions for the 'Full Data Set'. ",
      "To grant the appropriate permissions: ",
      "(1) go to 'User Rights' in the REDCap project site, ",
      "(2) select the desired user, and then select 'Edit User Privileges', ",
      "(3) in the 'Data Exports' radio buttons, select 'Full Data Set'.\n",
      "Users with only `De-Identified` export privileges can still use ",
      "`redcap_read_oneshot()` and `redcap_write_oneshot()`."
    )

  ds_glossary            <- REDCapR::create_batch_glossary(row_count=length(uniqueIDs), batch_size=batch_size)
  lst_batch              <- NULL
  lst_status_code        <- NULL
  # lst_status_message   <- NULL
  lst_outcome_message    <- NULL
  success_combined       <- TRUE

  message("Starting to read ", format(length(uniqueIDs), big.mark=",", scientific=F, trim=T), " records  at ", Sys.time())
  for( i in ds_glossary$id ) {
    selected_index <- seq(from=ds_glossary[i, "start_index"], to=ds_glossary[i, "stop_index"])
    selected_ids <- uniqueIDs[selected_index]

    if( i > 0 ) Sys.sleep(time = interbatch_delay)
    if( verbose ) {
      message(
        "Reading batch ", i, " of ", nrow(ds_glossary), ", with subjects ", min(selected_ids), " through ", max(selected_ids),
        " (ie, ", length(selected_ids), " unique subject records)."
      )
    }
    read_result <- REDCapR::redcap_read_oneshot(
      redcap_uri                  = redcap_uri,
      token                       = token,
      records                     = selected_ids,
      fields_collapsed            = fields_collapsed,
      filter_logic                = filter_logic,
      events_collapsed            = events_collapsed,
      export_data_access_groups   = export_data_access_groups,
      raw_or_label                = raw_or_label,
      verbose                     = verbose,
      config_options              = config_options
    )

    lst_status_code[[i]] <- read_result$status_code
    # lst_status_message[[i]] <- read_result$status_message
    lst_outcome_message[[i]] <- read_result$outcome_message

    if( !read_result$success ) {
      error_message <- paste0("The `redcap_read()` call failed on iteration ", i, ".")
      error_message <- paste(error_message, ifelse(!verbose, "Set the `verbose` parameter to TRUE and rerun for additional information.", ""))

      if( continue_on_error ) warning(error_message)
      else stop(error_message)
    }

    lst_batch[[i]]   <- read_result$data
    success_combined <- success_combined | read_result$success

    rm(read_result) #Admittedly overkill defensiveness.
  }
  # browser()
  ds_stacked               <- as.data.frame(data.table::rbindlist(lst_batch))
  # ds_stacked               <- as.data.frame(dplyr::bind_rows(lst_batch))

  elapsed_seconds          <- as.numeric(difftime( Sys.time(), start_time, units="secs"))
  status_code_combined     <- paste(lst_status_code, collapse="; ")
  outcome_message_combined <- paste(lst_outcome_message, collapse="; ")

  return( list(
    data                = ds_stacked,
    success             = success_combined,
    status_codes        = status_code_combined,
    outcome_messages    = outcome_message_combined,
    records_collapsed   = records_collapsed,
    fields_collapsed    = fields_collapsed,
    filter_logic        = filter_logic,
    events_collapsed    = events_collapsed,
    elapsed_seconds     = elapsed_seconds
  ) )
}

# redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
# token <- "9A81268476645C4E5F03428B8AC3AA7B"
# redcap_read(batch_size=2, redcap_uri=redcap_uri, token=token)
