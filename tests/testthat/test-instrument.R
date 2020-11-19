library(testthat)

credential <- retrieve_credential_testing()
delay_after_download_file <- 1.0 # In seconds

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
  expect_equal(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_equal(returned_object$file_name, "instruments.pdf", label="The name of the downloaded file should be correct.")
})

test_that("download instrument conflict -Error", {
  testthat::skip_on_cran()

  expected_outcome_message_1  <- '*text/html; charset=UTF-8 successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as instruments\\.pdf'
  expected_outcome_message_2  <- 'The operation was halted because the file `instruments\\.pdf`\\s+already exists and `overwrite` is FALSE\\.  Please check the directory if you believe this is a mistake\\.'

  tryCatch({
    # The first run should work.
    expect_message(
      returned_object_1 <- redcap_download_instrument(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
      ),
      regexp = expected_outcome_message_1
    )
    Sys.sleep(delay_after_download_file)

    #Test the values of the returned object.
    expect_true(returned_object_1$success)
    expect_equal(returned_object_1$status_code, expected=200L)

    # The second run should fail (b/c the file already exists).
    expect_error(
      returned_object_2 <- redcap_download_instrument(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        overwrite     = FALSE
      ),
      regexp = expected_outcome_message_2
    )
    Sys.sleep(delay_after_download_file)

    expect_false(exists("returned_object_2"))

  }, finally = base::unlink(returned_object_1$file_name)
  )
})

test_that("bad token -Error", {
  testthat::skip_on_cran()
  expected_outcome_message <- "file NOT downloaded."

  testthat::expect_message(
    returned_object <-
      redcap_download_instrument(
        redcap_uri  = credential$redcap_uri,
        token       = "BAD00000000000000000000000000000"
      ),
    expected_outcome_message
  )

  testthat::expect_false(returned_object$success)
  testthat::expect_equal(returned_object$status_code, 403L)
  testthat::expect_equal(returned_object$raw_text, "ERROR: You do not have permissions to use the API")
})

rm(credential)
