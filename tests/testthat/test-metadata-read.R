library(testthat)
context("Metadata Read")

credential <- REDCapR::retrieve_credential_local(
  path_credential = base::file.path(devtools::inst(name="REDCapR"), "misc/example.credentials"),
  project_id      = 153
)

test_that("Smoke Test", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <- redcap_metadata_read(redcap_uri=credential$redcap_uri, token=credential$token)
  )
})
test_that("All Records -Default", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(field_name = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "age", "sex", "height",
    "weight", "bmi", "comments", "mugshot", "race", "ethnicity"),
    form_name = c("demographics", "demographics", "demographics",
    "demographics", "demographics", "demographics", "demographics",
    "demographics", "demographics", "health", "health", "health",
    "health", "health", "race_and_ethnicity", "race_and_ethnicity"
    ), section_header = c("", "Contact Information", "", "",
    "", "", "", "", "", "", "", "", "General Comments", "", "",
    ""), field_type = c("text", "text", "text", "notes", "text",
    "text", "text", "calc", "radio", "text", "text", "calc",
    "notes", "file", "checkbox", "radio"), field_label = c("Study ID",
    "First Name", "Last Name", "Street, City, State, ZIP", "Phone number",
    "E-mail", "Date of birth", "Age (years)", "Gender", "Height (cm)",
    "Weight (kilograms)", "BMI", "Comments", "Mugshot", "Race (Select all that apply)",
    "Ethnicity"), select_choices_or_calculations = c("", "",
    "", "", "", "", "", "rounddown(datediff([dob],'today','y'))",
    "0, Female | 1, Male", "", "", "round(([weight]*10000)/(([height])^(2)),1)",
    "", "", "1, American Indian/Alaska Native | 2, Asian | 3, Native Hawaiian or Other Pacific Islander | 4, Black or African American | 5, White | 6, Unknown / Not Reported",
    "0, Unknown / Not Reported | 1, NOT Hispanic or Latino | 2, Hispanic or Latino"
    ), field_note = c("", "", "", "", "Include Area Code", "",
    "", "", "", "", "", "", "", "", "", ""), text_validation_type_or_show_slider_number = c("",
    "", "", "", "phone", "email", "date_ymd", "", "", "number",
    "integer", "", "", "", "", ""), text_validation_min = c(NA,
    NA, NA, NA, NA, NA, NA, NA, NA, 130L, 35L, NA, NA, NA, NA,
    NA), text_validation_max = c(NA, NA, NA, NA, NA, NA, NA,
    NA, NA, 215L, 200L, NA, NA, NA, NA, NA), identifier = c("",
    "y", "y", "y", "y", "y", "y", "", "", "", "", "", "", "",
    "", ""), branching_logic = c(NA, NA, NA, NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA), required_field = c(NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    ), custom_alignment = c(NA, NA, NA, NA, NA, NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA), question_number = c(NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
    matrix_group_name = c(NA, NA, NA, NA, NA, NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA), matrix_ranking = c(NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA), field_annotation = c(NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    )), .Names = c("field_name", "form_name", "section_header",
    "field_type", "field_label", "select_choices_or_calculations",
    "field_note", "text_validation_type_or_show_slider_number", "text_validation_min",
    "text_validation_max", "identifier", "branching_logic", "required_field",
    "custom_alignment", "question_number", "matrix_group_name", "matrix_ranking",
    "field_annotation"), class = "data.frame", row.names = c(NA,
    -16L))

  expected_outcome_message <- "The data dictionary describing 16 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  expect_message(
    returned_object <- redcap_metadata_read(redcap_uri=credential$redcap_uri, token=credential$token),
    regexp = expected_outcome_message
  )

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$forms_collapsed=="", "A subset of forms was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
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

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", verbose=T),
    regexp = expected_outcome_message
  )

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
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

  expected_outcome_message <- "5 records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="raw", export_data_access_groups=TRUE, verbose=T),
    regexp = expected_outcome_message
  )

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
test_that("All Records -label and DAG", {
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

  expected_outcome_message <- "5 records and 25 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=TRUE, verbose=T),
    regexp = expected_outcome_message
  )

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
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

  expected_outcome_message <- "5 records and 24 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    returned_object <- redcap_read_oneshot(redcap_uri=credential$redcap_uri, token=credential$token, raw_or_label="label", export_data_access_groups=FALSE, verbose=T),
    regexp = expected_outcome_message
  )

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
