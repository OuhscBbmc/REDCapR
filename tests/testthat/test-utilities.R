library(testthat)

###########
context("Replace NAs")
###########


# test_that("replace_nas_standard", {
#   a <- letters
#   missing_indices <- c(3, 6, 8, 25)
#   a[missing_indices] <- NA_character_
#   
#   expected <- c("a", "b", "Unknown", "d", "e", "Unknown", "g", "Unknown", "i", "j", "k", "l", "m", 
#                 "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "Unknown", "z")
#   
#   a <- REDCapR::replace_nas_with_factor_level(a)
#   expect_equal(a, expected)
#   
#   batchSize <- 100
#   expectedGlossaryCount <- 1
#   
#   dsResult <- REDCapR::create_batch_glossary(row_count=rowCount, batch_size=batchSize) # dput(dsResult)
#   dsExpected <- structure(list(id = 1L, start_index = 1, stop_index = 100, index_pretty = "1", 
#                                start_index_pretty = "001", stop_index_pretty = "100", label = "1_001_100"), .Names = c("id", 
#                                                                                                                        "start_index", "stop_index", "index_pretty", "start_index_pretty", 
#                                                                                                                        "stop_index_pretty", "label"), row.names = c(NA, -1L), class = "data.frame")
#   
#   expect_equal(object=nrow(dsResult), expected=expectedGlossaryCount, info="The number of batches should be correct.")
#   expect_equal(object=colnames(dsResult), expected=ExpectedColumnNames, info="The column namesshould be correct.")
#   expect_equal(object=dsResult, expected=dsExpected, info="The returned batch glossary should be correct.")
# })
