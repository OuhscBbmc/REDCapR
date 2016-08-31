library(testthat)
context("Retrieve Token")

test_that("Missing DSN & Channel", {
  testthat::skip_if_not_installed(pkg="RODBC"); testthat::skip_if_not_installed(pkg="RODBCext")
  expected_message <- "The 'dsn' parameter can be missing only if a 'channel' has been passed to 'retrieve_token_mssql'."
  
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name="rc_project_1", dsn=NULL)
  )
})

test_that("Bad Project Name", {
  testthat::skip_if_not_installed(pkg="RODBC"); testthat::skip_if_not_installed(pkg="RODBCext")
  expected_message <- "The 'project_name' parameter must contain only letters, numbers, and underscores."
  
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name="!bad")
  )
    
  #dashes #1
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name="234 --DROP tbl_bobby")
  )
  
  #dashes #2
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name="234 --332")
  )
  
  #Blank
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name="")
  )
})
test_that("project_name wrong length", {
  testthat::skip_if_not_installed(pkg="RODBC"); testthat::skip_if_not_installed(pkg="RODBCext")
  expected_message <- "The `project_name` parameter should contain exactly one element."

  #empty
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name=character(0))
  )
  
  #too many
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name=character(2))
  )
})
test_that("dsn wrong length", {
  testthat::skip_if_not_installed(pkg="RODBC"); testthat::skip_if_not_installed(pkg="RODBCext")
  expected_message <- "The `dsn` parameter should contain at most one element."

  #too many
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name='rc_project_1', dsn=character(2))
  )
})
test_that("bad type: project_name", {
  testthat::skip_if_not_installed(pkg="RODBC"); testthat::skip_if_not_installed(pkg="RODBCext")
  expected_message <- "The `project_name` parameter be a character type."

  #integer
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name=integer(1))
  )
  
  #numeric
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name=numeric(1))
  )
})
test_that("bad type: DSN name", {
  testthat::skip_if_not_installed(pkg="RODBC"); testthat::skip_if_not_installed(pkg="RODBCext")
  expected_message <- "The `dsn` parameter be a character type, or missing or NULL."

  #integer
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(dsn=integer(1), project_name="rc_project_1")
  )
  
  #numeric
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(dsn=integer(1), project_name="rc_project_1")
  )
})

test_that("bad type: channel ", {
  testthat::skip_if_not_installed(pkg="RODBC"); testthat::skip_if_not_installed(pkg="RODBCext")
  expected_message <- "The `channel` parameter be a `RODBC` type, or NULL."

  #integer
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name="rc_project_1", channel=integer(1))
  )

  #numeric
  expect_error(
    regexp = expected_message,
    REDCapR::retrieve_token_mssql(project_name="rc_project_1", channel=numeric(1))
  )
})
