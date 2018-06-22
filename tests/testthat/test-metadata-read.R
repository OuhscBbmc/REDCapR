library(testthat)
context("Metadata Read")

credential <- REDCapR::retrieve_credential_local(
  path_credential = system.file("misc/example.credentials", package="REDCapR"),
  project_id      = 153
)
credential_super_wide <- REDCapR::retrieve_credential_local(
  path_credential = system.file("misc/example.credentials", package="REDCapR"),
  project_id      = 753
)

test_that("Metadata Smoke Test", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <- redcap_metadata_read(redcap_uri=credential$redcap_uri, token=credential$token)
  )
})


test_that("Super-wide", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The data dictionary describing 3,001 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."
  expected_row_count    <- 3001L
  expected_column_count <- 18L
  expected_na_cells     <- 42014L

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_metadata_read(redcap_uri=credential_super_wide$redcap_uri, token=credential_super_wide$token)
  )

  expect_equal(nrow(returned_object$data), expected=expected_row_count) # dput(returned_object$data)
  expect_equal(ncol(returned_object$data), expected=expected_column_count)
  expect_equal(sum(is.na(returned_object$data)), expected=expected_na_cells)
})

test_that("Metadata Normal", {
  testthat::skip_on_cran()
  expected_data_frame <- structure(list(field_name = c("record_id", "name_first", "name_last",
    "address", "telephone", "email", "dob", "age", "sex", "height",
    "weight", "bmi", "comments", "mugshot", "race", "ethnicity"),
    form_name = c("demographics", "demographics", "demographics",
    "demographics", "demographics", "demographics", "demographics",
    "demographics", "demographics", "health", "health", "health",
    "health", "health", "race_and_ethnicity", "race_and_ethnicity"
    ), section_header = c(NA, "Contact Information", NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, "General Comments", NA, NA,
    NA), field_type = c("text", "text", "text", "notes", "text",
    "text", "text", "text", "radio", "text", "text", "calc",
    "notes", "file", "checkbox", "radio"), field_label = c("Study ID",
    "First Name", "Last Name", "Street, City, State, ZIP", "Phone number",
    "E-mail", "Date of birth", "Age (years)", "Gender", "Height (cm)",
    "Weight (kilograms)", "BMI", "Comments", "Mugshot", "Race (Select all that apply)",
    "Ethnicity"), select_choices_or_calculations = c(NA, NA,
    NA, NA, NA, NA, NA, NA, "0, Female | 1, Male", NA, NA, "round(([weight]*10000)/(([height])^(2)),1)",
    NA, NA, "1, American Indian/Alaska Native | 2, Asian | 3, Native Hawaiian or Other Pacific Islander | 4, Black or African American | 5, White | 6, Unknown / Not Reported",
    "0, Unknown / Not Reported | 1, NOT Hispanic or Latino | 2, Hispanic or Latino"
    ), field_note = c(NA, NA, NA, NA, "Include Area Code", NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA), text_validation_type_or_show_slider_number = c(NA,
    NA, NA, NA, "phone", "email", "date_ymd", NA, NA, "number",
    "integer", NA, NA, NA, NA, NA), text_validation_min = c(NA,
    NA, NA, NA, NA, NA, NA, NA, NA, "130", "35", NA, NA, NA,
    NA, NA), text_validation_max = c(NA, NA, NA, NA, NA, NA,
    NA, NA, NA, "215", "200", NA, NA, NA, NA, NA), identifier = c(NA,
    "y", "y", "y", "y", "y", "y", NA, NA, NA, NA, NA, NA, NA,
    NA, NA), branching_logic = c(NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_), required_field = c(NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_), custom_alignment = c(NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_), question_number = c(NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_), matrix_group_name = c(NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_), matrix_ranking = c(NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_), field_annotation = c(NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_, NA_character_,
    NA_character_, NA_character_, NA_character_)), .Names = c("field_name",
    "form_name", "section_header", "field_type", "field_label", "select_choices_or_calculations",
    "field_note", "text_validation_type_or_show_slider_number", "text_validation_min",
    "text_validation_max", "identifier", "branching_logic", "required_field",
    "custom_alignment", "question_number", "matrix_group_name", "matrix_ranking",
    "field_annotation"), row.names = c(NA, -16L), class = c("tbl_df",
    "tbl", "data.frame"), spec = structure(list(cols = structure(list(
    field_name = structure(list(), class = c("collector_character",
    "collector")), form_name = structure(list(), class = c("collector_character",
    "collector")), section_header = structure(list(), class = c("collector_character",
    "collector")), field_type = structure(list(), class = c("collector_character",
    "collector")), field_label = structure(list(), class = c("collector_character",
    "collector")), select_choices_or_calculations = structure(list(), class = c("collector_character",
    "collector")), field_note = structure(list(), class = c("collector_character",
    "collector")), text_validation_type_or_show_slider_number = structure(list(), class = c("collector_character",
    "collector")), text_validation_min = structure(list(), class = c("collector_character",
    "collector")), text_validation_max = structure(list(), class = c("collector_character",
    "collector")), identifier = structure(list(), class = c("collector_character",
    "collector")), branching_logic = structure(list(), class = c("collector_character",
    "collector")), required_field = structure(list(), class = c("collector_character",
    "collector")), custom_alignment = structure(list(), class = c("collector_character",
    "collector")), question_number = structure(list(), class = c("collector_character",
    "collector")), matrix_group_name = structure(list(), class = c("collector_character",
    "collector")), matrix_ranking = structure(list(), class = c("collector_character",
    "collector")), field_annotation = structure(list(), class = c("collector_character",
    "collector"))), .Names = c("field_name", "form_name", "section_header",
    "field_type", "field_label", "select_choices_or_calculations",
    "field_note", "text_validation_type_or_show_slider_number", "text_validation_min",
    "text_validation_max", "identifier", "branching_logic", "required_field",
    "custom_alignment", "question_number", "matrix_group_name", "matrix_ranking",
    "field_annotation")), default = structure(list(), class = c("collector_character",
    "collector"))), .Names = c("cols", "default"), class = "col_spec"))

  expected_outcome_message <- "The data dictionary describing 16 fields was read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200."

  expect_message(
    returned_object <- redcap_metadata_read(redcap_uri=credential$redcap_uri, token=credential$token),
    regexp = expected_outcome_message
  )

  # datapasta::tribble_paste(returned_object$data)
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_true(returned_object$forms_collapsed=="", "A subset of forms was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
