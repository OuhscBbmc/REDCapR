rm(list=ls(all=TRUE))
devtools::install_github("testthat", "hadley") #For Version 0.8

devtools::build_github_devtools()
