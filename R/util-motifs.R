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
correct_motif <- function(motif) {
  stri_detect_regex(motif, "^(\\^?[ABCDEFGHIJKLMNOPQRSTUVWXYZ\\*]+\\$?)?$")
}

#' Upgrade motif to detect ambiguous letters
#' 
#' @description Replaces ambiguous letters (`B`, `J`, `Z`, `X`, and `*`) with
#' a set of characters (e.g. `B` with `[BDN]`).
#' 
#' @param motif \[\code{character(1)}\]\cr
#'  Motif to patternize.
#' 
#' @return A single string with regex-ready motif.
#' 
#' @importFrom stringi stri_replace_all_regex
patternize_motif <- function(motif) {
  stri_replace_all_regex(motif, 
                         c("B", "J", "Z", "X", "\\*"),
                         c("[BDN]", "[JIL]", "[ZEQ]", "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]", ".*"),
                         vectorise_all = FALSE)
}

#' Check whether sequences fit motif
#' 
#' @description Compare each sequence against a motif. Motif is patternized
#' before making comparisons.
#' 
#' @param sequences \[\code{list()}\]\cr
#'  Sequences to check, each element being a `tibble` with `name` and `sequence`
#'  columns.
#' @param motif \[\code{character(1)}\]\cr
#'  Motif to look for in sequences.
#' 
#' @return A logical vector of the same length as `sequences` vector, each
#' element showing whether a motif was found in a sequence.
#' 
#' @importFrom purrr map_lgl some
#' @importFrom stringi stri_detect_regex
contains_motif <- function(sequences, motif) {
  motif <- patternize_motif(motif)
  map_lgl(sequences, ~ some(.x[["sequence"]], stri_detect_regex, motif))
}
