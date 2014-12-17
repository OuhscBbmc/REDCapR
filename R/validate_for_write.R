#' @name validate_for_write
#' @aliases validate_for_write validate_no_logical validate_no_uppercase
#' @export validate_for_write validate_no_logical validate_no_uppercase 
#' 
#' @usage
#' validate_for_write( d )
#' 
#' validate_no_logical( d )
#' 
#' validate_no_uppercase( d )
#' 
#' @title Inspect a \code{data.frame} to anticipate problems before writing to a REDCap project.
#'  
#' @description This set of functions inspect a \code{data.frame} to anticipate problems before writing with REDCap's \href{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}{API}.
#' 
#' @param d The \code{data.frame} containing the dataset used to update the REDCap project.  Required.
#' @return A \code{data.frame}, where each potential violation is a row.  The two columns are:
#' \enumerate{
#'  \item \code{field_name}: The name of the \code{data.frame} that might cause problems during the upload.
#'  \item \code{field_index}: The position of the field.  (For example, a value of '1' indicates the first column, while a '3' indicates the third column.)
#'  \item \code{concern}: A description of the problem potentially caused by the \code{field}.
#'  \item \code{suggestion}: A \emph{potential} solution to the concern.
#' }
#' @details 
#' All functions listed in the Usage section above inspect a specific aspect of the dataset.  The \code{validate_for_read()} function executes all
#' these individual validation checks.  It allows the client to check everything with one call.
#' 
#' @author Will Beasley
#' 
#' @examples
#' d <- data.frame(
#'   record_id = 1:4,
#'   flag_logical = c(TRUE, TRUE, FALSE, TRUE),
#'   flag_Uppercase = c(4, 6, 8, 2)
#' )
#' validate_for_write(d = d)


validate_no_logical <- function( d ) {
  indices <- which(sapply(d, class)=="logical")
  
  if( length(indices) == 0 ) {
    return( data.frame())
  }
  else {    
    data.frame(
      field_name = colnames(d)[indices],
      field_index = indices,
      concern = "The REDCap API does not automatically convert boolean values to 0/1 values.",
      suggestion = "Convert the variable with the `as.integer()` function.",
      stringsAsFactors = FALSE
    )
  }
}
validate_no_uppercase <- function( d ) {
  indices <- grep(pattern="[A-Z]", x=colnames(d), perl=TRUE)
  if( length(indices) == 0 ) {
    return( data.frame())
  }
  else { 
    data.frame(
      field_name = colnames(d)[indices],
      field_index = indices,
      concern = "A REDCap project does not allow field names with an uppercase letter.",
      suggestion = "Change the uppercase letters to lowercase, potentially with `base::tolower()`.",
      stringsAsFactors = FALSE
    )
  }
}

validate_for_write <- function( d ) {
  lstConcerns <- list(
    validate_no_logical(d),
    validate_no_uppercase(d)
  )
  dsAggregatedConcerns <- data.frame(do.call(plyr::rbind.fill, lstConcerns), stringsAsFactors=FALSE) #Vertically stack all the data.frames into a single data.frame
  
 return( dsAggregatedConcerns )
}
