#' @author   Amanda Lin Li

#' @description Removes different unwanted html tags from field labels.
#'
#' @param s strings which may contain html tags
#'
#' @return  strings with html tags (if any) removed
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

#' @description Separate `field_labels` mixed with English and Spanish,
#' into `field_label_en` and `field_label_es`, respectively.
#' And removes unwanted html tags and extra whitespaces.
#'
#' @param dict tibble. A dataframe containing a REDCap data dictionary
#' @param lang vector of string from where English or Spanish is selected
#'
choose_dict_lang <- function(dict, lang = c("es", "en")) {
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
        field_label = field_label_en,
      ) %>%
      dplyr::select(-field_label_es, -field_label_en)
  } else if (lang == "es") {
    dict <- dict %>%
      dplyr::mutate(
        field_label = field_label_es,
      ) %>%
      dplyr::select(-field_label_es, -field_label_en)
  }
}

#
#' @description  Clean Field Labels
#'
#' @param dict tibble. A data frame containing a REDCap data dictionary
#' @param l string language option "en" == English, es == "Spanish"
#' @return tibble. A data frame containing the cleaned data dictionary.
clean_field_label <- function(dict, l = c("en")) {
  dict %>%
    choose_dict_lang(.,lang = l) %>%
    dplyr::mutate(
      field_label = field_label %>%
        sub(pattern = "_x000D_", replacement = "") %>%
        sub(pattern = "&nbsp", replacement = "") %>%
        gsub(pattern = " ,", replacement = ",") %>%
        # Amanda added
        gsub(pattern = " \\.", replacement = ".")
    )

}

