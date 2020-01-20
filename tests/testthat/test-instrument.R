library(testthat)

credential <- REDCapR::retrieve_credential_local(
  path_credential = system.file("misc/example.credentials", package="REDCapR"),
  project_id      = 153L
)

test_that("download instrument", {
  testthat::skip_on_cran()

  expected_outcome_message <- "Preparing to download the file `.+`."

  tryCatch({
    expect_message(
      returned_object <- redcap_download_instrument(
        redcap_uri  = credential$redcap_uri,
        token       = credential$token
      ),
      regexp = expected_outcome_message
    )
  }, finally = base::unlink(returned_object$file_name)
  )

  # start_time <- Sys.time() - lubridate::seconds(1) #Knock off a second in case there's small time imprecisions
  start_time <- Sys.time() - 10 #Knock off ten seconds in case there are small time imprecisions.
  expected_outcome_message <- "text/html; charset=UTF-8 successfully downloaded in .+? seconds, and saved as instruments\\.pdf\\."

  #Test the values of the returned object.
  expect_true(returned_object$success)
  expect_equal(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_equal(length(returned_object$record_id), 0L)
  expect_true(returned_object$elapsed_seconds>0, "The `elapsed_seconds` should be a positive number.")
  expect_equivalent(returned_object$raw_text, expected="") # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, "instruments.pdf", label="The name of the downloaded file should be correct.")
})

rm(credential)
