source("R/random_description.R")

nodeInfoUI <- function(id) {
  div(
    class = "ag-node-panel",
    conditionalPanel(
      id = "conditional_node_panel",
      condition = "input.selected_node != null",
      div(
        class = "ag-node-info",
        uiOutput(NS(id, "info")),
        tabsetPanel(
          id = NS(id, "tabs"),
          tabPanel(
            title = "Interactees",
            dataTableOutput(NS(id, "interactees"))),
          tabPanel(
            title = "Interactors",
            dataTableOutput(NS(id, "interactors")))
        ))),
    conditionalPanel(
      condition = "input.selected_node == null",
      div(
        class = "ag-node-info",
        "select node to display info about it and interactions associated with it"))
  )
}

nodeInfoServer <- function(id, edge_data, node_data, selected_node_id) {
  moduleServer(id, function(input, output, session) {
    selected_node_info <- reactive({
      req(selected_node_id())
      node_data %>%
        filter(id == selected_node_id())
    })
    
    selected_node_label <- reactive({
      selected_node_info()[["label"]]
    })
    
    output[["info"]] <- renderUI({
      req(selected_node_id())
      HTML(random_description(selected_node_label()))
    })
    
    renderInteractionTable <- function(target_id, target_variable) {
      renderDataTable({
        req(selected_node_id())
        edge_data()[["table"]] %>%
          filter({{target_id}} == selected_node_id()) %>%
          arrange({{target_variable}}, doi) %>%
          select({{target_variable}}, doi, aggregation_speed, elongates_by_attaching, heterogenous_fibers)
      }, options = list(
        pageLength = 10,
        lengthChange = FALSE
      ))
    }
    
    output[["interactees"]] <- renderInteractionTable(from_id, interactee_name)
    
    output[["interactors"]] <- renderInteractionTable(to_id, interactor_name)
  })
}