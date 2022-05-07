#' Copy selections in subtables to main table
#' 
#' @description On "select" button click collects all selected interactions in
#' both subtables in single protein panel. Then finds these interactions in the
#' main table and sets the selected rows to these. Lastly, moves the user to
#' the table tab.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app.
#' @param subtables \[code{reactivevalues()}\]\cr
#'  A list with two subtables for interactions as interactor and interactee
#'  respectively.
#' @param edges \[\code{reactivevalues()}\]\cr
#'  AmyloGraph data with "table" element.
#' @param table_proxy \[\code{dataTableProxy(1)}\]\cr
#'  Proxy of the main table (target table).
#' @param rvals \[\code{reactivevalues}\]\cr
#'  Reactive values handling the problem of setting selection in a table that
#'  wasn't displayed previously.
#' 
#' @return An observer.
#' 
#' @importFrom shiny NS observeEvent updateTabsetPanel
#' @importFrom dplyr `%>%` mutate filter pull cur_group_rows
#' @importFrom DT selectRows
observe_moving_selection <- \(input, subtables, edges, table_proxy, rvals) observeEvent(
  input[[NS("single_protein", "select_in_table")]],
  {
    ns <- NS("single_protein")
    if (input[[ns("select_in_table")]] > 0) {
      interactees_rows_selected <- input[[ns("interactees_rows_selected")]]
      interactors_rows_selected <- input[[ns("interactors_rows_selected")]]
      
      indices <- unique(c(
        subtables[["interactees"]]()[interactees_rows_selected, "original_AGID", drop = TRUE],
        subtables[["interactors"]]()[interactors_rows_selected, "original_AGID", drop = TRUE]
      ))
      
      new_selection <-
        edges[["table"]] %>%
        mutate(rownr = cur_group_rows()) %>%
        filter(AGID %in% indices) %>%
        pull(rownr) 
      
      if (ic(rvals[["table_visited"]])) {
        selectRows(table_proxy, new_selection)
      } else {
        rvals[["initially_selected"]] <- new_selection
      }
      
      updateTabsetPanel(inputId = "tabset_panel",
                        selected = "table")
    }
  }
)