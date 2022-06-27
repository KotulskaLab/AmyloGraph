#' Build table data
#' 
#' @description Mutates filtered interaction data to contain DOI links and
#' clickable AGIDs; then selects only columns that are displayed in the main
#' table.
#' 
#' @param edges \[\code{reactivevalues()}\]\cr
#'  AmyloGraph data with "table" element.
#' @param ns \[code{function()}\]\cr
#'  Namespace function to use for AGID buttons.
#' 
#' @return A \code{reactive} object with a \code{tibble} containing filtered
#' interaction data. 
#' 
#' @importFrom shiny reactive
#' @importFrom dplyr mutate select `%>%`
#' @importFrom icecream ic
reactive_table_data <- function(edges, ns) {
  reactive({
    ic(edges[["table"]]) %>% 
      mutate(doi = linkify_doi(doi),
             original_AGID = AGID,
             AGID = AGID_button(AGID, ns)) %>% 
      select(AGID,
             interactor_name,
             interactee_name,
             aggregation_speed,
             elongates_by_attaching,
             heterogenous_fibers,
             doi,
             original_AGID)
    # original_AGID must be last for column invisibility to work correctly
  })
}

#' @importFrom shiny reactive
#' @importFrom dplyr filter arrange mutate select `%>%`
reactive_subtable_data <- function(edges, ns, input, target_id, target_variable) {
  reactive({
    (if (input[["ignore_filters"]]) edges[["all"]] else edges[["table"]]) %>%
      filter({{target_id}} == input[["select_node"]]) %>%
      arrange({{target_variable}}, doi) %>%
      mutate(doi = linkify_doi(doi),
             original_AGID = AGID,
             AGID = AGID_button(AGID, ns)) %>%
      select(AGID, {{target_variable}}, doi, original_AGID)
    # original_AGID must be last for column invisibility to work correctly
  })
}
