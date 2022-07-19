#' Build table data
#' 
#' @description Mutates filtered interaction data to contain DOI links and
#' clickable AGIDs; then selects only columns that are displayed in the main
#' table.
#' 
#' @param edges \[\code{reactivevalues()}\]\cr
#'  AmyloGraph data with "table" element.
#' @param ns \[code{function(1)}\]\cr
#'  Namespace function to use for AGID buttons.
#' 
#' @return A \code{reactive} object with a \code{tibble} containing filtered
#' interaction data.
#' 
#' @importFrom dplyr mutate select
#' @importFrom icecream ic
reactive_table_data <- function(edges, ns) {
  reactive({
    ic(edges[["table"]]) %>% 
      mutate(doi = linkify_doi(doi)) %>% 
      # TODO: change other code to avoid AGID = AGID_button & original_AGID = AGID
      select(AGID = AGID_button,
             interactor_name,
             interactee_name,
             aggregation_speed,
             elongates_by_attaching,
             heterogenous_fibers,
             doi,
             original_AGID = AGID)
  })
}

#' Build table data for single protein
#' 
#' @description Mutates filtered interaction data for a single selected protein
#' to contain DOI links and clickable AGIDs; then selects only columns that are
#' displayed in the interactors or interactees table.
#' 
#' @param edges \[\code{reactivevalues()}\]\cr
#'  AmyloGraph data with "table" element.
#' @param ns \[code{function(1)}\]\cr
#'  Namespace function to use for AGID buttons.
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the protein selector.
#' @param target_id \[\code{character(1)}\]\cr
#'  ID column name to use.
#' @param target_variable \[\code{character(1)}\]\cr
#'  Protein name column to use.
#' 
#' @return A \code{reactive} object with a \code{tibble} containing filtered
#' interaction data for a single protein, either with interactors or
#' interactees (depends on selected target ID).
#' 
#' @importFrom dplyr filter arrange mutate select
reactive_subtable_data <- function(edges, ns, input, target_id, target_variable) {
  reactive({
    (if (input[["ignore_filters"]]) ag_data_interactions else edges[["table"]]) %>%
      filter(.data[[target_id]] == input[["select_node"]]) %>%
      arrange(.data[[target_variable]], doi) %>%
      mutate(doi = linkify_doi(doi)) %>%
      select(AGID = AGID_button, .data[[target_variable]], doi, original_AGID = AGID)
  })
}
