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

test_that("validate_no_logical -good", {
  ds <- validate_no_logical(ds_good, stop_on_error = TRUE)
  expect_equal(nrow(ds), 0)
})

test_that("validate_no_logical -stop on error", {
  expect_error(
    validate_no_logical(ds_bad, stop_on_error = TRUE),
    "1 field\\(s\\) were logical/boolean. The REDCap API does not automatically convert boolean values to 0/1 values.  Convert the variable with the `as.integer\\(\\)` function."
  )
})

test_that("validate_no_logical -concern dataset", {
  ds <- validate_no_logical(ds_bad)
  expect_equal(object=nrow(ds), expected=1, info="One logical field should be flagged")
  expect_equal(object=ds$field_name, expected="bad_logical")
  expect_equal(object=unname(ds$field_index), expected="2")
})

# ---- redcap-repeat-instance --------------------------------------------------
test_that("repeat-instance: no column", {
  ds <- validate_repeat_instance(mtcars)
  expect_equal(object = nrow(ds), expected = 0)
})

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
