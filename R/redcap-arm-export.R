#' @title
#' Export Arms
#'
#' @description
#' Export Arms of a REDCap project
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  The verbose output might contain
#' sensitive information (*e.g.* PHI), so turn this off if the output might
#' be visible somewhere public. Optional.
#' @param config_options A list of options passed to [httr::POST()].
#' See details at [httr::httr_options()]. Optional.
#' @param handle_httr The value passed to the `handle` parameter of
#' [httr::POST()].
#' This is useful for only unconventional authentication approaches.  It
#' should be `NULL` for most institutions.  Optional.
#'
#' @return
#' Currently, a list is returned with the following elements:
#' * `has_arms`: a `logical` value indicating if the REDCap project has
#' arms (*i.e.*, "TRUE") or is a classic non-longitudinal project
#' (*i.e.*, "FALSE").
#' * `data`: a [tibble::tibble()] with one row per arm.  The columns are
#' `arm_number` (an integer) and `arm_name` (a human-friendly string).
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#'
#' @author
#' Will Beasley
#'
#' @references
#' The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' https://community.projectredcap.org/articles/456/api-documentation.html and
#' https://community.projectredcap.org/articles/462/api-examples.html).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#' @examples
#' \dontrun{
#' uri            <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#'
#' # Query a classic project with 3 arms
#' token_1  <- "14817611F9EA1A6E149BBDC37134E8EA" # arm-multiple-delete
#' result_1 <- REDCapR::redcap_arm_export(redcap_uri=uri, token=token_1)
#' result_1$has_arms
#' result_1$data
#'
#' # Query a classic project without arms
#' token_2  <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write
#' result_2 <- REDCapR::redcap_arm_export(redcap_uri=uri, token=token_2)
#' result_2$has_arms
#' result_2$data
#' }

#' @importFrom rlang .data
#' @importFrom magrittr %>%
#' @export
redcap_arm_export <- function(
  redcap_uri,
  token,
  verbose         = TRUE,
  config_options  = NULL,
  handle_httr     = NULL
) {

  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <-
    list(
      token     = token,
      content   = "arm",
      format    = "csv"
    )

  try(
    {
      # This is the important call that communicates with the REDCap server.
      kernel <-
        kernel_api(
          redcap_uri      = redcap_uri,
          post_body       = post_body,
          config_options  = config_options,
          handle_httr     = handle_httr
        )
    },
    # Don't print the warning in the try block.  Print it below,
    #   where it's under the control of the caller.
    silent = TRUE
  )

  if (exists("kernel")) {
    if (kernel$success) {
      has_arms <- TRUE
      outcome_message <- sprintf(
        paste(
          "The list of arms was retrieved from the REDCap project in %0.1f seconds.",
          "The http status code was %i."
        ),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      col_types <- readr::cols(
        arm_num = readr::col_integer(),
        name    = readr::col_character()
      )
      d <-
        readr::read_csv(
          I(kernel$raw_text),
          col_types = col_types
        ) %>%
        dplyr::select(
          arm_number  = "arm_num",
          arm_name    = "name"
        )

      # If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
      kernel$raw_text <- ""
    } else if (kernel$raw_text == "ERROR: You cannot export arms for classic projects") {
      has_arms <- FALSE
      outcome_message <- sprintf(
        paste(
          "A 'classic' REDCap project has no arms.  Retrieved in %0.1f seconds.",
          "The http status code was %i."
        ),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      d <- tibble::tibble(
        arm_number = integer(0),
        arm_name   = character(0)
      )
    } else {
      error_message <- sprintf(
        paste(
          "The REDCapR arm export failed.",
          "The http status code was %i.",
          "The error message was: '%s'."
        ),
        kernel$status_code,
        kernel$raw_text
      )
      stop(error_message)
    }
  } else {
    # nocov start
    error_message <- sprintf("The REDCapR arm export failed. The error message was:\n%s.", kernel$raw_text)
    stop(error_message)
    # nocov end
  }

  if (verbose)
    message(outcome_message)

  list(
    has_arms                  = has_arms,
    data                      = d,
    success                   = kernel$success,
    status_code               = kernel$status_code,
    outcome_message           = outcome_message,
    elapsed_seconds           = kernel$elapsed_seconds,
    raw_text                  = kernel$raw_text
  )
}
