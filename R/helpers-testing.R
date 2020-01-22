
retrieve_credential_testing <- function(project_id = 153L) {
  checkmate::assert_integer(project_id, lower = 1, len = 1, any.missing = FALSE)
   REDCapR::retrieve_credential_local(
    path_credential = system.file("misc/example.credentials", package="REDCapR"),
    project_id      = project_id
  )
}
