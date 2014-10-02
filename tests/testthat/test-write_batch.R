library(testthat)

###########
context("WriteBatch")
###########
test_that("Smoke Test", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project
})

test_that("Write Batch -Insert", {  
  testthat::skip(message = "Skipping test to address in a subsequent batch.")
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project
  
  expected_outcome_message <- "5 records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  
  #Remove the calculated fields
  returned_object$data$bmi <- NULL
  returned_object$data$age <- NULL
  
  expected_data_frame <- structure(list(record_id = 1:5, first_name = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), last_name = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(432) 456-4848", "(234) 234-2343", "(433) 435-9865", 
    "(987) 654-3210", "(333) 333-4444"), email = c("nutty@mouse.com", 
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
    "1955-04-15"), ethnicity = c(1L, 1L, 0L, 1L, 1L), race = c(2L, 
    6L, 4L, 4L, 4L), sex = c(0L, 1L, 1L, 0L, 1L), height = c(5, 6, 
    180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ),mugshot = c("[document]", "[document]", "[document]", "[document]", "[document]"), demographics_complete = c(2L, 
    2L, 2L, 2L, 2L)), .Names = c("record_id", "first_name", "last_name", 
    "address", "telephone", "email", "dob", "ethnicity", "race", 
    "sex", "height", "weight", "comments", "mugshot", "demographics_complete"
    ), row.names = c(NA, -5L), class = "data.frame")
    
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") #returned_object$data$bmi<-NULL; returned_object$data$age<-NULL;dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("Write Batch -Update One Field", {
  testthat::skip(message = "Skipping test to address in a subsequent batch.")
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project
  
  expected_outcome_message <- "5 records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object1 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  #Remove the calculated fields
  returned_object1$data$bmi <- NULL
  returned_object1$data$age <- NULL
  
  #Change some values
  returned_object1$data$address <- 1000 + seq_len(nrow(returned_object1$data))
  REDCapR::redcap_write(ds=returned_object1$data, redcap_uri=project$redcap_uri, token=project$token)
  
  expected_outcome_message <- "5 records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object2 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )  
  #Remove the calculated fields
  returned_object2$data$bmi <- NULL
  returned_object2$data$age <- NULL
  
  expected_data_frame <- structure(list(record_id = 1:5, first_name = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), last_name = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = 1001:1005, telephone = c("(432) 456-4848", 
    "(234) 234-2343", "(433) 435-9865", "(987) 654-3210", "(333) 333-4444"
    ), email = c("nutty@mouse.com", "tummy@mouse.comm", "mw@mwood.net", 
    "peroxide@blonde.com", "left@hippocket.com"), dob = c("2003-08-30", 
    "2003-03-10", "1934-04-09", "1952-11-02", "1955-04-15"), ethnicity = c(1L, 
    1L, 0L, 1L, 1L), race = c(2L, 6L, 4L, 4L, 4L), sex = c(0L, 1L, 
    1L, 0L, 1L), height = c(5, 6, 180, 165, 193.04), weight = c(1L, 
    1L, 80L, 54L, 104L), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ),mugshot = c("[document]", "[document]", "[document]", "[document]", "[document]"), demographics_complete = c(2L, 
    2L, 2L, 2L, 2L)), .Names = c("record_id", "first_name", "last_name", 
    "address", "telephone", "email", "dob", "ethnicity", "race", 
    "sex", "height", "weight", "comments", "mugshot", "demographics_complete"
    ), row.names = c(NA, -5L), class = "data.frame")

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected=200L)
  expect_equivalent(returned_object2$raw_text, expected="") # dput(returned_object2$raw_text)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
})

test_that("Write Batch -Update Two Fields", {
  testthat::skip(message = "Skipping test to address in a subsequent batch.")
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project
  
  expected_outcome_message <- "5 records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object1 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  #Remove the calculated fields
  returned_object1$data$bmi <- NULL
  returned_object1$data$age <- NULL
  
  #Change some values
  returned_object1$data$address <- 1000 + seq_len(nrow(returned_object1$data))
  returned_object1$data$telephone <- sprintf("(405) 321-%1$i%1$i%1$i%1$i", seq_len(nrow(returned_object1$data)))
  REDCapR::redcap_write(ds=returned_object1$data, redcap_uri=project$redcap_uri, token=project$token)
  
  expected_outcome_message <- "5 records and 17 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object2 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )  
  #Remove the calculated fields
  returned_object2$data$bmi <- NULL
  returned_object2$data$age <- NULL
  
  expected_data_frame <- structure(list(record_id = 1:5, first_name = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), last_name = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = 1001:1005, telephone = c("(405) 321-1111", 
    "(405) 321-2222", "(405) 321-3333", "(405) 321-4444", "(405) 321-5555"
    ), email = c("nutty@mouse.com", "tummy@mouse.comm", "mw@mwood.net", 
    "peroxide@blonde.com", "left@hippocket.com"), dob = c("2003-08-30", 
    "2003-03-10", "1934-04-09", "1952-11-02", "1955-04-15"), ethnicity = c(1L, 
    1L, 0L, 1L, 1L), race = c(2L, 6L, 4L, 4L, 4L), sex = c(0L, 1L, 
    1L, 0L, 1L), height = c(5, 6, 180, 165, 193.04), weight = c(1L, 
    1L, 80L, 54L, 104L), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ),mugshot = c("[document]", "[document]", "[document]", "[document]", "[document]"), demographics_complete = c(2L, 
    2L, 2L, 2L, 2L)), .Names = c("record_id", "first_name", "last_name", 
    "address", "telephone", "email", "dob", "ethnicity", "race", 
    "sex", "height", "weight", "comments", "mugshot", "demographics_complete"
    ), row.names = c(NA, -5L), class = "data.frame")

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected=200L)
  expect_equivalent(returned_object2$raw_text, expected="") # dput(returned_object2$raw_text)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
})
