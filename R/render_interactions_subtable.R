#' @importFrom DT renderDataTable
#' @importFrom dplyr `%>%` filter arrange select mutate
render_interactions_subtable <- function(input, edge_data, target_id, target_variable) {
  rendered_data <- reactive(
    edge_data[["node_info"]] %>%
      filter({{target_id}} == input[["select_node"]]) %>%
      arrange({{target_variable}}, doi) %>%
      mutate(doi = linkify_doi(doi),
             details = details_button(AGID)) %>%
      select(AGID, details, {{target_variable}}, doi)
  )
  renderDataTable(
    rendered_data(),
    options = list(
      pageLength = 10,
      lengthChange = FALSE
    ),
    escape = FALSE,
    rownames = FALSE,
    colnames = ag_colnames(rendered_data())
  )
}
