#' @importFrom shiny reactive
#' @importFrom dplyr select `%>%`
#' @importFrom icecream ic
reactive_table_data <- function(edges, ns)
  reactive({
    ic(edges[["table"]]) %>% 
      mutate(doi = linkify_doi(doi),
             original_AGID = AGID,
             AGID = AGID_button(AGID, "interaction_detail", ns)) %>% 
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

#' @importFrom shiny reactive
#' @importFrom dplyr select `%>%`
#' @importFrom icecream ic
reactive_subtable_data <- function(edges, ns, input, target_id, target_variable)
  reactive({
    (if (input[["ignore_filters"]]) edges[["all"]] else edges[["table"]]) %>%
      filter({{target_id}} == input[["select_node"]]) %>%
      arrange({{target_variable}}, doi) %>%
      mutate(doi = linkify_doi(doi),
             original_AGID = AGID,
             AGID = AGID_button(AGID, "interaction_detail", ns)) %>%
      select(AGID, {{target_variable}}, doi, original_AGID)
    # original_AGID must be last for column invisibility to work correctly
  })