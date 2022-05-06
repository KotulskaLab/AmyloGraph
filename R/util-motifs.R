#' Check motif correctness
#' 
#' @description Validates a motif against a regex.
#' 
#' @param motif \[\code{character(1)}\]\cr
#'  Motif to check.
#' 
#' @return A single logical value.
#' 
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
