#' @title Download a file from a REDCap project record
#'
#' @description This function uses REDCap's API to download a file.
#'
#' @param file_name The name of the file where the downloaded file is saved.
#'   If empty the original name of the file will be used and saved in the default directory.  Optional.
#' @param directory The directory where the file is saved. By default current directory. Optional
#' @param overwrite Boolean value indicating if existing files should be overwritten. Optional
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param record The record ID where the file is to be imported. Required
#' @param field The name of the field where the file is saved in REDCap. Required
#' @param event The name of the event where the file is saved in REDCap. Optional
#' @param verbose A boolean value indicating if `message`s should be printed to the R console during the operation.  Optional.
#' @param config_options  A list of options to pass to [httr::POST()] method in the 'httr' package.  See the details below. Optional.
#'
#' @return Currently, a list is returned with the following elements,
#' * `success`: A boolean value indicating if the operation was apparently successful.
#' * `status_code`: The [http status code](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of the operation.
#' * `outcome_message`: A human readable string indicating the operation's outcome.
#' * `records_affected_count`: The number of records inserted or updated.
#' * `affected_ids`: The subject IDs of the inserted or updated records.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by REDCap.  If an operation is successful, the `raw_text` is returned as an empty string to save RAM.
#' * `file_name`: The name of the file persisted to disk. This is useful if the name stored in REDCap is used (which is the default).
#'
#' @details
#' Currently, the function doesn't modify any variable types to conform to REDCap's supported variables.  See [validate_for_write()] for a helper function that checks for some common important conflicts.
#'
#' @author Will Beasley, John J. Aponte
#'
#' @references The official documentation can be found on the 'API Help Page' and 'API Examples' pages
#' on the REDCap wiki (*i.e.*, https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html). If you do not have an account
#' for the wiki, please ask your campus REDCap administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' uri     <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token   <- "D70F9ACD1EDD6F151C6EA78683944E98" #pid=213
#' record  <- 1
#' field   <- "mugshot"
#' # event <- "" # only for longitudinal events
#'
#' result_1 <- REDCapR::redcap_download_file_oneshot(
#'   record        = record,
#'   field         = field,
#'   redcap_uri    = uri,
#'   token         = token
#' )
#' base::unlink("mugshot-1.jpg")
#'
#' (full_name <- base::tempfile(pattern="mugshot", fileext=".jpg"))
#' result_2   <- REDCapR::redcap_download_file_oneshot(
#'   file_name     = full_name,
#'   record        = record,
#'   field         = field,
#'   redcap_uri    = uri,
#'   token         = token
#' )
#' base::unlink(full_name)
#'
#' (relative_name <- "ssss.jpg")
#' result_3 <- REDCapR::redcap_download_file_oneshot(
#'   file_name    = relative_name,
#'   record       = record,
#'   field        = field,
#'   redcap_uri   = uri,
#'   token        = token
#' )
#' base::unlink(relative_name)
#' }

#' @export
redcap_download_file_oneshot <- function(
  file_name       = NULL,
  directory       = NULL,
  overwrite       = FALSE,
  redcap_uri,
  token,
  record,
  field,
  event           = "",
  verbose         = TRUE,
  config_options  = NULL
) {

  checkmate::assert_character(redcap_uri                , any.missing=F, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token                     , any.missing=F, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token         = token,
    content       = 'file',
    action        = 'export',
    record        = record,
    field         = field,
    # event         = event,
    returnFormat  = 'csv'
  )

  if( nchar(event ) > 0 ) post_body$event   <- event

  # This is the first of two important lines in the function.
  #   It retrieves the information from the server and stores it in RAM.
  kernel <- kernel_api(redcap_uri, post_body, config_options)

  if( kernel$success ) {
    result_header <- kernel$result_headers$`content-type`

    if( missing(file_name) | is.null(file_name) ) {
      #process the content-type to get the file name
      regex_matches <- regmatches(kernel$result_headers, regexpr("name=.*", kernel$result_headers))
      file_name     <- gsub(pattern='(name=.)|(")', replacement="", x=regex_matches)
    }

    file_path <- if( missing(directory) & is.null(directory) ) {
      file_name #Use relative path.
    } else {
      file.path(directory, file_name) #Qualify the file with its full path.
    }

    if( verbose )
      message("Preparing to download the file `", file_path, "`.")

    if( !overwrite & file.exists(file_path) )
      stop("The operation was halted because the file `", file_path, "` already exists and `overwrite` is FALSE.  Please check the directory if you believe this is a mistake.")

    #This is the second of two important lines in the function.
    #  It persists/converts the information in RAM to a file.
    writeBin(httr::content(kernel$result, as="raw"), con=file_path)

    outcome_message <- paste0(
      result_header, " successfully downloaded in " ,
      round(kernel$elapsed_seconds, 1), " seconds, and saved as ", file_path, "."
    )
    records_affected_count  <- length(record)
    record_id               <- as.character(record)
    kernel$raw_text         <- ""  # If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
  } else { #If the operation was unsuccessful, then...
    outcome_message         <- "file NOT downloaded."
    records_affected_count  <- 0L
    record_id               <- character(0) # Return an empty vector.
    raw_text                <- kernel$raw_text
    file_path               <- character(0)
  }

  if( verbose )
    message(outcome_message)

  return( list(
    success                  = kernel$success,
    status_code              = kernel$status_code,
    outcome_message          = outcome_message,
    records_affected_count   = records_affected_count,
    affected_ids             = record_id,
    elapsed_seconds          = kernel$elapsed_seconds,
    raw_text                 = kernel$raw_text,
    file_name                = file_name,
    file_path                = file_path
  ))
}
