library(testthat)
context("Retrieve Credentials MS-SQL")

pid_read           <- 153L #This project is for testing only reading from the server.

test_that("Missing DSN", {
  expected_message <- "The 'dsn' parameter can be missing only if a 'channel' has been passed to 'retrieve_token_mssql'."
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_mssql(pid_read, "dev")
  )
  
})

test_that("Bad project ID", {
  expected_message <- "The 'project_id' parameter must contain at least one digit, and only digits."
  
  #Digits with letters
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(-2L, "dev")
  )
  
})
test_that("Bad instance name", {
  expected_message <- "The 'instance' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets."

  #dashes #1
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(pid_read, instance="234 --DROP tbl_bobby")
  )
  
  #dashes #2
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(pid_read, instance="234 --332")
  )
  
  #Blank
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(pid_read, instance="")
  )
})

test_that("pid wrong length", {
  expected_message <- "The `project_id` parameter should contain exactly one element."

  #empty
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(project_id=integer(0), instance="234 --DROP tbl_bobby")
  )
  
  #too many
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(project_id=integer(2), instance="234 --DROP tbl_bobby")
  )
})

test_that("instance wrong length", {
  expected_message <- "The `instance` parameter should contain exactly one element."

  #empty
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(pid_read, instance=character(0))
  )
  
  #too many
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(pid_read, instance=character(2))
  )
})

test_that("bad type: project_id", {
  expected_message <- "The `project_id` parameter be a integer type."

  #character
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(character(1), instance="dev")
  )

  #numeric
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(numeric(1), instance="dev")
  )
})
test_that("bad type: instance", {
  expected_message <- "The `instance` parameter be a character type."

  #integer
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(pid_read, instance=integer(1))
  )
  
  #numeric
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(pid_read, instance=numeric(1))
  )
})
test_that("bad type: DSN name", {
  expected_message <- "The `dsn` parameter be a character type, or missing or NULL."

  #integer
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=integer(1), pid_read, instance="dev")
  )
  
  #numeric
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(dsn=integer(1), pid_read, instance="dev")
  )
})

test_that("bad type: channel ", {
  expected_message <- "The `channel` parameter be a `RODBC` type, or NULL."

  #integer
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(pid_read, instance="dev", channel=integer(1))
  )

  #numeric
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_credential_mssql(pid_read, instance="dev", channel=numeric(1))
  )
})

