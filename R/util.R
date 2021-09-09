#' @importFrom glue glue
ag_option <- function(option) {
  getOption(glue("ag_{option}"))
}

#' @importFrom purrr keep
ag_colnames <- function(data) {
  keep(ag_option("colnames"), ~ .x %in% colnames(data))
}

is_node_selected <- function(id) {
  length(id) != 0 && id != ag_option("str_null")
}

#' @importFrom glue glue
#' @importFrom stringr str_trunc
linkify_doi <- function(doi, truncate = TRUE) {
  glue("<a href='https://doi.org/{doi}' target='_blank' rel='noopener noreferer'>{if (truncate) str_trunc(doi, 18) else doi}</a>")
}