#' @name redcap_read_oneshot
#' @export redcap_read_oneshot
#' @title Read/Export records from a REDCap project.
#'
#' @description This function uses REDCap's API to select and return data.
#'
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
#' @param raw_or_label A string (either `'raw'` or `'label'` that specifies whether to export the raw coded values or the labels for the options of multiple choice fields.  Default is `'raw'`.
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  The verbose output might contain sensitive information (*e.g.* PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to `POST` method in the `httr` package.  See the details below. Optional.
#' @return Currently, a list is returned with the following elements,
#' * `data`: An R [base::data.frame()] of the desired records and columns.
#' * `success`: A boolean value indicating if the operation was apparently successful.
#' * `status_code`: The [http status code](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the operation.
#' * `outcome_message`: A human readable string indicating the operation's outcome.
#' * `records_collapsed`: The desired records IDs, collapsed into a single string, separated by commas.
#' * `fields_collapsed`: The desired field names, collapsed into a single string, separated by commas.
#' * `filter_logic`: The filter statement passed as an argument.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by REDCap.  If an operation is successful, the `raw_text` is returned as an empty string to save RAM.
#'
#' @details
#' The full list of configuration options accepted by the `httr` package is viewable by executing [httr::httr_options()].  The `httr`
#' package and documentation is available at https://cran.r-project.org/package=httr.
#'
#' If you do not pass in this export_data_access_groups value, it will default to `FALSE`. The following is from the API help page for version 5.2.3: This flag is only viable if the user whose token is being used to make the API request is *not* in a data access group. If the user is in a group, then this flag will revert to its default value.
#' @author Will Beasley
#' @references The official documentation can be found on the 'API Help Page' and 'API Examples' pages
#' on the REDCap wiki (ie, https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html). If you do not have an account
#' for the wiki, please ask your campus REDCap administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' library(REDCapR) #Load the package into the current R session.
#' uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token    <- "9A81268476645C4E5F03428B8AC3AA7B"
#' #Return all records and all variables.
#' ds_all_rows_all_fields <- redcap_read_oneshot(redcap_uri=uri, token=token)$data
#'
#' #Return only records with IDs of 1 and 3
#' desired_records_v1 <- c(1, 3)
#' ds_some_rows_v1 <- redcap_read_oneshot(
#'    redcap_uri = uri,
#'    token      = token,
#'    records    = desired_records_v1
#' )$data
#'
#' #Return only the fields record_id, name_first, and age
#' desired_fields_v1 <- c("record_id", "name_first", "age")
#' ds_some_fields_v1 <- redcap_read_oneshot(
#'    redcap_uri = uri,
#'    token      = token,
#'    fields     = desired_fields_v1
#' )$data
#' }

redcap_read_oneshot <- function(
  redcap_uri, token, records=NULL, records_collapsed="",
  fields=NULL, fields_collapsed="",
  events=NULL, events_collapsed="",
  export_data_access_groups=FALSE,
  filter_logic="",
  raw_or_label='raw', verbose=TRUE, config_options=NULL
) {
  #TODO: NULL verbose parameter pulls from getOption("verbose")

  start_time <- Sys.time()

  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_read_oneshot()`.")
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_read_oneshot()`.")
  if( !is.logical(export_data_access_groups) )
    stop("The optional parameter `export_data_access_groups` must be a logical/Boolean variable.")
  if( !is.character(filter_logic) )
    stop("The optional parameter `filter_logic` must be a character/string variable.")
  if( !(raw_or_label %in% c("raw", "label")) )
    stop("The optional parameter `raw_or_label` must be either 'raw' or 'label'.")

  token <- sanitize_token(token)
  validate_field_names(fields)

  if( all(nchar(records_collapsed)==0) )
    records_collapsed <- ifelse(is.null(records), "", paste0(records, collapse=",")) #This is an empty string if `records` is NULL.
  if( (length(fields_collapsed)==0L) | is.null(fields_collapsed) | all(nchar(fields_collapsed)==0L) )
    fields_collapsed <- ifelse(is.null(fields), "", paste0(fields, collapse=",")) #This is an empty string if `fields` is NULL.
  if( all(nchar(events_collapsed)==0) )
    events_collapsed <- ifelse(is.null(events), "", paste0(events, collapse=",")) #This is an empty string if `events` is NULL.
  if( all(nchar(filter_logic)==0) )
    filter_logic <- ifelse(is.null(filter_logic), "", filter_logic) #This is an empty string if `filter_logic` is NULL.

  if( any(grepl("[A-Z]", fields_collapsed)) )
    warning("The fields passed to REDCap appear to have at least uppercase letter.  REDCap variable names are snake case.")

  export_data_access_groups_string <- ifelse(export_data_access_groups, "true", "false")

  post_body <- list(
    token                   = token,
    content                 = 'record',
    format                  = 'csv',
    type                    = 'flat',
    rawOrLabel              = raw_or_label,
    exportDataAccessGroups  = export_data_access_groups_string,
    # records               = ifelse(nchar(records_collapsed)   > 0, records_collapsed  , NULL),
    # fields                = ifelse(nchar(fields_collapsed)    > 0, fields_collapsed   , NULL),
    # events                = ifelse(nchar(events_collapsed)    > 0, events_collapsed   , NULL),
    filterLogic             = filter_logic
  )

  if( nchar(records_collapsed) > 0 ) post_body$records  <- records_collapsed
  if( nchar(fields_collapsed ) > 0 ) post_body$fields   <- fields_collapsed
  if( nchar(events_collapsed ) > 0 ) post_body$events   <- events_collapsed

  result <- httr::POST(
    url     = redcap_uri,
    body    = post_body,
    config  = config_options
  )

  status_code <- result$status
  success <- (status_code==200L)

  raw_text <- httr::content(result, "text")
  elapsed_seconds <- as.numeric(difftime(Sys.time(), start_time, units="secs"))

  # raw_text <- "The hostname (redcap-db.hsc.net.ou.edu) / username (redcapsql) / password (XXXXXX) combination could not connect to the MySQL server. \r\n\t\tPlease check their values."
  regex_cannot_connect <- "^The hostname \\((.+)\\) / username \\((.+)\\) / password \\((.+)\\) combination could not connect.+"
  regex_empty <- "^\\s+$"

  if(
    any(grepl(regex_cannot_connect, raw_text)) |
    any(grepl(regex_empty, raw_text))
  ) {
    success <- FALSE
  }

  if( success ) {
    try (
      {
        ds <- utils::read.csv(text=raw_text, stringsAsFactors=FALSE)
        # ds <- readr::read_csv(file=raw_text)
      }, #Convert the raw text to a dataset.
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )

    if( exists("ds") & inherits(ds, "data.frame") ) {
      outcome_message <- paste0(
        format(nrow(ds), big.mark=",", scientific=FALSE, trim=TRUE),
        " records and ",
        format(length(ds), big.mark=",", scientific=FALSE, trim=TRUE),
        " columns were read from REDCap in ",
        round(elapsed_seconds, 1), " seconds.  The http status code was ",
        status_code, "."
      )

      # browser()
      # ds <- dplyr::mutate_if(
      #   ds,
      #   is.character,
      #   function(x) dplyr::coalesce(x, "") #Replace NAs with blanks
      # )
      #
      # ds <- dplyr::mutate_if(
      #   ds,
      #   is.character,
      #   function( x ) gsub("\r\n", "\n", x, perl=TRUE)
      # )
      # ds <- dplyr::mutate_if(
      #   ds,
      #   function( x) inherits(x, "Date"),
      #   as.character
      # )
      #
      # ds <- base::as.data.frame(ds)

      #If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
      raw_text <- ""
    } else {
      success          <- FALSE #Override the 'success' determination from the http status code.
      ds               <- data.frame() #Return an empty data.frame
      outcome_message  <- paste0("The REDCap read failed.  The http status code was ", status_code, ".  The 'raw_text' returned was '", raw_text, "'.")
    }
  }
  else {
    ds                 <- data.frame() #Return an empty data.frame
    if( any(grepl(regex_empty, raw_text)) ) {
      outcome_message    <- "The REDCapR read/export operation was not successful.  The returned dataset was empty."
    } else {
      outcome_message    <- paste0("The REDCapR read/export operation was not successful.  The error message was:\n",  raw_text)
    }
  }

  if( verbose )
    message(outcome_message)

  return( list(
    data               = ds,
    success            = success,
    status_code        = status_code,
    outcome_message    = outcome_message,
    records_collapsed  = records_collapsed,
    fields_collapsed   = fields_collapsed,
    filter_logic       = filter_logic,
    events_collapsed   = events_collapsed,
    elapsed_seconds    = elapsed_seconds,
    raw_text           = raw_text
  ) )
}
