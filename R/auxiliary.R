#' @name retrieve_token
#' @export retrieve_token_mssql
#' 
#' @title Read a token from a (non-REDCap) database.
#'  
#' @description From an external perspective, this function is similar to \code{\link{redcap_read_oneshot}}.  The internals
#' differ in that \code{redcap_read} retrieves subsets of the data, and then combines them before returning
#' (among other objects) a single \code{data.frame}.  This function can be more appropriate than 
#' \code{\link{redcap_read_oneshot}} when returning large datasets that could tie up the server.   
#' 
#' @param dsn_name ---.  The default is 100.
#' @param project_name ---. The default is 0.5 seconds.
#' @param channel ---.  Required.
#' @param schema_name ---.  Required.
#' @param procedure_name ---.  Optional.
#' @param variable_name_project ---.  Optional.
#' @param field_name_token ---.  Optional.
#' 
#' @return The token, which is a 32 character string.
#' @details 
#' Specifically, it internally uses multiple calls to \code{\link{redcap_read_oneshot}} to select and return data.
#' Initially, only primary key is queried through the REDCap API.  The long list is then subsetted into partitions,
#' whose sizes are determined by the \code{batch_size} parameter.  REDCap is then queried for all variables of
#' the subset's subjects.  This is repeated for each subset, before returning a unified \code{data.frame}.
#' 
#' The function allows a delay between calls, which allows the server to attend to other users' requests.
#' @author Will Beasley
#' @references The official documentation can be found on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiDocumentation}).  
#' Also see the `API Examples' page on the REDCap wiki (\url{https://iwg.devguard.com/trac/redcap/wiki/ApiExamples}). 
#' A user account is required to access the wiki, which typically is granted only to REDCap administrators.  
#' If you do not
#' 
#' The official \href{http://curl.haxx.se}{cURL site} discusses the process of using SSL to verify the server being connected to.
#' 
#' @examples
#' \dontrun{
#' library(REDCapR) #Load the package into the current R session.
#' dsn_name <- "TokenSecurity"
#' project_name <- "DiabetesSurveyProject2"
#' token <- retrieve_token(dsn_name=dsn, project_name=project)
#' }
#' 

retrieve_token_mssql <- function( 
  dsn_name, 
  project_name, 
  channel = NULL, 
  schema_name = "[Redcap]", 
  procedure_name = "[prcToken]", 
  variable_name_project = "@RedcapProjectName", 
  field_name_token = "Token"
  ) {
  
  if( !require(RODBC) ) stop("The function REDCapR::retrieve_token_mssql() cannot run if the `RODBC` package is not installed.  Please install it and try again.")

  sql <- sprintf("EXEC %s.%s %s = %s", schema_name, procedure_name, variable_name_project, field_name_token)
  
  if( base::missing(channel) | is.null(channel) ) {
    channel <- RODBC::odbcConnect(dsn=dsn_name)
    close_channel <- FALSE
  } else {
    close_channel <- TRUE
  }
  
  tryCatch(
    expr = { token <- RODBC::sqlQuery(channel, sql, stringsAsFactors=FALSE)[1, field_name_token] }, 
    finally = { if( close_channel ) RODBC::odbcClose(channel) }
  )
  
  return( token )
}
