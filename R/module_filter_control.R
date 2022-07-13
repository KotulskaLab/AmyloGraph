#' @importFrom purrr imap
#' @importFrom shinyhelper helper
ui_filter_control <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    helper(
      selectInput(
        inputId = ns("label_group"),
        label = "Group edges by",
        choices = add_none(ag_data_group_labels),
        multiple = FALSE
      ),
      type = "markdown",
      content = "label_group"
    ),
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

#' @importFrom dplyr filter group_by summarize cur_group_id mutate select
#' @importFrom glue glue_collapse
#' @importFrom icecream ic
#' @importFrom purrr map when walk
#' @importFrom rlang sym expr
#' @importFrom shinyjs toggleCssClass
server_filter_control <- function(id) {
  moduleServer(id, function(input, output, session) {
    observe({
      walk(ag_data_group_labels,
           ~ toggleCssClass(.x, "filter_checkbox_active",
                            input[["label_group"]] == .x))
    })
    
    motif <- server_motif_filter("motif")
    
    ret <- reactiveValues(
      table = NULL,
      graph = NULL
    )
    
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
    
    observe({
      label_group <- input[["label_group"]] %>%
        when(
          . == ag_option("str_null") ~ "",
          ~ .
        )
      
      ret[["graph"]] <- ret[["table"]] %>%
        group_by(to_id, from_id, !!sym(label_group)) %>%
        summarize(
          title = glue_collapse(unique(doi), sep = ", ", last = " and "),
          id = cur_group_id(),
          .groups = "drop") %>% 
        mutate(color = ag_data_color_map[[label_group]][!!sym(label_group)]) %>%
        select(id, from = from_id, to = to_id, title, any_of(c("color", label_group)))
    })
    
    ret
  })
}