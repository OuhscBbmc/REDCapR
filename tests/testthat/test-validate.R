library(testthat)

ds_bad <- data.frame(
  record_id = 1:4,
  bad_logical = c(TRUE, TRUE, FALSE, TRUE),
  bad_Uppercase = c(4, 6, 8, 2)
)
ds_good <- data.frame(
  record_id = 1:4,
  not_logical = c(1, 1, 0, 1),
  no_uppercase = c(4, 6, 8, 2)
)

test_that("validate_for_write", {
  ds <- validate_for_write(d=ds_bad)
  expect_equal(object=nrow(ds), expected=2)
})

test_that("validate_for_write_no_errors", {
  ds <- validate_for_write(d=ds_good)
  expect_equal(object=nrow(ds), expected=0)
})

test_that("validate_for_write_no_errors - convert_logical_to_integer", {
  d <-
    data.frame(
      record_id     = 1:4,
      logical       = c(TRUE, TRUE, FALSE, TRUE),
      no_uppercase  = c(4, 6, 8, 2)
    )
  ds <- validate_for_write(d, convert_logical_to_integer = TRUE)
  expect_equal(object = nrow(ds), expected = 0)
})

test_that("not a data.frame", {
  error_pattern <- "The `d` object is not a valid `data\\.frame`\\."
  expect_error(
    validate_for_write(as.matrix(mtcars)),
    error_pattern
  )
})

# ---- redcap-repeat-instance --------------------------------------------------
# credential  <- REDCapR::retrieve_credential_local(
#   path_credential = system.file("misc/dev-2.credentials", package = "REDCapR"),
#   project_id      = 1400
# )


# test_that("repeat-instance: good integer", {
#   d <-
#     "test-data/vignette-repeating-write/data-block-matrix.csv" %>%
#     system.file(package = "REDCapR") %>%
#     readr::read_csv(show_col_types = FALSE) %>%
#     dplyr::mutate(
#       redcap_repeat_instance = as.integer(redcap_repeat_instance),
#     )
#
#   ds <- validate_repeat_instance(d)
#   expect_equal(object = nrow(ds), expected = 0)
# })
# test_that("repeat-instance: bad double", {
#   d <-
#     "test-data/vignette-repeating-write/data-block-matrix.csv" %>%
#     system.file(package = "REDCapR") %>%
#     readr::read_csv(show_col_types = FALSE)
#
#   ds_1 <- validate_repeat_instance(d)
#
#   expect_equal(object=nrow(ds_1), expected=1, info="One uppercase field should be flagged")
#   expect_equal(object=ds_1$field_name, expected="redcap_repeat_instance")
#   expect_equal(object=ds_1$field_index, expected=3)
#
#   ds_2 <- validate_for_write(d, convert_logical_to_integer = TRUE)
#
#   expect_equal(object=nrow(ds_2), expected=1, info="One uppercase field should be flagged")
#   expect_equal(object=ds_2$field_name, expected="redcap_repeat_instance")
#   expect_equal(object=ds_2$field_index, expected=3)
# })
#
# test_that("repeat-instance: bad double -stop on error", {
#   d <-
#     "test-data/vignette-repeating-write/data-block-matrix.csv" %>%
#     system.file(package = "REDCapR") %>%
#     readr::read_csv(show_col_types = FALSE)
#
#   expect_error(
#     validate_repeat_instance(d, stop_on_error = TRUE),
#     "The `redcap_repeat_instance` column should be an integer\\."
#   )
# })
