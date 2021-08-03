#' @importFrom shiny reactive
#' @importFrom dplyr select `%>%`
reactive_select_table <- function(edges) reactive({
  edges[["table"]] %>% 
    mutate(doi = linkify_doi(doi)) %>% 
    select(AGID,
           interactor_name,
           interactee_name,
           aggregation_speed,
           elongates_by_attaching,
           heterogenous_fibers,
           doi)
})