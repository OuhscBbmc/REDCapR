##' @name redcap_project
##' @export redcap_project
##' 
##' @title A \code{Reference Class} to make later calls to REDCap more convenient.
##' 
##' @docType class
##' 
##' @description This \code{Reference Class} represents a REDCap project. 
##' Once some values are set that are specific to a REDCap project (such as the URI and token), 
##' later calls are less verbose (such as reading and writing data).
##' 
##' 
##' @examples
##' library(REDCapR) #Load the package into the current R session.
##' uri <- "https://bbmc.ouhsc.edu/redcap/api/"
##' token <- "9A81268476645C4E5F03428B8AC3AA7B"
##' project <- redcap_project$new(redcap_uri=uri, token=token)
##' project$read()

redcap_project <- setRefClass(
  Class = "redcap_project",
  
  fields = list(
    redcap_uri = "character",
    token = "character"
    # batch_size_default 
  ),
  
  methods = list(
    read = function( 
      batch_size = 100L, interbatch_delay = 0,
      records = NULL, records_collapsed = NULL, 
      fields = NULL, fields_collapsed = NULL, 
      export_data_access_groups = FALSE,
      raw_or_label = 'raw',
      verbose = TRUE, cert_location = NULL) {
      
      return( REDCapR::redcap_read( 
        batch_size = batch_size, interbatch_delay = interbatch_delay,
        redcap_uri = redcap_uri, token = token, 
        records = records, records_collapsed = records_collapsed, 
        fields = fields, fields_collapsed = fields_collapsed, 
        export_data_access_groups = export_data_access_groups,
        raw_or_label = raw_or_label,
        verbose = verbose, cert_location=cert_location 
      ))
      
    }
  )
)
# http://adv-r.had.co.nz/OO-essentials.html

# http://stackoverflow.com/questions/21875596/mapping-a-c-sharp-class-definition-to-an-r-reference-class-definition

# REDCapR::redcap_project$
# # library(REDCapR) #Load the package into the current R session.
# uri <- "https://bbmc.ouhsc.edu/redcap/api/"
# token <- "9A81268476645C4E5F03428B8AC3AA7B"
# 
# # uri <- "https://redcap.vanderbilt.edu/api/"
# # token <- "8E66DB6844D58E990075AFB51658A002"
# 
# require(RCurl)
# cert_location <- file.path(devtools::inst("REDCapR"), "ssl_certs", "mozilla_2013_12_05.crt")
# curl_options <- RCurl::curlOptions(cainfo = cert_location)
# # tt <- RCurl::getURL(url=uri, .opts=curl_options)
# # tt
# 
# project <- redcap_project$new(redcap_uri=uri, token=token)
# project$read()
# redcap_read(batch_size=2, redcap_uri=uri, token=token)
