library(testthat)
context("Retrieve Credentials Local")

path               <- system.file("misc/example.credentials", package="REDCapR")
pid_read           <- 153L #This project is for testing only reading from the server.
pid_longitudinal   <- 212L #This project is for testing reading longitudinal projects.
pid_write          <- 213L #This project is for testing reading & writing.

test_that("Good Credentials", {
  expected_read_redcap_uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
  expected_read_username        <- "myusername"
  expected_read_project_id      <- pid_read
  expected_read_token           <- "9A81268476645C4E5F03428B8AC3AA7B"
  expected_read_comment         <- "simple static (read-only) test project"
  
  expected_longitudinal_redcap_uri     <- "https://bbmc.ouhsc.edu/redcap/api/"
  expected_longitudinal_username       <- "myusername"
  expected_longitudinal_project_id     <- pid_longitudinal
  expected_longitudinal_token          <- "0434F0E9CF53ED0587847AB6E51DE762"
  expected_longitudinal_comment        <- "longitudinal (read-only) test project"
  
  expected_write_redcap_uri     <- "https://bbmc.ouhsc.edu/redcap/api/"
  expected_write_username       <- "myusername"
  expected_write_project_id     <- pid_write
  expected_write_token          <- "D70F9ACD1EDD6F151C6EA78683944E98"
  expected_write_comment        <- "simple write test project"

  credential_read         <- REDCapR::retrieve_credential_local(path, pid_read)
  credential_longitudinal <- REDCapR::retrieve_credential_local(path, pid_longitudinal)
  credential_write        <- REDCapR::retrieve_credential_local(path, pid_write)
  
  expect_equal(credential_read$redcap_uri   , expected_read_redcap_uri)
  expect_equal(credential_read$username     , expected_read_username)
  expect_equal(credential_read$project_id   , expected_read_project_id)
  expect_equal(credential_read$token        , expected_read_token)
  expect_equal(credential_read$comment      , expected_read_comment)
  
  expect_equal(credential_longitudinal$redcap_uri   , expected_longitudinal_redcap_uri)
  expect_equal(credential_longitudinal$username     , expected_longitudinal_username)
  expect_equal(credential_longitudinal$project_id   , expected_longitudinal_project_id)
  expect_equal(credential_longitudinal$token        , expected_longitudinal_token)
  expect_equal(credential_longitudinal$comment      , expected_longitudinal_comment)
  
  expect_equal(credential_write$redcap_uri   , expected_write_redcap_uri)
  expect_equal(credential_write$username     , expected_write_username)
  expect_equal(credential_write$project_id   , expected_write_project_id)
  expect_equal(credential_write$token        , expected_write_token)
  expect_equal(credential_write$comment      , expected_write_comment)
})

test_that("Missing file", {
  expected_message <- "The credential file was not found."
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path           = system.file("misc/missing.credentials", package="REDCapR"),
      project_id     = pid_read
    )
  )
})
test_that("Malformed file", {
  expected_message <- "The credentials file did not contain the proper variables"
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path           = system.file("misc/out-of-order.credentials", package="REDCapR"),
      project_id     = pid_read
    )
  )
})

test_that("Zero rows", {
  expected_message <- "The project_id was not found in the csv credential file."
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path           = system.file("misc/zero-rows.credentials", package="REDCapR"),
      project_id     = pid_read
    )
  )
})

test_that("Zero matching rows", {
  expected_message <- "The project_id was not found in the csv credential file."
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path           = path,
      project_id     = 666L
    )
  )
})

test_that("Conflicting rows", {
  expected_message <- "More than one matching project_id was found in the csv credential file.  There should be only one."
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path           = system.file("misc/conflicting-rows.credentials", package="REDCapR"),
      project_id     = pid_read
    )
  )
})

test_that("Bad URI", {
  expected_message <- "The REDCap URL does not reference an https address.  First check that the URL is correct, and then consider using SSL to encrypt the REDCap webserver.  Set the `check_url` parameter to FALSE if you're sure you have the correct file & file contents."
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path                = system.file("misc/bad.credentials", package="REDCapR"),
      project_id          = pid_read,
      check_url           = TRUE,
      check_username      = FALSE,
      check_token_pattern = FALSE
    )
  )
})

test_that("Bad Username", {
  expected_message <- "doesn't match the username in the credentials file."
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path                = system.file("misc/bad.credentials", package="REDCapR"),
      project_id          = pid_read,
      check_url           = FALSE,
      check_username      = TRUE,
      check_token_pattern = FALSE
    )
  )
})

test_that("Bad URI", {
  expected_message <- "A REDCap token should be a string of 32 digits and uppercase characters.  The retrieved value was not. Set the `check_token_pattern` parameter to FALSE if you're sure you have the correct file & file contents."
  
  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path                = system.file("misc/bad.credentials", package="REDCapR"),
      project_id          = pid_read,
      check_url           = FALSE,
      check_username      = FALSE,
      check_token_pattern = TRUE
    )
  )
})