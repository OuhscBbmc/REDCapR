# Copied from https://github.com/agstudy/rsqlserver/blob/master/tests/testthat/helper.R

# Edit as required to run tests on an accessible SQL Server
# See docker.sh for instructions to setup a SQL Server Docker container
server <- "mydockermsdb"
dbname <- "rsqlserverdb"
user <- "SA"
password <- "Password12!"

if (identical(Sys.getenv("TRAVIS"), "true")) {
  server <- "mssqldb"
  dbname <- "rsqlserverdb"
  user <- "sa"
  password <- "Password12!"
} else if (identical(Sys.getenv("APPVEYOR"), "True")) {
  server <- "(local)\\SQL2014"
  dbname <- "rsqlserverdb"
  user <- "sa"
  password <- "Password12!"
}

url <- sprintf("Server=%s;Database=%s;User Id=%s;Password=%s;",
               server, dbname, user, password)

get_con <- function(){
  dbConnect("SqlServer", url = url)
}
