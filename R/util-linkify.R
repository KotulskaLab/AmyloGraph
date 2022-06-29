#' Wrap DOI in a link
#' 
#' @description Wraps DOI code in a HTML clickable link to the respective
#' address on doi.org. Allows displaying a truncated DOI string instead of the
#' full form.
#' 
#' @param doi \[\code{character()}\]\cr
#'  DOI codes to use (as labels and links).
#' @param truncate \[\code{logical(1)}\]\cr
#'  Whether displayed DOI code should be truncated to the first 18 characters.
#' 
#' @return A string vector of the same length as `doi` parameter, each element
#' being an `<a>` tag for respective DOI code.
#' 
#' @seealso \code{\link{citify}()}, \code{\link{linkify_uniprot}()}
#' 
#' @importFrom stringr str_trunc
linkify_doi <- function(doi, truncate = TRUE) {
  glue("<a href='https://doi.org/{doi}' target='_blank' rel='noopener noreferer'>{if (truncate) str_trunc(doi, 18) else doi}</a>")
}

#' Wrap UniProt ID in a link
#' 
#' @description Wraps UniProt ID code in a HTML clickable link to the respective
#' address on uniprot.org.
#' 
#' @param uniprot_id \[\code{character()}\]\cr
#'  UniProt IDs to use (as labels and links).
#' 
#' @return A string vector of the same length as `uniprot_id` parameter, each
#' element being an `<a>` tag for respective UniProt ID.
#' 
#' @seealso \code{\link{citify}()}, \code{\link{linkify_doi}()}
linkify_uniprot <- function(uniprot_id) {
  glue("<a href='https://uniprot.org/uniprot/{uniprot_id}' target='_blank' rel='noopener noreferer''>{uniprot_id}</a>")
}

#' Generate paper citation
#' 
#' @description This function formats paper reference data in a human-friendly
#' format, akin to one of those used in formatting citations.
#' 
#' @param reference \[\code{character matrix(1, )}\]\cr
#'  Paper citation data with the following columns: `all_names`, `title`,
#'  `journal`, `year`, and `doi`.
#' 
#' @return A single string with well-formatted citation.
#' 
#' @seealso \code{\link{linkify_doi}()}, \code{\link{linkify_uniprot}()}
#' 
#' @export
citify <- function(reference) {
  all_names <- reference[1, "all_names", drop = TRUE]
  title <- reference[1, "title", drop = TRUE]
  journal <- reference[1, "journal", drop = TRUE]
  year <- reference[1, "year", drop = TRUE]
  doi <- reference[1, "doi", drop = TRUE]
  glue("{all_names}, **{title}**, {journal} {year} (doi: {linkify_doi(doi, truncate = FALSE)})")
}
