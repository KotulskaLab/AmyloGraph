#' Present chains in human-friendly format
#' 
#' @description Converts a tibble with sequence data for chains of a protein to
#' a human-readable string. If tibble is empty, returns `"no sequence available"`
#' instead.
#' 
#' @param tbl_sq \[\code{data.frame()}\]\cr
#'  Sequence data for one protein, a result of a call to
#'  \code{\link{read_chains}()}.
#' 
#' @return A single string, possibly with multiple lines.
#' 
#' @importFrom dplyr rowwise summarize pull
prettify_chains <- function(tbl_sq) {
  if (nrow(tbl_sq) == 0) {
    "no sequence available"
  } else {
    rowwise(tbl_sq) %>%
      summarize(seq_output = prettify_sequence_output(name, sequence)) %>%
      pull(seq_output) %>%
      paste0(collapse = "\n\n")
  }
}

#' Present sequence in human-friendly format
#' 
#' @description Displays a sequence in a line in group of 10 (by default,
#' configurable with `sequence_group_length` AG option), each group numbered.
#' Prepends it with sequence length and chain name, if applicable.
#' 
#' @param name \[\code{character(1)}\]\cr
#'  Chain name. If not applicable, use `NA`.
#' @param sequence \[\code{character(1)}\]\cr
#'  Amino acid sequence.
#' 
#' @return A single string with multiple lines (probably 3 or 4).
prettify_sequence_output <- function(name, sequence) {
  ret_sequence <- sequence_to_lines(sequence)
  ret_indices <- sequence_indices(sequence)
  
  paste(ret_indices, ret_sequence, sep = "\n", collapse = "\n") %>%
    add_sequence_info(nchar(sequence), name)
}

#' Split sequence into lines
#' 
#' @description Splits sequence into lines of indicated length (by default 80)
#' and adds spaces between groups (by default 10 characters). To be used with
#' indices preferably.
#' 
#' @param sequence \[\code{character(1)}\]\cr
#'  A single string with sequence to split into lines.
#' 
#' @return A vector of strings, each element being its own line.
#' 
#' @importFrom purrr pluck
#' @importFrom stringi stri_extract_all_regex stri_join_list
sequence_to_lines <- function(sequence) {
  line_length <- ag_option("sequence_line_length")
  group_length <- ag_option("sequence_group_length")
  
  sequence %>%
    stri_extract_all_regex(glue(".{{1,{line_length}}}")) %>%
    pluck(1) %>%
    stri_extract_all_regex(glue(".{{1,{group_length}}}")) %>%
    stri_join_list(sep = " ")
}

#' Index along a sequence
#' 
#' @description Creates a vector of indices to use along with a sequence.
#' 
#' @param sequence \[\code{character(1)}\]\cr
#'  A single string with sequence to index.
#' 
#' @return A vector of strings, each containing several padded indices to be
#' used as a single line.
#' 
#' @importFrom purrr map2
#' @importFrom stringi stri_join_list
sequence_indices <- function(sequence) {
  line_length <- ag_option("sequence_line_length")
  group_length <- ag_option("sequence_group_length")
  seq_length <- nchar(sequence)
  
  indices_from <- safe_seq(group_length, seq_length, by = line_length)
  indices_to <- c(safe_seq(line_length, seq_length, by = line_length), seq_length)
  
  if (length(indices_from) < length(indices_to)) {
    indices_from <- c(indices_from, Inf)
  }
  
  map2(indices_from, indices_to, index_line, by = group_length) %>%
    stri_join_list(sep = " ")
}

#' Add sequence info
#' 
#' @description Prepends the sequence and indices with sequence length and chain
#' name (if applicable).
#' 
#' @param content \[\code{character(1)}\]\cr
#'  Sequence with indices and newlines.
#' @param seq_length \[\code{integer(1)}\]\cr
#'  Length of the sequence.
#' @param name \[\code{character(1)}\]\cr
#'  Chain name, may be `NA` if not applicable.
#' 
#' @return A single string with all info prepended and separated with newlines.
add_sequence_info <- function(content, seq_length, name) {
  chain <- if (!is.na(name)) paste("Chain:", name, "\n") else NULL
  length <- paste("Sequence length:", seq_length, "\n")
  glue("{chain}{length}{content}", .null = NULL)
}

#' Create a line of indices
#' 
#' @description Creates a vector of left-padded strings with indices in the
#' indicated range.
#' 
#' @param from \[\code{integer(1)}\]\cr
#'  First element of a sequence.
#' @param to \[\code{integer(1)}\]\cr
#'  Last element of a sequence.
#' @param by \[\code{integer(1)}\]\cr
#'  Size of a group and padding length.
#' 
#' @return A vector of strings, each element being a number left-padded with
#' spaces.
index_line <- function(from, to, by) {
  if (from > to) {
    # Return empty character if no indices to be created
    return("")
  }
  
  seq(from, to, by = by) %>%
    format(width = by)
}

#' Safely create a sequence of numbers
#' 
#' @description Wraps `base::seq()` with a safeguard that returns an empty
#' vector if sequence cannot be created.
#' 
#' @param from \[\code{numeric(1)}\]\cr
#'  First element of a sequence.
#' @param to \[\code{numeric(1)}\]\cr
#'  Upper limit of a sequence.
#' @param ... \cr
#'  Arguments passed to \code{\link[base]{seq}()}.
#' 
#' @return A vector of numbers.
safe_seq <- function(from, to, ...) {
  if (from > to) {
    # Return empty integer vector if sequence cannot be created
    return(integer())
  }
  
  seq(from, to, ...)
}
