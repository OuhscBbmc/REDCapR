library(testthat)

###########
context("ReadBatch")
###########
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `UnitTestPhiFree` account
project <- redcap_project$new(redcap_uri=uri, token=token)

test_that("Smoke Test", {  
  #Static method
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, verbose=T)    
  )
  
  #Instance method
  expect_message(
    returned_object <- project$read()
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
    "1955-04-15"), age = c(10L, 11L, 79L, 61L, 58L), ethnicity = c(1L, 
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
  expected_outcome_message <- "\\d+ records and 16 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, verbose=T),
    regexp = expected_outcome_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  # expect_equal(dsToWrite, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  # expect_match(returned_object$status_messages, regexp="OK", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
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
    "1955-04-15"), age = c(10L, 11L, 79L, 61L, 58L), ethnicity = c(1L, 
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
  expected_outcome_message <- "\\d+ records and 16 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
    regexp = expected_outcome_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  # expect_match(returned_object$status_messages, regexp="OK", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
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
    "1955-04-15"), age = c(10L, 11L, 79L, 61L, 58L), ethnicity = c(1L, 
    1L, 0L, 1L, 1L), race = c(2L, 6L, 4L, 4L, 4L), sex = c(0L, 1L, 
    1L, 0L, 1L), height = c(5, 6, 180, 165, 193.04), weight = c(1L, 
    1L, 80L, 54L, 104L), bmi = c(400, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), demographics_complete = c(2L, 2L, 2L, 2L, 2L)), .Names = c("record_id", 
    "redcap_data_access_group", "first_name", "last_name", "address", 
    "telephone", "email", "dob", "age", "ethnicity", "race", "sex", 
    "height", "weight", "bmi", "comments", "demographics_complete"
    ), class = "data.frame", row.names = c(NA, -5L))
  expected_outcome_message <- "\\d+ records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, raw_or_label="raw", export_data_access_groups="true", verbose=T),
    regexp = expected_outcome_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  # expect_match(returned_object$status_messages, regexp="OK", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
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
    "1955-04-15"), age = c(10L, 11L, 79L, 61L, 58L), ethnicity = c("NOT Hispanic or Latino", 
    "NOT Hispanic or Latino", "Hispanic or Latino", "NOT Hispanic or Latino", 
    "NOT Hispanic or Latino"), race = c("Native Hawaiian or Other Pacific Islander", 
    "Unknown / Not Reported", "White", "White", "White"), sex = c("Female", 
    "Male", "Male", "Female", "Male"), height = c(5, 6, 180, 165, 
    193.04), weight = c(1L, 1L, 80L, 54L, 104L), bmi = c(400, 277.8, 
    24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), demographics_complete = c("Complete", "Complete", "Complete", 
    "Complete", "Complete")), .Names = c("record_id", "redcap_data_access_group", 
    "first_name", "last_name", "address", "telephone", "email", "dob", 
    "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
    "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             -5L))
  expected_outcome_message <- "\\d+ records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, raw_or_label="label", export_data_access_groups="true", verbose=T),
    regexp = expected_outcome_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  # expect_match(returned_object$status_messages, regexp="OK", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
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
    "1955-04-15"), age = c(10L, 11L, 79L, 61L, 58L), ethnicity = c("NOT Hispanic or Latino", 
    "NOT Hispanic or Latino", "Hispanic or Latino", "NOT Hispanic or Latino", 
    "NOT Hispanic or Latino"), race = c("Native Hawaiian or Other Pacific Islander", 
    "Unknown / Not Reported", "White", "White", "White"), sex = c("Female", 
    "Male", "Male", "Female", "Male"), height = c(5, 6, 180, 165, 
    193.04), weight = c(1L, 1L, 80L, 54L, 104L), bmi = c(400, 277.8, 
    24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), demographics_complete = c("Complete", "Complete", "Complete", 
    "Complete", "Complete")), .Names = c("record_id", 
    "first_name", "last_name", "address", "telephone", "email", "dob", 
    "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
    "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, -5L))

  expected_outcome_message <- "\\d+ records and 16 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, raw_or_label="label", export_data_access_groups="false", verbose=T),
    regexp = expected_outcome_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  # expect_match(returned_object$status_messages, regexp="OK", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
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
    "1955-04-15"), age = c(10L, 11L, 79L, 61L, 58L), ethnicity = c(1L, 
    1L, 0L, 1L, 1L), race = c(2L, 6L, 4L, 4L, 4L), sex = c(0L, 1L, 
    1L, 0L, 1L), height = c(5, 6, 180, 165, 193.04), weight = c(1L, 
    1L, 80L, 54L, 104L), bmi = c(400, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), demographics_complete = c(2L, 2L, 2L, 2L, 2L)), .Names = c("record_id", 
    "first_name", "last_name", "address", "telephone", "email", "dob", 
    "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
    "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, -5L))
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, verbose=T, batch_size=2),
    regexp = expected_outcome_message
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_true(returned_object$success)
  expect_match(returned_object$status_codes, regexp="200; 200; 200", perl=TRUE)
  # expect_match(returned_object$status_messages, regexp="OK.*; OK.*; OK") #Sometimes the Status Message have line breaks appended at the end.
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})