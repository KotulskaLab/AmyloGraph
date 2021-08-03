#' @importFrom glue glue
linkify_doi <- function(doi) {
  glue("<a href='https://doi.org/{doi}' target='_blank' rel='noopener noreferer'>{doi}</a>")
}