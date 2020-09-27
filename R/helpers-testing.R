retrieve_credential_testing <- function(project_id = 153L) {
  checkmate::assert_integer(project_id, lower = 1, len = 1, any.missing = FALSE)
   REDCapR::retrieve_credential_local(
    path_credential = system.file("misc/example.credentials", package="REDCapR"),
    project_id      = project_id
  )
}

save_expected <- function (o, path) {
  path <- file.path("inst", path)
  if (!dir.exists(dirname(path))) dir.create(dirname(path), recursive = FALSE)

  dput(o, path)
}

retrieve_expected <- function (path) {
  full_path   <- system.file(path, package = "REDCapR")
  if (!file.exists(full_path))
    stop("The expected file `", full_path, "` was not found.")
  dget(full_path)
}
