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
  group_length <- ag_option("sequence_group_length")
  
  seq_length <- glue("Sequence length: {nchar(sequence)}")
  indices <- if (nchar(sequence) >= group_length) {
    seq(group_length, nchar(sequence), by = group_length) %>%
      format(width = group_length) %>%
      paste0(collapse = " ")
  } else {
    ""
  }
  sequence_w_spaces <- gsub(glue("(.{{{group_length}}})"), "\\1 ", sequence)
  
  ret <- paste(seq_length, indices, sequence_w_spaces, sep = "\n")
  if (!is.na(name)) {
    chain <- glue("Chain: {name}")
    ret <- paste(chain, ret, sep = "\n")
  }
  ret
}

#' Flush chain reader buffer
#' 
#' @description Move chain data (name and sequence) from buffer to result
#' storage.
#' 
#' @param reader \[\code{AG_sequence_reader(1)}\]\cr
#'  Sequence reader with buffer to empty.
#' 
#' @return `AG_sequence_reader` with empty buffer and additional sequence data.
#' 
#' @importFrom dplyr bind_rows
empty_buffer <- function(reader) {
  if (length(reader[["sequence"]] > 0)) {
    reader[["tbl"]] <- bind_rows(
      reader[["tbl"]],
      c(name = reader[["name"]], sequence = reader[["sequence"]])
    )
    reader[["name"]] <- character()
    reader[["sequence"]] <- character()
  }
  reader
}

#' Parse chain sequence data
#' 
#' @description Reads amino acid sequences and their corresponding names, if
#' available. The input should be either in FASTA format or a single sequence
#' without a name.
#' 
#' @param txt \[\code{character(1)}\]\cr
#'  Sequence data to parse.
#' @param separator \[\code{character(1)}\]\cr
#'  A character or string to split data into lines on.
#' 
#' @return A `tibble` with the following columns: `name` and `sequence`.
#' 
#' @importFrom dplyr tibble
read_chains <- function(txt, separator = ag_option("chain_separator")) {
  reader <- structure(
    list(
      name = character(),
      sequence = character(),
      tbl = tibble(name = character(), sequence = character())
    ),
    class = "AG_sequence_reader"
  )
  
  if (!is.na(txt)) {
    # If the sequences are provided as a single string
    txt <- strsplit(txt, separator)[[1]]
    
    for (line in txt) {
      if (substr(line, 1, 1) == ">") {
        # A new name was found
        reader <- empty_buffer(reader)
        reader[["name"]] <- trimws(substring(line, 2))
      } else {
        reader[["sequence"]] <- paste0(reader[["sequence"]], trimws(line))
      }
    }
    reader <- empty_buffer(reader)
  }
  reader[["tbl"]]
}
