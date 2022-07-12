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
#' 
#' @importFrom purrr pluck map2
#' @importFrom stringi stri_extract_all_regex stri_join_list
prettify_sequence_output <- function(name, sequence) {
  line_length <- ag_option("sequence_line_length")
  group_length <- ag_option("sequence_group_length")
  seq_length <- nchar(sequence)
  
  # A vector with as many elements as there are lines
  ret_sequence <- sequence %>%
    stri_extract_all_regex(glue(".{{1,{line_length}}}")) %>%
    pluck(1) %>%
    stri_extract_all_regex(glue(".{{1,{group_length}}}")) %>%
    stri_join_list(sep = " ")
  
  ret_indices <- if (seq_length >= group_length) {
    indices_from <- seq(group_length, seq_length, by = line_length)
    indices_to <- seq_length
    if (seq_length >= line_length) {
      indices_to <- c(seq(line_length, seq_length, by = line_length), indices_to)
    }
    if (length(indices_from) < length(indices_to)) {
      indices_from <- c(indices_from, Inf)
    }
    indices <- map2(indices_from, indices_to, ~ {
      if (.x < .y) {
        seq(.x, .y, by = group_length) %>%
          format(width = group_length)
      } else {
        ""
      }
    })
    stri_join_list(indices, sep = " ")
  } else {
    ""
  }
  
  ret <- paste(ret_indices, ret_sequence, sep = "\n", collapse = "\n")
  ret <- glue("Sequence length: {seq_length}\n{ret}")
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
  if (!grepl(separator, txt)) {
    return(tibble(
      name = NA,
      sequence = txt
    ))
  }
  
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

#' Revert chain tibbles to strings
#' 
#' @description Deparses chain data tibbles back to strings, depending on the
#' structure of the tibble; plain sequence if there's only one row and `name`
#' column is `NA`, a FASTA-like format otherwise.
#' 
#' @param tbl_sq \[\code{tibble()}\]\cr
#'  Sequence data for one protein.
#' @param separator \[\code{character(1)}\]\cr
#'  A character or string to join lines of data with.
#' 
#' @return A character vector with FASTA-like entries or plain sequences.
#' 
#' @importFrom glue glue_collapse glue_data
deparse_chains <- function(tbl_sq, separator = ag_option("chain_separator")) {
  if (nrow(tbl_sq) == 0) {
    ""
  } else if (nrow(tbl_sq) == 1 && is.na(tbl_sq[["name"]])) {
    tbl_sq[["sequence"]]
  } else {
    glue_collapse(
      glue_data(tbl_sq, ">{name}{separator}{sequence}"),
      sep = separator
    )
  }
}
