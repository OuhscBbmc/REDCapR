library(RODBCext)

retrieve_token_mssql2 <- function(
  dsn,
  project_name,
  channel = NULL,
  schema_name = "[Redcap]",
  procedure_name = "[prcToken]",
  variable_name_project = "@RedcapProjectName",
  field_name_token = "Token"
  ) {
  
  if( !requireNamespace("RODBC", quietly=TRUE) ) stop("The function REDCapR::retrieve_token_mssql() cannot run if the `RODBC` package is not installed.  Please install it and try again.")
  
  regex_pattern_1 <- "^*[a-zA-Z0-9_]*$"
  regex_pattern_2 <- "^\\[*[a-zA-Z0-9_]*\\]*$"
  regex_pattern_3 <- "^@*[a-zA-Z0-9_]*$"
  if( !grepl(regex_pattern_1, project_name) ) stop("The 'project_name' parameter must contain only letters, numbers, and underscores.")
  if( !grepl(regex_pattern_2, schema_name) ) stop("The 'schema_name' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets.")
  if( !grepl(regex_pattern_2, procedure_name) ) stop("The 'procedure_name' parameter must contain only letters, numbers, and underscores.  It may optionally be enclosed in square brackets.")
  if( !grepl(regex_pattern_3, variable_name_project) ) stop("The 'variable_name_project' parameter must contain only letters, numbers, and underscores.  It may optionally have a leading ampersand.")
  if( !grepl(regex_pattern_1, field_name_token) ) stop("The 'field_name_token' parameter must contain only letters, numbers, and underscores.")
  
  sql <- base::sprintf("EXEC %s.%s %s = '%s'", schema_name, procedure_name, variable_name_project, project_name)
  
  if( base::missing(channel) | base::is.null(channel) ) {
    channel <- RODBC::odbcConnect(dsn=dsn)
    close_channel_on_exit <- TRUE
  } else {
    close_channel_on_exit <- FALSE
  }
  
  base::tryCatch(
    expr = {
      token <- RODBC::sqlQuery(channel, sql, stringsAsFactors=FALSE)[1, field_name_token]
    }, finally = {
      if( close_channel_on_exit )
        RODBC::odbcClose(channel)
    }
  )
  
  return( token )
}

retrieve_token_mssql2(dsn="BbmcSecurity", project_name="Gpav2", schema_name = "[Redcap]")
!grepl("^[a-zA-Z0-9_]*$", "Redcap")
!grepl("^[a-zA-Z0-9_]*$", "[Redcap]")
!grepl("^\\[*[a-zA-Z0-9_]*\\]*$", "[Redcap]")
!grepl("^\\[*[a-zA-Z0-9_]*\\]*$", "Gpav2")
!grepl(regex_pattern, "Gpav2")
retrieve_token_mssql(dsn="BbmcSecurity", project_name="Gpav2", schema_name = "[Redcap]")


# library(RODBC)
# channel <- RODBC::odbcConnect("BbmcSecurity")
# project <- "Gpav2"
# RODBC::sqlQuery(channel, 'CALL "BbmcSecurity"."Redcap"."prcToken" (project)')
# 
# RODBC::sqlQuery(channel, 'CALL [Redcap].[prcToken] (Gpav2)')
# RODBC::sqlQuery(channel, 'EXEC Redcap.prcToken ( "Gpav2" )')
# RODBC::odbcClose(channel)
