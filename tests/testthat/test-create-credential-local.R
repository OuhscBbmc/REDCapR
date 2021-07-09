library(testthat)

test_that("existing directory", {
  path_demo <- base::tempfile(pattern="temp", fileext=".credentials")
  on.exit(base::unlink(path_demo))

  success <- create_credential_local(path_demo)

  expect_true(success)
  expect_true(base::file.exists(path_demo))
})

test_that("new directory", {
  path_demo <- base::tempfile(pattern="new-dir/temp", fileext=".credentials")
  on.exit(base::unlink(path_demo))

  success <- create_credential_local(path_demo)

  expect_true(success)
  expect_true(base::file.exists(path_demo))
})

test_that("overwrite-fail", {
  # expected_message <- "^A credential file already exists at .+?\\.credentials'\\.$"
  expected_message <- "^A credential file already exists at .+?\\.credentials`\\.$"

  path_demo <- base::tempfile(pattern="temp", fileext=".credentials")
  on.exit(base::unlink(path_demo))

  success <- create_credential_local(path_demo)
  expect_true(success)

  expect_error(
    regexp = expected_message,
    create_credential_local(path_demo)
  )

})
