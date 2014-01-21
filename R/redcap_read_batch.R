#' @name redcap_read_batch
#' @export redcap_read_batch
#' 
#' @title Read records from a REDCap project in subsets, and stacks them together before returning a \code{data.frame}.
#'  
#' @description From an external perpsective, this function is similar to \code{\link{redcap_read}}.  The internals
#' differ in that \code{read_read_batch} retrieves subsets of the data, and then combines them before returning
#' (among other objects) a single \code{data.frame}.  This function can be more appropriate than 
#' \code{\link{redcap_read}} when returning large datasets that could tie up the server.   
#' 
#' @param batch_size The maximum number of subject records a single batch should contain.  The default is 100.
#' @param interbatch_delay The number of seconds the function will wait before requesting a new subset from REDCap. The default is 0.5 seconds.
#' @param redcap_uri The URI of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param records An array, where each element corresponds to the ID of a desired record.  Optional.
#' @param records_collapsed A single string, where the desired ID values are separated by commas.  Optional.
#' @param fields An array, where each element corresponds a desired project field.  Optional.
#' @param fields_collapsed A single string, where the desired field names are separated by commas.  Optional.
#' @param export_data_access_groups A boolean value that specifies whether or not to export the ``redcap_data_access_group'' field when data access groups are utilized in the project. Default is \code{FALSE}. See the details below.
#' @param raw_or_label A string (either \code{'raw'} or \code{'label'} that specifies whether to export the raw coded values or the labels for the options of multiple choice fields.  Default is \code{'raw'}.
#' @param verbose A boolean value indicating if \code{message}s should be printed to the R console during the operation.  Optional.
#' @param cert_location  If present, this string should point to the location of the cert files required for SSL verification.  If the value is missing or NULL, the server's identity will be verified using a recent CA bundle from the \href{http://curl.haxx.se}{cURL website}.  See the details below. Optional.
#' 
#' @return Currently, a list is returned with the following elements,
#' \enumerate{
#'  \item \code{data}: an R \code{data.frame} of the desired records and columns.
#'  \item \code{raw_csv}: the text of comma separated values returned by REDCap through \code{RCurl}.
#'  \item \code{records_collapsed}: the desired records IDs, collapsed into a single string, separated by commas.
#'  \item \code{fields_collapsed}: the desired field names, collapsed into a single string, separated by commas.
#'  \item \code{elapsed_seconds}: the duration of the function.
#'  \item \code{status_message}: a boolean value indicating if the operation was apparently successful.
#' }
#' @details 
#' Specifically, it internally uses multiple calls to \code{\link{redcap_read}} to select and return data.
#' Initially, only primary key is queried through the REDCap API.  The long list is then subsetted into partitions,
#' whose sizes are determined by the \code{batch_size} parameter.  REDCap is then queried for all variables of
#' the subset's subjects.  This is repeated for each subset, before returning a unified \code{data.frame}.
#' 
#' The function allows a delay between calls, which allows the server to attend to other users' requests.
#' @author Will Beasley
#' @references The official documentation can be found on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiDocumentation}).  
#' Also see the `API Examples' page on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}). 
#' A user account is required to access the wiki, which typically is granted only to REDCap administrators.  
#' If you do not
#' 
#' The official \href{http://curl.haxx.se}{cURL site} discusses the process of using SSL to verify the server being connected to.
#' 
#' @examples
#' \dontrun{
#' library(REDCapR) #Load the package into the current R session.
#' uri <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token <- "9A81268476645C4E5F03428B8AC3AA7B"
#' redcap_read_batch(batch_size=2, redcap_uri=uri, token=token)
#' }
#' 

redcap_read_batch <- function( batch_size=100L, interbatch_delay=0,
                               redcap_uri, token, records=NULL, records_collapsed=NULL, 
                               fields=NULL, fields_collapsed=NULL, 
                               export_data_access_groups = FALSE,
                               raw_or_label = 'raw',
                               verbose=TRUE, cert_location=NULL ) {  
  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_read()`.")
  
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_read()`.")
  
  if( missing(records_collapsed) & !missing(records) )
    records_collapsed <- paste0(records, collapse=",")
  
  if( missing(fields_collapsed) & !missing(fields) )
    fields_collapsed <- paste0(fields, collapse=",")
  
  #   export_data_access_groups_string <- ifelse(export_data_access_groups, "true", "false")
  #   
  #   if( missing( cert_location ) | is.null(cert_location) ) 
  #     cert_location <- file.path(devtools::inst("REDCapR"), "ssl_certs", "mozilla_2012_12_29.crt")
  #   #     curl_options <- RCurl::curlOptions(ssl.verifypeer = FALSE)
  #   
  #   if( !base::file.exists(cert_location) )
  #     stop(paste0("The file specified by `cert_location`, (", cert_location, ") could not be found."))
  
  start_time <- Sys.time()
  initial_call <- REDCapR::redcap_read(redcap_uri=redcap_uri, token=token, records_collapsed=records_collapsed, fields_collapsed="nonexistant_field_name", verbose=verbose, cert_location=cert_location)
  
  ###
  ### Stop and return to the caller if the initial query failed.
  ###
  if( !initial_call$success ) {
    status_message <- paste0("The initial call failed with the message: ", initial_call$status_message, ".")
    elapsed_seconds <- as.numeric(difftime( Sys.time(), start_time, units="secs"))
    return( list(
      data = data.frame(), 
      raw_csv = "",
      records_collapsed = "failed in initial batch call", 
      fields_collapsed = "failed in initial batch call",
      elapsed_seconds = elapsed_seconds, 
      status_message = status_message, 
      success = initial_call$success
    ) )
  }
  ###
  ### Continue as intended if the initial query succeeded.
  ###
  ids <- initial_call$data[, 1]
  ids <- ids[order(ids)]
  
  ds_glossary <- REDCapR:::create_batch_glossary(row_count=length(ids), batch_size=batch_size)
  lst_batch <- NULL
  lst_status_message <- NULL
  success_combined <- TRUE
  
  message("Starting to read ", format(length(ids), big.mark=",", scientific=F, trim=T), " records to be deactivated at ", Sys.time())
  for( i in ds_glossary$id ) {
    selected_index <- seq(from=ds_glossary[i, "start_index"], to=ds_glossary[i, "stop_index"])
    selected_ids <- ids[selected_index]
    message("Reading batch ", i, " of ", nrow(ds_glossary), ", with ids ", min(selected_ids), " through ", max(selected_ids), ".")
    read_result <- REDCapR::redcap_read(redcap_uri = redcap_uri,
                                        token = token,  
                                        records = selected_ids,
                                        fields_collapsed = fields_collapsed,
                                        export_data_access_groups = export_data_access_groups, 
                                        raw_or_label = raw_or_label,
                                        verbose = verbose, 
                                        cert_location = cert_location)
    if( !read_result$success )
      stop("The `redcap_read_batch()` call failed on iteration", i, ". Set the `verbose` parameter to TRUE and rerun for additional information.")
    
    lst_batch[[i]] <- read_result$data
    lst_status_message[[i]] <- read_result$status_message
    success_combined <- success_combined | read_result$success
    
    rm(read_result) #Admittedly overkill defensiveness.
  }
  
  ds_stacked <- plyr::rbind.fill(lst_batch)
  status_message_combined <- paste(lst_status_message, collapse="; ")
  
  elapsed_seconds <- as.numeric(difftime( Sys.time(), start_time, units="secs"))
  
  return( list(
    data = ds_stacked, 
    raw_csv = "The raw CSV isn't available with `redcap_read_batch()`.  Use `redcap_read()` instead.",
    records_collapsed = records_collapsed, 
    fields_collapsed = fields_collapsed,
    elapsed_seconds = elapsed_seconds, 
    status_message = status_message_combined, 
    success = success_combined
  ) )
}

# redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
# token <- "9A81268476645C4E5F03428B8AC3AA7B"
# redcap_read_batch(batch_size=2, redcap_uri=redcap_uri, token=token)
