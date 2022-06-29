#' @title Render list of protein sources
#' 
#' @description This function generates a list of source organisms with their
#' UniProt IDs for a given protein. UniProt IDs contain links to UniProt site. 
#' 
#' @param selected_node_label \[\code{reactive(character(1))}\]\cr
#'  A label (i.e. human-readable name) of a protein currently selected on the
#'  graph.
#' @param protein_data \[\code{data.frame}\]\cr
#'  A list of source organisms and their UniProt IDs for all proteins in the
#'  database.
#' 
#' @return A \code{renderText} object.
#'
#' @importFrom dplyr filter
#' @importFrom glue glue_data
render_protein_info <- \(selected_node_label, protein_data) renderText({
  req(selected_node_label())
  filtered_data <- protein_data %>%
    filter(name == selected_node_label())
  c(
    glue("{nrow(filtered_data)} source{pluralize(nrow(filtered_data))} found in UniProt:<br>"),
    filtered_data %>%
      glue_data("<b>{source}</b>: {linkify_uniprot(uniprot_id)}<br>")
  )
})