#' @title
#' Export the metadata of a REDCap project
#'
#' @description
#' Export the metadata (as a data dictionary) of a REDCap project
#' as a [tibble::tibble()]. Each row in the data dictionary corresponds to
#' one field in the project's dataset.
#'
#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param forms An array, where each element corresponds to the REDCap form
#' of the desired fields.  Optional.
#' @param fields An array, where each element corresponds to a desired project
#' field.  Optional.
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
#'
#' * `data`: An R [tibble::tibble()] of the desired fields (as rows).
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_codes`: A collection of
#' [http status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
#' separated by semicolons.  There is one code for each batch attempted.
#' * `outcome_messages`: A collection of human readable strings indicating the
#' operations' semicolons.  There is one code for each batch attempted.  In an
#' unsuccessful operation, it should contain diagnostic information.
#' * `forms_collapsed`: The desired records IDs, collapsed into a single
#' string, separated by commas.
#' * `fields_collapsed`: The desired field names, collapsed into a single
#' string, separated by commas.
#' * `elapsed_seconds`: The duration of the function.
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
#' uri   <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#'
#' # A simple project
#' token <- "9A068C425B1341D69E83064A2D273A70" # simple
#' REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)
#'
#' # A longitudinal project
#' token <- "0434F0E9CF53ED0587847AB6E51DE762" # longitudinal
#' REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)
#'
#' # A repeating measures
#' token <- "77842BD8C18D3408819A21DD0154CCF4" # vignette-repeating
#' REDCapR::redcap_metadata_read(redcap_uri=uri, token=token)
#' }

#' @importFrom magrittr %>%
#' @export
redcap_metadata_read <- function(
  redcap_uri,
  token,
  forms             = NULL,
  fields            = NULL,
  verbose           = TRUE,
  config_options    = NULL,
  handle_httr       = NULL
) {

  checkmate::assert_character(redcap_uri  , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token       , any.missing=FALSE, len=1, pattern="^.{1,}$")

  assert_field_names(fields)

  token               <- sanitize_token(token)
  fields_collapsed    <- collapse_vector(fields)
  fields_array        <- to_api_array(fields, "fields")
  forms_collapsed     <- collapse_vector(forms)
  forms_array         <- to_api_array(forms, "forms")
  verbose             <- verbose_prepare(verbose)

  post_body <- list(
    token    = token,
    content  = "metadata",
    format   = "json"
  )

  # append forms and fields arrays in format expected by REDCap API
  # If either is NULL nothing will be appended
  post_body <- c(post_body, fields_array, forms_array)

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
          kernel$raw_text %>%
          jsonlite::fromJSON(
            flatten = TRUE
          ) %>%
          tibble::as_tibble() %>%
          dplyr::mutate_all(
            ~dplyr::na_if(.x, "")
          )
      },
      # Don't print the warning in the try block.  Print it below,
      #   where it's under the control of the caller.
      silent = TRUE
    )

    if (exists("ds") && inherits(ds, "data.frame")) {
      outcome_message <- sprintf(
        "The data dictionary describing %s fields was read from REDCap in %0.1f seconds.  The http status code was %i.",
        format(nrow(ds), big.mark = ",", scientific = FALSE, trim = TRUE),
        kernel$elapsed_seconds,
        kernel$status_code
      )

      # If an operation is successful, the `raw_text` is no longer returned
      #   to save RAM.  The content is not really necessary with httr's status
      #   message exposed.
      kernel$raw_text   <- ""
    } else { # nocov start
      # Override the 'success' determination from the http status code
      #   and return an empty data.frame.
      kernel$success    <- FALSE
      ds                <- tibble::tibble()
      outcome_message   <- sprintf(
        "The REDCap metadata export failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
    }       # nocov end
  } else {
    # nocov start
    ds                  <- tibble::tibble() # Return an empty data.frame
    outcome_message     <- sprintf(
      "The REDCapR metadata export operation was not successful.  The error message was:\n%s",
      kernel$raw_text
    )
    # nocov end
  }

  if (verbose)
    message(outcome_message)

  list(
    data               = ds,
    success            = kernel$success,
    status_code        = kernel$status_code,
    outcome_message    = outcome_message,
    forms_collapsed    = forms_collapsed,
    fields_collapsed   = fields_collapsed,
    elapsed_seconds    = kernel$elapsed_seconds,
    raw_text           = kernel$raw_text
  )
}

#' @title
#' Convert a vector to the array format expected by the REDCap API
#'
#' @description
#' Utility function to convert a vector into the array format expected by the
#' some REDCap API calls.  It is called internally by REDCapR functions,
#' and is not intended to be called directly.
#'
#' @param x A vector to convert to array format.  Can be `NULL`.
#' @param element_names A string containing the name of the API request parameter for
#' the array.  Must be either "fields" or "forms".
#'
#' @return
#' If `x` is not `NULL` a list is returned with one element for
#' each element of x in the format:
#' \code{list(`element_names[0]` = x[1], `element_names[1]` = x[2], ...)}.
#'
#' If `x` is `NULL` then `NULL` is returned.
to_api_array <- function(x, element_names) {
  checkmate::assert_character(x       , null.ok = TRUE, any.missing = FALSE)
  checkmate::assert_character(element_names, null.ok = TRUE, any.missing = FALSE, max.len = 1L, pattern = "^fields|forms$")

  if (is.null(x)) {
    return(NULL)
  } else if (is.null(element_names)) {
    rlang::abort("The `element_names` parameter cannot be null if `x` is not null.")
  }

  res <- as.list(x)
  names(res) <- paste0(element_names, "[", seq_along(res) - 1L, "]")

  res
}
