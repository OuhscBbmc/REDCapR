library(testthat)
context("Users Export")

credential_1 <- REDCapR::retrieve_credential_local(
  path_credential = system.file("misc/example.credentials", package="REDCapR"),
  project_id      = 999
)

credential_2 <- REDCapR::retrieve_credential_local(
  path_credential = system.file("misc/example.credentials", package="REDCapR"),
  project_id      = 153
)

test_that("smoke test", {
  testthat::skip_on_cran()
  expect_message({
    returned_object_1 <- redcap_users_export(redcap_uri=credential_1$redcap_uri, token=credential_1$token, verbose=T)
    returned_object_2 <- redcap_users_export(redcap_uri=credential_2$redcap_uri, token=credential_2$token, verbose=T)
  })
})

test_that("with DAGs", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The REDCap users were successfully exported in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."
  expected_data_user <- structure(
    list(username = c("dwells", "unittestphifree", "wbeasleya"
    ), email = c("donna-wells@ouhsc.edu", "wibeasley@hotmail.com",
    "william-beasley@ouhsc.edu"), firstname = c("Donna", "Unit Test",
    "Will"), lastname = c("Wells", "PHI Free", "Beasley_A"), expiration = structure(c(20334,
    NA, NA), class = "Date"), data_access_group = c("dagb", "daga",
    NA), data_access_group_id = c("332", "331", NA), design = c(FALSE,
    FALSE, TRUE), user_rights = c(FALSE, FALSE, TRUE), data_access_groups = c(FALSE,
    FALSE, TRUE), data_export = c("2", "1", "1"), reports = c(FALSE,
    FALSE, TRUE), stats_and_charts = c(FALSE, FALSE, TRUE), manage_survey_participants = c(TRUE,
    TRUE, TRUE), calendar = c(FALSE, FALSE, TRUE), data_import_tool = c(FALSE,
    FALSE, TRUE), data_comparison_tool = c(FALSE, FALSE, TRUE), logging = c(FALSE,
    FALSE, TRUE), file_repository = c(FALSE, FALSE, TRUE), data_quality_create = c(FALSE,
    FALSE, TRUE), data_quality_execute = c(FALSE, FALSE, TRUE), api_export = c(FALSE,
    TRUE, TRUE), api_import = c(FALSE, FALSE, TRUE), mobile_app = c(FALSE,
    FALSE, TRUE), mobile_app_download_data = c(FALSE, FALSE, TRUE
    ), record_create = c(FALSE, FALSE, TRUE), record_rename = c(FALSE,
    FALSE, FALSE), record_delete = c(FALSE, FALSE, FALSE), lock_records_all_forms = c(FALSE,
    FALSE, FALSE), lock_records = c(FALSE, FALSE, FALSE), lock_records_customization = c(FALSE,
    FALSE, FALSE)), row.names = c(NA, -3L), class = c("tbl_df", "tbl",
    "data.frame")
  )
  expected_data_user_form <- structure(
    list(username = c("dwells", "unittestphifree", "wbeasleya"
    ), form_name = c("demographics", "demographics", "demographics"
    ), permission = c(TRUE, TRUE, TRUE)), class = c("tbl_df", "tbl",
    "data.frame"), row.names = c(NA, -3L)
  )

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_users_export(redcap_uri=credential_1$redcap_uri, token=credential_1$token, verbose=T)
  )

  expect_equivalent(returned_object$data_user     , expected=expected_data_user     , label="The returned data.frame should be correct") # dput(returned_object$data_user);
  expect_equivalent(returned_object$data_user_form, expected=expected_data_user_form, label="The returned data.frame should be correct") # dput(returned_object$data_user_form)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  # system.file("misc/example.credentials", package="REDCapR")

  # expect_equal_to_reference(returned_object$data, file=system.file("test-data/project-simple/variations/default.rds", package="REDCapR"))
  # expect_equal_to_reference(returned_object$data, file="./test-data/project-simple/variations/default.rds")
})
test_that("with DAGs", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The REDCap users were successfully exported in \\d+(\\.\\d+\\W|\\W)seconds\\.  The http status code was 200\\."
  expected_data_user <- structure(
    list(username = c("unittestphifree", "wbeasleya"),
    email = c("wibeasley@hotmail.com", "william-beasley@ouhsc.edu"
    ), firstname = c("Unit Test", "Will"), lastname = c("PHI Free",
    "Beasley_A"), expiration = structure(c(NA_real_, NA_real_
    ), class = "Date"), data_access_group = c(NA_character_,
    NA_character_), data_access_group_id = c(NA_character_, NA_character_
    ), design = c(FALSE, TRUE), user_rights = c(FALSE, TRUE),
    data_access_groups = c(FALSE, TRUE), data_export = c("1",
    "1"), reports = c(TRUE, TRUE), stats_and_charts = c(TRUE,
    TRUE), manage_survey_participants = c(TRUE, TRUE), calendar = c(TRUE,
    TRUE), data_import_tool = c(FALSE, TRUE), data_comparison_tool = c(FALSE,
    TRUE), logging = c(FALSE, TRUE), file_repository = c(TRUE,
    TRUE), data_quality_create = c(FALSE, TRUE), data_quality_execute = c(FALSE,
    TRUE), api_export = c(TRUE, FALSE), api_import = c(FALSE,
    FALSE), mobile_app = c(FALSE, FALSE), mobile_app_download_data = c(FALSE,
    FALSE), record_create = c(TRUE, TRUE), record_rename = c(FALSE,
    FALSE), record_delete = c(FALSE, FALSE), lock_records_all_forms = c(FALSE,
    FALSE), lock_records = c(FALSE, FALSE), lock_records_customization = c(FALSE,
    FALSE)), row.names = c(NA, -2L), class = c("tbl_df", "tbl",
    "data.frame")
  )
  expected_data_user_form <- structure(
    list(username = c("unittestphifree", "unittestphifree",
    "unittestphifree", "wbeasleya", "wbeasleya", "wbeasleya"), form_name = c("demographics",
    "health", "race_and_ethnicity", "demographics", "health", "race_and_ethnicity"
    ), permission = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)), class = c("tbl_df",
    "tbl", "data.frame"), row.names = c(NA, -6L)
  )

  expect_message(
    regexp           = expected_outcome_message,
    returned_object <- redcap_users_export(redcap_uri=credential_2$redcap_uri, token=credential_2$token, verbose=T)
  )

  expect_equivalent(returned_object$data_user     , expected=expected_data_user     , label="The returned data.frame should be correct") # dput(returned_object$data_user);
  expect_equivalent(returned_object$data_user_form, expected=expected_data_user_form, label="The returned data.frame should be correct") # dput(returned_object$data_user_form)
  expect_equal(returned_object$status_code, expected=200L)
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})
