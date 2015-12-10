rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
library(RCurl)
library(httr)

redcap_uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B"


# curl_options <- RCurl::curlOptions(ssl.verifypeer = FALSE)
# curl_options <- RCurl::curlOptions(cainfo = "./inst/ssl-certs/mozilla-ca-root.crt", sslversion=3)
curl_options <- list(cainfo = system.file("cacert.pem", package = "httr"))

raw_text2 <- RCurl::postForm(
  uri = redcap_uri
  , token = token
  , content = 'record'
  , format = 'csv'
  , type = 'flat'
  , .opts = curl_options
)
raw_text2

#Returns
#     [1] "record_id,name_first,name_last,address,telephone,email,dob,age,ethnicity,race,sex,height,weight,bmi,comments,demographics_complete\n\"1\",\"Nutmeg\",\"Nutmouse\",\"14 Rose Cottage St.\r\nKenning UK, 323232\",\"(432) 456-4848\",\"nutty@mouse.com\",\"2003-08-30\",10,1,2,0,5,1,400,\"Character in a book, with some guessing\",2\n\"2\",\"Tumtum\",\"Nutmouse\",\"14 Rose Cottage Blvd.\r\nKenning UK 34243\",\"(234) 234-2343\",\"tummy@mouse.comm\",\"2003-03-10\",11,1,6,1,6,1,277.8,\"A mouse character from a good book\",2\n\"3\",\"Marcus\",\"Wood\",\"243 Hill St.\r\nGuthrie OK 73402\",\"(433) 435-9865\",\"mw@mwood.net\",\"1934-04-09\",79,0,4,1,180,80,24.7,\"completely made up\",2\n\"4\",\"Trudy\",\"DAG\",\"342 Elm\r\nDuncanville TX, 75116\",\"(987) 654-3210\",\"peroxide@blonde.com\",\"1952-11-02\",61,1,4,0,165,54,19.8,\"This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail\",2\n\"5\",\"John Lee\",\"Walker\",\"Hotel Suite\r\nNew Orleans LA, 70115\",\"(333) 333-4444\",\"left@hippocket.com\",\"1955-04-15\",58,1,4,1,193.04,104,27.9,\"Had a hand for trouble and a eye for cash\r\n\r\nHe had a gold watch chain and a black mustache\",2\n"
#     attr(,"Content-Type")
#     charset 
#     "text/html"     "utf-8" 

raw_text <- httr::POST(
  url = redcap_uri
  , body = list(
    token = token
    , content = 'record'
    , format = 'csv'
    , type = 'flat'
  ),
  #, .opts = RCurl::curlOptions(ssl.verifypeer = FALSE)
  , .opts = curl_options
  , httr::verbose()
)
raw_text

#Returns
#     Error in function (type, msg, asError = TRUE)  : 
#       Unknown SSL protocol error in connection to bbmc.ouhsc.edu:443 