create_batch_glossary <- function( row_count, batch_size ) {
  digit_count <- nchar(row_count) #Determine the number of characters needed to express the number of rows.
  start_index <- seq(from=1, to=row_count, by=batch_size)
  
  ds_batch <- data.frame(id=seq_along(start_index), start_index=start_index)
  ds_batch$stop_index <- mapply(function(i) ifelse(i<length(start_index), start_index[i+1]-1, row_count), ds_batch$id )
  
  ds_batch$index_pretty <- stringr::str_pad(ds_batch$id, width=max(nchar(ds_batch$id)), pad="0")
  ds_batch$start_index_pretty <- stringr::str_pad(ds_batch$start_index, width=digit_count, pad="0")
  ds_batch$stop_index_pretty <- stringr::str_pad(ds_batch$stop_index, width=digit_count, pad="0")
  ds_batch$label <- paste0(ds_batch$index_pretty, "_", ds_batch$start_index_pretty, "_", ds_batch$stop_index_pretty)
  
  return(ds_batch)
}

# REDCapR:::create_batch_glossary(100, 3)
