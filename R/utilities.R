#' @name replace_nas_with_factor_level
#' @export replace_nas_with_factor_level
#' 
#' @title Create explicit factor level for missing values.
#'  
#' @description Missing values are converted to a factor level.  This explicit assignment can reduce the chances that missing values are inadvertantly ignored.  
#' It also allows the presence of a missing to become a predictor in models.
#' 
#' @param scores An array of values, ideally either factor or character. Required
#' @param new_na_label The factor label assigned to the missing value.  Defaults to \code{Unknown}.
#' @param add_unknown_level Should a new factor level be created?  (Specify \code{TRUE} if it already exists.)   Defaults to \code{FALSE}.
#' 
#' @return An array of values, where the \code{NA} values are now a factor level, with the label specified by the \code{new_na_label} value.
#' 
#' @note
#' A \code{stop} error will be thrown if the operation fails to convert all the \code{NA} values.
#' 
#' @author Will Beasley
#' 
#' @examples
#' library(REDCapR) #Load the package into the current R session.

replace_nas_with_factor_level <- function( scores, new_na_label="Unknown", add_unknown_level=FALSE) {
  
  if( add_unknown_level ) {
    levels(scores) <- c(levels(scores), new_na_label)  #Add a new level called 'Unknown'
  }
  
  scores[is.na(scores)] <- new_na_label #"Unknown"
  
  if(any(is.na(scores))) 
    stop("The reassigned factor variable should not have any NA values.")
  
  return( scores )
}

