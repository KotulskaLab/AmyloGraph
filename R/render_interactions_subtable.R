#' @importFrom DT renderDataTable
#' @importFrom dplyr `%>%` filter arrange select mutate
render_interactions_subtable <- function(input, edge_data, target_id, target_variable) {
  rendered_data <- reactive(
    edge_data[["node_info"]] %>%
      filter({{target_id}} == input[["select_node"]]) %>%
      arrange({{target_variable}}, doi) %>%
      mutate(doi = linkify_doi(doi),
             AGID = AGID_button(AGID)) %>%
      select(AGID, {{target_variable}}, doi)
  )
  renderDataTable(
    rendered_data(),
    options = list(
      dom = 'Brtip',
      pageLength = 10,
      lengthChange = FALSE,
      buttons = c("selectAll", "selectNone"),
      select = list(style = "multi+shift", items = "row")
    ),
    escape = FALSE,
    rownames = FALSE,
    colnames = ag_colnames(rendered_data()),
    extensions = c("Select", "Buttons"),
    selection = "none",
    server = FALSE
  )
}
