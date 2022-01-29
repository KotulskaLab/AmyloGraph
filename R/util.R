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


#' @importFrom glue glue
#' @importFrom stringr str_trunc
#' @export
citify <- function(reference_row) {
  all_names <- reference_row[1, "all_names", drop = TRUE]
  title <- reference_row[1, "title", drop = TRUE]
  journal <- reference_row[1, "journal", drop = TRUE]
  year <- reference_row[1, "year", drop = TRUE]
  doi <- reference_row[1, "doi", drop = TRUE]
  glue("{all_names}, **{title}**, {journal} {year} (doi: <a href='https://doi.org/{doi}' target='_blank' rel='noopener noreferer'>{doi}</a>)")
}


#' @importFrom glue glue
linkify_uniprot <- function(uniprot_id) {
  glue("<a href='https://uniprot.org/uniprot/{uniprot_id}' target='_blank' rel='noopener noreferer''>{uniprot_id}</a>")
}

#' @importFrom glue glue
#' @importFrom dplyr `%>%`
prettify_sequence_output <- \(sequence) {
  group_length <- 10
  seq_length <- glue("Sequence length: {nchar(sequence)}")
  indices <- seq(group_length, nchar(sequence), by = group_length) %>%
    format(width = 10) %>%
    paste0(collapse = " ")
  sequence_w_spaces <- gsub(glue("(.{{{group_length}}})"), "\\1 ", sequence)
  paste(seq_length, indices, sequence_w_spaces, sep = "\n")
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

#' @importFrom stringi stri_detect_regex
contains_motif <- \(sequences, motif) {
  stri_detect_regex(sequences, patternize_motif(motif))
}

pluralize <- \(value, plural = "s", singular = "") {
  ifelse(value == 1, singular, plural)
}

#' @importFrom glue glue
load_js_code <- \(name) {
  path <- system.file(c("inst", "js", glue("{name}.js")), package = "AmyloGraph")
  paste(readLines(glue("{path}/{name}.js")))
}
