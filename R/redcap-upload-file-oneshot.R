#' @name redcap_upload_file_oneshot
#' @export redcap_upload_file_oneshot
#' @title Upload a file into to a REDCap project record.
#'
#' @description This function uses REDCap's API to upload a file
#'
#' @param file_name The name of the relative or full file to be uploaded into the REDCap project.  Required.
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param record The record ID where the file is to be imported. Required
#' @param field The name of the field where the file is saved in REDCap. Required
#' @param event The name of the event where the file is saved in REDCap. Optional
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  Optional.
#' @param config_options  A list of options to pass to `POST` method in the `httr` package.  See the details below. Optional.
#'
#' @return Currently, a list is returned with the following elements,
#' * `success`: A boolean value indicating if the operation was apparently successful.
#' * `status_code`: The [http status code](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the operation.
#' * `outcome_message`: A human readable string indicating the operation's outcome.
#' * `records_affected_count`: The number of records inserted or updated.
#' * `affected_ids`: The subject IDs of the inserted or updated records.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by REDCap.  If an operation is successful, the `raw_text` is returned as an empty string to save RAM.
#'
#' @details
#' Currently, the function doesn't modify any variable types to conform to REDCap's supported variables.  See [validate_for_write()] for a helper function that checks for some common important conflicts.
#' @author Will Beasley
#' @author John J. Aponte
#' @references The official documentation can be found on the 'API Help Page' and 'API Examples' pages
#' on the REDCap wiki (ie, https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html). If you do not have an account
#' for the wiki, please ask your campus REDCap administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' #Define some constants
#' uri       <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token     <- "D70F9ACD1EDD6F151C6EA78683944E98" #For the simple project (pid 213)
#' field     <- "mugshot"
#' event     <- "" # only for longitudinal events
#'
#' #Upload a single image file.
#' record    <- 1
#' file_path <- base::file.path(devtools::inst(name="REDCapR"), paste0("test-data/mugshot-1.jpg"))
#'
#' redcap_upload_file_oneshot(
#'   file_name=file_path, record=record, field=field,
#'   redcap_uri=redcap_uri, token=token
#' )
#'
#' #Upload a collection of five images.
#' records   <- 1:5
#' file_paths <- base::file.path(
#'   devtools::inst(name="REDCapR"),
#'   paste0("test-data/mugshot-", records, ".jpg")
#' )
#'
#' for( i in seq_along(records) ) {
#'   record    <- records[i]
#'   file_path <- file_paths[i]
#'   redcap_upload_file_oneshot(
#'     file_name=file_path, record=record, field=field,
#'     redcap_uri=redcap_uri, token=token
#'   )
#' }
#' }

redcap_upload_file_oneshot <- function( file_name, record, redcap_uri, token, field, event="", verbose=TRUE, config_options=NULL ) {
  start_time <- Sys.time()

  if( missing(file_name) | is.null(file_name) )
    stop("The required parameter `file_name` was missing from the call to `redcap_upload_file_oneshot()`.")

  if( !base::file.exists(file_name) )
    stop("The file `", file_name, "` was not found at the specified path.")

  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_upload_file_oneshot()`.")

  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_upload_file_oneshot()`.")

  token <- sanitize_token(token)

  if( verbose )
    message("Preparing to upload the file `", file_name, "`.")

  post_body <- list(
    token          = token,
    content        = 'file',
    action         = 'import',
    record         = record,
    field          = field,
    # event          = event,
    file           = httr::upload_file(path=file_name),
    returnFormat   = 'csv'
  )

  if( nchar(event ) > 0 ) post_body$event  <- event

  result <- httr::POST(
    url    = redcap_uri,
    body   = post_body,
    config = config_options
  )

  status_code       <- result$status_code
  elapsed_seconds   <- as.numeric(difftime(Sys.time(), start_time, units="secs"))
  success           <- (status_code == 200L)

  if( success ) {
    outcome_message <- paste0("file uploaded to REDCap in ",  round(elapsed_seconds, 1), " seconds.")
    recordsAffectedCount <- 1
    record_id <- record
    raw_text <- ""
  }
  else { #If the returned content wasn't recognized as valid IDs, then
    raw_text               <- httr::content(result, type="text")
    outcome_message        <- paste0("file NOT uploaded ")
    recordsAffectedCount   <- 0L
    record_id              <- numeric(0) #Return an empty vector.
  }
  if( verbose )
    message(outcome_message)

  return( list(
    success                  = success,
    status_code              = status_code,
    outcome_message          = outcome_message,
    records_affected_count   = recordsAffectedCount,
    affected_ids             = record_id,
    elapsed_seconds          = elapsed_seconds,
    raw_text                 = raw_text
  ))
}
