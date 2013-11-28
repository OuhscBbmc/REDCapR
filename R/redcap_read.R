#' @name redcap_read
#' @export redcap_read
#' 
#' @title Read records from a REDCap project
#' 
#' @usage redcap_read( redcap_uri, token, records=NULL, records_collapsed=NULL, fields=NULL, fields_collapsed=NULL, verbose=TRUE )
#' 
#' @description This function uses REDCap's \href{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}{API}
#' to select and return data.
#' 
#' @param redcap_uri The URI of your REDCap project (\emph{eg}, https://ouhsc.edu/redcap).  Required.
#' @param token The user-specific string that serves as the password for a project.  Required.
#' @param records An array, where each element corresponds to the ID of a desired record.  Optional.
#' @param records_collapsed A single string, where the desired ID values are separated by commas.  Optional.
#' @param fields An array, where each element corresponds a desired project field.  Optional.
#' @param records_collapsed A single string, where the desired field names are separated by commas.  Optional.
#' @param verbose A boolean value indicating if \code{message}s should be printed to the R console during the operation.  Optional.
#' 
#' @return Currently, a list is returned with the arguments \code{ASquared},
#' \code{CSquared}, \code{ESquared}, and \code{RowCount}.  In the future, this
#' may be changed to an \code{S4} class.
#' 
#' @details 
#' The \code{AceUnivariate} function is a wrapper that calls
#' \code{DeFriesFulkerMethod1} or \code{DeFriesFulkerMethod3}.  Future
#' versions will incorporate methods that use latent variable models.
#' 
#' @author Will Beasley
#' @references The `API Examples' page on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}). A user account is required.
#' @examples 
#' \dontrun{
#' library(REDCapR) #Load the package into the current R session.
#' 
#' #Return all records and all variables.
#' ds_all_rows_all_fields <- redcap_read(redcap_uri=redcapUri, token=token)$data
#' 
#' #Return only records with IDs of 101, 102, 103, and 104
#' desired_records <- c(101, 102, 103, 104)
#' ds_some_rows <- redcap_read(redcap_uri=redcapUri, token=token, records=desired_records)$data
#' 
#' #Return only records with IDs of 101, 102, 103, and 104 (alternate way)
#' desired_records <- "101, 102, 103, 104"
#' ds_some_rows <- redcap_read(redcap_uri=redcapUri, token=token, records_collapsed=desired_records)$data
#' 
#' dsCall1 <- redcap_read(redcap_uri=redcapUri, token=token, fields=initialFields )$data
#' 
#' initialFields <- c("recruitid", "call1_recruiter", "call1_start", "call1_outcome", "inactive_record", "inactivated_date")
#' dsCall1 <- redcap_read(redcap_uri=redcapUri, token=token, fields=initialFields )$data
#' }

redcap_read <- function( redcap_uri, token, records=NULL, records_collapsed=NULL, fields=NULL, fields_collapsed=NULL, verbose=TRUE ) {
  #TODO: unaswered verbose parameter pulls from getOption("verbose")
  start_time <- Sys.time()
  
  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_read()`.")
  
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_read()`.")
  
  if( missing(records_collapsed) & !missing(records) )
    records_collapsed <- paste0(records, collapse=",")
  
  if( missing(fields_collapsed) & !missing(fields) )
    fields_collapsed <- paste0(fields, collapse=",")
  
  raw_csv <- RCurl::postForm(
    uri = redcap_uri
    , token = token
    , content = 'record'
    , format = 'csv'
    , type = 'flat'
    , records = records_collapsed
    , fields = fields_collapsed
    , .opts = RCurl::curlOptions(cainfo = "./Dal/Certs/ca-bundle.crt")
  )
  ds <- read.csv(text=raw_csv, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
  
  elapsed_seconds <- as.numeric(difftime( Sys.time(), start_time,units="secs"))
  
  #The comma formatting uses the same code as scales::comma, but I don't want to create a package dependency just for commas.
  status_message <- paste0(format(nrow(ds), big.mark = ",", scientific = FALSE, trim = TRUE), " records and ",  format(length(ds), big.mark = ",", scientific = FALSE, trim = TRUE), " columns were read from REDCap in ", round(elapsed_seconds, 2), " seconds.")
  if( verbose ) 
    message(status_message)
  
  return( list(
    data = ds, 
    raw_csv = raw_csv,
    records_collapsed = records_collapsed, 
    records_collapsed = fields_collapsed,
    elapsed_seconds = elapsed_seconds, 
    status_message = status_message
  ))
}
