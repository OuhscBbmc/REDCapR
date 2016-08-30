library(testthat)
context("Retrieve Credentials MS-SQL")

pid_read           <- 153L #This project is for testing only reading from the server.

test_that("Missing DSN", {
  expected_message <- "The 'dsn' parameter can be missing only if a 'channel' has been passed to 'retrieve_token_mssql'."
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, "dev", channel=NULL)
  )
  
})

test_that("Bad project ID", {
  expected_message <- "The 'project_id' parameter must contain at least one digit, and only digits."
  
  #Digits with letters
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, "asdf32", "dev", channel=NULL)
  )
  
  #letters only
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, "asdf", "dev", channel=NULL)
  )
  
  #dashes #1
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, "234 --DROP tbl_bobby", "dev", channel=NULL)
  )
  
  #dashes #2
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, "234 --332", "dev", channel=NULL)
  )
  
  #Blank
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, "", "dev", channel=NULL)
  )
})
test_that("Bad instance name", {
  expected_message <- "The 'instance' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets."

  #dashes #1
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, instance="234 --DROP tbl_bobby", channel=NULL)
  )
  
  #dashes #2
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, instance="234 --332", channel=NULL)
  )
  
  #Blank
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, instance="", channel=NULL)
  )
})
test_that("Bad schema name", {
  expected_message <- "The 'schema_name' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets."

  #dashes #1
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, "dev", schema_name="234 --DROP tbl_bobby", channel=NULL)
  )
  
  #dashes #2
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, "dev", schema_name="234 --332", channel=NULL)
  )
  
  #Blank
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, "dev", schema_name="", channel=NULL)
  )
})
test_that("Bad procedure name", {
  expected_message <- "The 'procedure_name' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets."

  #dashes #1
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, "dev", procedure_name="234 --DROP tbl_bobby", channel=NULL)
  )
  
  #dashes #2
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, "dev", procedure_name="234 --332", channel=NULL)
  )
  
  #Blank
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=NULL, pid_read, "dev", procedure_name="", channel=NULL)
  )
})

