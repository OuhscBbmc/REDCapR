requireNamespace("RODBC")
requireNamespace("RODBCext")

retrieve_credential_mssql2 <- function(
  dsn = "BbmcSecurity",
  instance = "bbmc",
  project_id = 404,
  channel = NULL,
  schema_name = "[redcap]",
  procedure_name = "[prc_credential]",
  variable_name_project = "@RedcapProjectName",
  field_name_token = "Token"
  ) {
  

  # sql <- base::sprintf("EXEC %s.%s %s = '%s'", schema_name, procedure_name, variable_name_project, project_name)
  #sql <- "EXEC [redcap].[prc_credential] @project_id = ?, @instance = ?"
  sql <- "EXEC [redcap].[prc_credential] @project_id = ?, @instance = ?"
  # sql <- "EXEC [Redcap].[prc_credential] @project_id = 302,	@instance = 'bbmc'
  # , schema_name, procedure_name, variable_name_project, project_name)
  
  if( base::missing(channel) | base::is.null(channel) ) {
    channel <- RODBC::odbcConnect(dsn=dsn)
    close_channel_on_exit <- TRUE
  } else {
    close_channel_on_exit <- FALSE
  }
  
  d_input <- data.frame(
    project_id         = project_id,
    instance           = instance,
    stringsAsFactors   = FALSE
  )
  
  
  base::tryCatch(
    expr = {

      d_credential <- RODBCext::sqlExecute(channel, sql, d_input, fetch=TRUE, stringsAsFactors=FALSE)

      
    }, finally = {
      if( close_channel_on_exit )
        RODBC::odbcClose(channel)
    }
  )
  
  return( d_credential )
}
retrieve_credential_mssql2()
