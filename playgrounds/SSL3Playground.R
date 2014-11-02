## This playground cmoes directly for @rparrish's thread at https://github.com/OuhscBbmc/REDCapR/issues/55

redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `U

redcap_uri <- "https://ampa.org/redcap/api/"
token <- "D1BB670A719F1D481A5574F33125A04C" ## expires 11/2/2014

## RCurl
library(RCurl)

# SO post:
# http://stackoverflow.com/questions/15347233/ssl-certificate-failed-for-twitter-in-r
options(RCurlOptions = 
            list(cainfo=system.file("CurlSSL", 
                                    "cacert.pem", 
                                    package = "RCurl")))

RCurl_raw <- RCurl::postForm(
    uri = redcap_uri
    , token = token
    , content = 'record'
    , format = 'csv'
    , type = 'flat'
    , rawOrLabel = 'raw'
    , exportDataAccessGroups = 'true'
    , .opts = RCurl::curlOptions(ssl.verifypeer=TRUE, verbose=TRUE)
)

RCurl_raw

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
    body = post_body,
    config = httr::config(ssl.verifypeer=TRUE)
    #httr::verbose() 
)
httr_raw

library(redcapAPI)
rcon <- redcapConnection(url=redcap_uri, token=token, config = list(ssl.verifypeer=TRUE))
redcap_API_data <- exportRecords(rcon)

redcap_API_data

library(REDCapR)
REDCapR_data <- redcap_read_oneshot(redcap_uri=redcap_uri, token=token,sslversion=NULL, verbose = TRUE)



