#This code checks the user's installed packages against a list of packages (that we've manually compiled) 
#   necessary for our repository's code to be fully operational. Missing packages are installed, while existing packages are not.
#   If anyone sees a package that should be on there, please tell me.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

packagesToInstall <- c(
  "colorspace" #Explicit control over the HCL color scheme
  , "devtools" #Used in the C1 survival for sourcing gists
  , "digest" #Creates SHA hashes for the recruiting database
  , "evaluate" #A package that Hadley et al use a lot in their packages.  It helps when things are passed by reference.
  , "foreign" #Reads data in other formats
  , "ggplot2" #Graphing
  , "ggthemes" #Extra themes, scales and geoms for ggplot
  , "googleVis" #JavaScript-based visualizations, like scrollable tables
  , "ggmap" #Maps & graphics, based on ggplot
  , "knitr" #For reporting
  , "lme4" #Multilevel models
  , "lubridate" #Consistent/convienent function signatures for manipulating dates
  , "plyr" #Important for most of our data manipulation
  , "random" #Creates random numbers for salts
  , "RColorBrewer" #Explicit control over the Color Brewer colors.  See http://colorbrewer2.org/
  , "RCurl" #Interact with the REDCap API
  , "reshape2" #Data manipulation not covered in plyr
  , "RODBC" #For connecting to ODBC databases
  , "roxygen2" #Creates documentation Rd file from (well-formed) comments
  , "stringr" #Consistent/convienent function signatures for manipulating text
  , "testit" #has the useful `assert()` function
  , "testthat" #Heavier testing framework that's good for package development
  , "xtable" #Formats tables, especially for LaTeX output.
  , "zipcode" #Database of zipcodes and their lat & long; also useful for flagging bad zipcodes
) 

for( packageName in packagesToInstall ) {
  available <- require(packageName, character.only=TRUE) #Loads the packages, and indicates if it's available
  if( !available ) {
    install.packages(packageName, dependencies=TRUE)
    require( packageName, character.only=TRUE)
  }
}

update.packages(ask="graphics", checkBuilt=TRUE)

#There will be a warning message for every  package that's called but not installed.  It will look like:
#    Warning message:
#        In library(package, lib.loc = lib.loc, character.only = TRUE, logical.return = TRUE,  :
#        there is no package called 'bootstrap'
#If you see the message (either in here or in another piece of the project's code),
#   then run this again to make sure everything is installed.  You shouldn't get a warning again.