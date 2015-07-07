#' @name redcap_read_oneshot
#' @export redcap_read_oneshot
#' 
#' @title Read/Export records from a REDCap project.
#'  
#' @description This function uses REDCap's \href{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}{API}
#' to select and return data.
#' 
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param records An array, where each element corresponds to the ID of a desired record.  Optional.
#' @param records_collapsed A single string, where the desired ID values are separated by commas.  Optional.
#' @param fields An array, where each element corresponds a desired project field.  Optional.
#' @param fields_collapsed A single string, where the desired field names are separated by commas.  Optional.
#' @param events An array, where each element corresponds a desired project event  Optional.
#' @param events_collapsed A single string, where the desired event names are separated by commas.  Optional.
#' @param export_data_access_groups A boolean value that specifies whether or not to export the ``redcap_data_access_group'' field when data access groups are utilized in the project. Default is \code{FALSE}. See the details below.
#' @param raw_or_label A string (either \code{'raw'} or \code{'label'} that specifies whether to export the raw coded values or the labels for the options of multiple choice fields.  Default is \code{'raw'}.
#' @param verbose A boolean value indicating if \code{message}s should be printed to the R console during the operation.  The verbose output might contain sensitive information (\emph{e.g.} PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to \code{POST} method in the \code{httr} package.  See the details below. Optional.
#' @return Currently, a list is returned with the following elements,
#' \enumerate{
#'  \item \code{data}: An R \code{data.frame} of the desired records and columns.
#'  \item \code{success}: A boolean value indicating if the operation was apparently successful.
#'  \item \code{status_code}: The \href{http://en.wikipedia.org/wiki/List_of_HTTP_status_codes}{http status code} of the operation.
#'  \item \code{outcome_message}: A human readable string indicating the operation's outcome.
#'  \item \code{records_collapsed}: The desired records IDs, collapsed into a single string, separated by commas.
#'  \item \code{fields_collapsed}: The desired field names, collapsed into a single string, separated by commas.
#'  \item \code{elapsed_seconds}: The duration of the function.
#'  \item \code{raw_text}: If an operation is NOT successful, the text returned by REDCap.  If an operation is successful, the `raw_text` is returned as an empty string to save RAM.
#' }
#' @details 
#' I like how \href{http://sburns.org/PyCap/}{PyCap} creates a `project' object with methods that read and write from REDCap.  However this isn't a style that R clients typically use.
#' I like the logic that it's associated with a particular REDCap project that shouldn't change between calls.
#' As a compromise, I think I'll wrap the uri, token, and cert location into a single \code{S4} object that's passed to these methods.  It will make these calls take less space.  
#' 
#' The full list of configuration options accepted by the \code{httr} package is viewable by executing \code{httr::httr_options()}.  The \code{httr}
#' package and documentation is available at \url{http://cran.r-project.org/package=httr}.
#' 
#' The `REDCapR' package includes a recent version of the \href{http://curl.haxx.se/ca/cacert.pem}{Bundle of CA Root Certificates} 
#' from the official \href{http://curl.haxx.se}{cURL site}.  This version is used by default, unless the `config_options` argument is
#' given a value; in this case, the user is responsible for passing the location of the cert file if SSL verification is desired.
#' See the examples below for one example of using a different SSL cert, and one example of avoiding SSL entirely.  Avoiding SSL
#' is suggested only for debugging purposes, and not for production code.
#'  
#' If you do not pass in this export_data_access_groups value, it will default to \code{FALSE}. The following is from the API help page for version 5.2.3: This flag is only viable if the user whose token is being used to make the API request is *not* in a data access group. If the user is in a group, then this flag will revert to its default value.
#' @author Will Beasley
#' @references The official documentation can be found on the `API Examples' page on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}). A user account is required.
#' 
#' The official \href{http://curl.haxx.se}{cURL site} discusses the process of using SSL to verify the server being connected to.
#' 
#' @examples
#' \dontrun{
#' library(REDCapR) #Load the package into the current R session.
#' uri <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token <- "9A81268476645C4E5F03428B8AC3AA7B"
#' #Return all records and all variables.
#' ds_all_rows_all_fields <- redcap_read_oneshot(redcap_uri=uri, token=token)$data
#' 
#' #Return only records with IDs of 1 and 3
#' desired_records_v1 <- c(1, 3)
#' ds_some_rows_v1 <- redcap_read_oneshot(
#'    redcap_uri = uri, 
#'    token = token, 
#'    records = desired_records_v1
#' )$data
#' 
#' #Return only the fields record_id, name_first, and age
#' desired_fields_v1 <- c("record_id", "name_first", "age")
#' ds_some_fields_v1 <- redcap_read_oneshot(
#'    redcap_uri = uri, 
#'    token = token, 
#'    fields = desired_fields_v1
#' )$data
#' 
#' 
#' #Use the SSL cert file that come with the httr package.
#' cert_location <- system.file("cacert.pem", package="httr")
#' config_options <- list(cainfo=cert_location)
#' ds_different_cert_file <- redcap_read_oneshot(
#'    redcap_uri = uri,
#'    token = token, 
#'    config_options = config_options
#' )$data
#' 
#' #Force the connection to use SSL=3 (which is not preferred, and possibly insecure).
#' config_options <- list(sslversion=3)
#' ds_ssl_3 <- redcap_read_oneshot(
#'   redcap_uri = uri,
#'   token = token, 
#'   config_options = config_options
#' )$data
#' 
#' config_options <- list(ssl.verifypeer=FALSE)
#' ds_no_ssl <- redcap_read_oneshot(
#'    redcap_uri = uri,
#'    token = token, 
#'    config_options = config_options
#' )$data
#' }

redcap_read_oneshot <- function( redcap_uri, token, records=NULL, records_collapsed="", 
                         fields=NULL, fields_collapsed="", 
                         events=NULL, events_collapsed="",
                         export_data_access_groups=FALSE,
                         raw_or_label='raw', verbose=TRUE, config_options=NULL ) {
  #TODO: NULL verbose parameter pulls from getOption("verbose")
  #TODO: warns if any requested fields aren't entirely lowercase.
  #TODO: validate export_data_access_groups
  #TODO: validate raw_or_label
  
  start_time <- Sys.time()
  
  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_read_oneshot()`.")
  
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_read_oneshot()`.")
  
  # browser() #| missing(fields_collapsed)
  
  if( all(nchar(records_collapsed)==0) )
    records_collapsed <- ifelse(is.null(records), "", paste0(records, collapse=",")) #This is an empty string if `records` is NULL.
  if( (length(fields_collapsed)==0L) | is.null(fields_collapsed) | all(nchar(fields_collapsed)==0L) )
    fields_collapsed <- ifelse(is.null(fields), "", paste0(fields, collapse=",")) #This is an empty string if `fields` is NULL.
  if( all(nchar(events_collapsed)==0) )
    events_collapsed <- ifelse(is.null(events), "", paste0(events, collapse=",")) #This is an empty string if `events` is NULL.
  
  export_data_access_groups_string <- ifelse(export_data_access_groups, "true", "false")
  
  # if( missing( config_options ) | is.null(config_options) ) {
  #   cert_location <- system.file("ssl_certs/mozilla_ca_root.crt", package="REDCapR")
  #   
  #   if( !base::file.exists(cert_location) )
  #     stop(paste0("The file specified by `cert_location`, (", cert_location, ") could not be found."))
  #   
  #   config_options <- list(cainfo=cert_location)
  # }
      
  post_body <- list(
    token = token,
    content = 'record',
    format = 'csv',
    type = 'flat',
    rawOrLabel = raw_or_label,
    exportDataAccessGroups = export_data_access_groups_string,
    records = records_collapsed,
    fields = fields_collapsed,
    events = events_collapsed
  )
  
  result <- httr::POST(
    url = redcap_uri,
    body = post_body,
    config = config_options
  )

  status_code <- result$status
#   status_message <- result$headers$statusmessage
  success <- (status_code==200L)
  
  raw_text <- httr::content(result, "text")  
  elapsed_seconds <- as.numeric(difftime(Sys.time(), start_time, units="secs"))
  
  # raw_text <- "The hostname (redcap-db.hsc.net.ou.edu) / username (redcapsql) / password (XXXXXX) combination could not connect to the MySQL server. \r\n\t\tPlease check their values."
  regex_cannot_connect <- "^The hostname \\((.+)\\) / username \\((.+)\\) / password \\((.+)\\) combination could not connect.+"
  
  if( any(grepl(regex_cannot_connect, raw_text)) ) 
    success <- FALSE
  
  if( success ) {
    try (
      {
        ds <- utils::read.csv(text=raw_text, stringsAsFactors=FALSE)
      }, #Convert the raw text to a dataset.
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )
    
    #TODO #80: catch variant of ' The.hostname..redcap.db.hsc.net.ou.edu....username..redcapsql....password..XXXXXX..combination.could.not.connect.to.the.MySQL.server. \t\tPlease check their values.'
    
    if( exists("ds") & (class(ds)=="data.frame") ) {
      outcome_message <- paste0(format(nrow(ds), big.mark=",", scientific=FALSE, trim=TRUE), 
                         " records and ",  
                         format(length(ds), big.mark=",", scientific=FALSE, trim=TRUE), 
                         " columns were read from REDCap in ", 
                         round(elapsed_seconds, 1), " seconds.  The http status code was ",
                         status_code, ".")
    
      #If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
      raw_text <- "" 
    } else {
      success <- FALSE #Override the 'success' determination from the http status code.
      ds <- data.frame() #Return an empty data.frame
      outcome_message <- paste0("The REDCap read failed.  The http status code was ", status_code, ".  The 'raw_text' returned was '", raw_text, "'.")
    }
  }
  else {
    ds <- data.frame() #Return an empty data.frame
    #outcome_message <- paste0("Reading the REDCap data was not successful.  The error message was:\n",  geterrmessage())
    outcome_message <- paste0("The REDCapR read/export operation was not successful.  The error message was:\n",  raw_text)
  }
    
  if( verbose ) 
    message(outcome_message)
  
  return( list(
    data = ds, 
    success = success,
    status_code = status_code,
    # status_message = status_message, 
    outcome_message = outcome_message,
    records_collapsed = records_collapsed, 
    fields_collapsed = fields_collapsed,
    events_collapsed = events_collapsed,
    elapsed_seconds = elapsed_seconds,
    raw_text = raw_text
  ) )
}
