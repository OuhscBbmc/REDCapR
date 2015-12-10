rm(list=ls(all=TRUE))
library(REDCapR)

uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "C1A2B36F94B518FDD50561D1FD09170D" #UnitTesttPhiFree
certs <- file.path(devtools::inst("REDCapR"), "ssl-certs/mozilla-ca-root.crt")
# certs <- file.path(devtools::inst("REDCapR"), "ssl_cert/v2.crt")
certs <- list(cainfo = system.file("cacert.pem", package = "httr"))

returned <- redcap_read(redcap_uri=uri, token=token)


raw_text <- RCurl::postForm(
  uri = uri
  , token = token
  , content = 'record'
  , format = 'csv'
  , type = 'flat'
#   , .opts = RCurl::curlOptions(cainfo = certs)
  , .opts = RCurl::curlOptions(ssl.verifypeer = FALSE)
)
try(
  dsTry <- utils::read.csv(text=raw_text, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
)
if( ! exists("dsTry") )
  dsTry <- data.frame()


