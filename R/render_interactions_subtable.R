#' @importFrom DT renderDataTable
#' @importFrom dplyr `%>%` filter arrange select mutate
render_interactions_subtable <- function(input, edge_data, target_id, target_variable) {
  renderDataTable({
    edge_data[["node_info"]] %>%
      filter({{target_id}} == input[["select_node"]]) %>%
      arrange({{target_variable}}, doi) %>%
      mutate(doi = linkify_doi(doi)) %>%
      select(AGID, {{target_variable}}, doi)
  }, options = list(
    pageLength = 10,
    lengthChange = FALSE
  ),
  escape = FALSE
  )
}
