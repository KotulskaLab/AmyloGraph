#' @importFrom purrr imap
#' @importFrom shinyhelper helper
ui_filter_control <- function(id, data_groups) {
  ns <- NS(id)
  div(
    id = id,
    helper(
      selectInput(
        inputId = ns("label_group"),
        label = "Group edges by",
        choices = add_none(ag_group_labels(data_groups)),
        multiple = FALSE
      ),
      type = "markdown",
      content = "label_group"
    ),
    ui_motif_filter(ns("motif")),
    do.call(
      tagList,
      imap(
        ag_group_labels(data_groups),
        ~ filterCheckboxInput(
          ns(.x),
          ag_color_map(data_groups, .x)[["values"]],
          .y
        )
      )
    )
  )
}

#' @importFrom dplyr filter group_by summarize cur_group_id mutate select
#' @importFrom glue glue_collapse
#' @importFrom icecream ic
#' @importFrom purrr set_names map when walk
#' @importFrom rlang sym expr
#' @importFrom shinyjs toggleCssClass
server_filter_control <- function(id, data_interactions, data_groups) {
  moduleServer(id, function(input, output, session) {
    observe({
      walk(ag_group_labels(data_groups),
           ~ toggleCssClass(.x, "filter_checkbox_active",
                            input[["label_group"]] == .x))
    })
    
    motif <- server_motif_filter("motif")
    
    ret <- reactiveValues(
      table = NULL,
      graph = NULL,
      all = data_interactions
    )
    
    interactions_filtered_by_group <- reactive({
      data_interactions %>%
        filter(!!!map(
          ag_group_labels(data_groups) %>% set_names(NULL),
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
        mutate(color = ag_color_map(data_groups, label_group)[["colors"]][!!sym(label_group)]) %>%
        select(id, from = from_id, to = to_id, title, any_of(c("color", label_group)))
    })
    
    ret
  })
}