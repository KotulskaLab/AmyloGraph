elem_app_main_panel <- \(data_nodes) fillCol(
  tabsetPanel(
    id = "tabset_panel",
    type = "pills",
    elem_tab_interactions_graph(data_nodes),
    elem_tab_interactions_table(),
    elem_tab_single_interaction(),
    elem_tab_db_statistics(),
    elem_tab_about()
  ),
  id = "main_panel"
)

elem_tab_interactions_graph <- \(data_nodes) tabPanel(
  title = "Graph",
  value = "graph",
  div(
    id = "tab_interactions_graph",
    elem_panel_interactions_graph(),
    elem_panel_single_protein(data_nodes)
  )
)

elem_panel_interactions_graph <- \() div(
  id = "panel_interactions_graph",
  visNetworkOutput("graph", height = "calc(100% - 10px)", width = "100%")
)

elem_panel_single_protein <- \(data_nodes) ui_single_protein("single_protein", data_nodes)

elem_tab_interactions_table <- \() tabPanel(
  title = "Table",
  value = "table",
  ui_interactions_table("interactions_table")
)

#' @importFrom glue glue
elem_tab_single_interaction <- \() tabPanel(
  title = "Interaction",
  value = "single_interaction",
  actionButton(
    inputId = "btn_close_tab",
    label = "Close",
    onclick = glue("Shiny.setInputValue('{NS('single_interaction', 'selected_interaction')}', null)")
  ),
  ui_single_interaction("single_interaction")
)

elem_tab_db_statistics <- \() tabPanel(
  title = "Database statistics",
  value = "db_statistics",
  ui_db_statistics("db_statistics")
)

elem_tab_about <- \() tabPanel(
  title = "About",
  value = "about",
  textOutput("ag_version"),
  includeMarkdown("manuals/about.md")
)
