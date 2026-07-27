test_that("write serialization preserves large IDs without scientific notation", {
  ds <- data.frame(
    record_id = c(99999, 100000, NA, 200000),
    value = c("a", "b", "c", "d")
  )

  csv <- REDCapR:::serialize_csv_for_write(ds)

  expect_match(csv, "100000,\"b\"", fixed = TRUE)
  expect_match(csv, ",\"c\"", fixed = TRUE)
  expect_match(csv, "200000,\"d\"", fixed = TRUE)
  expect_false(grepl("1e\\+05|2e\\+05", csv))
})
