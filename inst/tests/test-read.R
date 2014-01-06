require(testthat)

###########
context("Read")
###########
test_that("Smoke Test", {
  uri <- "https://miechvprojects.ouhsc.edu/redcap/redcap_v5.2.3/API/"
  token <- "9A81268476645C4E5F03428B8AC3AA7B" #UnitTestPhiFree
  
  expected_data_frame <- structure(list(record_id = 1:3, first_name = c("Nutmeg", "Tumtum", 
                            "Marcus"), last_name = c("Nutmouse", "Nutmouse", "Wood"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
                            "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402"
                            ), telephone = c("(432) 456-4848", "(234) 234-2343", "(433) 435-9865"
                            ), email = c("nutty@mouse.com", "tummy@mouse.comm", "mw@mwood.net"
                            ), dob = c("2003-08-30", "2003-03-10", "1934-04-09"), age = c(10L, 
                            10L, 79L), ethnicity = c(1L, 1L, 0L), race = c(2L, 6L, 4L), sex = c(0L, 
                            1L, 1L), height = c(5L, 6L, 180L), weight = c(1L, 1L, 80L), bmi = c(400, 
                            277.8, 24.7), comments = c("Character in a book, with some guessing", 
                            "A mouse character from a good book", "completely made up"), 
                                demographics_complete = c(2L, 2L, 2L)), .Names = c("record_id", 
                            "first_name", "last_name", "address", "telephone", "email", "dob", 
                            "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
                            "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, 
                            -3L))
  expected_csv <- structure("record_id,first_name,last_name,address,telephone,email,dob,age,ethnicity,race,sex,height,weight,bmi,comments,demographics_complete\n\"1\",\"Nutmeg\",\"Nutmouse\",\"14 Rose Cottage St.\r\nKenning UK, 323232\",\"(432) 456-4848\",\"nutty@mouse.com\",\"2003-08-30\",10,1,2,0,5,1,400,\"Character in a book, with some guessing\",2\n\"2\",\"Tumtum\",\"Nutmouse\",\"14 Rose Cottage Blvd.\r\nKenning UK 34243\",\"(234) 234-2343\",\"tummy@mouse.comm\",\"2003-03-10\",10,1,6,1,6,1,277.8,\"A mouse character from a good book\",2\n\"3\",\"Marcus\",\"Wood\",\"243 Hill St.\r\nGuthrie OK 73402\",\"(433) 435-9865\",\"mw@mwood.net\",\"1934-04-09\",79,0,4,1,180,80,24.7,\"completely made up\",2\n", "`Content-Type`" = structure(c("text/html", "utf-8"), .Names = c("", "charset")))
  expected_status_message <- "3 records and 16 columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."
  
  expect_message(
    returned_object <- redcap_read(redcap_uri=uri, token=token, verbose=T)    
  )
  
  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct") # dput(returned_object$data)
  expect_equivalent(returned_object$raw_csv, expected=expected_csv) # dput(returned_object$raw_csv)
  expect_true(is.null(returned_object$records_collapsed), "A subset of records was not requested.")
  expect_true(is.null(returned_object$fields_collapsed), "A subset of fields was not requested.")
  expect_match(returned_object$status_message, regexp=expected_status_message, perl=TRUE)
  expect_true(returned_object$success)
})
