source("R/ifelsePanel.R")
source("R/random_description.R")

nodeInfoUI <- function(id, node_data) {
  div(
    class = "ag-node-panel",
    helper(
      selectInput(
        inputId = NS(id, "select_node"),
        label = "Select node to display info about",
        #null value encoded as text, becase NULL value cannot be an element of a vector 
        choices = c(none = STR_NULL, set_names(node_data[["id"]], node_data[["label"]])),
        multiple = FALSE),
      type = "markdown",
      content = "label_group"),
    ifelsePanel(
      id = NS(id, "ifelse"),
      condition = glue("input.select_node == '{STR_NULL}'"),
      content_true = div(
        class = "ag-node-info",
        "select node to display info about it and interactions associated with it"
      ),
      content_false = div(
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
        )
      ),
      ns = NS(id)
    )
  )
}

nodeInfoServer <- function(id, edge_data, node_data) {
  moduleServer(id, function(input, output, session) {
    selected_node_info <- reactive({
      req(input[["select_node"]])
      node_data %>%
        filter(id == input[["select_node"]])
    })
    
    selected_node_label <- reactive({
      selected_node_info()[["label"]]
    })
    
    output[["info"]] <- renderUI({
      req(input[["select_node"]])
      HTML(random_description(selected_node_label()))
    })
    
    renderInteractionTable <- function(target_id, target_variable) {
      renderDataTable({
        req(input[["select_node"]])
        edge_data[["node_info"]] %>%
          filter({{target_id}} == input[["select_node"]]) %>%
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