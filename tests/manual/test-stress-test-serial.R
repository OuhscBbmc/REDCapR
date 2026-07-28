library(testthat)

credential <- retrieve_credential_testing()

read_count <- 2000L
file_count <-  200L

# Read ---------------------------------------------------
message("\n========\nRead")
expected_data_frame <- structure(list(record_id = c(1, 2, 3, 4, 5), name_first = c("Nutmeg",
  "Tumtum", "Marcus", "Trudy", "John Lee"), name_last = c("Nutmouse",
  "Nutmouse", "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232",
  "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402",
  "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
  ), telephone = c("(405) 321-1111", "(405) 321-2222", "(405) 321-3333",
  "(405) 321-4444", "(405) 321-5555"), email = c("nutty@mouse.com",
  "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
  ), dob = structure(c(12294, 12121, -13051, -6269, -5375), class = "Date"),
  age = c(11, 11, 80, 61, 59), sex = c(0, 1, 1, 0, 1), demographics_complete = c(2,
  2, 2, 2, 2), height = c(7, 6, 180, 165, 193.04), weight = c(1,
  1, 80, 54, 104), bmi = c(204.1, 277.8, 24.7, 19.8, 27.9),
  comments = c("Character in a book, with some guessing", "A mouse character from a good book",
  "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail",
  "Had a hand for trouble and a eye for cash\n\nHe had a gold watch chain and a black mustache"
  ), mugshot = c("mugshot-1.jpg", "mugshot-2.jpg", "mugshot-3.jpg",
  "mugshot-4.jpg", "mugshot-5.jpg"), health_complete = c(1,
  0, 2, 2, 0), race___1 = c(0, 0, 0, 0, 1), race___2 = c(0,
  0, 0, 1, 0), race___3 = c(0, 1, 0, 0, 0), race___4 = c(0,
  0, 1, 0, 0), race___5 = c(1, 1, 1, 1, 0), race___6 = c(0,
  0, 0, 0, 1), ethnicity = c(1, 1, 0, 1, 2), interpreter_needed = c(0,
  0, 1, NA, 0), race_and_ethnicity_complete = c(2, 0, 2, 2,
  2)), spec = structure(list(cols = list(record_id = structure(list(), class = c("collector_double",
  "collector")), name_first = structure(list(), class = c("collector_character",
  "collector")), name_last = structure(list(), class = c("collector_character",
  "collector")), address = structure(list(), class = c("collector_character",
  "collector")), telephone = structure(list(), class = c("collector_character",
  "collector")), email = structure(list(), class = c("collector_character",
  "collector")), dob = structure(list(format = ""), class = c("collector_date",
  "collector")), age = structure(list(), class = c("collector_double",
  "collector")), sex = structure(list(), class = c("collector_double",
  "collector")), demographics_complete = structure(list(), class = c("collector_double",
  "collector")), height = structure(list(), class = c("collector_double",
  "collector")), weight = structure(list(), class = c("collector_double",
  "collector")), bmi = structure(list(), class = c("collector_double",
  "collector")), comments = structure(list(), class = c("collector_character",
  "collector")), mugshot = structure(list(), class = c("collector_character",
  "collector")), health_complete = structure(list(), class = c("collector_double",
  "collector")), race___1 = structure(list(), class = c("collector_double",
  "collector")), race___2 = structure(list(), class = c("collector_double",
  "collector")), race___3 = structure(list(), class = c("collector_double",
  "collector")), race___4 = structure(list(), class = c("collector_double",
  "collector")), race___5 = structure(list(), class = c("collector_double",
  "collector")), race___6 = structure(list(), class = c("collector_double",
  "collector")), ethnicity = structure(list(), class = c("collector_double",
  "collector")), interpreter_needed = structure(list(), class = c("collector_double",
  "collector")), race_and_ethnicity_complete = structure(list(), class = c("collector_double",
  "collector"))), default = structure(list(), class = c("collector_guess",
  "collector")), delim = ","), class = "col_spec"), row.names = c(NA,
  -5L), class = c("spec_tbl_df", "tbl_df", "tbl", "data.frame"))

expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

for (i in seq_len(read_count)) {
  expect_message(
    returned_object <- redcap_read_oneshot(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      raw_or_label  = "raw"
    ),
    regexp = expected_outcome_message
  )

  expect_identical(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_identical(returned_object$status_code, expected=200L)
  expect_identical(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_identical(returned_object$records_collapsed, "", "A subset of records was not requested.")
  expect_identical(returned_object$fields_collapsed, "", "A subset of fields was not requested.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
  message(i, ": ", returned_object$elapsed_seconds)
}



# File ---------------------------------------------------
message("\n========\nFile")
for (i in seq_len(file_count)) {
  start_clean_result <- REDCapR:::clean_start_simple(batch=FALSE)
  project <- start_clean_result$redcap_project

  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  expect_message(
    returned_object <- redcap_read_oneshot(
      redcap_uri      = project$redcap_uri,
      token           = project$token,
      raw_or_label    = "raw"
    ),
    regexp = expected_outcome_message
  )

#   start_time <- Sys.time() - lubridate::seconds(1) # Knock off a second inc ase there's small time imprecisions
  start_time <- Sys.time() - 25 # Knock off a second in case there are small time imprecisions

  path_of_expected <- system.file("test-data/mugshot-1.jpg", package="REDCapR")
  info_expected <- file.info(path_of_expected)
  record <- 1
  field <- "mugshot"

  expected_outcome_message <- 'image/jpeg; name="mugshot-1\\.jpg" successfully downloaded in \\d+(\\.\\d+\\W|\\W)seconds\\, and saved as mugshot-1.jpg'
  # image/jpeg; name="mugshot-1.jpg" successfully downloaded in 0.7 seconds, and saved as mugshot-1.jpg

  tryCatch({
    expect_message(
      returned_object <- redcap_file_download_oneshot(
        record        = record,
        field         = field,
        redcap_uri    = start_clean_result$redcap_project$redcap_uri,
        token         = start_clean_result$redcap_project$token
      ),
      regexp = expected_outcome_message
    )
    info_actual <- file.info(returned_object$file_name)
    expect_true(file.exists(returned_object$file_name), "The downloaded file should exist.")
    }, finally = base::unlink("mugshot-1.jpg")
  )

  # Test the values of the returned object.
  expect_true(returned_object$success)
  expect_identical(returned_object$status_code, expected=200L)
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_identical(returned_object$records_affected_count, 1L)
  expect_identical(returned_object$affected_ids, "1")
  expect_gt(returned_object$elapsed_seconds, 0, "The `elapsed_seconds` should be a positive number.")
  expect_identical(returned_object$raw_text, expected="", ignore_attr = TRUE) # dput(returned_object$raw_text)
  expect_identical(returned_object$file_name, "mugshot-1.jpg", label="The name of the downloaded file should be correct.")

  # Test the values of the file.
  expect_identical(info_actual$size, expected=info_expected$size, label="The size of the downloaded file should match.")
  expect_false(info_actual$isdir, "The downloaded file should not be a directory.")
  expect_identical(info_actual$mode, expected=info_expected$mode, label="The mode/permissions of the downloaded file should match.")
  expect_gt(info_actual$mtime, expected=start_time, label="The downloaded file's modification time should not precede this function's start time.")
  expect_gt(info_actual$ctime, expected=start_time, label="The downloaded file's last change time should not precede this function's start time.")
  expect_gt(info_actual$atime, expected=start_time, label="The downloaded file's last access time should not precede this function's start time.")
  message(i, ": ", returned_object$elapsed_seconds)
}

rm(credential)
