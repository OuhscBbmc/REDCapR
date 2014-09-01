rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

require(httr)


redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B"

raw_or_label <- "raw"
export_data_access_groups_string <- "true"
records_collapsed <- "1,2,5"
fields_collapsed <- NULL


curl_options <- RCurl::curlOptions(cainfo = "./inst/ssl_certs/mozilla_2014_04_22.crt")

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

# 
# raw_text2 <- RCurl::postForm(
#   uri = redcap_uri
#   , token = token
#   , content = 'record'
#   , format = 'csv'
#   , type = 'flat'
#   , rawOrLabel = raw_or_label
#   , exportDataAccessGroups = export_data_access_groups_string
#   , records = records_collapsed
#   , fields = fields_collapsed
#   , .opts = RCurl::curlOptions(ssl.verifypeer = FALSE)
# )
# ds2 <- read.csv(text=raw_text2, stringsAsFactors=FALSE) #Convert the raw text to a dataset.

# result <- redcap_read_oneshot(redcap_uri="https://bbmc.ouhsc.edu/redcap/api/", token = "9A81268476645C4E5F03428B8AC3AA7B")
# dput(result$data)
dsToWrite <- structure(list(record_id = 1:5, first_name = c("Nutmeg", "Tumtum", 
  "Marcus", "Trudy", "John Lee"), last_name = c("Nutmouse", "Nutmouse", 
  "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
  "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
  "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
  ), telephone = c("(432) 456-4848", "(234) 234-2343", "(433) 435-9865", 
  "(987) 654-3210", "(333) 333-4444"), email = c("nutty@mouse.com", 
  "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
  ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
  "1955-04-15"), age = c(10L, 10L, 79L, 61L, 58L), ethnicity = c(1L, 
  1L, 0L, 1L, 1L), race = c(2L, 6L, 4L, 4L, 4L), sex = c(0L, 1L, 
  1L, 0L, 1L), height = c(5, 6, 180, 165, 193.04), weight = c(1L, 
  1L, 80L, 54L, 104L), bmi = c(400, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
  "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
  "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
  ), demographics_complete = c(2L, 2L, 2L, 2L, 2L)), .Names = c("record_id", 
  "first_name", "last_name", "address", "telephone", "email", "dob", 
  "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
  "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, 
  -5L))
dsToWrite$age <- NULL; dsToWrite$bmi <- NULL #Drop the calculated fields
# dsToWrite <- dsToWrite[1:3, ]
# result <- REDCapR::redcap_write_oneshot(ds=dsToWrite, redcap_uri="https://bbmc.ouhsc.edu/redcap/api/", token = "9A81268476645C4E5F03428B8AC3AA7B")

con <-  base::textConnection(object='csvElements', open='w', local=TRUE)
write.csv(dsToWrite, con, row.names = FALSE, na="")  
close(con)

csv <- paste(csvElements, collapse="\n")
csvForPostman <- gsub(pattern="[\\]", replacement="", x=csv)
csvForPostman

post_body <- list(
  token = token,
  content = 'record',
  format = 'csv',
  type = 'flat',
  rawOrLabel = raw_or_label,
  exportDataAccessGroups = export_data_access_groups_string,
  records = records_collapsed,
  fields = fields_collapsed,
  
  #These next values separate the import from the export API call
  data = csv,
  overwriteBehavior = 'overwrite', #overwriteBehavior: *normal* - blank/empty values will be ignored [default]; *overwrite* - blank/empty values are valid and will overwrite data
  returnContent = 'ids',
  returnFormat = 'csv'  
)

result <- httr::POST(
  url = redcap_uri,
  body = post_body,
  .opts = curl_options #RCurl::curlOptions(ssl.verifypeer = FALSE)
)
result

status_code <- result$status_code
status_message <- result$headers$statusmessage
return_content <- httr::content(result, type="text")

# returnContent <- RCurl::postForm(
#   uri = redcap_uri, 
#   token = token,
#   content = 'record',
#   format = 'csv', 
#   type = 'flat', 
#   returnContent = "ids",
#   overwriteBehavior = 'overwrite', #overwriteBehavior: *normal* - blank/empty values will be ignored [default]; *overwrite* - blank/empty values are valid and will overwrite data
#   data = csv,
#   .opts = curl_options
# )
