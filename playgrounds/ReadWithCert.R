require(REDCapR)

uri <- "http://miechvprojects.ouhsc.edu/redcap/api/"
token <- "9446D2E3FAA71ABB815A2336E4692AF3"
certs <- "C:/Users/Will/Documents/Miechv/MReporting/Dal/Certs"

# returned <- redcap_read(redcap_uri=uri, token=token)


sssss <- RCurl::postForm(
  uri = uri
  , token = token
  , content = 'record'
  , format = 'csv'
  , type = 'flat'
  , .opts = RCurl::curlOptions(ssl.verifypeer = FALSE)
)
try(
  dsTry <- read.csv(text=raw_csv, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
)
if( ! exists("dsTry") )
  dsTry <- data.frame()
sssss
