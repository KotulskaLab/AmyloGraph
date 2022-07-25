observe_graph_buttons <- function(input, output, tabs_visited, edges) {
  bindEvent(
    observe({
      req(tabs_visited[["graph"]])
      
      output[["download_xgmml"]] <- render_XGMML_download("download_xgmml", edges)
      node_positions <- reactive_node_positions(input, "graph")
      output[["download_html"]] <- render_HTML_download("download_html", node_positions)
    }),
    tabs_visited[["graph"]],
    ignoreInit = TRUE,
    once = TRUE
  )
}
