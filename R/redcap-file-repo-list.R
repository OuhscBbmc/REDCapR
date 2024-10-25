#' @title
#' Export a List of Files/Folders from the File Repository
#'#'
#' @description
#' Allows you to export a list of all files and sub-folders from a specific
#' folder in a project's File Repository.
#' Each sub-folder will have an associated folder_id number,
#' and each file will have an associated doc_id number.
#'
#' @param folder_id the `folder_id` of a specific folder in the
#' File Repository for which you wish to export a list of its
#' files and sub-folders.
#' If `NA` (the default),
#' the top-level directory of the File Repository will be used.

#' @param redcap_uri The
#' [uri](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier)/url
#' of the REDCap server
#' typically formatted as "https://server.org/apps/redcap/api/".
#' Required.
#' @param token The user-specific string that serves as the password for a
#' project.  Required.
#' @param verbose A boolean value indicating if `message`s should be printed
#' to the R console during the operation.  Optional.
#' @param config_options A list of options passed to [httr::POST()].
#' See details at [httr::httr_options()]. Optional.
#' @param handle_httr The value passed to the `handle` parameter of
#' [httr::POST()].
#' This is useful for only unconventional authentication approaches.  It
#' should be `NULL` for most institutions.  Optional.
#'
#' @return
#' Currently, a list is returned with the following elements,
#' * `success`: A boolean value indicating if the operation was apparently
#' successful.
#' * `status_code`: The
#' [http status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
#' of the operation.
#' * `outcome_message`: A human readable string indicating the operation's
#' outcome.
#' * `records_affected_count`: The number of records inserted or updated.
#' * `affected_ids`: The subject IDs of the inserted or updated records.
#' * `elapsed_seconds`: The duration of the function.
#' * `raw_text`: If an operation is NOT successful, the text returned by
#' REDCap.  If an operation is successful, the `raw_text` is returned as an
#' empty string to save RAM.
#' * `file_name`: The name of the file persisted to disk. This is useful if
#' the name stored in REDCap is used (which is the default).
#'
#' @details
#' For files in a repeating instrument, don't specify `repeating_instrument`.
#' The server only needs `field` (name) and `repeating_instance`.
#'
#' The function `redcap_download_file_oneshot()` is soft-deprecated
#' as of REDCapR 1.2.0.
#' Please rename to [redcap_file_download_oneshot()].
#'
#' @author
#' Will Beasley, John J. Aponte
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
#' uri     <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
#' token   <- "589740603423E92BC79BAC2811B1F82A" # file-repo
#'
#' # Top-level directory
#' REDCapR::redcap_file_repo_list_oneshot(
#'   redcap_uri    = uri,
#'   token         = token
#' )$data
#'
#' # First subdirectory
#' REDCapR::redcap_file_repo_list_oneshot(
#'   redcap_uri    = uri,
#'   token         = token,
#'   folder_id     = 1
#' )$data
#'
#' }

#' @export
redcap_file_repo_list_oneshot <- function(
  redcap_uri,
  token,
  folder_id       = NA_integer_,
  verbose         = TRUE,
  config_options  = NULL,
  handle_httr     = NULL
) {

  checkmate::assert_integerish(  folder_id , len=1, lower = 1)
  checkmate::assert_character(redcap_uri, any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_character(token     , any.missing=FALSE, len=1, pattern="^.{1,}$")

  token   <- sanitize_token(token)
  verbose <- verbose_prepare(verbose)

  folder_id <- dplyr::if_else(!is.na(folder_id), as.character(folder_id), "")

  post_body <- list(
    token         = token,
    content       = "fileRepository",
    action        = "list",
    folder_id     = folder_id,
    format        = "csv",
    returnFormat  = "csv"
  )

  # This is the first of two important lines in the function.
  #   It retrieves the information from the server and stores it in RAM.
  kernel <-
    kernel_api(
      redcap_uri      = redcap_uri,
      post_body       = post_body,
      config_options  = config_options,
      handle_httr     = handle_httr
    )
  # browser()

  col_types <- readr::cols(
    folder_id   = readr::col_integer(),
    doc_id      = readr::col_integer(),
    name        = readr::col_character()
  )

  if (kernel$success) {
    try(
      {
        # Convert the raw text to a dataset.
        ds <-
          readr::read_csv(
            file            = I(kernel$raw_text),
            col_types       = col_types,
            show_col_types  = FALSE
          )
      },
      # Don't print the warning in the try block.  Print it below,
      #   where it's under the control of the caller.
      silent = TRUE
    )

    if (exists("ds") && inherits(ds, "data.frame")) {
      outcome_message <- sprintf(
        "The file repository structure describing %s elements was read from REDCap in %0.1f seconds.  The http status code was %i.",
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
        "The REDCap file repository listing failed.  The http status code was %i.  The 'raw_text' returned was '%s'.",
        kernel$status_code,
        kernel$raw_text
      )
    }       # nocov end
  } else {
    # nocov start
    ds                  <- tibble::tibble() # Return an empty data.frame
    outcome_message     <- sprintf(
      "The REDCapR file repository listing was not successful.  The error message was:\n%s",
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
    elapsed_seconds    = kernel$elapsed_seconds,
    raw_text           = kernel$raw_text
  )
}
