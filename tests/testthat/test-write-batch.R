library(testthat)

test_that("Smoke Test", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project
})

test_that("Write Batch -Insert", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )

  #Remove the calculated fields
  returned_object$data$bmi <- NULL
  returned_object$data$age <- NULL

  expected_data_frame <- structure(
    list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = structure(c(12294, 12121, -13051, -6269, -5375), class = "Date"),
    sex = c(0L, 1L, 1L, 0L, 1L), demographics_complete = c(2L,
    2L, 2L, 2L, 2L), height = c(7, 6, 180, 165, 193.04), weight = c(1L,
    1L, 80L, 54L, 104L), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up",
    "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]",
    "[document]", "[document]"), health_complete = c(1L, 0L,
    2L, 2L, 0L), race___1 = c(0L, 0L, 0L, 0L, 1L), race___2 = c(0L,
    0L, 0L, 1L, 0L), race___3 = c(0L, 1L, 0L, 0L, 0L), race___4 = c(0L,
    0L, 1L, 0L, 0L), race___5 = c(1L, 1L, 1L, 1L, 0L), race___6 = c(0L,
    0L, 0L, 0L, 1L), ethnicity = c(1L, 1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L,
    0L, 2L, 2L, 2L)), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "sex", "demographics_complete",
    "height", "weight", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
    "ethnicity", "race_and_ethnicity_complete"), row.names = c(NA,
    -5L), spec = structure(list(cols = structure(list(record_id = structure(list(), class = c("collector_integer",
    "collector")), name_first = structure(list(), class = c("collector_character",
    "collector")), name_last = structure(list(), class = c("collector_character",
    "collector")), address = structure(list(), class = c("collector_character",
    "collector")), telephone = structure(list(), class = c("collector_character",
    "collector")), email = structure(list(), class = c("collector_character",
    "collector")), dob = structure(list(format = ""), .Names = "format", class = c("collector_date",
    "collector")), age = structure(list(), class = c("collector_integer",
    "collector")), sex = structure(list(), class = c("collector_integer",
    "collector")), demographics_complete = structure(list(), class = c("collector_integer",
    "collector")), height = structure(list(), class = c("collector_double",
    "collector")), weight = structure(list(), class = c("collector_integer",
    "collector")), bmi = structure(list(), class = c("collector_double",
    "collector")), comments = structure(list(), class = c("collector_character",
    "collector")), mugshot = structure(list(), class = c("collector_character",
    "collector")), health_complete = structure(list(), class = c("collector_integer",
    "collector")), race___1 = structure(list(), class = c("collector_integer",
    "collector")), race___2 = structure(list(), class = c("collector_integer",
    "collector")), race___3 = structure(list(), class = c("collector_integer",
    "collector")), race___4 = structure(list(), class = c("collector_integer",
    "collector")), race___5 = structure(list(), class = c("collector_integer",
    "collector")), race___6 = structure(list(), class = c("collector_integer",
    "collector")), ethnicity = structure(list(), class = c("collector_integer",
    "collector")), race_and_ethnicity_complete = structure(list(), class = c("collector_integer",
    "collector"))), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "age", "sex", "demographics_complete",
    "height", "weight", "bmi", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
    "ethnicity", "race_and_ethnicity_complete")), default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec"), class = "data.frame"
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") #returned_object$data$bmi<-NULL; returned_object$data$age<-NULL;dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

test_that("Write Batch -Update One Field", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object1 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  #Remove the calculated fields
  returned_object1$data$bmi <- NULL
  returned_object1$data$age <- NULL

  #Change some values
  returned_object1$data$address <- 1000 + seq_len(nrow(returned_object1$data))
  REDCapR::redcap_write(returned_object1$data, redcap_uri=project$redcap_uri, token=project$token)

  expect_message(
    returned_object2 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  #Remove the calculated fields
  returned_object2$data$bmi <- NULL
  returned_object2$data$age <- NULL

  expected_data_frame <- structure(
    list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
    "Wood", "DAG", "Walker"), address = 1001:1005, telephone = c("(405) 321-1111",
    "(405) 321-2222", "(405) 321-3333", "(405) 321-4444", "(405) 321-5555"
    ), email = c("nutty@mouse.com", "tummy@mouse.comm", "mw@mwood.net",
    "peroxide@blonde.com", "left@hippocket.com"), dob = structure(c(12294,
    12121, -13051, -6269, -5375), class = "Date"), sex = c(0L, 1L,
    1L, 0L, 1L), demographics_complete = c(2L, 2L, 2L, 2L, 2L), height = c(7,
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]", "[document]",
    "[document]"), health_complete = c(1L, 0L, 2L, 2L, 0L), race___1 = c(0L,
    0L, 0L, 0L, 1L), race___2 = c(0L, 0L, 0L, 1L, 0L), race___3 = c(0L,
    1L, 0L, 0L, 0L), race___4 = c(0L, 0L, 1L, 0L, 0L), race___5 = c(1L,
    1L, 1L, 1L, 0L), race___6 = c(0L, 0L, 0L, 0L, 1L), ethnicity = c(1L,
    1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L, 0L, 2L,
    2L, 2L)), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "sex", "demographics_complete",
    "height", "weight", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
    "ethnicity", "race_and_ethnicity_complete"), row.names = c(NA,
    -5L), spec = structure(list(cols = structure(list(record_id = structure(list(), class = c("collector_integer",
    "collector")), name_first = structure(list(), class = c("collector_character",
    "collector")), name_last = structure(list(), class = c("collector_character",
    "collector")), address = structure(list(), class = c("collector_integer",
    "collector")), telephone = structure(list(), class = c("collector_character",
    "collector")), email = structure(list(), class = c("collector_character",
    "collector")), dob = structure(list(format = ""), .Names = "format", class = c("collector_date",
    "collector")), age = structure(list(), class = c("collector_integer",
    "collector")), sex = structure(list(), class = c("collector_integer",
    "collector")), demographics_complete = structure(list(), class = c("collector_integer",
    "collector")), height = structure(list(), class = c("collector_double",
    "collector")), weight = structure(list(), class = c("collector_integer",
    "collector")), bmi = structure(list(), class = c("collector_double",
    "collector")), comments = structure(list(), class = c("collector_character",
    "collector")), mugshot = structure(list(), class = c("collector_character",
    "collector")), health_complete = structure(list(), class = c("collector_integer",
    "collector")), race___1 = structure(list(), class = c("collector_integer",
    "collector")), race___2 = structure(list(), class = c("collector_integer",
    "collector")), race___3 = structure(list(), class = c("collector_integer",
    "collector")), race___4 = structure(list(), class = c("collector_integer",
    "collector")), race___5 = structure(list(), class = c("collector_integer",
    "collector")), race___6 = structure(list(), class = c("collector_integer",
    "collector")), ethnicity = structure(list(), class = c("collector_integer",
    "collector")), race_and_ethnicity_complete = structure(list(), class = c("collector_integer",
    "collector"))), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "age", "sex", "demographics_complete",
    "height", "weight", "bmi", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
    "ethnicity", "race_and_ethnicity_complete")), default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec"), class = "data.frame"
  )

  expect_equivalent(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected=200L)
  expect_equivalent(returned_object2$raw_text, expected="") # dput(returned_object2$raw_text)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
})

test_that("Write Batch -Update Two Fields", {
  testthat::skip_on_cran()
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
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
  REDCapR::redcap_write(returned_object1$data, redcap_uri=project$redcap_uri, token=project$token)

  expect_message(
    returned_object2 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message
  )
  #Remove the calculated fields
  returned_object2$data$bmi <- NULL
  returned_object2$data$age <- NULL

  expected_data_frame <- structure(
    list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
    "Wood", "DAG", "Walker"), address = 1001:1005, telephone = c("(405) 321-1111",
    "(405) 321-2222", "(405) 321-3333", "(405) 321-4444", "(405) 321-5555"
    ), email = c("nutty@mouse.com", "tummy@mouse.comm", "mw@mwood.net",
    "peroxide@blonde.com", "left@hippocket.com"), dob = structure(c(12294,
    12121, -13051, -6269, -5375), class = "Date"), sex = c(0L, 1L,
    1L, 0L, 1L), demographics_complete = c(2L, 2L, 2L, 2L, 2L), height = c(7,
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]", "[document]",
    "[document]"), health_complete = c(1L, 0L, 2L, 2L, 0L), race___1 = c(0L,
    0L, 0L, 0L, 1L), race___2 = c(0L, 0L, 0L, 1L, 0L), race___3 = c(0L,
    1L, 0L, 0L, 0L), race___4 = c(0L, 0L, 1L, 0L, 0L), race___5 = c(1L,
    1L, 1L, 1L, 0L), race___6 = c(0L, 0L, 0L, 0L, 1L), ethnicity = c(1L,
    1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L, 0L, 2L,
    2L, 2L)), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "sex", "demographics_complete",
    "height", "weight", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
    "ethnicity", "race_and_ethnicity_complete"), row.names = c(NA,
    -5L), spec = structure(list(cols = structure(list(record_id = structure(list(), class = c("collector_integer",
    "collector")), name_first = structure(list(), class = c("collector_character",
    "collector")), name_last = structure(list(), class = c("collector_character",
    "collector")), address = structure(list(), class = c("collector_integer",
    "collector")), telephone = structure(list(), class = c("collector_character",
    "collector")), email = structure(list(), class = c("collector_character",
    "collector")), dob = structure(list(format = ""), .Names = "format", class = c("collector_date",
    "collector")), age = structure(list(), class = c("collector_integer",
    "collector")), sex = structure(list(), class = c("collector_integer",
    "collector")), demographics_complete = structure(list(), class = c("collector_integer",
    "collector")), height = structure(list(), class = c("collector_double",
    "collector")), weight = structure(list(), class = c("collector_integer",
    "collector")), bmi = structure(list(), class = c("collector_double",
    "collector")), comments = structure(list(), class = c("collector_character",
    "collector")), mugshot = structure(list(), class = c("collector_character",
    "collector")), health_complete = structure(list(), class = c("collector_integer",
    "collector")), race___1 = structure(list(), class = c("collector_integer",
    "collector")), race___2 = structure(list(), class = c("collector_integer",
    "collector")), race___3 = structure(list(), class = c("collector_integer",
    "collector")), race___4 = structure(list(), class = c("collector_integer",
    "collector")), race___5 = structure(list(), class = c("collector_integer",
    "collector")), race___6 = structure(list(), class = c("collector_integer",
    "collector")), ethnicity = structure(list(), class = c("collector_integer",
    "collector")), race_and_ethnicity_complete = structure(list(), class = c("collector_integer",
    "collector"))), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "age", "sex", "demographics_complete",
    "height", "weight", "bmi", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
    "ethnicity", "race_and_ethnicity_complete")), default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec"), class = "data.frame"
  )

  expect_equivalent(returned_object2$data, expected=expected_data_frame, label="The returned data.frame should be correct") #returned_object2$data$bmi<-NULL; returned_object2$data$age<-NULL;dput(returned_object2$data)
  expect_equal(returned_object2$status_code, expected=200L)
  expect_equivalent(returned_object2$raw_text, expected="") # dput(returned_object2$raw_text)
  expect_true(returned_object2$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object2$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object2$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object2$success)
})
test_that("Write Batch -Bad URI", {
  testthat::skip_on_cran()
  bad_uri <- "google.com"
  start_clean_result <- REDCapR:::clean_start_simple(batch=TRUE)
  project <- start_clean_result$redcap_project

  expected_outcome_message_1 <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expected_outcome_message_2 <- "The REDCapR write/import operation was not successful."

  expect_message(
    returned_object1 <- redcap_read_oneshot(redcap_uri=project$redcap_uri, token=project$token, raw_or_label="raw"),
    regexp = expected_outcome_message_1
  )
  #Remove the calculated fields
  returned_object1$data$bmi <- NULL
  returned_object1$data$age <- NULL

  #Change some values
  returned_object1$data$address <- 1000 + seq_len(nrow(returned_object1$data))
  returned_object1$data$telephone <- sprintf("(405) 321-%1$i%1$i%1$i%1$i", seq_len(nrow(returned_object1$data)))

  expect_error(
    REDCapR::redcap_write(returned_object1$data, redcap_uri=bad_uri, token=project$token)
  )
})
