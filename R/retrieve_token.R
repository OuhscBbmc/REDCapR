#' @name retrieve_token
#' @aliases retrieve_token_mssql
#' @export retrieve_token_mssql
#'
#' @title Read a token from a (non-REDCap) database.
#'
#' @description These functions are not essential to calling the REDCap API, but instead are functions that help manage tokens securely.
#'
#' @param dsn A \href{http://en.wikipedia.org/wiki/Data_source_name}{DSN} on the local machine that points to the desired MSSQL database. Required.
#' @param project_name The friendly/shortened name given to the REDCap project in the MSSQL table.  Notice this isn't necessarily the same name used by REDCap. Required
#' @param channel An \emph{optional} connection handle as returned by \code{RODBC::odbcConnect}.  See Details below. Optional.
#' @param schema_name The schema used within the database.  Note that MSSQL uses the more conventional definition of \href{http://en.wikipedia.org/wiki/Database_schema}{schema} than MySQL.  Defaults to \code{'[Redcap]'}. Optional.
#' @param procedure_name The stored procedure called to retrieve the token. Defaults to \code{'[prcToken]'}.  Optional.
#' @param variable_name_project The variable declared within the stored procedure that contains the desired project name.  Optional.
#' @param field_name_token The field/column/variable name in the database table containing the token values.  Defaults to \code{'Token'}.  Optional.
#'
#' @return The token, which is a 32 character string.
#' @details
#' If no \code{channel} is passed, one will be created at the beginning of the function, and destroyed at the end.  However if a channel
#' is created, it's the caller's responsibility to destroy this resource.  If you're making successive calls to the database, it might
#' be quicker to create a single \code{channel} object and batch the calls together.  Otherwise, the performance should be equivalent.
#'
#' If you create the \code{channel} object yourself, consider wrapping calls in a \code{base::tryCatch} block, and closing the channel in
#' its \code{finally} expression; this helps ensure the expensive database resource isn't held open unnecessarily.  See the internals of
#' \code{retrieve_token_mssql} for an example of closing the \code{channel} in a \code{tryCatch} block.
#'
#' If the database elements are create with the script provided in package's `Security Database' vignette, the default values will work.
#'
#' @note
#' We use Microsoft SQL Server, because that fits our University's infrastructure the easiest.  But this approach theoretically can work
#' with any LDAP-enabled database server.  Please contact us if your institution is using something other than SQL Server, and would like help adapting this approach to
#' your infrastructure.
#' @author Will Beasley
#'
#' @examples
#' \dontrun{
#' library(REDCapR) #Load the package into the current R session.
#'
#' ##
#' ## Rely on `retrieve_token()` to create & destory the channel.
#' ##
#' dsn <- "TokenSecurity"
#' project <- "DiabetesSurveyProject"
#' token <- retrieve_token(dsn=dsn, project_name=project)
#'
#' ##
#' ## Create & close the channel yourself, to optimize repeated calls.
#' ##
#' dsn <- "TokenSecurity"
#' project1 <- "DiabetesSurveyProject1"
#' project2 <- "DiabetesSurveyProject2"
#' project3 <- "DiabetesSurveyProject3"
#'
#' channel <- RODBC::odbcConnect(dsn=dsn)
#' token1 <- retrieve_token(dsn=dsn, project_name=project1)
#' token2 <- retrieve_token(dsn=dsn, project_name=project2)
#' token3 <- retrieve_token(dsn=dsn, project_name=project3)
#' RODBC::odbcClose(channel)
#' }
#'

retrieve_token_mssql <- function(
  dsn,
  project_name,
  channel = NULL,
  schema_name = "[Redcap]",
  procedure_name = "[prcToken]",
  variable_name_project = "@RedcapProjectName",
  field_name_token = "Token"
  ) {

  if( !requireNamespace("RODBC", quietly=TRUE) ) 
    stop("The function REDCapR::retrieve_token_mssql() cannot run if the `RODBC` package is not installed.  Please install it and try again.")

  regex_pattern_1 <- "^*[a-zA-Z0-9_]*$"
  regex_pattern_2 <- "^\\[*[a-zA-Z0-9_]*\\]*$"
  regex_pattern_3 <- "^@*[a-zA-Z0-9_]*$"
  
  if( !grepl(regex_pattern_1, project_name) ) 
    stop("The 'project_name' parameter must contain only letters, numbers, and underscores.")
  if( !grepl(regex_pattern_2, schema_name) ) 
    stop("The 'schema_name' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets.")
  if( !grepl(regex_pattern_2, procedure_name) ) 
    stop("The 'procedure_name' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets.")
  if( !grepl(regex_pattern_3, variable_name_project) ) 
    stop("The 'variable_name_project' parameter must contain only letters, numbers, and underscores.  It may optionally have a leading ampersand.")
  if( !grepl(regex_pattern_1, field_name_token) ) 
    stop("The 'field_name_token' parameter must contain only letters, numbers, and underscores.")
  
  sql <- base::sprintf("EXEC %s.%s %s = '%s'", schema_name, procedure_name, variable_name_project, project_name)

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
      token <- RODBC::sqlQuery(channel, sql, stringsAsFactors=FALSE)[1, field_name_token]
    }, finally = {
      if( close_channel_on_exit ) RODBC::odbcClose(channel)
    }
  )

  return( token )
}
