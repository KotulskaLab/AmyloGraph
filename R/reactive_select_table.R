#' @importFrom shiny reactive
#' @importFrom dplyr select `%>%`
#' @importFrom icecream ic
reactive_interactions_table <- function(edges, ns) reactive({
  ic(edges[["table"]])
  edges[["table"]] %>% 
    mutate(doi = linkify_doi(doi),
           details = details_button(AGID, "interaction_detail", ns)) %>% 
    select(AGID,
           details,
           interactor_name,
           interactee_name,
           aggregation_speed,
           elongates_by_attaching,
           heterogenous_fibers,
           doi)
})