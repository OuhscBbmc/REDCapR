retrieve_credential_testing <- function (project_id = 153L, username = NA_character_) {
  checkmate::assert_integer(project_id, lower = 1, len = 1, any.missing = FALSE)
   REDCapR::retrieve_credential_local(
    path_credential = system.file("misc/example.credentials", package="REDCapR"),
    project_id      = project_id,
    username        = username
  )
}

# This function isn't used during testing itself.  Just to create the expected file.
save_expected <- function (o, path) {
  # nocov start
  path <- file.path("inst", path)
  if (!dir.exists(dirname(path))) dir.create(dirname(path), recursive = FALSE)

  dput(o, path)
  # nocov end
}

retrieve_expected <- function (path) {
  full_path   <- system.file(path, package = "REDCapR")
  if (!file.exists(full_path))
    stop("The expected file `", full_path, "` was not found.")  # nocov
  dget(full_path)
}
