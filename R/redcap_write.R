
redcap_write <- function( ds, redcap_uri, token, verbose=TRUE ) {
  #TODO: convert boolean to integer/bit
  start_time <- Sys.time()
  
  if( missing(redcap_uri) )
    stop("The required parameter `redcap_uri` was missing from the call to `redcap_write()`.")
  
  if( missing(token) )
    stop("The required parameter `token` was missing from the call to `redcap_write()`.")     
  
  con <-  base::textConnection(object='csvElements', open='w', local=TRUE)
  write.csv(ds, con, row.names = FALSE, na="")  
  close(con)
  
  csv <- paste(csvElements, collapse="\n")
  rm(csvElements, con)
  
  returnContent <- RCurl::postForm(
    uri = redcap_uri, 
    token = token,
    content = 'record',
    format = 'csv', 
    type = 'flat', 
    returnContent = "ids",
    overwriteBehavior = 'overwrite', #overwriteBehavior: *normal* - blank/empty values will be ignored [default]; *overwrite* - blank/empty values are valid and will overwrite data
    data = csv,
    .opts = RCurl::curlOptions(cainfo = "./Dal/Certs/ca-bundle.crt")
  )
  elapsed_seconds <- as.numeric(difftime( Sys.time(), start_time,units="secs"))    
  
  isValidIDList <- grepl(pattern="^id\\n.{1,}", x=returnContent, perl=TRUE) #example: x="id\n5835\n5836\n5837\n5838\n5839"
  if( isValidIDList ) {
    elements <- unlist(strsplit(returnContent, split="\\n"))
    affectedIDs <- elements[-1]  
    recordsAffectedCount <- length(affectedIDs)
    status_message <- paste0(format(recordsAffectedCount, big.mark = ",", scientific = FALSE, trim = TRUE), " records were written to REDCap in ", round(elapsed_seconds, 2), " seconds.")
  } 
  else { #If the returned content wasn't recognized as valid IDs, then
    affectedIDs <- numeric() #Pass an empty array
    recordsAffectedCount <- NA
    status_message <- "The content returned during the write operation was not recognized.  Please see the `returnContent` elemnt for more information." 
  }
  if( verbose ) 
    message(status_message)
  
  return( list(
    records_affected_count = recordsAffectedCount,
    affected_ids = affectedIDs,
    elapsed_seconds = elapsed_seconds, 
    status_message = status_message, 
    return_content = returnContent, 
    success = isValidIDList
  ))
}
