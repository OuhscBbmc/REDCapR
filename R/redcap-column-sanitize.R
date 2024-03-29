#' @title
#' Sanitize to adhere to REDCap character encoding requirements
#'
#' @description
#' Replace non-ASCII characters with legal characters that won't
#' cause problems when writing to a REDCap project.
#'
#' @param d The [base::data.frame()] or [tibble::tibble()] containing the dataset
#' used to update the REDCap project.  Required.
#' @param column_names An array of `character` values indicating the names of
#' the variables to sanitize.  Optional.
#' @param encoding_initial An array of `character` values indicating the names
#' of the variables to sanitize.  Optional.
#' @param substitution_character The `character` value that replaces characters
#' that were unable to be appropriately matched.
#'
#' @return A data frame with same columns, but whose character values
#' have been sanitized.
#'
#' @details
#' Letters like an accented 'A' are replaced with a plain 'A'.
#'
#' This is a thin wrapper around [base::iconv()].
#' The `ASCII//TRANSLIT` option does the actual transliteration work.  As of
#' `R 3.1.0`, the OSes use similar, but different, versions to convert the
#' characters.  Be aware of this in case you notice OS-dependent differences.
#'
#' @author
#' Will Beasley
#'
#' @examples
#' # Typical examples are not shown because they require non-ASCII encoding,
#' #   which makes the package documentation less portable.
#'
#' dirty <- data.frame(
#'   id     = 1:3,
#'   names  = c("Ekstr\xf8m", "J\xf6reskog", "bi\xdfchen Z\xfcrcher")
#' )
#'
#' REDCapR::redcap_column_sanitize(dirty)

#' @export
redcap_column_sanitize <- function(
  d,
  column_names            = colnames(d),
  encoding_initial        = "latin1",
  substitution_character  = "?"
) {

  checkmate::assert_data_frame(d                      , any.missing=FALSE)
  checkmate::assert_character( column_names           , any.missing=FALSE)
  checkmate::assert_character( encoding_initial       , any.missing=FALSE, len=1)
  checkmate::assert_character( substitution_character , any.missing=FALSE, len=1, pattern="^.$")

  for (column in column_names) {
    d[[column]] <- base::iconv(
      x     = d[[column]],
      from  = encoding_initial,
      to    = "ASCII//TRANSLIT",
      sub   = substitution_character
    )
  }
  d
}
