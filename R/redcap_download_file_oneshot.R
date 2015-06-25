#' @name redcap_download_file_oneshot
#' @export redcap_download_file_oneshot
#' 
#' @title Download a file from a REDCap project record.
#'  
#' @description This function uses REDCap's \href{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}{API}
#' to download a file
#' 
#' @param file_name The name of the file where the downloaded file is saved.
#' 		     If empty the original name of the file will be used and saved in 
#' 		     the default directory.  Optional. 
#' @param directory The directory where the file is saved. By default current directory. Optional
#' @param overwrite Boolean value indicating if existing files should be overwritten. Optional
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project.  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param record The record ID where the file is to be imported. Required
#' @param field The name of the field where the file is saved in REDCap. Required
#' @param event The name of the event where the file is saved in REDCap. Optional
#' @param verbose A boolean value indicating if \code{message}s should be printed to the R console during the operation.  Optional.
#' @param config_options  A list of options to pass to \code{POST} method in the \code{httr} package.  See the details below. Optional.
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
#'  \item \code{file_name}: The name of the file persisted to disk. This is useful if the name stored in REDCap is used (which is the default).
#' }
#' @details 
#' The `REDCapR' package includes a recent version of the \href{http://curl.haxx.se/ca/cacert.pem}{Bundle of CA Root Certificates} 
#' from the official \href{http://curl.haxx.se}{cURL site}.  This version is used by default, unless the `cert_location` parameter is given another location.
#' 
#' Currently, the function doesn't modify any variable types to conform to REDCap's supported variables.  See \code{\link{validate_for_write}} for a helper function that checks for some common important conflicts.
#' @author Will Beasley
#' @author John J. Aponte
#' @references The official documentation can be found on the `API Examples' page on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}). A user account is required.
#' 
#' The official \href{http://curl.haxx.se}{cURL site} discusses the process of using SSL to verify the server being connected to.
#' 
#' @examples
#' \dontrun{  
#' uri  <- "https://bbmc.ouhsc.edu/redcap/api/"
#' token <- "D70F9ACD1EDD6F151C6EA78683944E98" #pid=213
#' record <- 1
#' field <- "mugshot"
#' # event <- "" # only for longitudinal events
#' 
#' result_1 <- redcap_download_file_oneshot(record=record, field=field, 
#'                                  redcap_uri=uri, token=token)
#' base::unlink("mugshot_1.jpg")
#' 
#' (full_name <- base::tempfile(pattern="mugshot", fileext=".jpg"))
#' result_2 <- redcap_download_file_oneshot(file_name=full_name, record=record, field=field, 
#'                                  redcap_uri=uri, token=token)
#' base::unlink(full_name)
#' 
#' (relative_name <- "ssss.jpg")
#' result_3 <- redcap_download_file_oneshot(file_name=relative_name, record=record, field=field, 
#'                                  redcap_uri=uri, token=token)
#' base::unlink(relative_name)
#' }

redcap_download_file_oneshot <- function( file_name=NULL, directory=NULL, overwrite=FALSE, redcap_uri, token, record, field, event="", verbose=TRUE, config_options=NULL ) {
	start_time <- Sys.time()
	
	if( missing(redcap_uri) )
		stop("The required parameter `redcap_uri` was missing from the call to `redcap_download_file_oneshot()`.")
	
	if( missing(token) )
		stop("The required parameter `token` was missing from the call to `redcap_download_file_oneshot()`.")     
	
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
		content = 'file',
		action = 'export',
		record = record,
		field = field,
		event = event,
		returnFormat = 'csv'  
	)
	
  #This is the first of two important lines in the function.
  #  It retrieves the information from the server and stores it in RAM.
	result <- httr::POST(
		url = redcap_uri,
		body = post_body,
		config = config_options
	)
	
	status_code <- result$status_code
	# status_message <- result$headers$statusmessage

	elapsed_seconds <- as.numeric(difftime(Sys.time(), start_time, units="secs"))    
	
	#isValidIDList <- grepl(pattern="^id\\n.{1,}", x=raw_text, perl=TRUE) #example: x="id\n5835\n5836\n5837\n5838\n5839"
	success <- (status_code == 200L)
	
	if( success ) {
		result_header <- result$headers$`content-type`
    
		if( missing(file_name) | is.null(file_name) ) {
			#process the content-type to get the file name
		  regex_matches <- regmatches(result_header, regexpr("name=.*", result_header))
		  file_name <- gsub(pattern='(name=.)|(")', replacement="", x=regex_matches)
		}
		
		if( missing(directory) & is.null(directory) ) {
		  file_path <- file_name #Use relative path.
    } else {
		  file_path <- file.path(directory, file_name) #Qualify the file with its full path.
    }
    
    if( verbose )
      message("Preparing to download the file `", file_path, "`.")
    
    if( !overwrite & file.exists(file_path) )
      stop("The operation was halted because the file `", file_path, "` already exists and `overwrite` is FALSE.  Please check the directory if you believe this is a mistake.")
    
		#This is the second of two important lines in the function.
		#  It persists/converts the information in RAM to a file.
		writeBin(httr::content(result, as="raw"), con=file_path)
    
		outcome_message <- paste0(result_header, " successfully downloaded in " ,
								  round(elapsed_seconds, 1), " seconds, and saved as ", file_path)
		recordsAffectedCount <- length(record)
		record_id <- record
		raw_text <- ""
	} 
	else { #If the operation was unsuccessful, then...
		outcome_message <- paste0("file NOT downloaded ")
		recordsAffectedCount <- 0
		record_id <- numeric(0) #Return an empty vector.
		raw_text <- httr::content(result, type="text")
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
		raw_text = raw_text,
		file_name = file_name,
		file_path = file_path
	))
}
