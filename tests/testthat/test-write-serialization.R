test_that("write serialization preserves large IDs without scientific notation", {
  ds <- data.frame(
    record_id = c(99999, 100000, NA, 200000),
    value = c("a", "b", "c", "d")
  )

  expected  <- "\"record_id\",\"value\"\n99999,\"a\"\n100000,\"b\"\n,\"c\"\n200000,\"d\"\n"
  observed  <- REDCapR:::serialize_csv_for_write(ds)

  expect_identical(observed, expected)
  expect_false(grepl("1e\\+05|2e\\+05", observed))
})
