#' @name create_batch_glossary
#' @export create_batch_glossary
#' 
#' @title Creates a \code{data.frame} that help batching long-running read and writes.
#'  
#' @description The function returns a \code{data.frame} that other functions use to separate long-running
#' read and write REDCap calls into multiple, smaller REDCap calls.  The goal is to (1) reduce the chance of time-outs, 
#' and (2) introduce little breaks between batches so that the server isn't continually tied up.
#' 
#' @param row_count The number records in the large dataset, before it's split.
#' @param batch_size The maximum number of subject records a single batch should contain.

#' @return Currently, a \code{data.frame} is returned with the following columns,
#' \enumerate{
#'  \item \code{id}: an \code{integer} that uniquely identifies the batch, starting at \code{1}.
#'  \item \code{start_index}: the index of the first row in the batch. \code{integer}.
#'  \item \code{stop_index}: the index of the last row in the batch. \code{integer}.
#'  \item \code{id_pretty}: a \code{character} representation of \code{id}, but padded with zeros.
#'  \item \code{start_index}: a \code{character} representation of \code{start_index}, but padded with zeros.
#'  \item \code{stop_index}: a \code{character} representation of \code{stop_index}, but padded with zeros.
#'  \item \code{label}: a \code{character} concatenation of \code{id_pretty}, \code{start_index}, and \code{stop_index_pretty}.
#' }
#' @details 
#' This function can also assist splitting and saving a large \code{data.frame} to disk as smaller files (such as a .csv).
#' The padded columns allow the OS to sort the batches/files in sequential order.
#' 
#' @author Will Beasley
#'  
#' @seealso
#' See \code{\link{redcap_read}} for a function that uses \code{create_batch_gloassary}.
#' 
#' @examples
#' library(REDCapR) #Load the package into the current R session.
#' create_batch_glossary(100, 50)
#' create_batch_glossary(100, 25)
#' create_batch_glossary(100, 3)
#' d <- data.frame(
#'   record_id = 1:100,
#'   iv = sample(x=4, size=100, replace=TRUE),
#'   dv = rnorm(n=100)
#' )
#' create_batch_glossary(nrow(d), batch_size=40)

create_batch_glossary <- function( row_count, batch_size ) {
  if( !(!is.na(row_count) & (length(row_count)==1L) & (row_count[1]>=1) | (class(row_count) == "integer")) )
    stop("`row_count` must be a positive scalar integer.")
  if( !(!is.na(batch_size) & (length(batch_size)==1L) & (batch_size[1]>=1) | (class(batch_size) == "integer")) )
    stop("`batch_size` must be a positive scalar integer.")
  
  start_index <- base::seq.int(from=1, to=row_count, by=batch_size)
  
  ds_batch <- base::data.frame(id=seq_along(start_index), start_index=start_index)
  ds_batch$stop_index <- base::mapply(function(i) base::ifelse(i<length(start_index), start_index[i+1]-1, row_count), ds_batch$id )
 
  sprintf_format_1 <- base::paste0("%0.", base::max(base::nchar(ds_batch$id)), "i")
  sprintf_format_2 <- base::paste0("%0.", base::nchar(row_count), "i")
  
  ds_batch$index_pretty <- base::sprintf(sprintf_format_1, ds_batch$id)
  ds_batch$start_index_pretty <-base::sprintf(sprintf_format_2, ds_batch$start_index)
  ds_batch$stop_index_pretty <- base::sprintf(sprintf_format_2, ds_batch$stop_index)
  ds_batch$label <- base::paste0(ds_batch$index_pretty, "_", ds_batch$start_index_pretty, "_", ds_batch$stop_index_pretty)
  
  return( ds_batch )
}

# REDCapR::create_batch_glossary(100, 3)
