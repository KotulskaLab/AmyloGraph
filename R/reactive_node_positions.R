#' Retrieve node positions in a network
#' 
#' @description Triggers update of `network_positions` input value, then reads
#' this value and formats it as a `data.frame`.
#' 
#' @param input \[\code{reactivevalues()}\]\cr
#'  An input object of the app or a module that contains the network.
#' @param network_id \[\code{character(1)}\]\cr
#'  ID of the network.
#' 
#' @return A \code{reactive} object with `NULL` if no positions available or
#' a `tibble` with `x`, `y` and `id` columns.
#' 
#' @importFrom dplyr bind_rows mutate
#' @importFrom visNetwork visNetworkProxy visGetPositions
reactive_node_positions <- function(input, network_id) {
  reactive({
    visNetworkProxy(network_id) %>%
      visGetPositions()
    
    if_null_else(
      input[[glue("{network_id}_positions")]],
      function(positions) {
        do.call(bind_rows, positions) %>%
          mutate(id = names(positions))
      }
    )
  })
}
