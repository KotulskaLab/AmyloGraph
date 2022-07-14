#' @importFrom purrr imap
#' @importFrom shinyhelper helper
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

#' @importFrom dplyr filter
#' @importFrom icecream ic
#' @importFrom purrr map walk
#' @importFrom rlang sym expr
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
    
    ret <- reactiveValues(
      table = NULL,
      graph = NULL
    )
    
    # TODO: rewrite the code using verb functions so that the result can be
    #  assigned to ret[["table"]] without intermediate variables
    interactions_filtered_by_group <- reactive({
      ag_data_interactions %>%
        filter(!!!map(
          unname(ag_data_group_labels),
          ~ expr(!!sym(.) %in% !!input[[.]]))
        )
    })
    
    interactions_filtered_by_motif <- reactive({
      if (is_valid(motif()) && nchar(motif()) > 0) {
        interactions_filtered_by_group() %>%
          filter(contains_motif(interactor_sequence, motif()) |
                   contains_motif(interactee_sequence, motif()))
      } else {
        interactions_filtered_by_group()
      }
    })
    
    observe({
      ret[["table"]] <- ic(interactions_filtered_by_motif())
    })
    
    graph_data <- reactive_graph_data(reactive(ret[["table"]]), group)
    
    observe({
      ret[["graph"]] <- graph_data()
    })
    
    ret
  })
}
