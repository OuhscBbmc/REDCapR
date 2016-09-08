#This code checks the user's installed packages against the packages listed in `./utility/package_dependency_list.csv`.
#   These are necessary for the repository's R code to be fully operational.
#   CRAN packages are installed only if they're not already; then they're updated if available.
#   GitHub packages are installed regardless if they're already installed.
#If anyone encounters a package that should be on there, please add it to `./utility/package_dependency_list.csv`

#Clear memory from previous runs.
base::rm(list=base::ls(all=TRUE))

path_csv <- "./utility/package-dependency-list.csv"

if( !file.exists(path_csv)) {
  base::stop("The path `", path_csv, "` was not found.  Make sure the working directory is set to the root of the repository.")
}

if( !base::requireNamespace("devtools") ) {
  utils::install.packages("devtools", repos="http://cran.rstudio.com")
}

devtools::install_github("OuhscBbmc/OuhscMunge")

OuhscMunge:::package_janitor(path_csv)
