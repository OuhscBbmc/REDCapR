library(testthat)
context("Read Batch - Simple")

credential <- REDCapR::retrieve_credential_local(
  path_credential = base::file.path(devtools::inst(name="REDCapR"), "misc/example.credentials"),
  project_id      = 153
)
project <- redcap_project$new(redcap_uri=credential$redcap_uri, token=credential$token)

test_that("Smoke Test", {  
  testthat::skip_on_cran()
  
  #Static method w/ default batch size
  expect_message(
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)    
  )  
  
  #Static method w/ tiny batch size
  expect_message(
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T, batch_size=2)    
  )
  
  #Instance method w/ default batch size
  expect_message(
    returned_object <- project$read()
  )  
  
  #Instance method w/ tiny batch size
  expect_message(
    returned_object <- project$read(batch_size=2)
  )
})
test_that("All Records -Default", {   
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333", 
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com", 
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
    "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L, 
    1L, 1L, 0L, 1L), demographics_complete = c(2L, 2L, 2L, 2L, 2L
    ), height = c(7, 6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 
    54L, 104L), bmi = c(204.1, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]", "[document]", 
    "[document]"), health_complete = c(1L, 0L, 2L, 2L, 0L), race___1 = c(0L, 
    0L, 0L, 0L, 1L), race___2 = c(0L, 0L, 0L, 1L, 0L), race___3 = c(0L, 
    1L, 0L, 0L, 0L), race___4 = c(0L, 0L, 1L, 0L, 0L), race___5 = c(1L, 
    1L, 1L, 1L, 0L), race___6 = c(0L, 0L, 0L, 0L, 1L), ethnicity = c(1L, 
    1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L, 0L, 2L, 2L, 
    2L)), .Names = c("record_id", "name_first", "name_last", "address", 
    "telephone", "email", "dob", "age", "sex", "demographics_complete", 
    "height", "weight", "bmi", "comments", "mugshot", "health_complete", 
    "race___1", "race___2", "race___3", "race___4", "race___5", 
    "race___6", "ethnicity", "race_and_ethnicity_complete"), class = "data.frame", row.names = c(NA, 
    -5L))
  expected_outcome_message <- "\\d+ records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)
  )  
  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)  
  
  ###########################
  ## Tiny Batch size
  expect_message(
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T, batch_size=2),
    regexp = expected_outcome_message
  )
  
  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object2$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("All Records -Raw", {   
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333", 
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com", 
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
    "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L, 
    1L, 1L, 0L, 1L), demographics_complete = c(2L, 2L, 2L, 2L, 2L
    ), height = c(7, 6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 
    54L, 104L), bmi = c(204.1, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]", "[document]", 
    "[document]"), health_complete = c(1L, 0L, 2L, 2L, 0L), race___1 = c(0L, 
    0L, 0L, 0L, 1L), race___2 = c(0L, 0L, 0L, 1L, 0L), race___3 = c(0L, 
    1L, 0L, 0L, 0L), race___4 = c(0L, 0L, 1L, 0L, 0L), race___5 = c(1L, 
    1L, 1L, 1L, 0L), race___6 = c(0L, 0L, 0L, 0L, 1L), ethnicity = c(1L, 
    1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L, 0L, 2L, 2L, 
    2L)), .Names = c("record_id", "name_first", "name_last", "address", 
    "telephone", "email", "dob", "age", "sex", "demographics_complete", 
    "height", "weight", "bmi", "comments", "mugshot", "health_complete", 
    "race___1", "race___2", "race___3", "race___4", "race___5", 
    "race___6", "ethnicity", "race_and_ethnicity_complete"), class = "data.frame", row.names = c(NA, 
    -5L))
  expected_outcome_message <- "\\d+ records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)
  )  
  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)  
  
  ###########################
  ## Tiny Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T, batch_size=2)
  )
  
  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object2$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("All Records -Raw and DAG", {   
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, redcap_data_access_group = c("dag_1", 
    "dag_1", "dag_1", "", "dag_2"), name_first = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333", 
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com", 
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
    "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L, 
    1L, 1L, 0L, 1L), demographics_complete = c(2L, 2L, 2L, 2L, 2L
    ), height = c(7, 6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 
    54L, 104L), bmi = c(204.1, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]", "[document]", 
    "[document]"), health_complete = c(1L, 0L, 2L, 2L, 0L), race___1 = c(0L, 
    0L, 0L, 0L, 1L), race___2 = c(0L, 0L, 0L, 1L, 0L), race___3 = c(0L, 
    1L, 0L, 0L, 0L), race___4 = c(0L, 0L, 1L, 0L, 0L), race___5 = c(1L, 
    1L, 1L, 1L, 0L), race___6 = c(0L, 0L, 0L, 0L, 1L), ethnicity = c(1L, 
    1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L, 0L, 2L, 2L, 
    2L)), .Names = c("record_id", "redcap_data_access_group", "name_first", 
    "name_last", "address", "telephone", "email", "dob", "age", "sex", 
    "demographics_complete", "height", "weight", "bmi", "comments", 
    "mugshot", "health_complete", "race___1", "race___2", "race___3", 
    "race___4", "race___5", "race___6", "ethnicity", "race_and_ethnicity_complete"
    ), class = "data.frame", row.names = c(NA, -5L))
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", export_data_access_groups=TRUE, verbose=T)
  )  
  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)  
  
  ###########################
  ## Tiny Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", export_data_access_groups=TRUE, verbose=T, batch_size=2)
  )
  
  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object2$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})
test_that("All Records -label and DAG -one single batch", {   
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, redcap_data_access_group = c("dag_1", 
    "dag_1", "dag_1", "", "dag_2"), name_first = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333", 
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com", 
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
    "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c("Female", 
    "Male", "Male", "Female", "Male"), demographics_complete = c("Complete", 
    "Complete", "Complete", "Complete", "Complete"), height = c(7, 
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L), bmi = c(204.1, 
    277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]", "[document]", 
    "[document]"), health_complete = c("Unverified", "Incomplete", 
    "Complete", "Complete", "Incomplete"), race___1 = c("Unchecked", 
    "Unchecked", "Unchecked", "Unchecked", "Checked"), race___2 = c("Unchecked", 
    "Unchecked", "Unchecked", "Checked", "Unchecked"), race___3 = c("Unchecked", 
    "Checked", "Unchecked", "Unchecked", "Unchecked"), race___4 = c("Unchecked", 
    "Unchecked", "Checked", "Unchecked", "Unchecked"), race___5 = c("Checked", 
    "Checked", "Checked", "Checked", "Unchecked"), race___6 = c("Unchecked", 
    "Unchecked", "Unchecked", "Unchecked", "Checked"), ethnicity = c("NOT Hispanic or Latino", 
    "NOT Hispanic or Latino", "Unknown / Not Reported", "NOT Hispanic or Latino", 
    "Hispanic or Latino"), race_and_ethnicity_complete = c("Complete", 
    "Incomplete", "Complete", "Complete", "Complete")), .Names = c("record_id", 
    "redcap_data_access_group", "name_first", "name_last", "address", 
    "telephone", "email", "dob", "age", "sex", "demographics_complete", 
    "height", "weight", "bmi", "comments", "mugshot", "health_complete", 
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6", 
    "ethnicity", "race_and_ethnicity_complete"), class = "data.frame", row.names = c(NA, 
    -5L))
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=TRUE, verbose=T)
  )  
  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)  
})
test_that("All Records -label and DAG -three tiny batches", {   
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, redcap_data_access_group = c("dag_1", 
    "dag_1", "dag_1", "", "dag_2"), name_first = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333", 
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com", 
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
    "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c("Female", 
    "Male", "Male", "Female", "Male"), demographics_complete = c("Complete", 
    "Complete", "Complete", "Complete", "Complete"), height = c(7, 
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L), bmi = c(204.1, 
    277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]", "[document]", 
    "[document]"), health_complete = c("Unverified", "Incomplete", 
    "Complete", "Complete", "Incomplete"), race___1 = c("Unchecked", 
    "Unchecked", "Unchecked", "Unchecked", "Checked"), race___2 = c("Unchecked", 
    "Unchecked", "Unchecked", "Checked", "Unchecked"), race___3 = c("Unchecked", 
    "Checked", "Unchecked", "Unchecked", "Unchecked"), race___4 = c("Unchecked", 
    "Unchecked", "Checked", "Unchecked", "Unchecked"), race___5 = c("Checked", 
    "Checked", "Checked", "Checked", "Unchecked"), race___6 = c("Unchecked", 
    "Unchecked", "Unchecked", "Unchecked", "Checked"), ethnicity = c("NOT Hispanic or Latino", 
    "NOT Hispanic or Latino", "Unknown / Not Reported", "NOT Hispanic or Latino", 
    "Hispanic or Latino"), race_and_ethnicity_complete = c("Complete", 
    "Incomplete", "Complete", "Complete", "Complete")), .Names = c("record_id", 
    "redcap_data_access_group", "name_first", "name_last", "address", 
    "telephone", "email", "dob", "age", "sex", "demographics_complete", 
    "height", "weight", "bmi", "comments", "mugshot", "health_complete", 
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6", 
    "ethnicity", "race_and_ethnicity_complete"), class = "data.frame", row.names = c(NA, 
    -5L))
  expected_outcome_message <- "\\d+ records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=TRUE, verbose=T, batch_size=2)
  )  
  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object2$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)  
})
test_that("All Records -label", {   
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum", 
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse", 
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333", 
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com", 
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
    "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c("Female", 
    "Male", "Male", "Female", "Male"), demographics_complete = c("Complete", 
    "Complete", "Complete", "Complete", "Complete"), height = c(7, 
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L), bmi = c(204.1, 
    277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]", "[document]", 
    "[document]"), health_complete = c("Unverified", "Incomplete", 
    "Complete", "Complete", "Incomplete"), race___1 = c("Unchecked", 
    "Unchecked", "Unchecked", "Unchecked", "Checked"), race___2 = c("Unchecked", 
    "Unchecked", "Unchecked", "Checked", "Unchecked"), race___3 = c("Unchecked", 
    "Checked", "Unchecked", "Unchecked", "Unchecked"), race___4 = c("Unchecked", 
    "Unchecked", "Checked", "Unchecked", "Unchecked"), race___5 = c("Checked", 
    "Checked", "Checked", "Checked", "Unchecked"), race___6 = c("Unchecked", 
    "Unchecked", "Unchecked", "Unchecked", "Checked"), ethnicity = c("NOT Hispanic or Latino", 
    "NOT Hispanic or Latino", "Unknown / Not Reported", "NOT Hispanic or Latino", 
    "Hispanic or Latino"), race_and_ethnicity_complete = c("Complete", 
    "Incomplete", "Complete", "Complete", "Complete")), .Names = c("record_id", 
    "name_first", "name_last", "address", "telephone", "email", "dob", 
    "age", "sex", "demographics_complete", "height", "weight", "bmi", 
    "comments", "mugshot", "health_complete", "race___1", "race___2", 
    "race___3", "race___4", "race___5", "race___6", "ethnicity", 
    "race_and_ethnicity_complete"), class = "data.frame", row.names = c(NA, 
    -5L))

  
  expected_outcome_message <- "\\d+ records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  ###########################
  ## Default Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object1 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=FALSE, verbose=T)
  )  
  expect_equal(returned_object1$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object1$data)
  expect_true(returned_object1$success)
  expect_match(returned_object1$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object1$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object1$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object1$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object1$outcome_messages, regexp=expected_outcome_message, perl=TRUE)  
  
  ###########################
  ## Tiny Batch size
  expect_message(
    regexp            = expected_outcome_message,
    returned_object2 <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=FALSE, verbose=T, batch_size=2)
  )

  expect_equal(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object2$data)
  expect_true(returned_object2$success)
  expect_match(returned_object2$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_messages, regexp=expected_outcome_message, perl=TRUE)
})

test_that("Filter - numeric", {  
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 3:4, name_first = c("Marcus", "Trudy"
    ), name_last = c("Wood", "DAG"), address = c("243 Hill St.\nGuthrie OK 73402", 
    "342 Elm\nDuncanville TX, 75116"), telephone = c("(405) 321-3333", 
    "(405) 321-4444"), email = c("mw@mwood.net", "peroxide@blonde.com"
    ), dob = c("1934-04-09", "1952-11-02"), age = c(80L, 61L), sex = c(1L, 
    0L), demographics_complete = c(2L, 2L), height = c(180L, 165L
    ), weight = c(80L, 54L), bmi = c(24.7, 19.8), comments = c("completely made up", 
    "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail"
    ), mugshot = c("[document]", "[document]"), health_complete = c(2L, 
    2L), race___1 = c(0L, 0L), race___2 = 0:1, race___3 = c(0L, 0L
    ), race___4 = c(1L, 0L), race___5 = c(1L, 1L), race___6 = c(0L, 
    0L), ethnicity = 0:1, race_and_ethnicity_complete = c(2L, 2L)), .Names = c("record_id", 
    "name_first", "name_last", "address", "telephone", "email", "dob", 
    "age", "sex", "demographics_complete", "height", "weight", "bmi", 
    "comments", "mugshot", "health_complete", "race___1", "race___2", 
    "race___3", "race___4", "race___5", "race___6", "ethnicity", 
    "race_and_ethnicity_complete"), class = "data.frame", row.names = c(NA, 
    -2L))

  expected_outcome_message <- "2 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  filter <- "[age] >= 61"
  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T, filter_logic=filter)
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, filter, "The filter was not correct.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("Filter - character", {  
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 5L, name_first = "John Lee", name_last = "Walker", 
    address = "Hotel Suite\nNew Orleans LA, 70115", telephone = "(405) 321-5555", 
    email = "left@hippocket.com", dob = "1955-04-15", age = 59L, 
    sex = 1L, demographics_complete = 2L, height = 193.04, weight = 104L, 
    bmi = 27.9, comments = "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache", 
    mugshot = "[document]", health_complete = 0L, race___1 = 1L, 
    race___2 = 0L, race___3 = 0L, race___4 = 0L, race___5 = 0L, 
    race___6 = 1L, ethnicity = 2L, race_and_ethnicity_complete = 2L), .Names = c("record_id", 
    "name_first", "name_last", "address", "telephone", "email", "dob", 
    "age", "sex", "demographics_complete", "height", "weight", "bmi", 
    "comments", "mugshot", "health_complete", "race___1", "race___2", 
    "race___3", "race___4", "race___5", "race___6", "ethnicity", 
    "race_and_ethnicity_complete"), class = "data.frame", row.names = c(NA, 
    -1L))

  expected_outcome_message <- "1 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  filter <- "[name_first] = 'John Lee'"
  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T, filter_logic=filter)
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_match(returned_object$status_codes, regexp="200", perl=TRUE)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, filter, "The filter was not correct.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success) 
})
