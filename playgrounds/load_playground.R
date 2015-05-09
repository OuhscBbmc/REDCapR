library(testthat)

###########
context("Read Oneshot")
###########
uri <- "https://bbmc.ouhsc.edu/redcap/api/"
token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `UnitTestPhiFree` account on pid=153.


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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)


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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)


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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)


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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)


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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)


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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)

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

expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

expect_message(
  returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw", verbose=T),
  regexp = expected_outcome_message
)

expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
expect_equal(returned_object$status_code, expected=200L)
# expect_match(returned_object$status_message, regexp="^OK", perl=TRUE) #For some reason, thhe win-builder was returning "OK\r\n".  No other windows r-dev version were fine.
expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
expect_true(returned_object$success)
message(returned_object$elapsed_seconds)