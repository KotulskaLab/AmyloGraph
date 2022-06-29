#' @importFrom purrr imap
#' @importFrom shinyhelper helper
ui_filter_control <- function(id, data_groups) {
  div(
    id = "filter_control",
    helper(
      selectInput(
        inputId = NS(id, "label_group"),
        label = "Group edges by",
        choices = add_none(ag_group_labels(data_groups)),
        multiple = FALSE
      ),
      type = "markdown",
      content = "label_group"
    ),
    do.call(
      tagList,
      imap(
        ag_group_labels(data_groups),
        ~ filterCheckboxInput(
          NS(id, .x),
          ag_color_map(data_groups, .x)[["values"]],
          .y
        )
      )
    ),
    uiOutput(outputId = NS(id, "incorrect_motif_message")),
    helper(
      textInput(NS(id, "motif"), "Filter by motif", placeholder = "^LXXA"),
      type = "markdown",
      content = "motif"
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
    
    is_motif_correct <- reactive({
      correct_motif(input[["motif"]])
    })
    
    interactions_filtered_by_motif <- reactive({
      if (is_motif_correct() && nchar(input[["motif"]]) > 0) {
        interactions_filtered_by_group() %>%
          filter(contains_motif(interactor_sequence, input[["motif"]]) |
                   contains_motif(interactee_sequence, input[["motif"]]))
      } else {
        interactions_filtered_by_group()
      }
    })
    
    output[["incorrect_motif_message"]] <- renderUI({
      if (is_motif_correct()) HTML("") else HTML("Incorrect motif provided!")
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