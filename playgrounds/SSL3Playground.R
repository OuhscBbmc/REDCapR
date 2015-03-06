## This playground comes directly for @rparrish's thread at https://github.com/OuhscBbmc/REDCapR/issues/55

redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `U
token <- "D70F9ACD1EDD6F151C6EA78683944E98****"
# redcap_uri <- "https://ampa.org/redcap/api/"
# token <- "D1BB670A719F1D481A5574F33125A04C" ## expires 11/2/2014

## RCurl
library(RCurl)

# SO post:
# http://stackoverflow.com/questions/15347233/ssl-certificate-failed-for-twitter-in-r
cert_location <- system.file("CurlSSL", "cacert.pem", package = "RCurl")
cert_location <- "./inst/ssl_certs/mozilla_ca_root.crt"
file.exists(cert_location)
options(RCurlOptions = list(cainfo=cert_location))

RCurl_raw <- RCurl::postForm(
    uri = redcap_uri
    , token = token
    , content = 'record'
    , format = 'csv'
#     , type = 'flat'
#     , rawOrLabel = 'raw'
#     , exportDataAccessGroups = 'true'
    , .opts = RCurl::curlOptions(ssl.verifypeer=T, verbose=TRUE)
)

RCurl_raw

devtools::install_github("hadley/httr")
library(httr)
post_body <- list(
    token = token,
    content = 'record',
    format = 'csv',
    type = 'flat',
    rawOrLabel = 'raw',
    exportDataAccessGroups = 'true'
)

httr_raw <- httr::POST(
    url = redcap_uri,
    body = post_body#,
   # config = httr::config(ssl.verifypeer=F)
    #httr::verbose() 
)
httr_raw

# devtools::install_github("nutterb/redcapAPI")
# install.packages("redcapAPI")
library(redcapAPI)
rcon <- redcapConnection(url=redcap_uri, token=token, config = list(ssl.verifypeer=F))
redcap_API_data <- exportRecords(rcon)

redcap_API_data

library(REDCapR)
REDCapR_data <- redcap_read_oneshot(redcap_uri=redcap_uri, token=token, sslversion=NULL, verbose=TRUE)
