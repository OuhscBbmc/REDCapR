library(testthat)
context("Retrieve Token")

dsn                   <- NULL #The dsn is never really called in these tests
project_name          <- "rc_project_1"
channel               <- NULL


test_that("Bad Project Name", {
  testthat::skip_if_not_installed(pkg = "RODBC")
  expected_message <- "The 'project_name' parameter must contain only letters, numbers, and underscores."
  
  expect_error(
    regexp = expected_message,
    object = observed <- REDCapR::retrieve_token_mssql(
      dsn                   = dsn,
      project_name          = "!bad",
      channel               = channel
    )
  )
})

test_that("Missing DSN & Channel", {
  testthat::skip_if_not_installed(pkg = "RODBC")
  expected_message <- "The 'dsn' parameter can be missing only if a 'channel' has been passed to 'retrieve_token_mssql'."
  
  expect_error(
    regexp = expected_message,
    object = observed <- REDCapR::retrieve_token_mssql(
      dsn                   = dsn,
      project_name          = project_name,
      channel               = channel
    )
  )
})
