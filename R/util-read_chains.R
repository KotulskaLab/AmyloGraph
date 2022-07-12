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
