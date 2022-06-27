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
