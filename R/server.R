#' @importFrom shinyhelper observe_helpers
ag_server <- function() function(input, output) {
  observe_helpers(help_dir = "manuals")
  
  tabs_visited <- reactiveValues(
    graph = FALSE,
    table = FALSE
  )
  
  initial_selection <- reactiveVal(NULL)
  
  observe_tab_visited(tabs_visited, reactive({ input[["tabset_panel"]] }))
  
  edges <- server_filter_control("filter_control")
  subtables <- server_single_protein("single_protein", edges)
  # TODO: extract function call below as a separate function that takes
  #  edges and id as only arguments
  table_proxy <- server_table(
    "interactions_table",
    BUTTONS[c("SELECT_ALL", "DESELECT_ALL", "DOWNLOAD_CSV", "DOWNLOAD_XLSX")],
    edges,
    table_data_func = reactive_table_data,
    render_table_func = render_interactions_table,
    selection_config = reactive_selection_config(tabs_visited, initial_selection),
    table_data = reactive(edges[["table"]])
  )
  
  server_single_interaction("single_interaction")
  server_db_statistics("db_statistics")
  server_about("about")
  
  output[["graph"]] <- render_network(edges)
  observe_graph_buttons(input, output, tabs_visited, edges)
  
  observe_node_selection(input)
  observe_interaction_selection(input)
  observe_edges_change(input, edges)
  observe_moving_selection(
    input, subtables, edges, table_proxy, tabs_visited, initial_selection
  )
}
