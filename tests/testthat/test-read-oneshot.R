library(testthat)
context("Read Oneshot")

credential <- REDCapR::retrieve_credential_local(
  path_credential = system.file("misc/example.credentials", package="REDCapR"),
  project_id      = 153
)

test_that("smoke test", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)
  )
})
test_that("default", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = structure(c(12294, 12121, -13051, -6269, -5375), class = "Date"),
    age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L, 1L, 1L, 0L,
    1L), demographics_complete = c(2L, 2L, 2L, 2L, 2L), height = c(7,
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L),
    bmi = c(204.1, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up",
    "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]",
    "[document]", "[document]"), health_complete = c(1L, 0L,
    2L, 2L, 0L), race___1 = c(0L, 0L, 0L, 0L, 1L), race___2 = c(0L,
    0L, 0L, 1L, 0L), race___3 = c(0L, 1L, 0L, 0L, 0L), race___4 = c(0L,
    0L, 1L, 0L, 0L), race___5 = c(1L, 1L, 1L, 1L, 0L), race___6 = c(0L,
    0L, 0L, 0L, 1L), ethnicity = c(1L, 1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L,
    0L, 2L, 2L, 2L)), class = "data.frame", .Names = c("record_id",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "height", "weight", "bmi",
    "comments", "mugshot", "health_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete"), row.names = c(NA, -5L), spec = structure(list(
    cols = structure(list(record_id = structure(list(), class = c("collector_integer",
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
    "race___1", "race___2", "race___3", "race___4", "race___5",
    "race___6", "ethnicity", "race_and_ethnicity_complete")),
    default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  system.file("misc/example.credentials", package="REDCapR")

  # expect_equal_to_reference(returned_object$data, file=system.file("test-data/project-simple/variations/default.rds", package="REDCapR"))
  # expect_equal_to_reference(returned_object$data, file="./test-data/project-simple/variations/default.rds")
})
test_that("specify forms", {
  testthat::skip_on_cran()
  desired_forms <- c("demographics", "race_and_ethnicity")
  expected_data_frame <- structure(
    list(record_id = c(1, 2, 3, 4, 5), name_first = c("Nutmeg",
    "Tumtum", "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse",
    "Nutmouse", "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = structure(c(12294, 12121, -13051, -6269, -5375), class = "Date"),
    age = c(11, 11, 80, 61, 59), sex = c(0, 1, 1, 0, 1), demographics_complete = c(2,
    2, 2, 2, 2), race___1 = c(0, 0, 0, 0, 1), race___2 = c(0,
    0, 0, 1, 0), race___3 = c(0, 1, 0, 0, 0), race___4 = c(0,
    0, 1, 0, 0), race___5 = c(1, 1, 1, 1, 0), race___6 = c(0,
    0, 0, 0, 1), ethnicity = c(1, 1, 0, 1, 2), race_and_ethnicity_complete = c(2,
    0, 2, 2, 2)), class = "data.frame", .Names = c("record_id",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete"), row.names = c(NA, -5L), spec = structure(list(
    cols = structure(list(record_id = structure(list(), class = c("collector_double",
    "collector")), name_first = structure(list(), class = c("collector_character",
    "collector")), name_last = structure(list(), class = c("collector_character",
    "collector")), address = structure(list(), class = c("collector_character",
    "collector")), telephone = structure(list(), class = c("collector_character",
    "collector")), email = structure(list(), class = c("collector_character",
    "collector")), dob = structure(list(format = ""), .Names = "format", class = c("collector_date",
    "collector")), age = structure(list(), class = c("collector_double",
    "collector")), sex = structure(list(), class = c("collector_double",
    "collector")), demographics_complete = structure(list(), class = c("collector_double",
    "collector")), race___1 = structure(list(), class = c("collector_double",
    "collector")), race___2 = structure(list(), class = c("collector_double",
    "collector")), race___3 = structure(list(), class = c("collector_double",
    "collector")), race___4 = structure(list(), class = c("collector_double",
    "collector")), race___5 = structure(list(), class = c("collector_double",
    "collector")), race___6 = structure(list(), class = c("collector_double",
    "collector")), ethnicity = structure(list(), class = c("collector_double",
    "collector")), race_and_ethnicity_complete = structure(list(), class = c("collector_double",
    "collector"))), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "age", "sex", "demographics_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5",
    "race___6", "ethnicity", "race_and_ethnicity_complete")),
    default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )

  expected_outcome_message <- "5 records and 18 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, forms=desired_forms)
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  #expect_equal_to_reference(returned_object$data, file=system.file("test-data/project-simple/variations/default.rds", package="REDCapR"))
  #expect_equal_to_reference(returned_object$data, file="./test-data/project-simple/variations/default.rds")
})
test_that("force character type", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = c("1", "2", "3", "4", "5"), name_first = c("Nutmeg",
    "Tumtum", "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse",
    "Nutmouse", "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02",
    "1955-04-15"), age = c("11", "11", "80", "61", "59"), sex = c("0",
    "1", "1", "0", "1"), demographics_complete = c("2", "2", "2",
    "2", "2"), height = c("7", "6", "180", "165", "193.04"), weight = c("1",
    "1", "80", "54", "104"), bmi = c("204.1", "277.8", "24.7", "19.8",
    "27.9"), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]", "[document]",
    "[document]"), health_complete = c("1", "0", "2", "2", "0"),
    race___1 = c("0", "0", "0", "0", "1"), race___2 = c("0",
    "0", "0", "1", "0"), race___3 = c("0", "1", "0", "0", "0"
    ), race___4 = c("0", "0", "1", "0", "0"), race___5 = c("1",
    "1", "1", "1", "0"), race___6 = c("0", "0", "0", "0", "1"
    ), ethnicity = c("1", "1", "0", "1", "2"), race_and_ethnicity_complete = c("2",
    "0", "2", "2", "2")), class = "data.frame", .Names = c("record_id",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "height", "weight", "bmi",
    "comments", "mugshot", "health_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete"), row.names = c(NA, -5L), spec = structure(list(
    cols = structure(list(record_id = structure(list(), class = c("collector_character",
    "collector")), name_first = structure(list(), class = c("collector_character",
    "collector")), name_last = structure(list(), class = c("collector_character",
    "collector")), address = structure(list(), class = c("collector_character",
    "collector")), telephone = structure(list(), class = c("collector_character",
    "collector")), email = structure(list(), class = c("collector_character",
    "collector")), dob = structure(list(), class = c("collector_character",
    "collector")), age = structure(list(), class = c("collector_character",
    "collector")), sex = structure(list(), class = c("collector_character",
    "collector")), demographics_complete = structure(list(), class = c("collector_character",
    "collector")), height = structure(list(), class = c("collector_character",
    "collector")), weight = structure(list(), class = c("collector_character",
    "collector")), bmi = structure(list(), class = c("collector_character",
    "collector")), comments = structure(list(), class = c("collector_character",
    "collector")), mugshot = structure(list(), class = c("collector_character",
    "collector")), health_complete = structure(list(), class = c("collector_character",
    "collector")), race___1 = structure(list(), class = c("collector_character",
    "collector")), race___2 = structure(list(), class = c("collector_character",
    "collector")), race___3 = structure(list(), class = c("collector_character",
    "collector")), race___4 = structure(list(), class = c("collector_character",
    "collector")), race___5 = structure(list(), class = c("collector_character",
    "collector")), race___6 = structure(list(), class = c("collector_character",
    "collector")), ethnicity = structure(list(), class = c("collector_character",
    "collector")), race_and_ethnicity_complete = structure(list(), class = c("collector_character",
    "collector"))), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "age", "sex", "demographics_complete",
    "height", "weight", "bmi", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5",
    "race___6", "ethnicity", "race_and_ethnicity_complete")),
    default = structure(list(), class = c("collector_character",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, guess_type=FALSE)
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  #expect_equal_to_reference(returned_object$data, file=system.file("test-data/project-simple/variations/default.rds", package="REDCapR"))
  #expect_equal_to_reference(returned_object$data, file="./test-data/project-simple/variations/default.rds")
})
test_that("raw", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = structure(c(12294, 12121, -13051, -6269, -5375), class = "Date"),
    age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L, 1L, 1L, 0L,
    1L), demographics_complete = c(2L, 2L, 2L, 2L, 2L), height = c(7,
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L),
    bmi = c(204.1, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up",
    "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]",
    "[document]", "[document]"), health_complete = c(1L, 0L,
    2L, 2L, 0L), race___1 = c(0L, 0L, 0L, 0L, 1L), race___2 = c(0L,
    0L, 0L, 1L, 0L), race___3 = c(0L, 1L, 0L, 0L, 0L), race___4 = c(0L,
    0L, 1L, 0L, 0L), race___5 = c(1L, 1L, 1L, 1L, 0L), race___6 = c(0L,
    0L, 0L, 0L, 1L), ethnicity = c(1L, 1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L,
    0L, 2L, 2L, 2L)), class = "data.frame", .Names = c("record_id",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "height", "weight", "bmi",
    "comments", "mugshot", "health_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete"), row.names = c(NA, -5L), spec = structure(list(
    cols = structure(list(record_id = structure(list(), class = c("collector_integer",
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
    "race___1", "race___2", "race___3", "race___4", "race___5",
    "race___6", "ethnicity", "race_and_ethnicity_complete")),
    default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", verbose=T)
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("raw and DAG", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, redcap_data_access_group = c("dag_1",
    "dag_1", "dag_1", NA, "dag_2"), name_first = c("Nutmeg", "Tumtum",
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = structure(c(12294, 12121, -13051, -6269, -5375), class = "Date"),
    age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L, 1L, 1L, 0L,
    1L), demographics_complete = c(2L, 2L, 2L, 2L, 2L), height = c(7,
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L),
    bmi = c(204.1, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up",
    "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]",
    "[document]", "[document]"), health_complete = c(1L, 0L,
    2L, 2L, 0L), race___1 = c(0L, 0L, 0L, 0L, 1L), race___2 = c(0L,
    0L, 0L, 1L, 0L), race___3 = c(0L, 1L, 0L, 0L, 0L), race___4 = c(0L,
    0L, 1L, 0L, 0L), race___5 = c(1L, 1L, 1L, 1L, 0L), race___6 = c(0L,
    0L, 0L, 0L, 1L), ethnicity = c(1L, 1L, 0L, 1L, 2L), race_and_ethnicity_complete = c(2L,
    0L, 2L, 2L, 2L)), class = "data.frame", .Names = c("record_id",
    "redcap_data_access_group", "name_first", "name_last", "address",
    "telephone", "email", "dob", "age", "sex", "demographics_complete",
    "height", "weight", "bmi", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
    "ethnicity", "race_and_ethnicity_complete"), row.names = c(NA,
    -5L), spec = structure(list(cols = structure(list(record_id = structure(list(), class = c("collector_integer",
    "collector")), redcap_data_access_group = structure(list(), class = c("collector_character",
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
    "collector"))), .Names = c("record_id", "redcap_data_access_group",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "height", "weight", "bmi",
    "comments", "mugshot", "health_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete")), default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )

  expected_outcome_message <- "5 records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", export_data_access_groups=TRUE, verbose=T)
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("label and DAG", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, redcap_data_access_group = c("dag_1",
    "dag_1", "dag_1", NA, "dag_2"), name_first = c("Nutmeg", "Tumtum",
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = structure(c(12294, 12121, -13051, -6269, -5375), class = "Date"),
    age = c(11L, 11L, 80L, 61L, 59L), sex = c("Female", "Male",
    "Male", "Female", "Male"), demographics_complete = c("Complete",
    "Complete", "Complete", "Complete", "Complete"), height = c(7,
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L),
    bmi = c(204.1, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up",
    "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]",
    "[document]", "[document]"), health_complete = c("Unverified",
    "Incomplete", "Complete", "Complete", "Incomplete"), race___1 = c("Unchecked",
    "Unchecked", "Unchecked", "Unchecked", "Checked"), race___2 = c("Unchecked",
    "Unchecked", "Unchecked", "Checked", "Unchecked"), race___3 = c("Unchecked",
    "Checked", "Unchecked", "Unchecked", "Unchecked"), race___4 = c("Unchecked",
    "Unchecked", "Checked", "Unchecked", "Unchecked"), race___5 = c("Checked",
    "Checked", "Checked", "Checked", "Unchecked"), race___6 = c("Unchecked",
    "Unchecked", "Unchecked", "Unchecked", "Checked"), ethnicity = c("NOT Hispanic or Latino",
    "NOT Hispanic or Latino", "Unknown / Not Reported", "NOT Hispanic or Latino",
    "Hispanic or Latino"), race_and_ethnicity_complete = c("Complete",
    "Incomplete", "Complete", "Complete", "Complete")), class = "data.frame", .Names = c("record_id",
    "redcap_data_access_group", "name_first", "name_last", "address",
    "telephone", "email", "dob", "age", "sex", "demographics_complete",
    "height", "weight", "bmi", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
    "ethnicity", "race_and_ethnicity_complete"), row.names = c(NA,
    -5L), spec = structure(list(cols = structure(list(record_id = structure(list(), class = c("collector_integer",
    "collector")), redcap_data_access_group = structure(list(), class = c("collector_character",
    "collector")), name_first = structure(list(), class = c("collector_character",
    "collector")), name_last = structure(list(), class = c("collector_character",
    "collector")), address = structure(list(), class = c("collector_character",
    "collector")), telephone = structure(list(), class = c("collector_character",
    "collector")), email = structure(list(), class = c("collector_character",
    "collector")), dob = structure(list(format = ""), .Names = "format", class = c("collector_date",
    "collector")), age = structure(list(), class = c("collector_integer",
    "collector")), sex = structure(list(), class = c("collector_character",
    "collector")), demographics_complete = structure(list(), class = c("collector_character",
    "collector")), height = structure(list(), class = c("collector_double",
    "collector")), weight = structure(list(), class = c("collector_integer",
    "collector")), bmi = structure(list(), class = c("collector_double",
    "collector")), comments = structure(list(), class = c("collector_character",
    "collector")), mugshot = structure(list(), class = c("collector_character",
    "collector")), health_complete = structure(list(), class = c("collector_character",
    "collector")), race___1 = structure(list(), class = c("collector_character",
    "collector")), race___2 = structure(list(), class = c("collector_character",
    "collector")), race___3 = structure(list(), class = c("collector_character",
    "collector")), race___4 = structure(list(), class = c("collector_character",
    "collector")), race___5 = structure(list(), class = c("collector_character",
    "collector")), race___6 = structure(list(), class = c("collector_character",
    "collector")), ethnicity = structure(list(), class = c("collector_character",
    "collector")), race_and_ethnicity_complete = structure(list(), class = c("collector_character",
    "collector"))), .Names = c("record_id", "redcap_data_access_group",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "height", "weight", "bmi",
    "comments", "mugshot", "health_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete")), default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )


  expected_outcome_message <- "5 records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=TRUE, verbose=T)
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("label", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
    "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
    "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = structure(c(12294, 12121, -13051, -6269, -5375), class = "Date"),
    age = c(11L, 11L, 80L, 61L, 59L), sex = c("Female", "Male",
    "Male", "Female", "Male"), demographics_complete = c("Complete",
    "Complete", "Complete", "Complete", "Complete"), height = c(7,
    6, 180, 165, 193.04), weight = c(1L, 1L, 80L, 54L, 104L),
    bmi = c(204.1, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up",
    "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]",
    "[document]", "[document]"), health_complete = c("Unverified",
    "Incomplete", "Complete", "Complete", "Incomplete"), race___1 = c("Unchecked",
    "Unchecked", "Unchecked", "Unchecked", "Checked"), race___2 = c("Unchecked",
    "Unchecked", "Unchecked", "Checked", "Unchecked"), race___3 = c("Unchecked",
    "Checked", "Unchecked", "Unchecked", "Unchecked"), race___4 = c("Unchecked",
    "Unchecked", "Checked", "Unchecked", "Unchecked"), race___5 = c("Checked",
    "Checked", "Checked", "Checked", "Unchecked"), race___6 = c("Unchecked",
    "Unchecked", "Unchecked", "Unchecked", "Checked"), ethnicity = c("NOT Hispanic or Latino",
    "NOT Hispanic or Latino", "Unknown / Not Reported", "NOT Hispanic or Latino",
    "Hispanic or Latino"), race_and_ethnicity_complete = c("Complete",
    "Incomplete", "Complete", "Complete", "Complete")), class = "data.frame", .Names = c("record_id",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "height", "weight", "bmi",
    "comments", "mugshot", "health_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete"), row.names = c(NA, -5L), spec = structure(list(
    cols = structure(list(record_id = structure(list(), class = c("collector_integer",
    "collector")), name_first = structure(list(), class = c("collector_character",
    "collector")), name_last = structure(list(), class = c("collector_character",
    "collector")), address = structure(list(), class = c("collector_character",
    "collector")), telephone = structure(list(), class = c("collector_character",
    "collector")), email = structure(list(), class = c("collector_character",
    "collector")), dob = structure(list(format = ""), .Names = "format", class = c("collector_date",
    "collector")), age = structure(list(), class = c("collector_integer",
    "collector")), sex = structure(list(), class = c("collector_character",
    "collector")), demographics_complete = structure(list(), class = c("collector_character",
    "collector")), height = structure(list(), class = c("collector_double",
    "collector")), weight = structure(list(), class = c("collector_integer",
    "collector")), bmi = structure(list(), class = c("collector_double",
    "collector")), comments = structure(list(), class = c("collector_character",
    "collector")), mugshot = structure(list(), class = c("collector_character",
    "collector")), health_complete = structure(list(), class = c("collector_character",
    "collector")), race___1 = structure(list(), class = c("collector_character",
    "collector")), race___2 = structure(list(), class = c("collector_character",
    "collector")), race___3 = structure(list(), class = c("collector_character",
    "collector")), race___4 = structure(list(), class = c("collector_character",
    "collector")), race___5 = structure(list(), class = c("collector_character",
    "collector")), race___6 = structure(list(), class = c("collector_character",
    "collector")), ethnicity = structure(list(), class = c("collector_character",
    "collector")), race_and_ethnicity_complete = structure(list(), class = c("collector_character",
    "collector"))), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "age", "sex", "demographics_complete",
    "height", "weight", "bmi", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5",
    "race___6", "ethnicity", "race_and_ethnicity_complete")),
    default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=FALSE, verbose=T)
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("label header", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(`Study ID` = c(1, 2, 3, 4, 5), `First Name` = c("Nutmeg",
    "Tumtum", "Marcus", "Trudy", "John Lee"), `Last Name` = c("Nutmouse",
    "Nutmouse", "Wood", "DAG", "Walker"), `Street, City, State, ZIP` = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), `Phone number` = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), `E-mail` = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), `Date of birth` = structure(c(12294, 12121, -13051, -6269,
    -5375), class = "Date"), `Age (years)` = c(11, 11, 80, 61, 59
    ), Gender = c(0, 1, 1, 0, 1), `Complete?` = c(2, 2, 2, 2, 2),
    `Height (cm)` = c(7, 6, 180, 165, 193.04), `Weight (kilograms)` = c(1,
    1, 80, 54, 104), BMI = c(204.1, 277.8, 24.7, 19.8, 27.9),
    Comments = c("Character in a book, with some guessing", "A mouse character from a good book",
    "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), Mugshot = c("[document]", "[document]", "[document]",
    "[document]", "[document]"), `Complete?_1` = c(1, 0, 2, 2,
    0), `Race (Select all that apply) (choice=American Indian/Alaska Native)` = c(0,
    0, 0, 0, 1), `Race (Select all that apply) (choice=Asian)` = c(0,
    0, 0, 1, 0), `Race (Select all that apply) (choice=Native Hawaiian or Other Pacific Islander)` = c(0,
    1, 0, 0, 0), `Race (Select all that apply) (choice=Black or African American)` = c(0,
    0, 1, 0, 0), `Race (Select all that apply) (choice=White)` = c(1,
    1, 1, 1, 0), `Race (Select all that apply) (choice=Unknown / Not Reported)` = c(0,
    0, 0, 0, 1), Ethnicity = c(1, 1, 0, 1, 2), `Complete?_2` = c(2,
    0, 2, 2, 2)), .Names = c("Study ID", "First Name", "Last Name",
    "Street, City, State, ZIP", "Phone number", "E-mail", "Date of birth",
    "Age (years)", "Gender", "Complete?", "Height (cm)", "Weight (kilograms)",
    "BMI", "Comments", "Mugshot", "Complete?_1", "Race (Select all that apply) (choice=American Indian/Alaska Native)",
    "Race (Select all that apply) (choice=Asian)", "Race (Select all that apply) (choice=Native Hawaiian or Other Pacific Islander)",
    "Race (Select all that apply) (choice=Black or African American)",
    "Race (Select all that apply) (choice=White)", "Race (Select all that apply) (choice=Unknown / Not Reported)",
    "Ethnicity", "Complete?_2"), row.names = c(NA, -5L), class = "data.frame", spec = structure(list(
    cols = structure(list(`Study ID` = structure(list(), class = c("collector_double",
    "collector")), `First Name` = structure(list(), class = c("collector_character",
    "collector")), `Last Name` = structure(list(), class = c("collector_character",
    "collector")), `Street, City, State, ZIP` = structure(list(), class = c("collector_character",
    "collector")), `Phone number` = structure(list(), class = c("collector_character",
    "collector")), `E-mail` = structure(list(), class = c("collector_character",
    "collector")), `Date of birth` = structure(list(format = ""), .Names = "format", class = c("collector_date",
    "collector")), `Age (years)` = structure(list(), class = c("collector_double",
    "collector")), Gender = structure(list(), class = c("collector_double",
    "collector")), `Complete?` = structure(list(), class = c("collector_double",
    "collector")), `Height (cm)` = structure(list(), class = c("collector_double",
    "collector")), `Weight (kilograms)` = structure(list(), class = c("collector_double",
    "collector")), BMI = structure(list(), class = c("collector_double",
    "collector")), Comments = structure(list(), class = c("collector_character",
    "collector")), Mugshot = structure(list(), class = c("collector_character",
    "collector")), `Complete?_1` = structure(list(), class = c("collector_double",
    "collector")), `Race (Select all that apply) (choice=American Indian/Alaska Native)` = structure(list(), class = c("collector_double",
    "collector")), `Race (Select all that apply) (choice=Asian)` = structure(list(), class = c("collector_double",
    "collector")), `Race (Select all that apply) (choice=Native Hawaiian or Other Pacific Islander)` = structure(list(), class = c("collector_double",
    "collector")), `Race (Select all that apply) (choice=Black or African American)` = structure(list(), class = c("collector_double",
    "collector")), `Race (Select all that apply) (choice=White)` = structure(list(), class = c("collector_double",
    "collector")), `Race (Select all that apply) (choice=Unknown / Not Reported)` = structure(list(), class = c("collector_double",
    "collector")), Ethnicity = structure(list(), class = c("collector_double",
    "collector")), `Complete?_2` = structure(list(), class = c("collector_double",
    "collector"))), .Names = c("Study ID", "First Name", "Last Name",
    "Street, City, State, ZIP", "Phone number", "E-mail", "Date of birth",
    "Age (years)", "Gender", "Complete?", "Height (cm)", "Weight (kilograms)",
    "BMI", "Comments", "Mugshot", "Complete?_1", "Race (Select all that apply) (choice=American Indian/Alaska Native)",
    "Race (Select all that apply) (choice=Asian)", "Race (Select all that apply) (choice=Native Hawaiian or Other Pacific Islander)",
    "Race (Select all that apply) (choice=Black or African American)",
    "Race (Select all that apply) (choice=White)", "Race (Select all that apply) (choice=Unknown / Not Reported)",
    "Ethnicity", "Complete?_2")), default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec"))

  expected_warning <- "Duplicated column names deduplicated: 'Complete\\?' => 'Complete\\?_1' \\[16\\], 'Complete\\?' => 'Complete\\?_2' \\[24\\]"
  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_warning(
    regexp = expected_warning,
    expect_message(
      regexp           = expected_outcome_message,
      returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label_headers="label")
    )
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("export_checkbox_label", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(
    list(record_id = c(1, 2, 3, 4, 5), name_first = c("Nutmeg",
    "Tumtum", "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse",
    "Nutmouse", "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
    "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
    ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
    "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
    "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), dob = structure(c(12294, 12121, -13051, -6269, -5375), class = "Date"),
    age = c(11, 11, 80, 61, 59), sex = c("Female", "Male", "Male",
    "Female", "Male"), demographics_complete = c("Complete",
    "Complete", "Complete", "Complete", "Complete"), height = c(7,
    6, 180, 165, 193.04), weight = c(1, 1, 80, 54, 104), bmi = c(204.1,
    277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing",
    "A mouse character from a good book", "completely made up",
    "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
    "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
    ), mugshot = c("[document]", "[document]", "[document]",
    "[document]", "[document]"), health_complete = c("Unverified",
    "Incomplete", "Complete", "Complete", "Incomplete"), race___1 = c(NA,
    NA, NA, NA, "American Indian/Alaska Native"), race___2 = c(NA,
    NA, NA, "Asian", NA), race___3 = c(NA, "Native Hawaiian or Other Pacific Islander",
    NA, NA, NA), race___4 = c(NA, NA, "Black or African American",
    NA, NA), race___5 = c("White", "White", "White", "White",
    NA), race___6 = c(NA, NA, NA, NA, "Unknown / Not Reported"
    ), ethnicity = c("NOT Hispanic or Latino", "NOT Hispanic or Latino",
    "Unknown / Not Reported", "NOT Hispanic or Latino", "Hispanic or Latino"
    ), race_and_ethnicity_complete = c("Complete", "Incomplete",
    "Complete", "Complete", "Complete")), .Names = c("record_id",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "height", "weight", "bmi",
    "comments", "mugshot", "health_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete"), row.names = c(NA, -5L), class = "data.frame", spec = structure(list(
    cols = structure(list(record_id = structure(list(), class = c("collector_double",
    "collector")), name_first = structure(list(), class = c("collector_character",
    "collector")), name_last = structure(list(), class = c("collector_character",
    "collector")), address = structure(list(), class = c("collector_character",
    "collector")), telephone = structure(list(), class = c("collector_character",
    "collector")), email = structure(list(), class = c("collector_character",
    "collector")), dob = structure(list(format = ""), .Names = "format", class = c("collector_date",
    "collector")), age = structure(list(), class = c("collector_double",
    "collector")), sex = structure(list(), class = c("collector_character",
    "collector")), demographics_complete = structure(list(), class = c("collector_character",
    "collector")), height = structure(list(), class = c("collector_double",
    "collector")), weight = structure(list(), class = c("collector_double",
    "collector")), bmi = structure(list(), class = c("collector_double",
    "collector")), comments = structure(list(), class = c("collector_character",
    "collector")), mugshot = structure(list(), class = c("collector_character",
    "collector")), health_complete = structure(list(), class = c("collector_character",
    "collector")), race___1 = structure(list(), class = c("collector_character",
    "collector")), race___2 = structure(list(), class = c("collector_character",
    "collector")), race___3 = structure(list(), class = c("collector_character",
    "collector")), race___4 = structure(list(), class = c("collector_character",
    "collector")), race___5 = structure(list(), class = c("collector_character",
    "collector")), race___6 = structure(list(), class = c("collector_character",
    "collector")), ethnicity = structure(list(), class = c("collector_character",
    "collector")), race_and_ethnicity_complete = structure(list(), class = c("collector_character",
    "collector"))), .Names = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "age", "sex", "demographics_complete",
    "height", "weight", "bmi", "comments", "mugshot", "health_complete",
    "race___1", "race___2", "race___3", "race___4", "race___5",
    "race___6", "ethnicity", "race_and_ethnicity_complete")),
    default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )
  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, export_checkbox_label=T, raw_or_label="label")
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("filter - numeric", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 3:4, name_first = c("Marcus", "Trudy"
    ), name_last = c("Wood", "DAG"), address = c("243 Hill St.\nGuthrie OK 73402",
    "342 Elm\nDuncanville TX, 75116"), telephone = c("(405) 321-3333",
    "(405) 321-4444"), email = c("mw@mwood.net", "peroxide@blonde.com"
    ), dob = structure(c(-13051, -6269), class = "Date"), age = c(80L,
    61L), sex = c(1L, 0L), demographics_complete = c(2L, 2L), height = c(180L,
    165L), weight = c(80L, 54L), bmi = c(24.7, 19.8), comments = c("completely made up",
    "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail"
    ), mugshot = c("[document]", "[document]"), health_complete = c(2L,
    2L), race___1 = c(0L, 0L), race___2 = 0:1, race___3 = c(0L, 0L
    ), race___4 = c(1L, 0L), race___5 = c(1L, 1L), race___6 = c(0L,
    0L), ethnicity = 0:1, race_and_ethnicity_complete = c(2L, 2L)), class = "data.frame", .Names = c("record_id",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "height", "weight", "bmi",
    "comments", "mugshot", "health_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete"), row.names = c(NA, -2L), spec = structure(list(
    cols = structure(list(record_id = structure(list(), class = c("collector_integer",
    "collector")), name_first = structure(list(), class = c("collector_character",
    "collector")), name_last = structure(list(), class = c("collector_character",
    "collector")), address = structure(list(), class = c("collector_character",
    "collector")), telephone = structure(list(), class = c("collector_character",
    "collector")), email = structure(list(), class = c("collector_character",
    "collector")), dob = structure(list(format = ""), .Names = "format", class = c("collector_date",
    "collector")), age = structure(list(), class = c("collector_integer",
    "collector")), sex = structure(list(), class = c("collector_integer",
    "collector")), demographics_complete = structure(list(), class = c("collector_integer",
    "collector")), height = structure(list(), class = c("collector_integer",
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
    "race___1", "race___2", "race___3", "race___4", "race___5",
    "race___6", "ethnicity", "race_and_ethnicity_complete")),
    default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )

  expected_outcome_message <- "2 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  filter <- "[age] >= 61"

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T, filter_logic=filter)
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, filter, "The filter was not correct.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("filter - character", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(record_id = 5L, name_first = "John Lee", name_last = "Walker",
    address = "Hotel Suite\nNew Orleans LA, 70115", telephone = "(405) 321-5555",
    email = "left@hippocket.com", dob = structure(-5375, class = "Date"),
    age = 59L, sex = 1L, demographics_complete = 2L, height = 193.04,
    weight = 104L, bmi = 27.9, comments = "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache",
    mugshot = "[document]", health_complete = 0L, race___1 = 1L,
    race___2 = 0L, race___3 = 0L, race___4 = 0L, race___5 = 0L,
    race___6 = 1L, ethnicity = 2L, race_and_ethnicity_complete = 2L), class = "data.frame", .Names = c("record_id",
    "name_first", "name_last", "address", "telephone", "email", "dob",
    "age", "sex", "demographics_complete", "height", "weight", "bmi",
    "comments", "mugshot", "health_complete", "race___1", "race___2",
    "race___3", "race___4", "race___5", "race___6", "ethnicity",
    "race_and_ethnicity_complete"), row.names = c(NA, -1L), spec = structure(list(
    cols = structure(list(record_id = structure(list(), class = c("collector_integer",
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
    "race___1", "race___2", "race___3", "race___4", "race___5",
    "race___6", "ethnicity", "race_and_ethnicity_complete")),
    default = structure(list(), class = c("collector_guess",
    "collector"))), .Names = c("cols", "default"), class = "col_spec")
  )

  expected_outcome_message <- "1 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  filter <- "[name_first] = 'John Lee'"
  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T, filter_logic=filter)
  )

  expect_equivalent(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_equal(returned_object$filter_logic, filter, "The filter was not correct.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
