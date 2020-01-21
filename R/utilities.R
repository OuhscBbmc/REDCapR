#' @name replace_nas_with_explicit
#' @title Create explicit factor level for missing values
#'
#' @description Missing values are converted to a factor level.
#' This explicit assignment can reduce the chances that missing values
#' are inadvertently ignored. It also allows the presence of a missing
#' to become a predictor in models.
#'
#' @param scores An array of values, ideally either factor or character.
#' Required
#' @param new_na_label The factor label assigned to the missing value.
#' Defaults to `Unknown`.
#' @param create_factor Converts `scores` into a factor, if it isn't one
#' already. Defaults to `FALSE`.
#' @param add_unknown_level Should a new factor level be created?
#' (Specify `TRUE` if it already exists.)   Defaults to `FALSE`.
#'
#' @return An array of values, where the `NA` values are now a factor level,
#'   with the label specified by the `new_na_label` value.
#'
#' @note
#' The `create_factor` parameter is respected only if `scores` isn't already
#' a factor. Otherwise, levels without any values would be lost.
#'
#' A `stop` error will be thrown if the operation fails to convert all the
#' `NA` values.
#'
#' @author Will Beasley
#'
#' @examples
#' library(REDCapR) #Load the package into the current R session.

## We're intentionally not exporting this function.
replace_nas_with_explicit <- function(
  scores,
  new_na_label      = "Unknown",
  create_factor     = FALSE,
  add_unknown_level = FALSE
) {

  if (create_factor & !is.factor(scores)) {
    scores <- factor(scores)
  }

  if (add_unknown_level) {
    if (!is.factor(scores)) {
      stop(
        "The `replace_nas_with_explicit()` function cannot add a level ",
        "to `scores` when it is not a factor.  Consider setting ",
        "`create_factor=TRUE`."
      )
    }
    levels(scores) <- c(levels(scores), new_na_label)  # Add a new level called 'Unknown'
  }

  scores[is.na(scores)] <- new_na_label # "Unknown"

  if (any(is.na(scores))) {
    stop("The reassigned factor variable should not have any NA values.")
  }

  scores
}


#' @name collapse_vector
#' @title Collapse a vector of values into a single string when necessary
#'
#' @description REDCap's API frequently specifies a series of values
#' separated by commas.
#' In the R world, it's easier to keep these values as separate elements in a
#' vector. This functions squashes them together in a single character element
#' (presumably right before the return value is passed to the API)
#'
#' @param elements An array of values.  Can be `NULL`.  Required.
#' @param collapsed A single character element, where the values are separated
#' by commas.  Can be `NULL`.  Required.
#'
#' @return A single character element, where the values are separated by
#' commas.  Can be blank. (*i.e.*, `""`).
#'
#' @author Will Beasley
#'
#' @examples
#' library(REDCapR) #Load the package into the current R session.
#' REDCapR:::collapse_vector(elements=NULL, collapsed=NULL)
#' REDCapR:::collapse_vector(elements=letters, collapsed=NULL)
#' REDCapR:::collapse_vector(elements=NULL, collapsed="4,5,6")

## We're intentionally not exporting this function.
collapse_vector <- function(elements, collapsed) {
  checkmate::assert_character(collapsed, len=1, any.missing=TRUE, null.ok=TRUE)

  if ((is.null(collapsed) | length(collapsed) == 0L) | all(nchar(collapsed) == 0L)) {

    # This is an empty string if `elements` (eg, fields`) is NULL.
    collapsed <- dplyr::if_else(
      is.null(elements),
      "",
      paste0(elements, collapse = ",")
    )
  }

  collapsed
}

## We're intentionally not exporting this function.
filter_logic_prepare <- function(filter_logic) {
  # This is an empty string if `filter_logic` is NULL.
  if (all(nchar(filter_logic) == 0L))
    filter_logic <- dplyr::if_else(is.null(filter_logic), "", filter_logic)
  return( filter_logic )
}

## We're intentionally not exporting this function.
verbose_prepare <- function (verbose) {
  ifelse(!is.null(verbose), verbose, getOption("verbose"))
}
