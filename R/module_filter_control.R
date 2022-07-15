#' @importFrom purrr imap
ui_filter_control <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    ui_group_edges(ns("group_edges")),
    ui_motif_filter(ns("motif")),
    do.call(
      tagList,
      imap(
        ag_data_group_labels,
        ~ filterCheckboxInput(
          ns(.x),
          ag_data_attribute_values[[.x]],
          .y
        )
      )
    )
  )
}

#' @importFrom purrr walk
#' @importFrom shinyjs toggleCssClass
server_filter_control <- function(id) {
  moduleServer(id, function(input, output, session) {
    group <- server_group_edges("group_edges")
    motif <- server_motif_filter("motif")
    
    # TODO: extract as observer
    observe({
      walk(ag_data_group_labels,
           ~ toggleCssClass(.x, "filter_checkbox_active",
                            group() == .x))
    })
    
    base_data <- reactive_base_data(input, motif)
    graph_data <- reactive_graph_data(base_data, group)
    
    # TODO: return list of reactives instead and extract them using %<-% or sth
    ret <- reactiveValues(
      table = NULL,
      graph = NULL
    )
    
    observe({
      ret[["table"]] <- base_data()
      ret[["graph"]] <- graph_data()
    })
    
    ret
  })
}
