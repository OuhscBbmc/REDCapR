library(dplyr)

strip_html <- function(s) {
  tryCatch(
    {
      res <- if_else(!is.na(s),
                     rvest::html_text(rvest::read_html(s), trim = TRUE),
                     NA_character_,
                     missing = NA_character_)
      return(res)
    },
    error = function(e) {
      return(s)
    }
  )
}


choose_dict_lang <- function(dict, lang = c("en")) {
  lang <- match.arg(lang)

  dict <- dict %>%
    tidyr::separate(
      field_label,
      c("field_label_en", "field_label_es"),
      '(?=<span\\s{1,5}lang=\"es\")|(?=<span\\s{1,5}lang=\'es\')',
      remove = FALSE
    ) %>%
    dplyr::mutate(
      # across(
      #   c(field_label_en, field_label_es),
      field_label_en = unlist(purrr::map(field_label_en,
                                         ~ strip_html(.x))) %>%
        gsub(pattern = "(?<=[\\s])\\s*|^\\s+|\\s+$",
          replacement = "",
          x = ., perl = TRUE) %>%
        trimws(),

      field_label_es = unlist(purrr::map(field_label_es,
                                         ~ strip_html(.x))) %>%
        gsub(pattern = "(?<=[\\s])\\s*|^\\s+|\\s+$",
             replacement = "",
             x = .,
             perl = TRUE) %>%
        trimws()
    )
  if (lang == "en") {
    dict <- dict %>%
      dplyr::mutate(
        field_label_new = field_label_en,
      ) %>%
      dplyr::select(-field_label_es, -field_label_en)
  } else if (lang == "es") {
    dict <- dict %>%
      dplyr::mutate(
        field_label_new = field_label_es,
      ) %>%
      dplyr::select(-field_label_es, -field_label_en)
  }
}

# Slightly change the formula so that the English and Spanish columns aren’t deleted at the end


# dic_clean

#' Clean Field Labels
#'
#' Removes different unwanted elements (e.g., special characters) from field
#'   labels.
#'   @Amanda: This probably has to be extended for more cases.
#'
#'   @Janosh, I also use purrr:reduce2 here.
# .
#' @param dict tibble. A data frame containing a REDCap data dictionary
#'
#' @param mapping_filepath string. A string containing the address of the `.csv`
#' file that save the error syntax and corresponding correct replacement.
#'
#' @return tibble. A data frame containing the cleaned data dictionary.
clean_field_label <- function(dict) {

  # readr::read_csv(mapping_filepath)
  dict %>%
    choose_dict_lang() %>%
    dplyr::mutate(
      field_label = field_label_new %>%
        sub(pattern = "_x000D_", replacement = "") %>%
        sub(pattern = "&nbsp", replacement = "") %>%
        gsub(pattern = " ,", replacement = ",") %>%
        # Amanda added
        gsub(pattern = " \\.", replacement = ".")
    ) %>%
    select(-field_label_new)

}
