#' @title
#' Export Events
#'
#' @description
#' Export Events of a REDCap project
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
#' * `data`: a [tibble::tibble()] with one row per arm-event combination.  The
#' columns are `event_name` (a human-friendly string), `arm_num` (an integer),
#' `unique_event_name` (a string), `custom_event_label` (a string), and
#' `event_id` (an integer).
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
#' Ezra Porter, Will Beasley
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
#' # Query a longitudinal project with a single arm and 3 events
#' token_1  <- "76B4A71A0158BD34C98F10DA72D5F27C" # arm-single-longitudinal
#' result_1 <- REDCapR::redcap_event_read(redcap_uri=uri, token=token_1)
#' result_1$data
#'
#' # Query a longitudinal project with 2 arms and complex arm-event mappings
#' token_2  <- "DA6F2BB23146BD5A7EA3408C1A44A556" # longitudinal
#' result_2 <- REDCapR::redcap_event_read(redcap_uri=uri, token=token_2)
#' result_2$data
#'
#' # Query a classic project without events
#' token_3  <- "F9CBFFF78C3D78F641BAE9623F6B7E6A" # simple-write
#' result_3 <- REDCapR::redcap_event_read(redcap_uri=uri, token=token_3)
#' result_3$data
#' }
#' @export
redcap_event_read <- function(
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
      content   = "event",
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
      outcome_message <- sprintf(
        paste(
          "The list of events was retrieved from the REDCap project in %0.1f seconds.",
          "The http status code was %i."
        ),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      col_types <- readr::cols(
        event_name         = readr::col_character(),
        arm_num            = readr::col_integer(),
        unique_event_name  = readr::col_character(),
        custom_event_label = readr::col_character(),
        event_id           = readr::col_integer()
      )
      d <-
        readr::read_csv(
          I(kernel$raw_text),
          col_types = col_types
        )

      # If an operation is successful, the `raw_text` is no longer returned to save RAM.  The content is not really necessary with httr's status message exposed.
      kernel$raw_text <- ""
    } else if (kernel$raw_text == "ERROR: You cannot export events for classic projects") {
      outcome_message <- sprintf(
        paste(
          "A 'classic' REDCap project has no events.  Retrieved in %0.1f seconds.",
          "The http status code was %i."
        ),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      d <- tibble::tibble(
        event_name         = character(0),
        arm_num            = integer(0),
        unique_event_name  = character(0),
        custom_event_label = character(0),
        event_id           = integer(0)
      )
    } else {
      error_message <- sprintf(
        paste(
          "The REDCapR event export failed.",
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
    error_message <- sprintf("The REDCapR event export failed. The error message was:\n%s.", kernel$raw_text)
    stop(error_message)
    # nocov end
  }

  if (verbose)
    message(outcome_message)

  list(
    data                      = d,
    success                   = kernel$success,
    status_code               = kernel$status_code,
    outcome_message           = outcome_message,
    elapsed_seconds           = kernel$elapsed_seconds,
    raw_text                  = kernel$raw_text
  )
}
