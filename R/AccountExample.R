#' A Reference Class to represent a bank account.

#' 
#' @field balance1 A length-one numeric vector
#' @field balance2 A length-one numeric vector

Account <- setRefClass("Account",
                       fields = list(balance1 = "numeric", balance2 = "numeric"),
                       methods = list(
                         withdraw1 = function(x) {
                           "Withdraw1 money from account. Allows overdrafts"
                           balance1 <<- balance1 - x
                         },
                         withdraw2 = function(x) {
                           "Withdraw2 money from account. Allows overdrafts"
                           balance2 <<- balance2 - x
                         }
                       )
)
