rm(list=ls(all=TRUE))
library(REDCapR)

dfBad <- data.frame(
  record_id = 1:4,
  bad_logical = c(T, T, F, T),
  UpperCase = c(4, 6, 8, 2)
)
validate_for_write(d = dfBad)


grep(pattern="[A-Z]", x=colnames(dfBad), perl=TRUE)

indices <- which(sapply(dfBad, class)=="logical")
colnames(dfBad)[indices]

# indices <- which(sapply(d, class)=="logical")
# colnames(df)[indices]

data.frame(
  field_name = colnames(dfBad)[indices],
  field_index = indices,
  concern = "The REDCap API does not automatically convert boolean values to 0/1 values.",
  suggestion = "Convert the variable with the `as.integer()` function ."
)

v <- validate_for_write(dfBad)

dfGood <- data.frame(
  record_id = 1:4,
  not_logical = c(1, 1, 0, 1),
  no_uppercase = c(4, 6, 8, 2)
)

flag <- (sapply(dfGood, class)=="logical")
indices <- which(flag)

data.frame(
  field_name = colnames(df)[flag],
  field_index = indices,
  concern = "The REDCap API does not automatically convert boolean values to 0/1 values.",
  suggestion = "Convert the variable with the `as.integer()` function .",
  stringsAsFactors = FALSE
)

v <- validate_no_logical(dfGood)
v <- validate_for_write(dfGood)

dfSoso <- data.frame(
  record_id = 1:4,
  bad_logical = c(T, T, T, F),
  no_uppercase = c(4, 6, 8, 2)
)
v <- validate_for_write(dfSoso)
