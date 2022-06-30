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
