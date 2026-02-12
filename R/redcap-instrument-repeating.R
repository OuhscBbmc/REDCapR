#' @title
#' Enumerate repeating instruments and events
#'
#' @description
#' This method allows you to export a list of the repeated instruments
#' and repeating events for a project. This includes their unique
#' instrument name as seen in the second column of the Data
#' Dictionary, as well as each repeating instrument's corresponding
#' custom repeating instrument label. For longitudinal projects, the
#' unique event name is also returned for each repeating instrument.
#' Additionally, repeating events are returned as separate items,
#' in which the instrument name will be blank/null to indicate that
#' it is a repeating event (rather than a repeating instrument).
#' (Copied from "Export Repeating Instruments and Events" method of
#' REDCap API documentation, v.16.0.4)
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
#' Currently, a list is returned with the following elements,
#' * `data`: A [tibble::tibble()] where each row represents one repeating instrument-event
#' combination in the REDCap project.
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
#' Ezra Porter
#'
#' @references
#' The official documentation can be found on the 'API Help Page'
#' and 'API Examples' pages on the REDCap wiki (*i.e.*,
#' <https://redcap.vumc.org/community/post.php?id=456> and
#' <https://redcap.vumc.org/community/post.php?id=462> ).
#' If you do not have an account for the wiki, please ask your campus REDCap
#' administrator to send you the static material.
#'
#'
#' @examples
#' \dontrun{
#' uri                 <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#'
#' # Repeating events project
#' token_1  <- "FEF7A22B52E6B9942AFF7A28C426C871" # "vignette-repeating" test project
#' token_1  <- "22C3FF1C8B08899FB6F86D91D874A159" # vignette-repeating production
#' REDCapR::redcap_instrument_repeating(redcap_uri=uri, token=token_1)$data
#'
#' # Classic project (without repeating instruments) throws an error
#' token_2  <- "9A068C425B1341D69E83064A2D273A70" # "simple" test project
#' token_2  <- "9A81268476645C4E5F03428B8AC3AA7B" # "simple" test project production
#' # Throws an error REDCapR::redcap_instrument_repeating(redcap_uri=uri, token=token_2)$data
#' }

#' @export
redcap_instrument_repeating <- function(
  redcap_uri,
  token,
  verbose           = TRUE,
  config_options    = NULL,
  handle_httr       = NULL
) {

  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  post_body <- list(
    token     = token,
    content   = "repeatingFormsEvents",
    format    = "csv"
  )

  col_types <- readr::cols(
    form_name         = readr::col_character(),
    custom_form_label = readr::col_character(),
    # Result contains 'event_name' only if the project is longitudinal
    # Implicitly set the type for 'event_name' since we don't know the project type
    .default = readr::col_character()
  )

  # This is the important call that communicates with the REDCap server.
  kernel <-
    kernel_api(
      redcap_uri      = redcap_uri,
      post_body       = post_body,
      config_options  = config_options,
      handle_httr     = handle_httr
    )

  if (kernel$success) {
    try(
      {
        # Convert the raw text to a dataset.
        ds <-
          readr::read_csv(
            file            = I(kernel$raw_text),
            col_types       = col_types
          )
      },
      silent = TRUE
      # Don't print the warning in the try block.  Print it below, where
      #    it's under the control of the caller.
    )

    if (exists("ds") && inherits(ds, "data.frame")) {
      outcome_message <- sprintf(
        "%s repeating event-instrument metadata records were read from REDCap in %0.1f seconds.  The http status code was %i.",
        format(nrow(ds), big.mark = ",", scientific = FALSE, trim = TRUE),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      kernel$raw_text   <- ""
      # If an operation is successful, the `raw_text` is no longer returned
      #   to save RAM.  The content is not really necessary with httr's status
      #   message exposed.
    } else {
      # nocov start
      kernel$success  <- FALSE # Override the 'success' http status code.
      ds              <- tibble::tibble() # Return an empty data.frame

      outcome_message <- sprintf(
        "The REDCap repeating event-instrument retrieval failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
      # nocov end
    }
  } else {
    ds              <- tibble::tibble() # Return an empty data.frame
    outcome_message <-
      if (any(grepl(kernel$regex_empty, kernel$raw_text))) {
        "The REDCapR read/export operation was not successful.  The returned dataset (of instrument-events) was empty." # nocov
      } else {
        sprintf(
          "The REDCapR repeating event-instrument retrieval was not successful.  The error message was:\n%s",
          kernel$raw_text
        )
      }
  }

  if (verbose)
    message(outcome_message)

  list(
    data                = ds,
    success             = kernel$success,
    status_code         = kernel$status_code,
    outcome_message     = outcome_message,
    elapsed_seconds     = kernel$elapsed_seconds,
    raw_text            = kernel$raw_text
  )
}
