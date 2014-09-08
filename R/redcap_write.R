#' @name redcap_write
#' @export redcap_write
#' 
#' @title Write/Import records to a REDCap project.
#'  
#' @description This function uses REDCap's \href{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}{API}
#' to select and return data.
#' 
#' @param ds_to_write The \code{data.frame} to be imported into the REDCap project.  Required.
#' @param batch_size The maximum number of subject records a single batch should contain.  The default is 100.
#' @param interbatch_delay The number of seconds the function will wait before requesting a new subset from REDCap. The default is 0.5 seconds.
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param verbose A boolean value indicating if \code{message}s should be printed to the R console during the operation.  Optional.
#' @param cert_location  If present, this string should point to the location of the cert files required for SSL verification.  If the value is missing or NULL, the server's identity will be verified using a recent CA bundle from the \href{http://curl.haxx.se}{cURL website}.  See the details below. Optional.
#' 
#' @return Currently, a list is returned with the following elements,
#' \enumerate{
#'  \item \code{success}: A boolean value indicating if the operation was apparently successful.
#'  \item \code{status_code}: The \href{http://en.wikipedia.org/wiki/List_of_HTTP_status_codes}{http status code} of the operation.
#'  \item \code{outcome_message}: A human readable string indicating the operation's outcome.
#'  \item \code{records_affected_count}: The number of records inserted or updated.
#'  \item \code{affected_ids}: The subject IDs of the inserted or updated records.
#'  \item \code{elapsed_seconds}: The duration of the function.
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

redcap_write <- function( ds_to_write, 
                          batch_size = 100L,
                          interbatch_delay = 0.5,
                          redcap_uri,
                          token,
                          verbose = TRUE, cert_location=NULL ) {  
  
  if( base::missing(redcap_uri) )
    base::stop("The required parameter `redcap_uri` was missing from the call to `redcap_write()`.")
  
  if( base::missing(token) )
    base::stop("The required parameter `token` was missing from the call to `redcap_write()`.")

  start_time <- base::Sys.time()

  ds_glossary <- REDCapR::create_batch_glossary(row_count=base::nrow(ds_to_write), batch_size=batch_size)
  
  affected_ids <- character(0)
  lst_status_code <- NULL
  # lst_status_message <- NULL
  lst_outcome_message <- NULL
  success_combined <- TRUE

  message("Starting to update ", format(nrow(ds_to_write), big.mark=",", scientific=F, trim=T), " records to be written at ", Sys.time())
  for( i in seq_along(ds_glossary$id) ) {
    selected_indices <- seq(from=ds_glossary[i, "start_index"], to=ds_glossary[i, "stop_index"])
    
    if( i > 0 ) Sys.sleep(time = interbatch_delay)
    #     selected_ids <- ids[selected_index]
    message("Writing batch ", i, " of ", nrow(ds_glossary), ", with indices ", min(selected_indices), " through ", max(selected_indices), ".")
    write_result <- REDCapR::redcap_write_oneshot(ds = ds_to_write[selected_indices, ],                                                  
                                                  redcap_uri = redcap_uri,
                                                  token = token,
                                                  verbose = verbose, 
                                                  cert_location=cert_location)
    
    lst_status_code[[i]] <- write_result$status_code
    # lst_status_message[[i]] <- write_result$status_message
    lst_outcome_message[[i]] <- write_result$outcome_message
    
    if( !write_result$success )
      stop("The `redcap_write()` call failed on iteration", i, ". Set the `verbose` parameter to TRUE and rerun for additional information.")
    
    affected_ids <- c(affected_ids, write_result$affected_ids)
    success_combined <- success_combined | write_result$success
       
    rm(write_result) #Admittedly overkill defensiveness.
  }
  
  elapsed_seconds <- as.numeric(difftime( Sys.time(), start_time, units="secs"))
  status_code_combined <- paste(lst_status_code, collapse="; ")
  # status_message_combined <- paste(lst_status_message, collapse="; ")
  outcome_message_combined <- paste(lst_outcome_message, collapse="; ")
#   outcome_message_overall <- paste0("\nAcross all batches,",
#                                    format(length(affected_ids), big.mark = ",", scientific = FALSE, trim = TRUE), 
#                                    " records were written to REDCap in ", 
#                                    round(elapsed_seconds, 2), 
#                                    " seconds.")
#   if( verbose ) 
#     message(outcome_message_overall)

  return( list(
    success = success_combined,
    status_code = status_code_combined,
    # status_message = status_message_combined, 
    outcome_message = outcome_message_combined,
    records_affected_count = length(affected_ids),
    affected_ids = affected_ids,
    elapsed_seconds = elapsed_seconds    
  ) )
}
