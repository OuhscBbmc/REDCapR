#' @name retrieve_token
#' @aliases retrieve_token_mssql
#' @export retrieve_token_mssql
#' @title Read a token from a (non-REDCap) database.
#'
#' @description This function will soon be deprecated; please transition to [retrieve_token_mssql()]. These functions are not essential to calling the REDCap API, but instead are functions that help manage tokens securely.
#'
#' @param dsn A [DSN](http://en.wikipedia.org/wiki/Data_source_name) on the local machine that points to the desired MSSQL database. Required.
#' @param project_name The friendly/shortened name given to the REDCap project in the MSSQL table.  Notice this isn't necessarily the same name used by REDCap. Required
#' @param channel An *optional* connection handle as returned by [RODBC::odbcConnect()].  See Details below. Optional.

#' @return The token, which is a 32 character string.
#' @details
#' If no `channel` is passed, one will be created at the beginning of the function, and destroyed at the end.  However if a channel
#' is created, it's the caller's responsibility to destroy this resource.  If you're making successive calls to the database, it might
#' be quicker to create a single `channel` object and batch the calls together.  Otherwise, the performance should be equivalent.
#'
#' If you create the `channel` object yourself, consider wrapping calls in a `base::tryCatch` block, and closing the channel in
#' its `finally` expression; this helps ensure the expensive database resource isn't held open unnecessarily.  See the internals of
#' [retrieve_token_mssql()] for an example of closing the `channel` in a `tryCatch` block.
#'
#' If the database elements are created with the script provided in package's 'Security Database' vignette, the default values will work.
#'
#' @note
#' We use Microsoft SQL Server, because that fits our University's infrastructure the easiest.  But this approach theoretically can work
#' with any LDAP-enabled database server.  Please contact us if your institution is using something other than SQL Server, and
#' would like help adapting this approach to your infrastructure.
#'
#' There's a lot of error checking for SQL injection, but remember that the user is executing under their
#' own credentials, so this doesn't obviate the need for disciplined credential management.  There's nothing
#' that can be done with this R function that isn't already exposed by any other interface into the database
#' (eg, SQL Server Management Studio, or MySQL Workbench.)
#'
#' @author Will Beasley
#'
#' @examples
#' library(REDCapR) #Load the package into the current R session.
#' \dontrun{
#' # ---- SQL Server Example ----------------------------
#' # Rely on `retrieve_token()` to create & destory the channel.
#' dsn      <- "TokenSecurity"
#' project  <- "DiabetesSurveyProject"
#' token    <- retrieve_token(dsn=dsn, project_name=project)
#'
#' # Create & close the channel yourself, to optimize repeated calls.
#' dsn      <- "TokenSecurity"
#' project1 <- "DiabetesSurveyProject1"
#' project2 <- "DiabetesSurveyProject2"
#' project3 <- "DiabetesSurveyProject3"
#'
#' channel  <- RODBC::odbcConnect(dsn=dsn)
#' token1   <- retrieve_token(dsn=dsn, project_name=project1)
#' token2   <- retrieve_token(dsn=dsn, project_name=project2)
#' token3   <- retrieve_token(dsn=dsn, project_name=project3)
#' RODBC::odbcClose(channel)
#' }

retrieve_token_mssql <- function(
  project_name,
  dsn                      = NULL,
  channel                  = NULL
) {
  message("REDCapR::retrieve_token_mssql() is deprecated: please use REDCapR::retrieve_credential_mssql() instead.")

  if( !requireNamespace("RODBC") )
    stop("The function REDCapR::retrieve_token_mssql() cannot run if the `RODBC` package is not installed.  Please install it and try again.")
  if( !requireNamespace("RODBCext") )
    stop("The function REDCapR::retrieve_token_mssql() cannot run if the `RODBCext` package is not installed.  Please install it and try again.")

  regex_pattern_1 <- "^[a-zA-Z0-9_]+$"

  if( class(project_name)  != "character" )
    stop("The `project_name` parameter be a character type.")
  if( !(base::missing(dsn) | base::is.null(dsn)) & !(class(dsn) %in% c("character")) )
    stop("The `dsn` parameter be a character type, or missing or NULL.")
  if( !(base::missing(channel) | base::is.null(channel)) & !inherits(channel, "RODBC") )
    stop("The `channel` parameter be a `RODBC` type, or NULL.")

  if( length(project_name) != 1L )
    stop("The `project_name` parameter should contain exactly one element.")
  if( length(dsn) > 1L )
    stop("The `dsn` parameter should contain at most one element.")
  if( length(channel) > 1L )
    stop("The `channel` parameter should contain at most one element.")

  if( !grepl(regex_pattern_1, project_name) )
    stop("The 'project_name' parameter must contain only letters, numbers, and underscores.")


  sql <- "EXEC [redcap].[prcToken] @RedcapProjectName = ?"

  d_input <- data.frame(
    RedcapProjectName  = project_name,
    stringsAsFactors   = FALSE
  )

  if( base::missing(channel) | base::is.null(channel) ) {
    if( base::missing(dsn) | base::is.null(dsn) )
      stop("The 'dsn' parameter can be missing only if a 'channel' has been passed to 'retrieve_token_mssql'.")

    channel <- RODBC::odbcConnect(dsn=dsn)
    close_channel_on_exit <- TRUE
  } else {
    close_channel_on_exit <- FALSE
  }

  base::tryCatch(
    expr = {
      token <- RODBCext::sqlExecute(channel, sql, d_input, fetch=TRUE, stringsAsFactors=FALSE)$Token[1]
    }, finally = {
      if( close_channel_on_exit ) RODBC::odbcClose(channel)
    }
  )

  if( length(token) >= 2L )
    stop("No more than one token should be retrieved  The [username]-by-[project_name] should be unique in the table.")

  return( token )
}

# a <- REDCapR::retrieve_token_mssql(dsn="BbmcSecurity", project_name='GpavRecruitment')
