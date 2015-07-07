#' @name redcap_metadata_read
#' @export redcap_metadata_read
#' 
#' @title Export the metadata of a REDCap project.
#'  
#' @description Export the metadata (as a data dictionary) of a REDCap project as a \code{data.frame}.  
#' Each row in the data dictionary corresponds to one field in the project's dataset.
#' 
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param forms An array, where each element corresponds to the REDCap form of the desired fields.  Optional.
#' @param forms_collapsed A single string, where the desired forms are separated by commas.  Optional.
#' @param fields An array, where each element corresponds to a desired project field.  Optional.
#' @param fields_collapsed A single string, where the desired field names are separated by commas.  Optional.
#' @param verbose A boolean value indicating if \code{message}s should be printed to the R console during the operation.  The verbose output might contain sensitive information (\emph{e.g.} PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to \code{POST} method in the \code{httr} package.  See the details in \code{redcap_read_oneshot()} Optional.
#' 
#' @return Currently, a list is returned with the following elements,
#' \enumerate{
#'  \item \code{data}: An R \code{data.frame} of the desired records and columns.
#'  \item \code{success}: A boolean value indicating if the operation was apparently successful.
#'  \item \code{status_codes}: A collection of \href{http://en.wikipedia.org/wiki/List_of_HTTP_status_codes}{http status codes}, separated by semicolons.  There is one code for each batch attempted.
#'  \item \code{outcome_messages}: A collection of human readable strings indicating the operations' semicolons.  There is one code for each batch attempted.  In an unsuccessful operation, it should contain diagnostic information.
#'  \item \code{forms_collapsed}: The desired records IDs, collapsed into a single string, separated by commas.
#'  \item \code{fields_collapsed}: The desired field names, collapsed into a single string, separated by commas.
#'  \item \code{elapsed_seconds}: The duration of the function.
#' }
#' @details 
#' Specifically, it internally uses multiple calls to \code{\link{redcap_read_oneshot}} to select and return data.
#' Initially, only primary key is queried through the REDCap API.  The long list is then subsetted into partitions,
#' whose sizes are determined by the \code{batch_size} parameter.  REDCap is then queried for all variables of
#' the subset's subjects.  This is repeated for each subset, before returning a unified \code{data.frame}.
#' 
#' The function allows a delay between calls, which allows the server to attend to other users' requests.
#' @author Will Beasley
#' @references The official documentation can be found on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiDocumentation}).  
#' A user account is required to access the wiki, which typically is granted only to REDCap administrators.  
#' 
#' @examples
#' \dontrun{
#' library(REDCapR) #Load the package into the current R session.
#' uri <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token <- "9A81268476645C4E5F03428B8AC3AA7B"
#' redcap_metadata_read(redcap_uri=uri, token=token)
#' }

redcap_metadata_read <- function( 
                         redcap_uri, token, forms=NULL, forms_collapsed="", 
                         fields=NULL, fields_collapsed="", 
                         verbose=TRUE, config_options=NULL ) {  
  #TODO: NULL verbose parameter pulls from getOption("verbose")
  #TODO: warns if any requested fields aren't entirely lowercase.
  
  message("The `REDCapR::redcap_metadata_read()` function is very new and under development.\nIt's likely to change in the future, especially how it handles checkboxes.")
  
  start_time <- Sys.time()
  
  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_read_oneshot()`.")
  
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_read_oneshot()`.")
  
  if( nchar(forms_collapsed)==0 )
    forms_collapsed <- ifelse(is.null(forms), "", paste0(forms, collapse=",")) #This is an empty string if `forms` is NULL.
  if( nchar(fields_collapsed)==0 )
    fields_collapsed <- ifelse(is.null(fields), "", paste0(fields, collapse=",")) #This is an empty string if `fields` is NULL.
  
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
    content = 'metadata',
    format = 'csv',
    forms = forms_collapsed,
    fields = fields_collapsed
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
  
  if( success ) {
    try (
      ds <- utils::read.csv(text=raw_text, stringsAsFactors=FALSE), #Convert the raw text to a dataset.
      silent = TRUE #Don't print the warning in the try block.  Print it below, where it's under the control of the caller.
    )
    
    if( exists("ds") & (class(ds)=="data.frame") ) {
      outcome_message <- paste0(
        "The data dictionary describing ",
        format(nrow(ds), big.mark=",", scientific=FALSE, trim=TRUE), 
        " fields was read from REDCap in ", 
        round(elapsed_seconds, 1), " seconds.  The http status code was ",
        status_code, ".")
    
      #If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
      raw_text <- "" 
    } else {
      success <- FALSE #Override the 'success' determination from the http status code.
      ds <- data.frame() #Return an empty data.frame
      outcome_message <- paste0("The REDCap metadata export failed.  The http status code was ", status_code, ".  The 'raw_text' returned was '", raw_text, "'.")
    }
  }
  else {
    ds <- data.frame() #Return an empty data.frame
    outcome_message <- paste0("The REDCapR metadata export operation was not successful.  The error message was:\n",  raw_text)
  }
    
  if( verbose ) 
    message(outcome_message)
  
  return( list(
    data = ds, 
    success = success,
    status_code = status_code,
    # status_message = status_message, 
    outcome_message = outcome_message,
    forms_collapsed = forms_collapsed, 
    fields_collapsed = fields_collapsed,
    elapsed_seconds = elapsed_seconds,
    raw_text = raw_text
  ) )
}

# uri <- "https://bbmc.ouhsc.edu/redcap/api/"

# token <- "D70F9ACD1EDD6F151C6EA78683944E98" #The version that is repeatedly deleted and rewritten for mosts unit tests.
# token <- "9A81268476645C4E5F03428B8AC3AA7B" #The version that is relatively static (and isn't repeatedly deleted).
# 
# redcap_metadata_read(redcap_uri=uri, token=token)
# redcap_metadata_read(redcap_uri=uri, token=token, fields=c("record_id", "name_last"))
# redcap_metadata_read(redcap_uri=uri, token=token, fields_collapsed = "record_id, name_last")
# redcap_metadata_read(redcap_uri=uri, token=token, forms = c("health"))
# redcap_metadata_read(redcap_uri=uri, token=token, forms_collapsed = "health")
