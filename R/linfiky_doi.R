#' @importFrom glue glue
#' @importFrom stringr str_trunc
linkify_doi <- function(doi) {
  glue("<a href='https://doi.org/{doi}' target='_blank' rel='noopener noreferer'>{str_trunc(doi, 18)}</a>")
}