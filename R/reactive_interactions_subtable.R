#' @importFrom shiny reactive
#' @importFrom dplyr select `%>%`
#' @importFrom icecream ic
reactive_interactions_subtable <- function(input, edge_data, target_id, target_variable) reactive({
  (if (input[["ignore_filters"]]) edge_data[["all"]]
   else edge_data[["table"]]) %>%
    filter({{target_id}} == input[["select_node"]]) %>%
    arrange({{target_variable}}, doi) %>%
    mutate(doi = linkify_doi(doi),
           original_AGID = AGID,
           AGID = AGID_button(AGID)) %>%
    select(AGID, {{target_variable}}, doi, original_AGID)
  # original_AGID must be last for column invisibility to work correctly
})