rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

require(httr)


redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B"

raw_or_label <- "raw"
export_data_access_groups_string <- "true"
records_collapsed <- "1,2,5"
fields_collapsed <- NULL


curl_options <- RCurl::curlOptions(cainfo = "./inst/ssl_certs/mozilla_2013_12_05.crt")

r <- httr::POST(
  url = redcap_uri
  , body = list(
    token = token
    , content = 'record'
    , format = 'csv'
    , type = 'flat'
    , rawOrLabel = raw_or_label
    , exportDataAccessGroups = export_data_access_groups_string
    , records = records_collapsed
    , fields = fields_collapsed
  ),
  #, .opts = RCurl::curlOptions(ssl.verifypeer = FALSE)
  , .opts = curl_options
)
r$status_code
r$headers$status
r$headers$statusmessage
raw_text <- httr::content(r, "text")

ds <- read.csv(text=raw_text, stringsAsFactors=FALSE) #Convert the raw text to a dataset.


raw_text2 <- RCurl::postForm(
  uri = redcap_uri
  , token = token
  , content = 'record'
  , format = 'csv'
  , type = 'flat'
  , rawOrLabel = raw_or_label
  , exportDataAccessGroups = export_data_access_groups_string
  , records = records_collapsed
  , fields = fields_collapsed
  , .opts = RCurl::curlOptions(ssl.verifypeer = FALSE)
)
ds2 <- read.csv(text=raw_text2, stringsAsFactors=FALSE) #Convert the raw text to a dataset.