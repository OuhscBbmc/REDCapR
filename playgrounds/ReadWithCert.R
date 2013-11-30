rm(list=ls(all=TRUE))
require(REDCapR)

uri <- "https://miechvprojects.ouhsc.edu/redcap/api/"
# uri <- "https://miechvprojects.ouhsc.edu/redcap/redcap_v5.2.3/API/"
token <- "9446D2E3FAA71ABB815A2336E4692AF3"
certs <- file.path(devtools::inst("REDCapR"), "ssl_certs", "mozilla_2012_12_29.crt")

returned <- redcap_read(redcap_uri=uri, token=token)


sssss <- RCurl::postForm(
  uri = uri
  , token = token
  , content = 'record'
  , format = 'csv'
  , type = 'flat'
  , .opts = RCurl::curlOptions(cainfo = certs)
  #, .opts = RCurl::curlOptions(ssl.verifypeer = FALSE)
)
try(
  dsTry <- read.csv(text=raw_csv, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
)
if( ! exists("dsTry") )
  dsTry <- data.frame()
sssss
