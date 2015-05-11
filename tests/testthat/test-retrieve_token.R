library(testthat)

###########
context("Retrieve Token")
###########

dsn                   = NULL #The dsn is never really called in these tests
project_name          = "rc_project_1"
channel               = NULL
schema_name           = "[Redcap]"
procedure_name        = "[prcToken]"
variable_name_project = "@RedcapProjectName"
field_name_token      = "Token"

test_that("Bad Project Name", {
  expected_message <- "The 'project_name' parameter must contain only letters, numbers, and underscores."
  
  expect_error(
    regexp = expected_message,
    object = observed <- REDCapR::retrieve_token_mssql(
      dsn                   = dsn,
      project_name          = "!bad",
      channel               = channel,
      schema_name           = schema_name,
      procedure_name        = procedure_name,
      variable_name_project = variable_name_project,
      field_name_token      = field_name_token
    )
  )
})

test_that("Bad Schema Name", {
  expected_message <- "The 'schema_name' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets."
  
  expect_error(
    regexp = expected_message,
    object = observed <- REDCapR::retrieve_token_mssql(
      dsn                   = dsn,
      project_name          = project_name,
      channel               = channel,
      schema_name           = "!bad",
      procedure_name        = procedure_name,
      variable_name_project = variable_name_project,
      field_name_token      = field_name_token
    )
  )
})

test_that("Bad Procedure Name", {
  expected_message <- "The 'procedure_name' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets."
  
  expect_error(
    regexp = expected_message,
    object = observed <- REDCapR::retrieve_token_mssql(
      dsn                   = dsn,
      project_name          = project_name,
      channel               = channel,
      schema_name           = schema_name,
      procedure_name        = "!bad",
      variable_name_project = variable_name_project,
      field_name_token      = field_name_token
    )
  )
})

test_that("Bad Variable Name Project", {
  expected_message <- "The 'variable_name_project' parameter must contain only letters, numbers, and underscores.  It may optionally have a leading ampersand."
  
  expect_error(
    regexp = expected_message,
    object = observed <- REDCapR::retrieve_token_mssql(
      dsn                   = dsn,
      project_name          = project_name,
      channel               = channel,
      schema_name           = schema_name,
      procedure_name        = procedure_name,
      variable_name_project = "!bad",
      field_name_token      = field_name_token
    )
  )
})

test_that("Field Name Token", {
  expected_message <- "The 'field_name_token' parameter must contain only letters, numbers, and underscores."
  
  expect_error(
    regexp = expected_message,
    object = observed <- REDCapR::retrieve_token_mssql(
      dsn                   = dsn,
      project_name          = project_name,
      channel               = channel,
      schema_name           = schema_name,
      procedure_name        = procedure_name,
      variable_name_project = variable_name_project,
      field_name_token      = "!bad"
    )
  )
})

test_that("Missing DSN & Channel", {
  expected_message <- "The 'dsn' parameter can be missing only if a 'channel' has been passed to 'retrieve_token_mssql'."
  
  expect_error(
    regexp = expected_message,
    object = observed <- REDCapR::retrieve_token_mssql(
      dsn                   = dsn,
      project_name          = project_name,
      channel               = channel,
      schema_name           = schema_name,
      procedure_name        = procedure_name,
      variable_name_project = variable_name_project,
      field_name_token      = field_name_token
    )
  )
})
