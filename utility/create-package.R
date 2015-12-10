library(devtools)
devtools::create(  path=file.path(getwd(), "seed"),check=TRUE, description=list(
  "Title"= "Interaction between R and REDCap",
  "Description"="Encapuslates functions to streamline calls from R",
  "Date"="2013-11-26",
  "Author"= "Will Beasley",
  "Maintainer"="'Will Beasley' <wibeasley@hotmail.com> "
))

devtools::use_cran_badge() 
# dr_github() 
devtools::use_code_of_conduct() 
