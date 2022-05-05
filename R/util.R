#' Extract AmyloGraph option
#' 
#' @description This function accesses the current value of a selected
#' AmyloGraph option.
#' 
#' @param option \[\code{character(1)}\]\cr
#'  Option name without leading `"ag-"`.
#' 
#' @details
#' The currently available options are:
#' \itemize{
#'   \item `str_null`
#'   \item `palette`
#'   \item `side_panel_width`
#'   \item `main_panel_width`
#'   \item `colnames`
#'   \item `interaction_attrs`
#'   \item `center_network`
#'   \item `sequence_group_length`
#'   \item `chain_separator`
#' }
#' 
#' @return Option value.
#' 
#' @importFrom glue glue
ag_option <- function(option) {
  getOption(glue("ag_{option}"))
}

#' Find AmyloGraph column names in data
#' 
#' @description Filters column names of a data frame or matrix which fulfill
#' a custom role in AmyloGraph, like "interactor name".
#' 
#' @param data \[\code{data.frame()}\]\cr
#'  Data, which column names are to be filtered.
#' 
#' @return A string vector with filtered column names.
#' 
#' @importFrom purrr keep
ag_colnames <- function(data) {
  keep(ag_option("colnames"), ~ .x %in% colnames(data))
}

is_node_selected <- function(id) {
  length(id) != 0 && id != ag_option("str_null")
}

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
#' @importFrom glue glue
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
#' 
#' @importFrom glue glue
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
#' @importFrom glue glue
#' @export
citify <- function(reference) {
  all_names <- reference[1, "all_names", drop = TRUE]
  title <- reference[1, "title", drop = TRUE]
  journal <- reference[1, "journal", drop = TRUE]
  year <- reference[1, "year", drop = TRUE]
  doi <- reference[1, "doi", drop = TRUE]
  glue("{all_names}, **{title}**, {journal} {year} (doi: {linkify_doi(doi, truncate = FALSE)})")
}


#' @importFrom stringi stri_detect_regex
correct_motif <- \(motif) {
  stri_detect_regex(motif, "^\\^?[ABCDEFGHIJKLMNOPQRSTUVWXYZ\\*]*\\$?$")
}

#' @importFrom stringi stri_replace_all_regex
patternize_motif <- \(motif) {
  stri_replace_all_regex(motif, 
                         c("B", "J", "Z", "X", "\\*"),
                         c("[BDN]", "[JIL]", "[ZEQ]", "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]", ".*"),
                         vectorise_all = FALSE)
}

#' @importFrom purrr map_lgl some
#' @importFrom stringi stri_detect_regex
contains_motif <- \(sequences, motif) {
  motif <- patternize_motif(motif)
  map_lgl(sequences, ~ some(.x[["sequence"]], stri_detect_regex, motif))
}

#' Return plural or singular form
#' 
#' @description Returns a plural or singular form depending on whether `value`
#' is equal 1. By default it returns plural suffix "-s" or singular empty
#' suffix.
#' 
#' @param value \[\code{numeric()}\]\cr
#'  Values to check for equality to 1.
#' @param plural \[\code{character(1)}\]\cr
#'  String to return if equality not satisfied.
#' @param singular \[\code{character(1)}\]\cr
#'  String to return if equality satisfied.
#' 
#' @return A vector of plural/singular values of the same length as `value`
#' parameter.
pluralize <- function(value, plural = "s", singular = "") {
  ifelse(value == 1, singular, plural)
}

#' Read JavaScript code from file
#' 
#' @description Reads JS code from `inst/js` folder inside AmyloGraph package.
#' 
#' @param name \[\code{character(1)}\]\cr
#'  File name without .js extension.
#' 
#' @return A single string with JavaScript code extracted from the file.
#' 
#' @importFrom glue glue
load_js_code <- function(name) {
  path <- system.file(c("inst", "js", glue("{name}.js")), package = "AmyloGraph")
  paste(readLines(glue("{path}/{name}.js")))
}
