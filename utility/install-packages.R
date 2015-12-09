#This code checks the user's installed packages against the packages listed in `./code_utilities/package-dependency-list.csv`.
#   These are necessary for the repository's R code to be fully operational.
#   CRAN packages are installed only if they're not already; then they're updated if available.
#   GitHub packages are installed regardless if they're already installed.
#If anyone encounters a package that should be on there, please add it to `./code_utilities/package-dependency-list.csv`

#Clear memory from previous runs.
base::rm(list=base::ls(all=TRUE))

#####################################
## @knitr declare_globals
path_csv <- './utility/package-dependency-list.csv'
cran_repo <- "http://cran.rstudio.com"

if( !file.exists(path_csv))
  base::stop("The path `", path_csv, "` was not found.  Make sure the working directory is set to the root of the repository.")

#####################################
## @knitr load_data
ds_packages <- utils::read.csv(file=path_csv, stringsAsFactors=FALSE)

rm(path_csv)

#####################################
## @knitr tweak_data
ds_install_from_cran <- ds_packages[ds_packages$install & ds_packages$on_cran, ]
ds_install_from_github <- ds_packages[ds_packages$install & !ds_packages$on_cran, ]

rm(ds_packages)

#####################################
## @knitr update_cran_packages
utils::update.packages(ask=FALSE, checkBuilt=TRUE, repos=cran_repo)

#####################################
## @knitr install_cran_packages
for( package_name in ds_install_from_cran$package_name ) {
  available <- base::requireNamespace(package_name, quietly=TRUE) #Loads the packages, and indicates if it's available
  if( !available ) {
    utils::install.packages(package_name, dependencies=TRUE, repos=cran_repo)
    base::requireNamespace(package_name, quietly=TRUE)
  }
  base::rm(available)
}
rm(ds_install_from_cran, package_name)

#####################################
## @knitr check_for_libcurl
if( R.Version()$os=="linux-gnu" ) {
  libcurl_results <- base::system("locate libcurl4")
  libcurl_missing <- (libcurl_results==0)

  if( libcurl_missing )
    base::warning("This Linux machine is possibly missing the 'libcurl' library.  ",
            "Consider running `sudo apt-get install libcurl4-openssl-dev`.")

  base::rm(libcurl_results, libcurl_missing)
}

#####################################
## @knitr install_devtools
# Installing the devtools package is different than the rest of the packages.  On Windows,
#   the dll can't be overwritten while in use.  This function avoids that issue.
# This should follow the initial CRAN installation of `devtools`.
#   Installing the newest GitHub devtools version isn't always necessary, but it usually helps.

if( !base::requireNamespace("devtools") )
  utils::install.packages("devtools", repos=cran_repo)

download_location <- "./devtools.zip" #This is the default value.
devtools::build_github_devtools(download_location)

base::unlink(download_location, recursive=FALSE) #Remove the file from disk.
base::rm(download_location)

#####################################
## @knitr install_github_packages
for( i in base::seq_len(base::nrow(ds_install_from_github)) ) {
  package_name <- ds_install_from_github[i, "package_name"]
  username <- ds_install_from_github[i, "github_username"]
  repository_name <- paste0(username, "/", package_name)
  devtools::install_github(repo=repository_name)
  base::rm(package_name, username, repository_name)
}

base::rm(ds_install_from_github, i)
