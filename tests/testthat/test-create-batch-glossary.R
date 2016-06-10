library(testthat)
context("Create Batch Glossary")

ExpectedColumnNames <- c("id", "start_index", "stop_index", "index_pretty", "start_index_pretty", 
                         "stop_index_pretty", "label") #dput(colnames(dsResult))

test_that("N100B3", {
  rowCount <- 100
  batchSize <- 3
  expectedGlossaryCount <- 34
  
  dsResult <- REDCapR::create_batch_glossary(row_count=rowCount, batch_size=batchSize) # dput(dsResult)
  dsExpected <- structure(list(id = 1:34, start_index = c(1, 4, 7, 10, 13, 16, 
                                                          19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49, 52, 55, 58, 61, 64, 
                                                          67, 70, 73, 76, 79, 82, 85, 88, 91, 94, 97, 100), stop_index = c(3, 
                                                                                                                           6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 
                                                                                                                           54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99, 
                                                                                                                           100), index_pretty = c("01", "02", "03", "04", "05", "06", "07", 
                                                                                                                                                  "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", 
                                                                                                                                                  "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", 
                                                                                                                                                  "30", "31", "32", "33", "34"), start_index_pretty = c("001", 
                                                                                                                                                                                                        "004", "007", "010", "013", "016", "019", "022", "025", "028", 
                                                                                                                                                                                                        "031", "034", "037", "040", "043", "046", "049", "052", "055", 
                                                                                                                                                                                                        "058", "061", "064", "067", "070", "073", "076", "079", "082", 
                                                                                                                                                                                                        "085", "088", "091", "094", "097", "100"), stop_index_pretty = c("003", 
                                                                                                                                                                                                                                                                         "006", "009", "012", "015", "018", "021", "024", "027", "030", 
                                                                                                                                                                                                                                                                         "033", "036", "039", "042", "045", "048", "051", "054", "057", 
                                                                                                                                                                                                                                                                         "060", "063", "066", "069", "072", "075", "078", "081", "084", 
                                                                                                                                                                                                                                                                         "087", "090", "093", "096", "099", "100"), label = c("01_001_003", 
                                                                                                                                                                                                                                                                                                                              "02_004_006", "03_007_009", "04_010_012", "05_013_015", "06_016_018", 
                                                                                                                                                                                                                                                                                                                              "07_019_021", "08_022_024", "09_025_027", "10_028_030", "11_031_033", 
                                                                                                                                                                                                                                                                                                                              "12_034_036", "13_037_039", "14_040_042", "15_043_045", "16_046_048", 
                                                                                                                                                                                                                                                                                                                              "17_049_051", "18_052_054", "19_055_057", "20_058_060", "21_061_063", 
                                                                                                                                                                                                                                                                                                                              "22_064_066", "23_067_069", "24_070_072", "25_073_075", "26_076_078", 
                                                                                                                                                                                                                                                                                                                              "27_079_081", "28_082_084", "29_085_087", "30_088_090", "31_091_093", 
                                                                                                                                                                                                                                                                                                                              "32_094_096", "33_097_099", "34_100_100")), .Names = c("id", 
                                                                                                                                                                                                                                                                                                                                                                                     "start_index", "stop_index", "index_pretty", "start_index_pretty", 
                                                                                                                                                                                                                                                                                                                                                                                     "stop_index_pretty", "label"), row.names = c(NA, -34L), class = "data.frame")
  
  expect_equal(object=nrow(dsResult), expected=expectedGlossaryCount, info="The number of batches should be correct.")
  expect_equal(object=colnames(dsResult), expected=ExpectedColumnNames, info="The column namesshould be correct.")
  expect_equal(object=dsResult, expected=dsExpected, info="The returned batch glossary should be correct.")
})

test_that("N100B100", {
  rowCount <- 100
  batchSize <- 100
  expectedGlossaryCount <- 1
  
  dsResult <- REDCapR::create_batch_glossary(row_count=rowCount, batch_size=batchSize) # dput(dsResult)
  dsExpected <- structure(list(id = 1L, start_index = 1, stop_index = 100, index_pretty = "1", 
                               start_index_pretty = "001", stop_index_pretty = "100", label = "1_001_100"), .Names = c("id", 
                                                                                                                       "start_index", "stop_index", "index_pretty", "start_index_pretty", 
                                                                                                                       "stop_index_pretty", "label"), row.names = c(NA, -1L), class = "data.frame")
  
  expect_equal(object=nrow(dsResult), expected=expectedGlossaryCount, info="The number of batches should be correct.")
  expect_equal(object=colnames(dsResult), expected=ExpectedColumnNames, info="The column names should be correct.")
  expect_equal(object=dsResult, expected=dsExpected, info="The returned batch glossary should be correct.")
})

test_that("N50B10", {
  rowCount <- 50
  batchSize <- 10
  expectedGlossaryCount <- 5
  
  dsResult <- REDCapR::create_batch_glossary(row_count=rowCount, batch_size=batchSize) # dput(dsResult)
  dsExpected <- structure(list(id = 1:5, start_index = c(1, 11, 21, 31, 41), 
                               stop_index = c(10, 20, 30, 40, 50), index_pretty = c("1", 
                                                                                    "2", "3", "4", "5"), start_index_pretty = c("01", "11", "21", 
                                                                                                                                "31", "41"), stop_index_pretty = c("10", "20", "30", "40", 
                                                                                                                                                                   "50"), label = c("1_01_10", "2_11_20", "3_21_30", "4_31_40", 
                                                                                                                                                                                    "5_41_50")), .Names = c("id", "start_index", "stop_index", 
                                                                                                                                                                                                            "index_pretty", "start_index_pretty", "stop_index_pretty", "label"
                                                                                                                                                                                    ), row.names = c(NA, -5L), class = "data.frame")
  expect_equal(object=nrow(dsResult), expected=expectedGlossaryCount, info="The number of batches should be correct.")
  expect_equal(object=colnames(dsResult), expected=ExpectedColumnNames, info="The column names should be correct.")
  expect_equal(object=dsResult, expected=dsExpected, info="The returned batch glossary should be correct.")
})
