#' @title
#' Validate and sanitize the user's REDCap token
#'
#' @description
#' Verifies the token is nonmissing and conforms to the legal
#' pattern of a 32-character hexadecimal value.
#' Each character must be an (a) digit 0-9, (b) uppercase letter A-F, or
#' (c) lowercase letter a-f.
#' Trailing line endings are removed.
#'
#' A typical user does not call this function directly.  However functions like
#' [redcap_read()] call it to provide a more informative
#' error message to the user.
#'
#' Some institutions create their own tokens --not the standard
#' 32-character hexadecimal value.  The pattern that validates their tokens
#' can be specified with the system environmental variable
#' `REDCAP_TOKEN_PATTERN` using
#' [base::Sys.setenv].
#'
#' For example, the following regex pattern captures a
#' [base64 encoded value](https://en.wikipedia.org/wiki/Base64)
#' with 40 characters (as opposed to a hexadecimal/base16 value
#' with 32 characters):
#' `^([A-Za-z\\d+/\\+=]{40})$`.
#' See <https://rgxdb.com/r/1NUN74O6>
#' for alternative approaches to validate base64 values.
#'
#' If no pattern is specified, the default is a 32-character hex token:
#' `^([0-9A-Fa-f]{32})(?:\\n)?$`.  The important segment is contained in the
#' first (and only) capturing group
#' (*i.e.*, `[0-9A-Fa-f]{32}`).
#' Any trailing newline character is removed.
#'
#' @param token The REDCap token. Required.
#'
#' @return
#' The token, without a terminal newline character.
#'
#' @details
#' Although the function does not accept a parameter,
#' it is influenced by the `REDCAP_TOKEN_PATTERN`
#' environmental variable.
#'
#' @note
#' Contact your institution's REDCap administrator for more information
#' about your project-specific token.
#'
#' @author
#' Hao Zhu, Benjamin Nutter, Will Beasley, Jordan Mark Barbone
#'
#' @examples
#' secret_token_1 <- "12345678901234567890123456ABCDEF"
#' secret_token_2 <- "12345678901234567890123456ABCDEF\n"
#' secret_token_3 <- "12345678901234567890123456abcdef"
#' REDCapR::sanitize_token(secret_token_1)
#' REDCapR::sanitize_token(secret_token_2)
#' REDCapR::sanitize_token(secret_token_3)
#'
#' # Some institutions use a token system that follows a different pattern
#' Sys.setenv("REDCAP_TOKEN_PATTERN" = "^([A-Za-z\\d+/\\+=]{10})$")
#'
#' secret_token_4 <- "abcde1234="
#' REDCapR::sanitize_token(secret_token_4)
#' Sys.getenv("REDCAP_TOKEN_PATTERN")
#' Sys.unsetenv("REDCAP_TOKEN_PATTERN")

#' @export
sanitize_token <- function(token) {
  checkmate::assert_character(token, any.missing = TRUE, len = 1)

  pattern_env <- Sys.getenv("REDCAP_TOKEN_PATTERN")
  pattern <-
    if (pattern_env != "") {
      checkmate::assert_character(pattern_env, any.missing = FALSE, len = 1)
      pattern_env
    } else {
      "^([0-9A-Fa-f]{32})(?:\\n)?$"
    }

  if (is.na(token)) {
    stop(
      "The token is `NA`, which is not allowed."
    )
  } else if (nchar(token) == 0L) {
    stop(
      "The token is an empty string, which is not allowed."
    )
  } else if (!grepl(pattern, token, perl = TRUE)) {
    stop(
      "The token does not conform with the regex `",
      pattern,
      "`."
    )
  }

  sub(pattern, "\\1", token, perl = TRUE)
}
