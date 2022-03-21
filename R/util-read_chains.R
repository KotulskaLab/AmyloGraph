#' @importFrom dplyr `%>%` rowwise summarize pull
prettify_chains <- \(sequence) {
  if (is.na(sequence)) {
    "no sequence available"
  } else {
    read_chains(sequence) %>%
      rowwise() %>%
      summarize(seq_output = prettify_sequence_output(name, sequence)) %>%
      pull(seq_output) %>%
      paste0(collapse = "\n\n")
  }
}

#' @importFrom glue glue
#' @importFrom dplyr `%>%`
prettify_sequence_output <- \(name, sequence) {
  group_length <- 10
  seq_length <- glue("Sequence length: {nchar(sequence)}")
  indices <- if (nchar(sequence) >= 10) {
    seq(group_length, nchar(sequence), by = group_length) %>%
      format(width = 10) %>%
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

#' @importFrom tibble tibble
read_chains <- function(txt) {
  # If the sequences are provided as a single string
  txt <- strsplit(txt, "\n")[[1]]
  
  reader <- structure(
    list(
      name = character(),
      sequence = character(),
      tbl = tibble(name = character(), sequence = character())
    ),
    class = "AG_sequence_reader"
  )
  
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
  reader[["tbl"]]
}
