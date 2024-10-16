#' @name
#' retrieve_credential
#'
#' @aliases
#' retrieve_credential_local retrieve_credential_mssql create_credential_local
#'
#' @title
#' Read a token and other credentials from a (non-REDCap)
#' database or file
#'
#' @description
#' These functions are not essential to calling the REDCap API,
#' but instead are functions that help manage tokens securely.
#'
#' @usage
#' retrieve_credential_local(
#'   path_credential,
#'   project_id,
#'   check_url            = TRUE,
#'   check_username       = FALSE,
#'   check_token_pattern  = TRUE,
#'   username             = NA_character_
#' )
#'
#' retrieve_credential_mssql(
#'   project_id,
#'   instance,
#'   dsn,
#'   channel    = NULL
#' )
#'
#' create_credential_local(
#'   path_credential
#' )
#'
#' @param path_credential The file path to the CSV containing the credentials.
#' Required.
#' @param project_id The ID assigned to the project withing REDCap.  This
#' allows the user to store tokens to multiple REDCap projects in one file.
#' Required
#' @param instance The casual name associated with the REDCap instance on
#' campus.  This allows one credential system to accommodate multiple
#' instances on campus.  Required
#' @param check_url A `logical` value indicates if the url in the credential
#' file should be checked to have approximately the correct form.  Defaults
#' to TRUE.
#' [REDCapR::retrieve_credential_local()].
#' @param check_username A `logical` value indicates if the username in the
#' credential file should be checked against the username returned by R.
#' Defaults to FALSE.
#' @param check_token_pattern A `logical` value indicates if the token in the
#' credential file is a 32-character hexadecimal string.  Defaults to FALSE.
#' @param dsn A [DSN](https://en.wikipedia.org/wiki/Data_source_name) on the
#' local machine that points to the desired MSSQL database. Required.
#' @param channel An *optional* connection handle as returned by
#' [DBI::dbConnect()].  See Details below. Optional.
#' @param username A character value used to retrieve a credential.
#' See the Notes below. Optional.
#'
#' @return
#' A list of the following elements are returned from
#' `retrieve_credential_local()` and `retrieve_credential_mssql()`:
#' * `redcap_uri`: The URI of the REDCap Server.
#' * `username`: Username.
#' * `project_id`: The ID assigned to the project within REDCap.
#' * `token`: The token to pass to the REDCap server
#' * `comment`: An optional string that is ignored by REDCapR
#'   but can be helpful for humans.
#'
#' @details
#' If the database elements are created with the script provided in package's
#' 'Security Database' vignette, the default values will work.
#'
#' The `create_credential_local()` function copies a
#' [static file](https://github.com/OuhscBbmc/REDCapR/blob/master/inst/misc/skeleton.credentials)
#' to the location specified in the `path_credential` argument.
#' Each record represents one accessible project per user.
#' Follow these steps to adapt to your desired REDCap project(s):
#' 1. Modify the credential file for the REDCap API with a text editor
#'    like [Notepad++](https://notepad-plus-plus.org/),
#'    Visual Studio Code, or
#'    [nano](https://www.nano-editor.org/).
#'    Replace existing records with the information from your projects.
#'    Delete the remaining example records.
#' 2. Make sure that the file (with the sensitive password-like) tokens
#'    is stored securely!
#' 3. Contact your REDCap admin to request the URI & token and
#'    discuss institutional policies.
#' 4. Ask your institution's IT security team for their recommendation
#     securing the file.
#' 5. For more info, see https://ouhscbbmc.github.io/REDCapR/articles/workflow-read.html
#'    and https://ouhscbbmc.github.io/REDCapR/reference/retrieve_credential.html
#' 6. Double-check the file is secured and not accessible by other users.
#'
#' @note
#' *Storing credentials on a server is preferred*
#'
#' Although we strongly encourage storing all the tokens on a central server
#' (*e.g.*, see the `retrieve_credential_mssql()` function and the
#' "SecurityDatabase" vignette), there are times when this approach is not
#' feasible and the token must be stored locally.  Please contact us
#' if your institution is using something other than SQL Server, and
#' would like help adapting this approach to your infrastructure.
#'
#' *Storing credentials locally*
#'
#' When storing credentials locally, typically the credential file
#' should be dedicated to just one user. Occasionally it makes sense to store
#' tokens for multiple users --usually it's for the purpose of testing.
#'
#' The `username` field is connected only in the local credential file.
#' It does not need to be the same as the official username in REDCap.
#'
#' @author
#' Will Beasley
#'
#' @examples
#' # ---- Local File Example ----------------------------
#' path <- system.file("misc/dev-2.credentials", package = "REDCapR")
#' (p1  <- REDCapR::retrieve_credential_local(path, 33L))
#' (p2  <- REDCapR::retrieve_credential_local(path, 34L))
#'
#'
#' \dontrun{
#' # Create a skeleton of the local credential file to modify
#' path_demo <- base::tempfile(pattern = "temp", fileext = ".credentials")
#'
#' create_credential_local(path_demo)
#'
#' base::unlink(path_demo) # This is just a demo; don't delete the real file!
#' }
#'
#' @export
retrieve_credential_local <- function(
  path_credential,
  project_id,
  check_url                = TRUE,
  check_username           = FALSE,
  check_token_pattern      = TRUE,
  username                 = NA_character_
) {

  checkmate::assert_character(path_credential  , any.missing=FALSE, len=1, pattern="^.{1,}$")
  checkmate::assert_file_exists(path_credential                                         )
  checkmate::assert_character(username         , any.missing=TRUE, len=1, pattern="^.{1,}$")

  col_types <- readr::cols_only(
    redcap_uri    = readr::col_character(),
    username      = readr::col_character(),
    project_id    = readr::col_integer(),
    token         = readr::col_character(),
    comment       = readr::col_character()
  )

  d_credentials <- readr::read_csv(
    file            = path_credential,
    col_types       = col_types,
    comment         = "#",
    show_col_types  = FALSE
  )

  # Check that it's a data.frame with valid variable names
  if (!inherits(d_credentials, "data.frame")) {
    stop(
      "The credentials file was not correctly transformed into a ",
      "[base::data.frame()].  Make sure it's a well-formed CSV."
    )
  } else if (
    !identical(
      colnames(d_credentials),
      c("redcap_uri", "username", "project_id", "token", "comment"))
    ) {
    stop(
      "The credentials file did not contain the proper variables of ",
      "`redcap_uri`, `username`, `project_id`, `token`,  and `comment`."
    )
  }

  # Select only the records with a matching project id.
  d_credentials <- d_credentials[!is.na(d_credentials$project_id), ]
  d_credential  <- d_credentials[d_credentials$project_id == project_id, ]

  # If specified, select only the records with a matching username.
  if (!is.na(username)) {
    d_credential <- d_credentials[d_credentials$username == username, ]
  }

  # Check that one and only one record matches the project id.
  if (nrow(d_credential) == 0L) {
    stop(
      "The project_id was not found in the csv credential file."
    )
  } else if (1L < nrow(d_credential)) {
    stop(
      "More than one matching project_id was found in the csv credential ",
      "file.  There should be only one."
    )
  } else {
    credential <- list(
      redcap_uri   = d_credential$redcap_uri[1],
      username     = d_credential$username[1],
      project_id   = d_credential$project_id[1],
      token        = d_credential$token[1],
      comment      = d_credential$comment[1]
    )
  }

  credential_local_validation(
    redcap_uri              = credential$redcap_uri,
    token                   = credential$token,
    username                = credential$username,
    check_url               = check_url,
    check_username          = check_username,
    check_token_pattern     = check_token_pattern
  )

  credential
}

# Privately-scoped function
credential_local_validation <- function(
  redcap_uri,
  token,
  username,
  check_url                = TRUE,
  check_username           = FALSE,
  check_token_pattern      = TRUE

) {
  # Progress through the optional checks
  if (check_url && !grepl("https://", redcap_uri, perl = TRUE)) {
    error_message_username <- paste(
      "The REDCap URL does not reference an https address.  First check",
      "that the URL is correct, and then consider using SSL to encrypt",
      "the REDCap webserver.  Set the `check_url` parameter to FALSE",
      "if you're sure you have the correct file & file contents."
    )
    stop(error_message_username)

  } else if (check_username && (Sys.info()["user"] != username)) {
    error_message_username <- paste(
      "The username (according to R's `Sys.info()['user']` doesn't match the",
      "username in the credentials file.  This is a friendly check, and",
      "NOT a security measure.  Set the `check_username` parameter to FALSE",
      "if you're sure you have the correct file & file contents.",
      "Otherwise, you may be pointing to the wrong credentials file."
    )
    stop(error_message_username)

  } else if (check_token_pattern && !grepl("[A-F0-9]{32}", token, perl = TRUE)) {
    error_message_token <- paste(
      "A REDCap token should be a string of 32 digits and uppercase",
      "characters.  The retrieved value was not.",
      "Set the `check_token_pattern` parameter to FALSE",
      "if you're sure you have the correct file & file contents."
    )
    stop(error_message_token)
  }
}

#' @export
create_credential_local <- function(path_credential) {
  path_source <- system.file(
    "misc/example.credentials",
    package   = "REDCapR"
    # mustWork  = TRUE
  )

  if (!base::file.exists(path_source))
    stop("The skeleton credential file was not found at `", path_source, "`.") # nocov

  if (base::file.exists(path_credential))
    stop("A credential file already exists at `", path_source, "`.")

  if (!base::dir.exists(base::dirname(path_credential)))
    base::dir.create(base::dirname(path_credential))

  success <-
    base::file.copy(
      from        = path_source,
      to          = path_credential,
      overwrite   = FALSE
    )

  if (!success)
    stop("The credential file could not be created at `", path_source, "`.") # nocov

  success
}

#' @export
retrieve_credential_mssql <- function(
  project_id,
  instance,
  dsn         = NULL,
  channel     = NULL
) {

  if (!requireNamespace("DBI") ) stop("The function REDCapR::retrieve_credential_mssql() cannot run if the `DBI` package is not installed.  Please install it and try again.")
  if (!requireNamespace("odbc")) stop("The function REDCapR::retrieve_credential_mssql() cannot run if the `odbc` package is not installed.  Please install it and try again.")

  regex_pattern_1 <- "^\\d+$"
  regex_pattern_2 <- "^\\[*[a-zA-Z0-9_]+\\]*$"

  if (!inherits(project_id, "integer")) {
    stop(
      "The `project_id` parameter should be an integer type.  ",
      "Either append an `L` ",
      "to the number, or cast with `as.integer()`."
    )
  } else if (!inherits(instance, "character")) {
    stop(
      "The `instance` parameter should be a character type.  ",
      "Either enclose in ",
      "quotes, or cast with `as.character()`."
    )
  } else if (!(base::missing(dsn) || base::is.null(dsn)) && !(class(dsn) %in% c("character"))) {
    stop(
      "The `dsn` parameter be a character type, or missing or NULL.  ",
      "Either enclose in quotes, or cast with `as.character()`."
    )
  } else if (!(base::missing(channel) || base::is.null(channel)) && !methods::is(channel, "DBIConnection")) {
    stop("The `channel` parameter be a `DBIConnection` type, or NULL.")

  } else if (length(project_id) != 1L) {
    stop("The `project_id` parameter should contain exactly one element.")
  } else if (length(instance) != 1L) {
    stop("The `instance` parameter should contain exactly one element.")
  } else if (length(dsn) > 1L) {
    stop("The `dsn` parameter should contain at most one element.")
  } else if (length(channel) > 1L) {
    stop("The `channel` parameter should contain at most one element.")
  } else if (!grepl(regex_pattern_1, project_id)) {
    stop(
      "The 'project_id' parameter must contain at least one digit, ",
      "and only digits."
    )
  } else if (!grepl(regex_pattern_2, instance)) {
    stop(
      "The 'instance' parameter must contain only letters, numbers, and ",
      "underscores.  It may optionally be enclosed in square brackets."
    )
  }

  sql <- "EXEC [redcap].[prc_credential] @project_id = ?, @instance = ?"
  input <- list(project_id = project_id, instance = instance)

  if (base::missing(channel) || base::is.null(channel)) {
    if (base::missing(dsn) || base::is.null(dsn)) {
      stop(
        "The 'dsn' parameter can be missing only if a 'channel' has been ",
        "passed to 'retrieve_credential_mssql'."
      )
    }
    channel <- DBI::dbConnect(odbc::odbc(), dsn = dsn)
    close_channel_on_exit <- TRUE
  } else {
    close_channel_on_exit <- FALSE
  }

  base::tryCatch(
    expr = {
      d_credential  <- DBI::dbGetQuery(channel, sql, params = input)
      # result        <- DBI::dbSendQuery(channel, sql)
      # DBI::dbBind(result, input)
      # d_credential  <- DBI::dbFetch(result, n = 1L)
    }, finally = {
      # if (!is.null(result))      DBI::dbClearResult(result)
      if (close_channel_on_exit) DBI::dbDisconnect(channel)
    }
  )

  if (nrow(d_credential) == 0L) {
    stop(
      "The REDCap token for project ",
      project_id,
      " was not found on for this username and instance.  Please verify with ",
      "your REDCap admin that you have both (a) API rights AND (b) an API ",
      "token generated."
    )
  } else if (2L <= nrow(d_credential)) {
    stop(
      "No more than one row should be retrieved from the credentials. The ",
      "[username]-by-[instance]-by-[project_id] should be unique in the table."
    )
  }

  credential <- list(
    redcap_uri   = d_credential$redcap_uri,
    username     = d_credential$username,
    project_id   = d_credential$project_id,
    token        = d_credential$token,
    comment      = ""
  )

  credential
}
