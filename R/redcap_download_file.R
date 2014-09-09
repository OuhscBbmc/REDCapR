#' @name redcap_download_file
#' @export redcap_download_file
#' 
#' @title Download a file from a REDCap project record.
#'  
#' @description This function uses REDCap's \href{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}{API}
#' to upload a file
#' 
#' @param fn The name of the file where the downloaded file is saved.
#' 		     If empty the original name of the file will be used and saved in 
#' 		     the default directory.  Optional. 
#' @parm  dir The directory where the file is saved. By default current directory. Optional
#' @param record The record id where the file is to be imported. Required
#' @param field The name of the field where the file is saved in REDCap. Required
#' @param event The name of the event where the file is saved in REDCap. Optional
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
#'  \item \code{raw_text}: If an operation is NOT successful, the text returned by REDCap.  If an operation is successful, the `raw_text` is returned as an empty string to save RAM.
#' }
#' @details 
#' The `REDCapR' package includes a recent version of the \href{http://curl.haxx.se/ca/cacert.pem}{Bundle of CA Root Certificates} 
#' from the official \href{http://curl.haxx.se}{cURL site}.  This version is used by default, unless the `cert_location` parameter is given another location.
#' 
#' Currently, the function doesn't modify any variable types to conform to REDCap's supported variables.  See \code{\link{validate_for_write}} for a helper function that checks for some common important conflicts.
#' @author Will Beasley
#' @author John Aponte
#' @references The official documentation can be found on the `API Examples' page on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}). A user account is required.
#' 
#' The official \href{http://curl.haxx.se}{cURL site} discusses the process of using SSL to verify the server being connected to.
#' 
#' @examples
#' \dontrun{ 
#' #Define some constants
#' uri  <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token <- "D70F9ACD1EDD6F151C6EA78683944E98"
#' record <- 1
#' field<-"file_field"
#' event <- "" # only for longitudinal events
#' redcap_download_file(record=record,field=field,event=event,redcap_uri=uri, token=token)
#' 
#' }
#' 
redcap_download_file <- function( fn="", dir="." , record, field, event="", redcap_uri, token, verbose=TRUE, cert_location=NULL ) {
	#TODO: automatically convert boolean/logical class to integer/bit class
	start_time <- Sys.time()
	
	if( missing(redcap_uri) )
		stop("The required parameter `redcap_uri` was missing from the call to `redcap_write_oneshot()`.")
	
	if( missing(token) )
		stop("The required parameter `token` was missing from the call to `redcap_write_oneshot()`.")     
	
	if( missing( cert_location ) | is.null(cert_location) ) 
		cert_location <- system.file("cacert.pem", package = "httr")
	# cert_location <- file.path(devtools::inst("REDCapR"), "ssl_certs/mozilla_ca_root.crt")
	
	if( !base::file.exists(cert_location) )
		stop(paste0("The file specified by `cert_location`, (", cert_location, ") could not be found."))
	
	config_options <- list(cainfo=cert_location, sslversion=3)

		
	post_body <- list(
		token = token,
		content = 'file',
		action = 'export',
		record = record,
		field = field,
		event = event,
		returnFormat = 'csv'  
	)
	
	result <- httr::POST(
		url = redcap_uri,
		body = post_body,
		config = config_options
	)
	
	status_code <- result$status_code
	# status_message <- result$headers$statusmessage

	elapsed_seconds <- as.numeric(difftime( Sys.time(), start_time,units="secs"))    
	
	#isValidIDList <- grepl(pattern="^id\\n.{1,}", x=raw_text, perl=TRUE) #example: x="id\n5835\n5836\n5837\n5838\n5839"
	success <- (status_code == 200L)
	
	if( success ) {
		rh<-result$headers$`content-type`
		if (fn == "") {
			#process the content-type to get the file name
			fn<-gsub('(name=.)|(")',"",regmatches(rh,regexpr("name=.*",rh)))
		}
		newfile<-file.path(dir,fn)
		writeBin(httr::content(result, as="raw"),newfile)
		outcome_message <- paste0(rh, " Downloaded with success in " ,
								  round(elapsed_seconds, 2), 
								  " seconds, and saved as ", newfile)
		recordsAffectedCount = 0
		record_id = record
		raw_text = ""
	} 
	else { #If the returned content wasn't recognized as valid IDs, then
		outcome_message <- paste0("file NOT not downloaded ")
		recordsAffectedCount = 0
		record_id = ""
		raw_text = httr::content(result, type="text")
	}
	if( verbose ) 
		message(outcome_message)
	
	return( list(
		success = success,
		status_code = status_code,
		# status_message = status_message, 
		outcome_message = outcome_message,
		records_affected_count = recordsAffectedCount,
		affected_ids = record_id,
		elapsed_seconds = elapsed_seconds,
		raw_text = raw_text    
	))
}

