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
  lst_status_code <- NULL
  lst_status_message <- NULL
  lst_outcome_message <- NULL
  success_combined <- TRUE

  message("Starting to update ", format(nrow(ds_to_write), big.mark=",", scientific=F, trim=T), " records to be written at ", Sys.time())
  for( i in seq_along(ds_glossary$id) ) {
    selected_indices <- seq(from=ds_glossary[i, "start_index"], to=ds_glossary[i, "stop_index"])
    #     selected_ids <- ids[selected_index]
    message("Writing batch ", i, " of ", nrow(ds_glossary), ", with indices ", min(selected_indices), " through ", max(selected_indices), ".")
    #TODO: add REDCapR:: when the function becomes public
    write_result <- redcap_write_oneshot(ds = ds_to_write[selected_indices, ],                                                  
                                                  redcap_uri = redcap_uri,
                                                  token = token,
                                                  verbose = verbose)
    
    lst_status_code[[i]] <- write_result$status_code
    lst_status_message[[i]] <- write_result$status_message
    lst_outcome_message[[i]] <- write_result$outcome_message
    
    if( !write_result$success )
      stop("The `redcap_write()` call failed on iteration", i, ". Set the `verbose` parameter to TRUE and rerun for additional information.")
    
    affected_ids <- c(affected_ids, write_result$affected_ids)
    success_combined <- success_combined | write_result$success
       
    rm(write_result) #Admittedly overkill defensiveness.
  }
  
  elapsed_seconds <- as.numeric(difftime( Sys.time(), start_time, units="secs"))
  status_code_combined <- paste(lst_status_code, collapse="; ")
  status_message_combined <- paste(lst_status_message, collapse="; ")
  outcome_message_combined <- paste(lst_outcome_message, collapse="; ")
#   outcome_message_overall <- paste0("\nAcross all batches,",
#                                    format(length(affected_ids), big.mark = ",", scientific = FALSE, trim = TRUE), 
#                                    " records were written to REDCap in ", 
#                                    round(elapsed_seconds, 2), 
#                                    " seconds.")
#   if( verbose ) 
#     message(outcome_message_overall)

  return( list(
    success = success_combined,
    status_code = status_code_combined,
    status_message = status_message_combined, 
    outcome_message = outcome_message_combined,
    records_affected_count = length(affected_ids),
    affected_ids = affected_ids,
    elapsed_seconds = elapsed_seconds    
  ) )
}
