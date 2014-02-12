#' @name redcap_column_sanitize
#' @export redcap_column_sanitize
#' @title Sanitize values to follow REDCap character requirements.
#'  
#' @description Replace characters that could cause problems when saving to a REDCap project.
#' 
#' @param d The \code{data.frame} containing the dataset used to update the REDCap project.  Required.
#' @param column_names An array of \code{character} values indicating the names of the variables to sanitize.  Optional.
#' @return A \code{data.frame} with same columns, but whose character values have been sanitized
#' @details 
#' Letters like an accented `A` are replaced with a plain `A`.  Please tell us if you encounter another violating character.
#' 
#' @author Will Beasley
#' 
#' @examples
#' # Examples are not shown because they make they require non-ASCII encoding, 
#' #   and make the documentation less portable.
#' # To see some of the characters replaced run this line.  
#' #   Unfortunately, the characters might not display correctly in your console either.
#' REDCapR::redcap_column_sanitize

redcap_column_sanitize <- function( d, column_names=colnames(d) ) {
  #Demote unicode characters to ASCII
  old_characters <- base::c("ÄÁÀÂÇÉÈÊËÍÎÏÑÓÖÔØÚÜÙÛŸÝ") #Pasted from http://www.periodni.com/unicode_utf-8_encoding.html
  new_characters <- base::c("AAAACEEEEIIINOOOOUUUUYY")
  old_characters <- base::paste0(old_characters, base::tolower(old_characters))
  new_characters <- base::paste0(new_characters, base::tolower(new_characters))
  
  for( column in column_names ) {
    d[, column] <- base::chartr(old=old_characters, new=new_characters, x=d[, column])
  }  
  return( d )
}

make.names("ÄÁÀ")
iconv("Žvaigždės aukštybėj užges or äüö", "latin1", "ASCII//TRANSLIT", "?")
iconv("ÄÁÀÂÇÉÈÊËÍÎÏÑÓÖÔØÚÜÙÛŸÝ", "latin1", "ASCII//TRANSLIT", "?")
iconv("äáàâçéèêëíîïñóöôøúüùûÿý", "latin1", "ASCII//TRANSLIT", "?")

# d <- data.frame(name_last=c("Gödel", "Pølsehorn"), name_first=c("Ángel", "Joaquín"), name_middle=c("Lý", "Tôn"))
# 
# #Sanitize all the columns.
# d_sanitized_all <- redcap_column_sanitize(d=d)
# d_sanitized_all
# 
# #Sanitize the last and middle name, but not the middle.
# d_sanitized_some <- redcap_column_sanitize(d=d, column_names=c("name_last", "name_middle"))
# d_sanitized_some

tools::showNonASCII("ÄÁÀÂÇÉÈÊËÍÎÏÑÓÖÔØÚÜÙÛŸÝ")

# tools::showNonASCII(data.frame(name_last=c("Gödel", "Pølsehorn"), name_first=c("Ángel", "Joaquín"), name_middle=c("Lý", "Tôn")))
