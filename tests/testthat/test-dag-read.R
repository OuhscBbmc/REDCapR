library(testthat)

credential_1        <- retrieve_credential_testing()
credential_no_dag   <- retrieve_credential_testing(2597L)


test_that("smoke", {
  testthat::skip_on_cran()
  expect_message(
    returned <- redcap_dag_read(
      redcap_uri  = credential_1$redcap_uri,
      token       = credential_1$token
    )
  )
})

test_that("dag-default", {
  testthat::skip_on_cran()
  expected_data <-
    structure(list(data_access_group_name = c("dag_1", "dag_2"),
      unique_group_name = c("dag_1", "dag_2")), row.names = c(NA,
      -2L), class = "data.frame"
    )
  expect_message(
    actual <- redcap_dag_read(
      redcap_uri  = credential_1$redcap_uri,
      token       = credential_1$token
    )
  )

  expect_true( actual$success)
  expect_equal(actual$status_code, 200L)
  expect_equal(actual$data, expected_data)
})

test_that("dag-default", {
  testthat::skip_on_cran()
  expected_data <-
    structure(list(data_access_group_name = character(0),
      unique_group_name = character(0)), row.names = integer(0),
      class = "data.frame"
    )

  expect_message(
    actual <- redcap_dag_read(
      redcap_uri  = credential_no_dag$redcap_uri,
      token       = credential_no_dag$token
    )
  )

  expect_true( actual$success)
  expect_equal(actual$status_code, 200L)
  expect_equal(actual$data, expected_data)
})

rm(credential_1)
rm(credential_no_dag)
