require(testthat)

###########
context("ReadBatch")
###########
uri <- "https://bbmc.ouhsc.edu/redcap/redcap_v5.2.3/API/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `UnitTestPhiFree` account

test_that("Smoke Test", {  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, verbose=T)    
  )
})

test_that("All Records -Default", {  
  expected_data_frame <- structure(list(record_id = 1:5, first_name = c("Nutmeg", "Tumtum", 
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
    "Had a hand for trouble and a eye for cash\nHe had a gold watch chain and a black mustache\n\nhttps://www.youtube.com/watch?v=DUESvITrvsI"
    ), demographics_complete = c(2L, 2L, 2L, 2L, 2L)), .Names = c("record_id", 
    "first_name", "last_name", "address", "telephone", "email", "dob", 
    "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
    "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, 
    -5L))
  expected_csv <- structure("record_id,first_name,last_name,address,telephone,email,dob,age,ethnicity,race,sex,height,weight,bmi,comments,demographics_complete\n\"1\",\"Nutmeg\",\"Nutmouse\",\"14 Rose Cottage St.\r\nKenning UK, 323232\",\"(432) 456-4848\",\"nutty@mouse.com\",\"2003-08-30\",10,1,2,0,5,1,400,\"Character in a book, with some guessing\",2\n\"2\",\"Tumtum\",\"Nutmouse\",\"14 Rose Cottage Blvd.\r\nKenning UK 34243\",\"(234) 234-2343\",\"tummy@mouse.comm\",\"2003-03-10\",10,1,6,1,6,1,277.8,\"A mouse character from a good book\",2\n\"3\",\"Marcus\",\"Wood\",\"243 Hill St.\r\nGuthrie OK 73402\",\"(433) 435-9865\",\"mw@mwood.net\",\"1934-04-09\",79,0,4,1,180,80,24.7,\"completely made up\",2\n\"4\",\"Trudy\",\"DAG\",\"342 Elm\r\nDuncanville TX, 75116\",\"(987) 654-3210\",\"peroxide@blonde.com\",\"1952-11-02\",61,1,4,0,165,54,19.8,\"This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail\",2\n\"5\",\"John Lee\",\"Walker\",\"Hotel Suite\r\nNew Orleans LA, 70115\",\"(333) 333-4444\",\"left@hippocket.com\",\"1955-04-15\",58,1,4,1,193.04,104,27.9,\"Had a hand for trouble and a eye for cash\r\nHe had a gold watch chain and a black mustache\r\n\r\nhttps://www.youtube.com/watch?v=DUESvITrvsI\",2\n", "`Content-Type`" = structure(c("text/html", "utf-8"), .Names = c("", "charset")))
  expected_status_message <- "5 records and 16 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, verbose=T),
    regexp = expected_status_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equivalent(returned_object$raw_csv, expected=expected_csv) # dput(returned_object$raw_csv)
  expect_true(is.null(returned_object$records_collapsed), "A subset of records was not requested.")
  expect_true(is.null(returned_object$fields_collapsed), "A subset of fields was not requested.")
  expect_match(returned_object$status_message, regexp=expected_status_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("All Records -Raw", {  
  expected_data_frame <- structure(list(record_id = 1:5, first_name = c("Nutmeg", "Tumtum", 
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
    "Had a hand for trouble and a eye for cash\nHe had a gold watch chain and a black mustache\n\nhttps://www.youtube.com/watch?v=DUESvITrvsI"
    ), demographics_complete = c(2L, 2L, 2L, 2L, 2L)), .Names = c("record_id", 
    "first_name", "last_name", "address", "telephone", "email", "dob", 
    "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
    "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, 
    -5L))
  expected_csv <- structure("record_id,first_name,last_name,address,telephone,email,dob,age,ethnicity,race,sex,height,weight,bmi,comments,demographics_complete\n\"1\",\"Nutmeg\",\"Nutmouse\",\"14 Rose Cottage St.\r\nKenning UK, 323232\",\"(432) 456-4848\",\"nutty@mouse.com\",\"2003-08-30\",10,1,2,0,5,1,400,\"Character in a book, with some guessing\",2\n\"2\",\"Tumtum\",\"Nutmouse\",\"14 Rose Cottage Blvd.\r\nKenning UK 34243\",\"(234) 234-2343\",\"tummy@mouse.comm\",\"2003-03-10\",10,1,6,1,6,1,277.8,\"A mouse character from a good book\",2\n\"3\",\"Marcus\",\"Wood\",\"243 Hill St.\r\nGuthrie OK 73402\",\"(433) 435-9865\",\"mw@mwood.net\",\"1934-04-09\",79,0,4,1,180,80,24.7,\"completely made up\",2\n\"4\",\"Trudy\",\"DAG\",\"342 Elm\r\nDuncanville TX, 75116\",\"(987) 654-3210\",\"peroxide@blonde.com\",\"1952-11-02\",61,1,4,0,165,54,19.8,\"This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail\",2\n\"5\",\"John Lee\",\"Walker\",\"Hotel Suite\r\nNew Orleans LA, 70115\",\"(333) 333-4444\",\"left@hippocket.com\",\"1955-04-15\",58,1,4,1,193.04,104,27.9,\"Had a hand for trouble and a eye for cash\r\nHe had a gold watch chain and a black mustache\r\n\r\nhttps://www.youtube.com/watch?v=DUESvITrvsI\",2\n", "`Content-Type`" = structure(c("text/html", "utf-8"), .Names = c("", "charset")))
  expected_status_message <- "5 records and 16 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
    regexp = expected_status_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equivalent(returned_object$raw_csv, expected=expected_csv) # dput(returned_object$raw_csv)
  expect_true(is.null(returned_object$records_collapsed), "A subset of records was not requested.")
  expect_true(is.null(returned_object$fields_collapsed), "A subset of fields was not requested.")
  expect_match(returned_object$status_message, regexp=expected_status_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("All Records -Raw", {  
  expected_data_frame <-structure(list(record_id = 1:5, redcap_data_access_group = c("dag_1", 
    "dag_1", "dag_1", "", "dag_2"), first_name = c("Nutmeg", "Tumtum", 
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
    "Had a hand for trouble and a eye for cash\nHe had a gold watch chain and a black mustache\n\nhttps://www.youtube.com/watch?v=DUESvITrvsI"
    ), demographics_complete = c(2L, 2L, 2L, 2L, 2L)), .Names = c("record_id", 
    "redcap_data_access_group", "first_name", "last_name", "address", 
    "telephone", "email", "dob", "age", "ethnicity", "race", "sex", 
    "height", "weight", "bmi", "comments", "demographics_complete"
    ), class = "data.frame", row.names = c(NA, -5L))
  expected_csv <- structure("record_id,redcap_data_access_group,first_name,last_name,address,telephone,email,dob,age,ethnicity,race,sex,height,weight,bmi,comments,demographics_complete\n\"1\",\"dag_1\",\"Nutmeg\",\"Nutmouse\",\"14 Rose Cottage St.\r\nKenning UK, 323232\",\"(432) 456-4848\",\"nutty@mouse.com\",\"2003-08-30\",10,1,2,0,5,1,400,\"Character in a book, with some guessing\",2\n\"2\",\"dag_1\",\"Tumtum\",\"Nutmouse\",\"14 Rose Cottage Blvd.\r\nKenning UK 34243\",\"(234) 234-2343\",\"tummy@mouse.comm\",\"2003-03-10\",10,1,6,1,6,1,277.8,\"A mouse character from a good book\",2\n\"3\",\"dag_1\",\"Marcus\",\"Wood\",\"243 Hill St.\r\nGuthrie OK 73402\",\"(433) 435-9865\",\"mw@mwood.net\",\"1934-04-09\",79,0,4,1,180,80,24.7,\"completely made up\",2\n\"4\",\"\",\"Trudy\",\"DAG\",\"342 Elm\r\nDuncanville TX, 75116\",\"(987) 654-3210\",\"peroxide@blonde.com\",\"1952-11-02\",61,1,4,0,165,54,19.8,\"This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail\",2\n\"5\",\"dag_2\",\"John Lee\",\"Walker\",\"Hotel Suite\r\nNew Orleans LA, 70115\",\"(333) 333-4444\",\"left@hippocket.com\",\"1955-04-15\",58,1,4,1,193.04,104,27.9,\"Had a hand for trouble and a eye for cash\r\nHe had a gold watch chain and a black mustache\r\n\r\nhttps://www.youtube.com/watch?v=DUESvITrvsI\",2\n", "`Content-Type`" = structure(c("text/html", "utf-8"), .Names = c("", "charset")))
  expected_status_message <- "5 records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, raw_or_label="raw", export_data_access_groups="true", verbose=T),
    regexp = expected_status_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equivalent(returned_object$raw_csv, expected=expected_csv) # dput(returned_object$raw_csv)
  expect_true(is.null(returned_object$records_collapsed), "A subset of records was not requested.")
  expect_true(is.null(returned_object$fields_collapsed), "A subset of fields was not requested.")
  expect_match(returned_object$status_message, regexp=expected_status_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("All Records -label and DAG", {  
  expected_data_frame <- structure(list(record_id = 1:5, redcap_data_access_group = c("dag_1", 
    "dag_1", "dag_1", "", "dag_2"), first_name = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), last_name = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(432) 456-4848", "(234) 234-2343", "(433) 435-9865", 
    "(987) 654-3210", "(333) 333-4444"), email = c("nutty@mouse.com", 
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
    "1955-04-15"), age = c(10L, 10L, 79L, 61L, 58L), ethnicity = c("NOT Hispanic or Latino", 
    "NOT Hispanic or Latino", "Hispanic or Latino", "NOT Hispanic or Latino", 
    "NOT Hispanic or Latino"), race = c("Native Hawaiian or Other Pacific Islander", 
    "Unknown / Not Reported", "White", "White", "White"), sex = c("Female", 
    "Male", "Male", "Female", "Male"), height = c(5, 6, 180, 165, 
    193.04), weight = c(1L, 1L, 80L, 54L, 104L), bmi = c(400, 277.8, 
    24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\nHe had a gold watch chain and a black mustache\n\nhttps://www.youtube.com/watch?v=DUESvITrvsI"
    ), demographics_complete = c("Complete", "Complete", "Complete", 
    "Complete", "Complete")), .Names = c("record_id", "redcap_data_access_group", 
    "first_name", "last_name", "address", "telephone", "email", "dob", 
    "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
    "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             -5L))
  expected_csv <- structure("record_id,redcap_data_access_group,first_name,last_name,address,telephone,email,dob,age,ethnicity,race,sex,height,weight,bmi,comments,demographics_complete\n\"1\",\"dag_1\",\"Nutmeg\",\"Nutmouse\",\"14 Rose Cottage St.\r\nKenning UK, 323232\",\"(432) 456-4848\",\"nutty@mouse.com\",\"2003-08-30\",10,\"NOT Hispanic or Latino\",\"Native Hawaiian or Other Pacific Islander\",\"Female\",5,1,400,\"Character in a book, with some guessing\",\"Complete\"\n\"2\",\"dag_1\",\"Tumtum\",\"Nutmouse\",\"14 Rose Cottage Blvd.\r\nKenning UK 34243\",\"(234) 234-2343\",\"tummy@mouse.comm\",\"2003-03-10\",10,\"NOT Hispanic or Latino\",\"Unknown / Not Reported\",\"Male\",6,1,277.8,\"A mouse character from a good book\",\"Complete\"\n\"3\",\"dag_1\",\"Marcus\",\"Wood\",\"243 Hill St.\r\nGuthrie OK 73402\",\"(433) 435-9865\",\"mw@mwood.net\",\"1934-04-09\",79,\"Hispanic or Latino\",\"White\",\"Male\",180,80,24.7,\"completely made up\",\"Complete\"\n\"4\",\"\",\"Trudy\",\"DAG\",\"342 Elm\r\nDuncanville TX, 75116\",\"(987) 654-3210\",\"peroxide@blonde.com\",\"1952-11-02\",61,\"NOT Hispanic or Latino\",\"White\",\"Female\",165,54,19.8,\"This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail\",\"Complete\"\n\"5\",\"dag_2\",\"John Lee\",\"Walker\",\"Hotel Suite\r\nNew Orleans LA, 70115\",\"(333) 333-4444\",\"left@hippocket.com\",\"1955-04-15\",58,\"NOT Hispanic or Latino\",\"White\",\"Male\",193.04,104,27.9,\"Had a hand for trouble and a eye for cash\r\nHe had a gold watch chain and a black mustache\r\n\r\nhttps://www.youtube.com/watch?v=DUESvITrvsI\",\"Complete\"\n", "`Content-Type`" = structure(c("text/html", "utf-8"), .Names = c("", "charset")))
  expected_status_message <- "5 records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, raw_or_label="label", export_data_access_groups="true", verbose=T),
    regexp = expected_status_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equivalent(returned_object$raw_csv, expected=expected_csv) # dput(returned_object$raw_csv)
  expect_true(is.null(returned_object$records_collapsed), "A subset of records was not requested.")
  expect_true(is.null(returned_object$fields_collapsed), "A subset of fields was not requested.")
  expect_match(returned_object$status_message, regexp=expected_status_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("All Records -label", {  
  expected_data_frame <- structure(list(record_id = 1:5, first_name = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), last_name = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(432) 456-4848", "(234) 234-2343", "(433) 435-9865", 
    "(987) 654-3210", "(333) 333-4444"), email = c("nutty@mouse.com", 
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
    "1955-04-15"), age = c(10L, 10L, 79L, 61L, 58L), ethnicity = c("NOT Hispanic or Latino", 
    "NOT Hispanic or Latino", "Hispanic or Latino", "NOT Hispanic or Latino", 
    "NOT Hispanic or Latino"), race = c("Native Hawaiian or Other Pacific Islander", 
    "Unknown / Not Reported", "White", "White", "White"), sex = c("Female", 
    "Male", "Male", "Female", "Male"), height = c(5, 6, 180, 165, 
    193.04), weight = c(1L, 1L, 80L, 54L, 104L), bmi = c(400, 277.8, 
    24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\nHe had a gold watch chain and a black mustache\n\nhttps://www.youtube.com/watch?v=DUESvITrvsI"
    ), demographics_complete = c("Complete", "Complete", "Complete", 
    "Complete", "Complete")), .Names = c("record_id", 
    "first_name", "last_name", "address", "telephone", "email", "dob", 
    "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
    "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, -5L))

  expected_csv <- structure("record_id,first_name,last_name,address,telephone,email,dob,age,ethnicity,race,sex,height,weight,bmi,comments,demographics_complete\n\"1\",\"Nutmeg\",\"Nutmouse\",\"14 Rose Cottage St.\r\nKenning UK, 323232\",\"(432) 456-4848\",\"nutty@mouse.com\",\"2003-08-30\",10,\"NOT Hispanic or Latino\",\"Native Hawaiian or Other Pacific Islander\",\"Female\",5,1,400,\"Character in a book, with some guessing\",\"Complete\"\n\"2\",\"Tumtum\",\"Nutmouse\",\"14 Rose Cottage Blvd.\r\nKenning UK 34243\",\"(234) 234-2343\",\"tummy@mouse.comm\",\"2003-03-10\",10,\"NOT Hispanic or Latino\",\"Unknown / Not Reported\",\"Male\",6,1,277.8,\"A mouse character from a good book\",\"Complete\"\n\"3\",\"Marcus\",\"Wood\",\"243 Hill St.\r\nGuthrie OK 73402\",\"(433) 435-9865\",\"mw@mwood.net\",\"1934-04-09\",79,\"Hispanic or Latino\",\"White\",\"Male\",180,80,24.7,\"completely made up\",\"Complete\"\n\"4\",\"Trudy\",\"DAG\",\"342 Elm\r\nDuncanville TX, 75116\",\"(987) 654-3210\",\"peroxide@blonde.com\",\"1952-11-02\",61,\"NOT Hispanic or Latino\",\"White\",\"Female\",165,54,19.8,\"This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail\",\"Complete\"\n\"5\",\"John Lee\",\"Walker\",\"Hotel Suite\r\nNew Orleans LA, 70115\",\"(333) 333-4444\",\"left@hippocket.com\",\"1955-04-15\",58,\"NOT Hispanic or Latino\",\"White\",\"Male\",193.04,104,27.9,\"Had a hand for trouble and a eye for cash\r\nHe had a gold watch chain and a black mustache\r\n\r\nhttps://www.youtube.com/watch?v=DUESvITrvsI\",\"Complete\"\n", "`Content-Type`" = structure(c("text/html", "utf-8"), .Names = c("", "charset")))
  expected_status_message <- "5 records and 16 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, raw_or_label="label", export_data_access_groups="false", verbose=T),
    regexp = expected_status_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equivalent(returned_object$raw_csv, expected=expected_csv) # dput(returned_object$raw_csv)
  expect_true(is.null(returned_object$records_collapsed), "A subset of records was not requested.")
  expect_true(is.null(returned_object$fields_collapsed), "A subset of fields was not requested.")
  expect_match(returned_object$status_message, regexp=expected_status_message, perl=TRUE)
  expect_true(returned_object$success)
})
