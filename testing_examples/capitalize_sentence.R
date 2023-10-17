capitalize_sentence <- function(sentence) {
  capitalized_words <- purrr::map(strsplit(sentence, " "), stringr::str_to_title)
  capitalized_words
}













# paste(capitalized_words[[1]], collapse = " ")