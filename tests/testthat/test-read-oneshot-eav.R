# library(testthat)
# context("Read Oneshot EAV")
#
# credential <- REDCapR::retrieve_credential_local(
#   path_credential = base::file.path(devtools::inst(name="REDCapR"), "misc/example.credentials"),
#   project_id      = 153
# )
#
# test_that("Smoke Test", {
#   testthat::skip_on_cran()
#   expect_message(
#     returned_object <- redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)
#   )
# })
# test_that("All Records -Default", {
#   testthat::skip_on_cran()
#   expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
#     "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
#     "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\r\nKenning UK, 323232",
#     "14 Rose Cottage Blvd.\r\nKenning UK 34243", "243 Hill St.\r\nGuthrie OK 73402",
#     "342 Elm\r\nDuncanville TX, 75116", "Hotel Suite\r\nNew Orleans LA, 70115"
#     ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
#     "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
#     "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
#     ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02",
#     "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L,
#     1L, 1L, 0L, 1L), height = c(7, 6, 180, 165, 193.04), weight = c(1L,
#     1L, 80L, 54L, 104L), bmi = c(204.1, 277.8, 24.7, 19.8, 27.9),
#     comments = c("Character in a book, with some guessing", "A mouse character from a good book",
#     "completely made up", "This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail",
#     "Had a hand for trouble and a eye for cash\r\n\r\nHe had a gold watch chain and a black mustache"
#     ), mugshot = 7610:7614, race___1 = c(FALSE, FALSE, FALSE,
#     FALSE, TRUE), race___2 = c(FALSE, FALSE, FALSE, TRUE, FALSE
#     ), race___3 = c(FALSE, TRUE, FALSE, FALSE, FALSE), race___4 = c(FALSE,
#     FALSE, TRUE, FALSE, FALSE), race___5 = c(TRUE, TRUE, TRUE,
#     TRUE, FALSE), race___6 = c(FALSE, FALSE, FALSE, FALSE, TRUE
#     ), ethnicity = c(1L, 1L, 0L, 1L, 2L), demographics_complete = c(2L,
#     2L, 2L, 2L, 2L), health_complete = c(1L, 0L, 2L, 2L, 0L),
#     race_and_ethnicity_complete = c(2L, 0L, 2L, 2L, 2L)), .Names = c("record_id",
#     "name_first", "name_last", "address", "telephone", "email", "dob",
#     "age", "sex", "height", "weight", "bmi", "comments", "mugshot",
#     "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
#     "ethnicity", "demographics_complete", "health_complete", "race_and_ethnicity_complete"
#     ), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA,
#     -5L))
#
#   expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#
#   expect_message(
#     regexp           = expected_outcome_message,
#     returned_object <- redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T)
#   )
#
#   expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equal(returned_object$status_code, expected=200L)
#   expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_true(returned_object$filter_logic=="", "A filter was not specified.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
#   #expect_equal_to_reference(returned_object$data, file=base::file.path(devtools::inst(name="REDCapR"), "test-data/project-simple/variations/default.rds") )
#   #expect_equal_to_reference(returned_object$data, file="./test-data/project-simple/variations/default.rds")
# })
# test_that("All Records -Raw", {
#   testthat::skip_on_cran()
#   expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
#     "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
#     "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\r\nKenning UK, 323232",
#     "14 Rose Cottage Blvd.\r\nKenning UK 34243", "243 Hill St.\r\nGuthrie OK 73402",
#     "342 Elm\r\nDuncanville TX, 75116", "Hotel Suite\r\nNew Orleans LA, 70115"
#     ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
#     "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
#     "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
#     ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02",
#     "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L,
#     1L, 1L, 0L, 1L), height = c(7, 6, 180, 165, 193.04), weight = c(1L,
#     1L, 80L, 54L, 104L), bmi = c(204.1, 277.8, 24.7, 19.8, 27.9),
#     comments = c("Character in a book, with some guessing", "A mouse character from a good book",
#     "completely made up", "This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail",
#     "Had a hand for trouble and a eye for cash\r\n\r\nHe had a gold watch chain and a black mustache"
#     ), mugshot = 7610:7614, race___1 = c(FALSE, FALSE, FALSE,
#     FALSE, TRUE), race___2 = c(FALSE, FALSE, FALSE, TRUE, FALSE
#     ), race___3 = c(FALSE, TRUE, FALSE, FALSE, FALSE), race___4 = c(FALSE,
#     FALSE, TRUE, FALSE, FALSE), race___5 = c(TRUE, TRUE, TRUE,
#     TRUE, FALSE), race___6 = c(FALSE, FALSE, FALSE, FALSE, TRUE
#     ), ethnicity = c(1L, 1L, 0L, 1L, 2L), demographics_complete = c(2L,
#     2L, 2L, 2L, 2L), health_complete = c(1L, 0L, 2L, 2L, 0L),
#     race_and_ethnicity_complete = c(2L, 0L, 2L, 2L, 2L)), .Names = c("record_id",
#     "name_first", "name_last", "address", "telephone", "email", "dob",
#     "age", "sex", "height", "weight", "bmi", "comments", "mugshot",
#     "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
#     "ethnicity", "demographics_complete", "health_complete", "race_and_ethnicity_complete"
#     ), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA,
#     -5L))
#
#   expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#
#   expect_message(
#     regexp           = expected_outcome_message,
#     returned_object <- redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", verbose=T)
#   )
#
#   expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equal(returned_object$status_code, expected=200L)
#   expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_true(returned_object$filter_logic=="", "A filter was not specified.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
# })
# test_that("All Records -Raw and DAG", {
#   testthat::skip_on_cran()
#   expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
#     "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
#     "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\r\nKenning UK, 323232",
#     "14 Rose Cottage Blvd.\r\nKenning UK 34243", "243 Hill St.\r\nGuthrie OK 73402",
#     "342 Elm\r\nDuncanville TX, 75116", "Hotel Suite\r\nNew Orleans LA, 70115"
#     ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
#     "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
#     "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
#     ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02",
#     "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c(0L,
#     1L, 1L, 0L, 1L), height = c(7, 6, 180, 165, 193.04), weight = c(1L,
#     1L, 80L, 54L, 104L), bmi = c(204.1, 277.8, 24.7, 19.8, 27.9),
#     comments = c("Character in a book, with some guessing", "A mouse character from a good book",
#     "completely made up", "This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail",
#     "Had a hand for trouble and a eye for cash\r\n\r\nHe had a gold watch chain and a black mustache"
#     ), mugshot = 7610:7614, race___1 = c(FALSE, FALSE, FALSE,
#     FALSE, TRUE), race___2 = c(FALSE, FALSE, FALSE, TRUE, FALSE
#     ), race___3 = c(FALSE, TRUE, FALSE, FALSE, FALSE), race___4 = c(FALSE,
#     FALSE, TRUE, FALSE, FALSE), race___5 = c(TRUE, TRUE, TRUE,
#     TRUE, FALSE), race___6 = c(FALSE, FALSE, FALSE, FALSE, TRUE
#     ), ethnicity = c(1L, 1L, 0L, 1L, 2L), demographics_complete = c(2L,
#     2L, 2L, 2L, 2L), health_complete = c(1L, 0L, 2L, 2L, 0L),
#     race_and_ethnicity_complete = c(2L, 0L, 2L, 2L, 2L)), .Names = c("record_id",
#     "name_first", "name_last", "address", "telephone", "email", "dob",
#     "age", "sex", "height", "weight", "bmi", "comments", "mugshot",
#     "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
#     "ethnicity", "demographics_complete", "health_complete", "race_and_ethnicity_complete"
#     ), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA,
#     -5L))
#
#   expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#
#   expect_message(
#     regexp           = expected_outcome_message,
#     returned_object <- redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", export_data_access_groups=TRUE, verbose=T)
#   )
#
#   expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equal(returned_object$status_code, expected=200L)
#   expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_true(returned_object$filter_logic=="", "A filter was not specified.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
# })
# test_that("All Records -label and DAG", {
#   testthat::skip_on_cran()
#   expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
#     "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
#     "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\r\nKenning UK, 323232",
#     "14 Rose Cottage Blvd.\r\nKenning UK 34243", "243 Hill St.\r\nGuthrie OK 73402",
#     "342 Elm\r\nDuncanville TX, 75116", "Hotel Suite\r\nNew Orleans LA, 70115"
#     ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
#     "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
#     "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
#     ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02",
#     "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c("Female",
#     "Male", "Male", "Female", "Male"), height = c(7, 6, 180, 165,
#     193.04), weight = c(1L, 1L, 80L, 54L, 104L), bmi = c(204.1, 277.8,
#     24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing",
#     "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail",
#     "Had a hand for trouble and a eye for cash\r\n\r\nHe had a gold watch chain and a black mustache"
#     ), mugshot = 7610:7614, race___1 = c(FALSE, FALSE, FALSE, FALSE,
#     FALSE), race___2 = c(FALSE, FALSE, FALSE, FALSE, FALSE), race___3 = c(FALSE,
#     FALSE, FALSE, FALSE, FALSE), race___4 = c(FALSE, FALSE, FALSE,
#     FALSE, FALSE), race___5 = c(FALSE, FALSE, FALSE, FALSE, FALSE
#     ), race___6 = c(FALSE, FALSE, FALSE, FALSE, FALSE), ethnicity = c("NOT Hispanic or Latino",
#     "NOT Hispanic or Latino", "Unknown / Not Reported", "NOT Hispanic or Latino",
#     "Hispanic or Latino"), demographics_complete = c("Complete",
#     "Complete", "Complete", "Complete", "Complete"), health_complete = c("Unverified",
#     "Incomplete", "Complete", "Complete", "Incomplete"), race_and_ethnicity_complete = c("Complete",
#     "Incomplete", "Complete", "Complete", "Complete")), .Names = c("record_id",
#     "name_first", "name_last", "address", "telephone", "email", "dob",
#     "age", "sex", "height", "weight", "bmi", "comments", "mugshot",
#     "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
#     "ethnicity", "demographics_complete", "health_complete", "race_and_ethnicity_complete"
#     ), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA,
#     -5L))
#
#   expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#
#   expect_message(
#     regexp           = expected_outcome_message,
#     returned_object <- redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=TRUE, verbose=T)
#   )
#
#   expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equal(returned_object$status_code, expected=200L)
#   expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_true(returned_object$filter_logic=="", "A filter was not specified.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
# })
# test_that("All Records -label", {
#   testthat::skip_on_cran()
#   expected_data_frame <- structure(list(record_id = 1:5, name_first = c("Nutmeg", "Tumtum",
#     "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse", "Nutmouse",
#     "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\r\nKenning UK, 323232",
#     "14 Rose Cottage Blvd.\r\nKenning UK 34243", "243 Hill St.\r\nGuthrie OK 73402",
#     "342 Elm\r\nDuncanville TX, 75116", "Hotel Suite\r\nNew Orleans LA, 70115"
#     ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
#     "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
#     "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
#     ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02",
#     "1955-04-15"), age = c(11L, 11L, 80L, 61L, 59L), sex = c("Female",
#     "Male", "Male", "Female", "Male"), height = c(7, 6, 180, 165,
#     193.04), weight = c(1L, 1L, 80L, 54L, 104L), bmi = c(204.1, 277.8,
#     24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing",
#     "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail",
#     "Had a hand for trouble and a eye for cash\r\n\r\nHe had a gold watch chain and a black mustache"
#     ), mugshot = 7610:7614, race___1 = c(FALSE, FALSE, FALSE, FALSE,
#     FALSE), race___2 = c(FALSE, FALSE, FALSE, FALSE, FALSE), race___3 = c(FALSE,
#     FALSE, FALSE, FALSE, FALSE), race___4 = c(FALSE, FALSE, FALSE,
#     FALSE, FALSE), race___5 = c(FALSE, FALSE, FALSE, FALSE, FALSE
#     ), race___6 = c(FALSE, FALSE, FALSE, FALSE, FALSE), ethnicity = c("NOT Hispanic or Latino",
#     "NOT Hispanic or Latino", "Unknown / Not Reported", "NOT Hispanic or Latino",
#     "Hispanic or Latino"), demographics_complete = c("Complete",
#     "Complete", "Complete", "Complete", "Complete"), health_complete = c("Unverified",
#     "Incomplete", "Complete", "Complete", "Incomplete"), race_and_ethnicity_complete = c("Complete",
#     "Incomplete", "Complete", "Complete", "Complete")), .Names = c("record_id",
#     "name_first", "name_last", "address", "telephone", "email", "dob",
#     "age", "sex", "height", "weight", "bmi", "comments", "mugshot",
#     "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
#     "ethnicity", "demographics_complete", "health_complete", "race_and_ethnicity_complete"
#     ), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA,
#     -5L))
#
#   expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#
#   expect_message(
#     regexp           = expected_outcome_message,
#     returned_object <- redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=FALSE, verbose=T)
#   )
#
#   expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equal(returned_object$status_code, expected=200L)
#   expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_true(returned_object$filter_logic=="", "A filter was not specified.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
# })
#
# test_that("Filter - numeric", {
#   testthat::skip_on_cran()
#   expected_data_frame <- structure(list(record_id = 3:4, name_first = c("Marcus", "Trudy"
#     ), name_last = c("Wood", "DAG"), address = c("243 Hill St.\r\nGuthrie OK 73402",
#     "342 Elm\r\nDuncanville TX, 75116"), telephone = c("(405) 321-3333",
#     "(405) 321-4444"), email = c("mw@mwood.net", "peroxide@blonde.com"
#     ), dob = c("1934-04-09", "1952-11-02"), age = c(80L, 61L), sex = c(1L,
#     0L), height = c(180L, 165L), weight = c(80L, 54L), bmi = c(24.7,
#     19.8), comments = c("completely made up", "This record doesn't have a DAG assigned\r\n\r\nSo call up Trudy on the telephone\r\nSend her a letter in the mail"
#     ), mugshot = 7612:7613, race___1 = c(FALSE, FALSE), race___2 = c(FALSE,
#     TRUE), race___3 = c(FALSE, FALSE), race___4 = c(TRUE, FALSE),
#     race___5 = c(TRUE, TRUE), race___6 = c(FALSE, FALSE), ethnicity = 0:1,
#     demographics_complete = c(2L, 2L), health_complete = c(2L,
#     2L), race_and_ethnicity_complete = c(2L, 2L)), .Names = c("record_id",
#     "name_first", "name_last", "address", "telephone", "email", "dob",
#     "age", "sex", "height", "weight", "bmi", "comments", "mugshot",
#     "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
#     "ethnicity", "demographics_complete", "health_complete", "race_and_ethnicity_complete"
#     ), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA,
#     -2L))
#
#   expected_outcome_message <- "2 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#   filter <- "[age] >= 61"
#   expect_message(
#     regexp           = expected_outcome_message,
#     returned_object <- redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T, filter_logic=filter)
#   )
#
#   expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equal(returned_object$status_code, expected=200L)
#   expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_equal(returned_object$filter_logic, filter, "The filter was not correct.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
# })
#
# test_that("Filter - character", {
#   testthat::skip_on_cran()
#   expected_data_frame <- structure(list(record_id = 5L, name_first = "John Lee", name_last = "Walker",
#     address = "Hotel Suite\r\nNew Orleans LA, 70115", telephone = "(405) 321-5555",
#     email = "left@hippocket.com", dob = "1955-04-15", age = 59L,
#     sex = 1L, height = 193.04, weight = 104L, bmi = 27.9, comments = "Had a hand for trouble and a eye for cash\r\n\r\nHe had a gold watch chain and a black mustache",
#     mugshot = 7614L, race___1 = TRUE, race___2 = FALSE, race___3 = FALSE,
#     race___4 = FALSE, race___5 = FALSE, race___6 = TRUE, ethnicity = 2L,
#     demographics_complete = 2L, health_complete = 0L, race_and_ethnicity_complete = 2L), .Names = c("record_id",
#     "name_first", "name_last", "address", "telephone", "email", "dob",
#     "age", "sex", "height", "weight", "bmi", "comments", "mugshot",
#     "race___1", "race___2", "race___3", "race___4", "race___5", "race___6",
#     "ethnicity", "demographics_complete", "health_complete", "race_and_ethnicity_complete"
#     ), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA,
#     -1L))
#
#   expected_outcome_message <- "1 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
#   filter <- "[name_first] = 'John Lee'"
#   expect_message(
#     regexp           = expected_outcome_message,
#     returned_object <- redcap_read_oneshot_eav(redcap_uri=credential$redcap_uri, token=credential$token, verbose=T, filter_logic=filter)
#   )
#
#   expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
#   expect_equal(returned_object$status_code, expected=200L)
#   expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
#   expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
#   expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
#   expect_equal(returned_object$filter_logic, filter, "The filter was not correct.")
#   expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
#   expect_true(returned_object$success)
# })
