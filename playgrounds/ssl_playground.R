rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 
## This playground comes directly for @rparrish's thread at https://github.com/OuhscBbmc/REDCapR/issues/55

# Credential for OU's test server
redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
# token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `U
token <- "D70F9ACD1EDD6F151C6EA78683944E98"


# # Credentials for Vandy's EC2 test server
redcap_uri <- "https://www.redcapplugins.org/api/"
# redcap_uri <- "https://www.redcapplugins.org/redcap_v6.5.0/API/"
token <- "D96029BFCE8FFE76737BFC33C2BCC72E" #For `UnitTestPhiFree` account and the simple project (pid 27) on Vandy's test server.

# SO post:
# http://stackoverflow.com/questions/15347233/ssl-certificate-failed-for-twitter-in-r
# cert_location <- system.file("CurlSSL", "cacert.pem", package = "RCurl")
cert_location <- "./inst/ssl-certs/mozilla-ca-root.crt"
file.exists(cert_location)

##########################################################################
# library(curl) #devtools::install_github("jeroenooms/curl")
curl::curl_fetch_memory(url=redcap_uri)

##########################################################################
library(httr) #devtools::install_github("hadley/httr")
post_body <- list(
    token                  = token,
    content                = 'record',
    format                 = 'csv',
    type                   = 'flat',
    rawOrLabel             = 'raw',
    exportDataAccessGroups = 'true'
)

httr_raw <- httr::POST(
    url            = redcap_uri,
    body           = post_body,
    config         = config(cainfo=cert_location),
    httr::verbose() 
)
httr_raw
content(httr_raw, type = "text")

##########################################################################
# library(httr) #devtools::install_github("hadley/httr")
# post_body <- list(
#   token = token,
#   content = 'record',
#   format = 'csv',
#   type = 'flat',
#   rawOrLabel = 'raw',
#   exportDataAccessGroups = 'true'
# )
# 
# # set_config(ssl_verifypeer=FALSE)
# # config(ssl_verifypeer=FALSE)
# # config()
# 
# httr_raw <- httr::POST(
#   url = redcap_uri,
#   body = post_body#,
#   # config = config(ssl_verifypeer=FALSE)
#   # config = httr::config(ssl.verifypeer=F)
#   #httr::verbose() 
# )
# httr_raw
# content(httr_raw, type = "text")

##########################################################################
library(RCurl)
# SO post: http://stackoverflow.com/questions/15347233/ssl-certificate-failed-for-twitter-in-r
file.exists(file.path(devtools::inst("REDCapR"), "ssl-certs/mozilla-ca-root.crt"))

rcurl_raw <- RCurl::postForm(
  uri = redcap_uri
  , token = token
  , content = 'record'
  , format = 'csv'
  , type = 'flat'
  , rawOrLabel = 'raw'
  , exportDataAccessGroups = 'true'
  , .opts = RCurl::curlOptions(cainfo = file.path(devtools::inst("REDCapR"), "ssl-certs/mozilla-ca-root.crt"))
  # , .opts = RCurl::curlOptions(ssl.verifypeer=F, verbose=TRUE)
)
rcurl_raw

##########################################################################
library(REDCapR)
redcapr_data <- redcap_read_oneshot(redcap_uri=redcap_uri, token=token)
redcapr_data$data

##########################################################################
library(redcapAPI) # devtools::install_github("nutterb/redcapAPI")
# rcon <- redcapAPI::redcapConnection(url=redcap_uri, token=token, config = list())
# rcon <- redcapAPI::redcapConnection(url=redcap_uri, token=token, config = list(ssl_verifypeer=F))
# rcon <- redcapAPI::redcapConnection(url=redcap_uri, token=token, config = httr::config(ssl_verifypeer=F))
# rcon <- redcapAPI::redcapConnection(url=redcap_uri, token=token, config = httr::config())
rcon <- redcapAPI::redcapConnection(url=redcap_uri, token=token)
redcapAPI::exportRecords(rcon)
