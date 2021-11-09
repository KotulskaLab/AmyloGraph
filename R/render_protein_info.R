#' @importFrom shiny renderText req HTML
#' @importFrom dplyr `%>%` filter
#' @importFrom glue glue_data
render_protein_info <- \(protein_data, selected_node_label) renderText({
  req(selected_node_label())
  filtered_data <- protein_data %>%
    filter(name == selected_node_label())
  c(
    glue("{nrow(filtered_data)} source{ifelse(nrow(filtered_data) == 1, '', 's')} found:<br>"),
    filtered_data %>%
      glue_data("<b>{source}</b>: {linkify_uniprot(uniprot_id)}<br>")
  )
})