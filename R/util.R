#' @importFrom glue glue
ag_option <- function(option) {
  getOption(glue("ag_{option}"))
}

is_node_selected <- function(id) {
  length(id) != 0 && id != ag_option("str_null")
}

#' @importFrom glue glue
#' @importFrom stringr str_trunc
linkify_doi <- function(doi) {
  glue("<a href='https://doi.org/{doi}' target='_blank' rel='noopener noreferer'>{str_trunc(doi, 18)}</a>")
}