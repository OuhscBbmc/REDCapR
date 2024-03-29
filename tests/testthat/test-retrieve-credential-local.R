library(testthat)

path               <- system.file("misc/example.credentials", package="REDCapR")
pid_read           <- 153L # This project is for testing only reading from the server.
pid_longitudinal   <- 212L # This project is for testing reading longitudinal projects.
pid_write          <- 213L # This project is for testing reading & writing.
pid_dag            <- 2545L #This project is for testing DAGs.

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
  expected_longitudinal_comment        <- "longitudinal (read-only) ARM test project"

  expected_write_redcap_uri     <- "https://bbmc.ouhsc.edu/redcap/api/"
  expected_write_username       <- "myusername"
  expected_write_project_id     <- pid_write
  expected_write_token          <- "D70F9ACD1EDD6F151C6EA78683944E98"
  expected_write_comment        <- "simple write data"

  credential_read         <- retrieve_credential_testing(pid_read)          # This project is for testing only reading from the server.
  credential_longitudinal <- retrieve_credential_testing(pid_longitudinal)  # This project is for testing reading longitudinal projects.
  credential_write        <- retrieve_credential_testing(pid_write)         # This project is for testing reading & writing.

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
test_that("Multiple users", {
  expected_admin_redcap_uri     <- "https://bbmc.ouhsc.edu/redcap/api/"
  expected_admin_username       <- "admin"
  expected_admin_project_id     <- pid_dag
  expected_admin_token          <- "0BF11B9CB01F0B8F8EE203B7E07DEFD9"
  expected_admin_comment        <- "DAG Write -admin"

  expected_user_redcap_uri      <- "https://bbmc.ouhsc.edu/redcap/api/"
  expected_user_username        <- "user-dag1"
  expected_user_project_id      <- pid_dag
  expected_user_token           <- "C79DB3836373478986928303B52E74DF"
  expected_user_comment         <- "DAG Write -group A"

  credential_admin        <- retrieve_credential_testing(pid_read, expected_admin_username)
  credential_user         <- retrieve_credential_testing(pid_read, expected_user_username)

  expect_equal(credential_admin$redcap_uri  , expected_admin_redcap_uri)
  expect_equal(credential_admin$username    , expected_admin_username)
  expect_equal(credential_admin$project_id  , expected_admin_project_id)
  expect_equal(credential_admin$token       , expected_admin_token)
  expect_equal(credential_admin$comment     , expected_admin_comment)

  expect_equal(credential_user$redcap_uri   , expected_user_redcap_uri)
  expect_equal(credential_user$username     , expected_user_username)
  expect_equal(credential_user$project_id   , expected_user_project_id)
  expect_equal(credential_user$token        , expected_user_token)
  expect_equal(credential_user$comment      , expected_user_comment)
})

test_that("Missing file", {
  expected_message <- "Assertion on 'path_credential' failed: File does not exist: 'misc/missing.credentials'."

  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path_credential = "misc/missing.credentials", #system.file("misc/missing.credentials", package="REDCapR"),
      project_id      = pid_read
    )
  )
})
test_that("Malformed file", {
  expected_message <- "The credentials file did not contain the proper variables"

  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path_credential = system.file("misc/out-of-order.credentials", package="REDCapR"),
      project_id      = pid_read
    )
  )
})

test_that("Zero rows", {
  expected_message <- "The project_id was not found in the csv credential file."

  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path_credential = system.file("misc/zero-rows.credentials", package="REDCapR"),
      project_id      = pid_read
    )
  )
})

test_that("Zero matching rows", {
  expected_message <- "The project_id was not found in the csv credential file."

  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path_credential = path,
      project_id      = 666L
    )
  )
})

test_that("Conflicting rows", {
  expected_message <- "More than one matching project_id was found in the csv credential file.  There should be only one."

  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path_credential = system.file("misc/conflicting-rows.credentials", package="REDCapR"),
      project_id      = pid_read
    )
  )
})

test_that("Bad URI", {
  expected_message <- "The REDCap URL does not reference an https address\\."

  expect_error(
    regexp = expected_message,
    object = REDCapR::retrieve_credential_local(
      path_credential     = system.file("misc/bad.credentials", package="REDCapR"),
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
      path_credential     = system.file("misc/bad.credentials", package="REDCapR"),
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
      path_credential     = system.file("misc/bad.credentials", package="REDCapR"),
      project_id          = pid_read,
      check_url           = FALSE,
      check_username      = FALSE,
      check_token_pattern = TRUE
    )
  )
})

# rm(credential_read         )
# rm(credential_longitudinal )
# rm(credential_write        )
