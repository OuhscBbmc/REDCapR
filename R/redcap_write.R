redcap_write <- function( ds_to_write, 
                          batch_size = 100L,
                          interbatch_delay = 0,
                          redcap_uri,
                          token,
                          verbose = TRUE ) {  
  
  if( base::missing(redcap_uri) )
    base::stop("The required parameter `redcap_uri` was missing from the call to `redcap_write()`.")
  
  if( base::missing(token) )
    base::stop("The required parameter `token` was missing from the call to `redcap_write()`.")

  start_time <- base::Sys.time()

  ds_glossary <- REDCapR::create_batch_glossary(row_count=base::nrow(ds_to_write), batch_size=batch_size)
  
  affected_ids <- character(0)
  lst_status_message <- NULL
  success_combined <- TRUE

  message("Starting to update ", format(nrow(ds_to_write), big.mark=",", scientific=F, trim=T), " records to be written at ", Sys.time())
  for( i in seq_along(ds_glossary$id) ) {
    selected_indices <- seq(from=ds_glossary[i, "start_index"], to=ds_glossary[i, "stop_index"])
    #     selected_ids <- ids[selected_index]
    message("Writing batch ", i, " of ", nrow(ds_glossary), ", with indices ", min(selected_indices), " through ", max(selected_indices), ".")
    write_result <- REDCapR:::redcap_write_oneshot(ds = ds_to_write[selected_indices, ],                                                  
                                                  redcap_uri = redcap_uri,
                                                  token = token,
                                                  verbose = verbose)
    
    lst_status_message[[i]] <- write_result$status_message
    if( !write_result$success )
      stop("The `redcap_write()` call failed on iteration", i, ". Set the `verbose` parameter to TRUE and rerun for additional information.")
    
    affected_ids <- c(affected_ids, write_result$affected_ids)
    success_combined <- success_combined | write_result$success
       
    rm(write_result) #Admittedly overkill defensiveness.
  }
  
  elapsed_seconds <- as.numeric(difftime( Sys.time(), start_time, units="secs"))
  status_message_combined <- paste(lst_status_message, collapse="; ")
  status_message_overall <- paste0("\nAcross all batches,",
                                   format(length(affected_ids), big.mark = ",", scientific = FALSE, trim = TRUE), 
                                   " records were written to REDCap in ", 
                                   round(elapsed_seconds, 2), 
                                   " seconds.")
  if( verbose ) 
    message(status_message_overall)

  return( list(
    affected_id_count = length(affected_ids), 
    affected_ids = affected_ids, 
    elapsed_seconds = elapsed_seconds, 
    status_message = status_message_combined,  
    success = success_combined
  ) )
}

# dsToWrite <- structure(list(record_id = 1:5, first_name = c("Nutmeg", "Tumtum", 
#                                                             "Marcus", "Trudy", "John Lee"), last_name = c("Nutmouse", "Nutmouse", 
#                                                                                                           "Wood", "DAG", "Walker"), address = c("14 Rose Cottage St.\nKenning UK, 323232", 
#                                                                                                                                                 "14 Rose Cottage Blvd.\nKenning UK 34243", "243 Hill St.\nGuthrie OK 73402", 
#                                                                                                                                                 "342 Elm\nDuncanville TX, 75116", "Hotel Suite\nNew Orleans LA, 70115"
#                                                                                                           ), telephone = c("(432) 456-4848", "(234) 234-2343", "(433) 435-9865", 
#                                                                                                                            "(987) 654-3210", "(333) 333-4444"), email = c("nutty@mouse.com", 
#                                                                                                                                                                           "tummy@mouse.comm", "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
#                                                                                                                            ), dob = c("2003-08-30", "2003-03-10", "1934-04-09", "1952-11-02", 
#                                                                                                                                       "1955-04-15"), age = c(10L, 10L, 79L, 61L, 58L), ethnicity = c(1L, 
#                                                                                                                                                                                                      1L, 0L, 1L, 1L), race = c(2L, 6L, 4L, 4L, 4L), sex = c(0L, 1L, 
#                                                                                                                                                                                                                                                             1L, 0L, 1L), height = c(5, 6, 180, 165, 193.04), weight = c(1L, 
#                                                                                                                                                                                                                                                                                                                         1L, 80L, 54L, 104L), bmi = c(400, 277.8, 24.7, 19.8, 27.9), comments = c("Character in a book, with some guessing", 
#                                                                                                                                                                                                                                                                                                                                                                                                  "A mouse character from a good book", "completely made up", "This record doesn't have a DAG assigned\n\nSo call up Trudy on the telephone\nSend her a letter in the mail", 
#                                                                                                                                                                                                                                                                                                                                                                                                  "Had a hand for trouble and a eye for cash\nHe had a gold watch chain and a black mustache\n\nhttps://www.youtube.com/watch?v=DUESvITrvsI"
#                                                                                                                                                                                                                                                                                                                         ), demographics_complete = c(2L, 2L, 2L, 2L, 2L)), .Names = c("record_id", 
#                                                                                                                                                                                                                                                                                                                                                                                       "first_name", "last_name", "address", "telephone", "email", "dob", 
#                                                                                                                                                                                                                                                                                                                                                                                       "age", "ethnicity", "race", "sex", "height", "weight", "bmi", 
#                                                                                                                                                                                                                                                                                                                                                                                       "comments", "demographics_complete"), class = "data.frame", row.names = c(NA, 
#                                                                                                                                                                                                                                                                                                                                                                                                                                                                 -5L))
# dsToWrite <- dsToWrite[1:3, ]
# result <- REDCapR:::redcap_write(batch_size=2L, ds=dsToWrite, redcap_uri="https://bbmc.ouhsc.edu/redcap/api/", token = "9A81268476645C4E5F03428B8AC3AA7B")
# str(result)
