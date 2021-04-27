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
browser()



  base::tryCatch(
    expr = {
      # d_credential  <- DBI::dbGetQuery(conn = channel, statement = sql, params = input, n = 1L)


      result        <- DBI::dbSendQuery(channel, sql)
      DBI::dbBind(result, input)
      # d_credential  <- DBI::dbFetch(result)
      d_credential  <- DBI::dbFetch(result, n = 1L)
    }, finally = {
      if (!is.null(result))      DBI::dbClearResult(result)
      DBI::dbDisconnect(channel)
    }
  )

  return( d_credential )
}
retrieve_credential_mssql2()
