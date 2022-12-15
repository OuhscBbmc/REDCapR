library(testthat)

credential_1        <- retrieve_credential_testing()
credential_no_dag   <- retrieve_credential_testing(2597L)

test_that("smoke", {
  testthat::skip_on_cran()
  expect_message({
    returned <-
      redcap_dag_read(
        redcap_uri  = credential_1$redcap_uri,
        token       = credential_1$token,
        verbose     = TRUE
      )
  })
  expect_type(returned, "list")
})

test_that("dag-default", {
  testthat::skip_on_cran()
  expected_data <-
    structure(list(data_access_group_name = c("dag_1", "dag_2"),
      unique_group_name = c("dag_1", "dag_2"), data_access_group_id = c(36,
      37)), row.names = c(NA, -2L), spec = structure(list(cols = list(
      data_access_group_name = structure(list(), class = c("collector_character",
      "collector")), unique_group_name = structure(list(), class = c("collector_character",
      "collector")), data_access_group_id = structure(list(), class = c("collector_double",
      "collector"))), default = structure(list(), class = c("collector_guess",
      "collector")), delim = ","), class = "col_spec"), class = c("spec_tbl_df",
      "tbl_df", "tbl", "data.frame")
    )
  # dput(actual$data)
  actual <-
    redcap_dag_read(
      redcap_uri  = credential_1$redcap_uri,
      token       = credential_1$token,
      verbose     = FALSE
    )

  expect_true( actual$success)
  expect_equal(actual$status_code, 200L)
  expect_equal(actual$data, expected_data)
  expect_s3_class(actual$data, "tbl")
})

test_that("dag-default", {
  testthat::skip_on_cran()
  expected_data <-
    structure(
      list(data_access_group_name = character(0), unique_group_name = character(0),
      data_access_group_id = character(0)), row.names = integer(0), spec = structure(list(
      cols = list(data_access_group_name = structure(list(), class = c("collector_character",
      "collector")), unique_group_name = structure(list(), class = c("collector_character",
      "collector")), data_access_group_id = structure(list(), class = c("collector_character",
      "collector"))), default = structure(list(), class = c("collector_guess",
      "collector")), delim = ","), class = "col_spec"), class = c("spec_tbl_df",
      "tbl_df", "tbl", "data.frame")
    )
  # dput(actual$data)

  actual <-
    redcap_dag_read(
      redcap_uri  = credential_no_dag$redcap_uri,
      token       = credential_no_dag$token,
      verbose     = FALSE
    )

  expect_true( actual$success)
  expect_equal(actual$status_code, 200L)
  expect_equal(actual$data, expected_data)
  expect_s3_class(actual$data, "tbl")
})

rm(credential_1)
rm(credential_no_dag)
