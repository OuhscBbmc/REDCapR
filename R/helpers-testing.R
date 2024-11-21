retrieve_credential_testing <- function(
    project_tag = "simple",
    username = NA_character_
  ) {
  checkmate::assert_character(project_tag     , any.missing = FALSE, min.chars = 2, max.chars = 50)
  checkmate::assert_character(username        , any.missing = TRUE , min.chars = 2, max.chars = 50)

  server_instance <-
    if(Sys.getenv("redcapr_test_server") != "") {
      Sys.getenv("redcapr_test_server")
    } else {
      message("The test server was not explicitly set, so defaulting to 'dev-2'.")
      "dev-2"
    }
  checkmate::assert_character(server_instance , any.missing = FALSE, min.chars = 2, max.chars = 50)

  # This line avoids a warning from the package check.
  projects <- project_id <- instance <- tag <- NULL

  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop(
      "Package `yaml` must be installed to use this function.",
      call. = FALSE
    )
  }
  d_map <-
    system.file("misc/project-redirection.yml", package = "REDCapR") |>
    yaml::yaml.load_file(
      handlers = list(map = \(x) tibble::as_tibble(x))
    ) |>
    dplyr::bind_rows() |>
    tidyr::unnest(projects) |>
    tidyr::pivot_longer(
      cols      = -c("instance", "credential_file"),
      names_to  = "tag",
      values_to = "project_id"
    ) |>
    tidyr::drop_na(project_id) |>
    dplyr::filter(instance == server_instance) |>
    dplyr::filter(tag      == project_tag)

  if (nrow(d_map) == 0L) {
    stop("A credential mapping entry does not exist for the desired arguments.")
  }

  path_credential <- system.file(d_map$credential_file, package = "REDCapR")
  if (!base::file.exists(path_credential)) {
    stop(
      "The credential file `",
      d_map$credential_file,
      "` associated with the `",
      server_instance,
      "` does not exist on this machine."
    )
  }

  retrieve_credential_local(
    path_credential = path_credential, # "misc/dev-2.credentials"
    project_id      = d_map$project_id,
    username        = username
  )
}
retrieve_plugins <- function(plugin_name) {
  checkmate::assert_character(plugin_name     , any.missing = FALSE, min.chars = 2, max.chars = 50)

  server_instance <-
    if(Sys.getenv("redcapr_test_server") != "") {
      Sys.getenv("redcapr_test_server")
    } else {
      message("The test server was not explicitly set for plugins, so defaulting to 'dev-2'.")
      "dev-2"
    }
  checkmate::assert_character(server_instance , any.missing = FALSE, min.chars = 2, max.chars = 50)

  # This line avoids a warning from the package check.
  plugins <- instance <- tag <- project_tag <- NULL

  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop(
      "Package `yaml` must be installed to use this function.",
      call. = FALSE
    )
  }
  d_map <-
    system.file("misc/plugin-redirection.yml", package = "REDCapR") |>
    yaml::yaml.load_file(
      handlers = list(map = \(x) tibble::as_tibble(x))
    ) |>
    dplyr::bind_rows() |>
    tidyr::unnest(plugins) |>
    tidyr::pivot_longer(
      cols      = -c("instance"),
      names_to  = "tag",
      values_to = "url"
    ) |>
    tidyr::drop_na(url) |>
    dplyr::filter(instance == server_instance) |>
    dplyr::filter(tag      == plugin_name)

  if (nrow(d_map) == 0L) {
    stop("A plugin mapping entry does not exist for the desired arguments.")
  }

  d_map |>
    dplyr::pull(url)
}
# This function isn't used during testing itself.  Just to create the expected file.
save_expected <- function(o, path) {
  # nocov start
  attr(o, which = "problems") <- NULL
  path <- file.path("inst", path)
  if (!dir.exists(dirname(path))) dir.create(dirname(path), recursive = FALSE)

  dput(o, path)
  # nocov end
}
retrieve_expected <- function(path) {
  full_path   <- system.file(path, package = "REDCapR")
  if (!file.exists(full_path))
    stop("The expected file `", full_path, "` was not found.")  # nocov
  dget(full_path)
}
