#' @importFrom htmltools div
#' @importFrom shinyhelper helper
#' @importFrom shiny selectInput NS uiOutput tabsetPanel tabPanel 
#' @importFrom DT dataTableOutput
#' @importFrom purrr set_names
#' @importFrom glue glue
nodeInfoUI <- function(id, node_data) {
  div(
    class = "ag-node-panel",
    helper(
      selectInput(
        inputId = NS(id, "select_node"),
        label = "Select node to display info about",
        #null value encoded as text, because NULL value cannot be an element of a vector 
        choices = c(none = ag_option("str_null"),
                    set_names(node_data[["id"]], node_data[["label"]])[order(node_data[["label"]])]),
        multiple = FALSE),
      type = "markdown",
      content = "label_group"),
    ifelsePanel(
      id = NS(id, "ifelse"),
      condition = glue("input.select_node == '{AmyloGraph:::ag_option('str_null')}'"),
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

#' @importFrom shiny moduleServer 
nodeInfoServer <- function(id, edge_data, node_data) {
  moduleServer(id, function(input, output, session) {
    selected_node_info <- reactive_selected_node_info(input, node_data)
    selected_node_label <- reactive_selected_node_label(selected_node_info)
    
    output[["info"]] <- render_protein_info(input, selected_node_label)
    output[["interactees"]] <- render_interactions_subtable(input, edge_data, from_id, interactee_name)
    output[["interactors"]] <- render_interactions_subtable(input, edge_data, to_id, interactor_name)
  })
}