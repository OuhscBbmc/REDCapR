#' @name sanitize_token
#' @export
#'
#' @title Validate and sanitize the user's REDCap token.
#'
#' @description Verifies the token is nonmissing and conforms to the legal pattern of a 32-character hexadecimal value.
#' Trailing line endings are removed.
#'
#' @param token The REDCap token. Required.
#'
#' @return The token, without a terminal newline character.
#'
#' @note Contact your institution's REDCap administrator for more informationa about your project-specific token.
#'
#' @author Hao Zhu, Benjamin Nutter, Will Beasley
#'
#' @examples
#' library(REDCapR) #Load the package into the current R session.
#' secret_token_1 <- "12345678901234567890123456ABCDEF"
#' secret_token_2 <- "12345678901234567890123456ABCDEF\n"
#' sanitize_token(secret_token_1)
#' sanitize_token(secret_token_2)

sanitize_token <- function( token ) {
  pattern <- "^([0-9A-F]{32})(?:\\n)?$"

  if( is.na(token) ) {
    stop("The token is `NA`, not a valid 32-character hexademical value.")
  } else if( nchar(token)==0L ) {
    stop("The token is an empty string, not a valid 32-character hexademical value.")
  } else if( !grepl(pattern, token, perl=TRUE) ) {
    stop("The token is not a valid 32-character hexademical value.")
  }

  sub(pattern, "\\1", token, perl=TRUE)
}
