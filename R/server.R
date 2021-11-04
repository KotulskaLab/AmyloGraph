#' @importFrom shinyhelper observe_helpers
#' @importFrom shiny isolate observe updateSelectInput
#' @importFrom shinyjs runjs
#' @importFrom glue glue
#' @importFrom dplyr cur_group_rows pull
#' @importFrom DT selectRows
ag_server <- function(ag_data) function(input, output) {
  observe_helpers(help_dir = "manuals")
  
  edges <- server_filter_control("filter_control", ag_data[["interactions"]], ag_data[["groups"]])
  subtables <- server_single_protein("single_protein", edges, ag_data[["nodes"]])
  table_proxy <- server_interactions_table("interactions_table", edges)
  
  server_single_interaction("single_interaction", ag_data[["interactions"]])
  server_db_statistics("db_statistics", ag_data[["interactions"]], ag_data[["nodes"]])
  
  output[["graph"]] <- render_network(ag_data[["nodes"]], edges)
  output[["ag_version"]] <- render_ag_version()
  
  observe_node_selection(input)
  observe_interaction_selection(input)
  observe_edges_change(input, edges)
  
  observeEvent(
    input[[NS("single_protein", "select_in_table")]],
    {
      ns <- NS("single_protein")
      if (input[[ns("select_in_table")]] > 0) {
        interactees_rows_selected <- input[[ns("interactees_rows_selected")]]
        interactors_rows_selected <- input[[ns("interactors_rows_selected")]]
        
        indices <- unique(c(
          subtables[["interactees"]]()[interactees_rows_selected, "original_AGID", drop = TRUE],
          subtables[["interactors"]]()[interactors_rows_selected, "original_AGID", drop = TRUE]
        ))
        
        new_selection <-
          edges[["table"]] %>%
          mutate(rownr = cur_group_rows()) %>%
          filter(AGID %in% indices) %>%
          pull(rownr) 
        
        table_proxy %>%
          selectRows(new_selection)
        
        updateTabsetPanel(inputId = "tabset_panel",
                          selected = "table")
      }
    })
}
