#' @importFrom shinyhelper observe_helpers
#' @importFrom shiny isolate observe updateSelectInput
#' @importFrom shinyjs runjs
#' @importFrom glue glue
#' @importFrom dplyr cur_group_rows pull
#' @importFrom DT selectRows
ag_server <- function(ag_data) function(input, output) {
  observe_helpers(help_dir = "manuals")
  
  rvals <- reactiveValues(
    table_visited = FALSE,
    initally_selected = NULL
  )
  
  observeEvent(input[["tabset_panel"]], {
    if (input[["tabset_panel"]] == "table") rvals[["table_visited"]] <- TRUE
  })
  
  edges <- server_filter_control("filter_control", ag_data[["interactions"]], ag_data[["groups"]])
  subtables <- server_single_protein("single_protein", edges, ag_data[["nodes"]], ag_data[["proteins"]])
  # TODO: extract function call below as a separate function that takes
  #  edges and id as only arguments
  table_proxy <- server_table(
    "interactions_table",
    BUTTONS[c("SELECT_ALL", "DESELECT_ALL", "DOWNLOAD_CSV", "DOWNLOAD_XSLX")],
    edges,
    table_data_func = reactive_table_data,
    render_table_func = render_interactions_table,
    rvals = rvals,
    table_data = reactive(edges[["table"]])
  )
  
  server_single_interaction("single_interaction", ag_data[["interactions"]])
  server_db_statistics("db_statistics", ag_data[["interactions"]], ag_data[["nodes"]])
  
  output[["graph"]] <- render_network(ag_data[["nodes"]], edges)
  output[["ag_version"]] <- render_ag_version()
  
  observe_node_selection(input)
  observe_interaction_selection(input)
  observe_edges_change(input, edges)
  observe_moving_selection(input, subtables, edges, table_proxy, rvals)
}
