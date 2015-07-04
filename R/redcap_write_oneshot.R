#' @name redcap_write_oneshot
#' @export redcap_write_oneshot
#' 
#' @title Write/Import records to a REDCap project.
#'  
#' @description This function uses REDCap's \href{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}{API}
#' to select and return data.
#' 
#' @param ds The \code{data.frame} to be imported into the REDCap project.  Required.
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param verbose A boolean value indicating if \code{message}s should be printed to the R console during the operation.  The verbose output might contain sensitive information (\emph{e.g.} PHI), so turn this off if the output might be visible somewhere public. Optional.
#' @param config_options  A list of options to pass to \code{POST} method in the \code{httr} package.  See the details in \code{redcap_read_oneshot()} Optional.
#' 
#' @return Currently, a list is returned with the following elements,
#' \enumerate{
#'  \item \code{success}: A boolean value indicating if the operation was apparently successful.
#'  \item \code{status_code}: The \href{http://en.wikipedia.org/wiki/List_of_HTTP_status_codes}{http status code} of the operation.
#'  \item \code{outcome_message}: A human readable string indicating the operation's outcome.
#'  \item \code{records_affected_count}: The number of records inserted or updated.
#'  \item \code{affected_ids}: The subject IDs of the inserted or updated records.
#'  \item \code{elapsed_seconds}: The duration of the function.
#'  \item \code{raw_text}: If an operation is NOT successful, the text returned by REDCap.  If an operation is successful, the `raw_text` is returned as an empty string to save RAM.
#' }
#' @details 
#' The `REDCapR' package includes a recent version of the \href{http://curl.haxx.se/ca/cacert.pem}{Bundle of CA Root Certificates} 
#' from the official \href{http://curl.haxx.se}{cURL site}.  This version is used by default, unless the `cert_location` parameter is given another location.
#' 
#' Currently, the function doesn't modify any variable types to conform to REDCap's supported variables.  See \code{\link{validate_for_write}} for a helper function that checks for some common important conflicts.
#' @author Will Beasley
#' @references The official documentation can be found on the `API Examples' page on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}). A user account is required.
#' 
#' The official \href{http://curl.haxx.se}{cURL site} discusses the process of using SSL to verify the server being connected to.
#' 
#' @examples
#' \dontrun{ 
#' #Define some constants
#' uri  <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token <- "D70F9ACD1EDD6F151C6EA78683944E98"
#' 
#' # Read the dataset for the first time.
#' result_read1 <- redcap_read_oneshot(redcap_uri=uri, token=token)
#' ds1 <- result_read1$data
#' ds1$telephone
#' # The line above returns something like this (depending on its previous state).
#' # [1] "(432) 456-4848" "(234) 234-2343" "(433) 435-9865" "(987) 654-3210" "(333) 333-4444"
#' 
#' # Manipulate a field in the dataset in a VALID way
#' ds1$telephone <- sprintf("(405) 321-%1$i%1$i%1$i%1$i", seq_len(nrow(ds1)))
#' 
#' ds1 <- ds1[1:3, ]
#' ds1$age <- NULL; ds1$bmi <- NULL #Drop the calculated fields before writing.
#' result_write <- REDCapR::redcap_write_oneshot(ds=ds1, redcap_uri=uri, token=token)
#' 
#' # Read the dataset for the second time.
#' result_read2 <- redcap_read_oneshot(redcap_uri=uri, token=token)
#' ds2 <- result_read2$data
#' ds2$telephone
#' # The line above returns something like this.  Notice only the first three lines changed.
#' # [1] "(405) 321-1111" "(405) 321-2222" "(405) 321-3333" "(987) 654-3210" "(333) 333-4444"
#' 
#' # Manipulate a field in the dataset in an INVALID way.  A US exchange can't be '111'.
#' ds1$telephone <- sprintf("(405) 111-%1$i%1$i%1$i%1$i", seq_len(nrow(ds1)))
#' 
#' # This next line will throw an error.
#' result_write <- REDCapR::redcap_write_oneshot(ds=ds1, redcap_uri=uri, token=token)
#' result_write$raw_text
#' }
#' 

redcap_write_oneshot <- function( ds, redcap_uri, token, verbose=TRUE, config_options=NULL ) {
  #TODO: automatically convert boolean/logical class to integer/bit class
  start_time <- Sys.time()
  csvElements <- NULL #This prevents the R CHECK NOTE: 'No visible binding for global variable Note in R CMD check';  Also see  if( getRversion() >= "2.15.1" )    utils::globalVariables(names=c("csvElements")) #http://stackoverflow.com/questions/8096313/no-visible-binding-for-global-variable-note-in-r-cmd-check; http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
  
  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_write_oneshot()`.")
  
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_write_oneshot()`.")     
  
  # if( missing( config_options ) | is.null(config_options) ) {
  #   cert_location <- system.file("ssl_certs/mozilla_ca_root.crt", package="REDCapR")
  #   
  #   if( !base::file.exists(cert_location) )
  #     stop(paste0("The file specified by `cert_location`, (", cert_location, ") could not be found."))
  #   
  #   config_options <- list(cainfo=cert_location)
  # }
  
  con <-  base::textConnection(object='csvElements', open='w', local=TRUE)
  utils::write.csv(ds, con, row.names = FALSE, na="")  
  close(con)
  
  csv <- paste(csvElements, collapse="\n")
  rm(csvElements, con)
  
  post_body <- list(
    token = token,
    content = 'record',
    format = 'csv',
    type = 'flat',
    
    #These next values separate the import from the export API call
    data = csv,
    overwriteBehavior = 'overwrite', #overwriteBehavior: *normal* - blank/empty values will be ignored [default]; *overwrite* - blank/empty values are valid and will overwrite data
    returnContent = 'ids',
    returnFormat = 'csv'  
  )
  
  result <- httr::POST(
    url = redcap_uri,
    body = post_body,
    config = config_options
  )
  
  status_code <- result$status_code
  # status_message <- result$headers$statusmessage
  raw_text <- httr::content(result, type="text")
  elapsed_seconds <- as.numeric(difftime(Sys.time(), start_time, units="secs"))    
  
  #isValidIDList <- grepl(pattern="^id\\n.{1,}", x=raw_text, perl=TRUE) #example: x="id\n5835\n5836\n5837\n5838\n5839"
  success <- (status_code == 200L)
    
  if( success ) {
    elements <- unlist(strsplit(raw_text, split="\\n"))
    affectedIDs <- elements[-1]  
    recordsAffectedCount <- length(affectedIDs)
    outcome_message <- paste0(format(recordsAffectedCount, big.mark = ",", scientific = FALSE, trim = TRUE), 
                             " records were written to REDCap in ", 
                             round(elapsed_seconds, 1), 
                             " seconds.")
    
    #If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
    raw_text <- ""     
  } 
  else { #If the returned content wasn't recognized as valid IDs, then
    affectedIDs <- numeric(0) #Pass an empty array
    recordsAffectedCount <- NA_integer_
    # outcome_message <- "The REDCapR write operation was not successful.  Please see the `raw_text` element for more information." 
    outcome_message <- paste0("The REDCapR write/import operation was not successful.  The error message was:\n",  raw_text)
  }
  if( verbose ) 
    message(outcome_message)

  return( list(
    success = success,
    status_code = status_code,
    # status_message = status_message, 
    outcome_message = outcome_message,
    records_affected_count = recordsAffectedCount,
    affected_ids = affectedIDs,
    elapsed_seconds = elapsed_seconds,
    raw_text = raw_text    
  ))
}

# #Define some constants
# uri  <- "https://bbmc.ouhsc.edu/redcap/api/"
# token <- "D70F9ACD1EDD6F151C6EA78683944E98"
# 
# # Read the dataset for the first time.
# result_read1 <- redcap_read_oneshot(redcap_uri=uri, token=token)
# ds1 <- result_read1$data
# ds1$telephone
# # The line above returns something like this (depending on its previous state).
# # [1] "(432) 456-4848" "(234) 234-2343" "(433) 435-9865" "(987) 654-3210" "(333) 333-4444"
# 
# # Manipulate a field in the dataset in a VALID way
# ds1$telephone <- sprintf("(405) 321-%1$i%1$i%1$i%1$i", seq_len(nrow(ds1)))
# 
# ds1 <- ds1[1:3, ]
# ds1$age <- NULL; ds1$bmi <- NULL #Drop the calculated fields before writing.
# result_write <- REDCapR::redcap_write_oneshot(ds=ds1, redcap_uri=uri, token=token)
# 
# # Read the dataset for the second time.
# result_read2 <- redcap_read_oneshot(redcap_uri=uri, token=token)
# ds2 <- result_read2$data
# ds2$telephone
# # The line above returns something like this.  Notice only the first three lines changed.
# # [1] "(405) 321-1111" "(405) 321-2222" "(405) 321-3333" "(987) 654-3210" "(333) 333-4444"
# 
# # Manipulate a field in the dataset in an INVALID way.  A US exchange can't be '111'.
# ds1$telephone <- sprintf("(405) 111-%1$i%1$i%1$i%1$i", seq_len(nrow(ds1)))
# 
# # This next line will throw an error.
# result_write <- REDCapR::redcap_write_oneshot(ds=ds1, redcap_uri=uri, token=token)
# result_write$raw_text
