retrieve_credential_mssql2 <- function(
  dsn = "BbmcSecurity",
  instance = "bbmc",
  project_id = 404
  ) {

  sql <- "EXEC [redcap].[prc_credential] @project_id = ?, @instance = ?"
  input <- list(project_id = project_id, instance = instance)
  # sql <- "EXEC [redcap].[prc_credential] @project_id = ?, @instance = 'bbmc'"
  # input <- list(project_id = project_id)
  # sql <- "EXEC [redcap].[prc_credential] @project_id = 404, @instance = 'bbmc'"
  # input <- list(project_id)
  channel <- DBI::dbConnect(odbc::odbc(), dsn = dsn)

  base::tryCatch(
    expr = {
      d_credential  <- DBI::dbGetQuery(conn = channel, statement = sql, params = input)


      # result        <- DBI::dbSendQuery(channel, sql)
      # DBI::dbBind(result, input)
      # d_credential  <- DBI::dbFetch(result)
    }, finally = {
      # if (!is.null(result))      DBI::dbClearResult(result)
      DBI::dbDisconnect(channel)
    }
  )

  return( d_credential )
}
retrieve_credential_mssql2()
