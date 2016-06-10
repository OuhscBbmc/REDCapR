library(testthat)
context("Replace NAs")

test_that("replace_nas_character_standard", {
  a <- letters
  missing_indices <- c(3, 6, 8, 25)
  a[missing_indices] <- NA_character_
  
  expected <- c("a", "b", "Unknown", "d", "e", "Unknown", "g", "Unknown", "i", "j", "k", "l", "m", 
                "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "Unknown", "z")
  
  a <- REDCapR:::replace_nas_with_explicit(a)
  expect_equal(a, expected, label="The correct letters should have been replaced.")
  expect_equal(class(a), "character", "The returned array should remain a character.")
})


test_that("replace_nas_factor_standard", {
  a <- factor(letters, levels=letters)
  missing_indices <- c(3, 6, 8, 25)
  a[missing_indices] <- NA_character_
  
  expected <- structure(c(1L, 2L, 27L, 4L, 5L, 27L, 7L, 27L, 9L, 10L, 11L, 12L, 13L, 14L, 15L, 16L, 17L, 18L, 19L, 20L, 21L, 22L, 23L, 24L, 27L, 26L), 
                        .Label = c(letters, "Unknown"), 
                        class = "factor")
  
  a <- REDCapR:::replace_nas_with_explicit(a, create_factor=F, add_unknown_level=T)
  expect_equal(a, expected, label="The correct letters should have been replaced.")
  expect_equal(class(a), "factor", "The returned array should be a converted factor.")
})
test_that("replace_nas_factor_create_not_existing", {
  a <- letters
  missing_indices <- c(3, 6, 8, 25)
  a[missing_indices] <- NA_character_
  
  expected <- structure(c(1L, 2L, 23L, 3L, 4L, 23L, 5L, 23L, 6L, 7L, 8L, 9L,  10L, 11L, 12L, 13L, 14L, 15L, 16L, 17L, 18L, 19L, 20L, 21L, 23L,  22L), 
                        .Label = c("a", "b", "d", "e", "g", "i", "j", "k", "l",  "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "z", "Unknown"), 
                        class = "factor")
  
  a <- REDCapR:::replace_nas_with_explicit(a, create_factor=T, add_unknown_level=T)
  expect_equal(a, expected, label="The correct letters should have been replaced.")
  expect_equal(class(a), "factor", "The returned array should be a converted factor.")
})
test_that("replace_nas_factor_create_already_existing", {
  a <- factor(letters, levels=letters, labels=letters)
  missing_indices <- c(3, 6, 8, 25)
  a[missing_indices] <- NA_character_
  
  expected <- structure(c(1L, 2L, 27L, 4L, 5L, 27L, 7L, 27L, 9L, 10L, 11L, 12L, 13L, 14L, 15L, 16L, 17L, 18L, 19L, 20L, 21L, 22L, 23L, 24L, 27L, 26L), 
                        .Label = c(letters, "Unknown"), 
                        class = "factor")
  
  a <- REDCapR:::replace_nas_with_explicit(a, create_factor=T, add_unknown_level=T)
  expect_equal(a, expected, label="The correct letters should have been replaced.")
  expect_equal(class(a), "factor", "The returned array should be a converted factor.")
})

test_that("replace_nas_factor_not_yet", {
  a <- letters
  missing_indices <- c(3, 6, 8, 25)
  a[missing_indices] <- NA_character_
  
  expected <- c("a", "b", "Unknown", "d", "e", "Unknown", "g", "Unknown", "i", "j", "k", "l", "m", 
                "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "Unknown", "z")
  
  expect_error(
    REDCapR:::replace_nas_with_explicit(a, add_unknown_level=T)
    , regexp = "The `replace_nas_with_explicit\\(\\)` function cannot add a level to `scores` when it is not a factor\\.  Consider setting `create_factor=TRUE`\\."
  )
})
