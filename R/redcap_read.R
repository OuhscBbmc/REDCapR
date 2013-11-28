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
