awaiting_fun  = "
function await_for_change() {
  if(!document.getElementById('graph').hasOwnProperty('htmlwidget_data_init_result')) {
    setTimeout(await_for_change, 50); //wait 50 millisecnds then recheck
    return;
  }
  
  function change()  {
    document.getElementById('graph').htmlwidget_data_init_result.network.body.view.translation.x = 500;
    document.getElementById('graph').htmlwidget_data_init_result.network.redraw();
  }
  setTimeout(change, 100); // waiting is necessary, because otherwise it doesn't work
}

await_for_change();
"


#' @importFrom visNetwork renderVisNetwork visNetwork visEdges visOptions visInteraction
#' @importFrom visNetwork visEvents visIgraphLayout visExport visNodes visPhysics
render_network <- function(ag_data_nodes, edges) {
  renderVisNetwork({
    # we don't want to render graph each time we modify edges
    # instead we remove and update them in a separate observer
    visNetwork(ag_data_nodes, isolate(edges[["graph"]]),
               width = 1600, height = 900) %>%
      visEdges(arrows = "to", 
               width = 2,
               color = "#3674AB") %>% 
      visNodes(color = "#F3C677",
               font = list(color = "#0C0A3E")) %>%
      visIgraphLayout(smooth = TRUE, physics = FALSE, randomSeed = 1338) %>%
      visPhysics(maxVelocity = 50, minVelocity = 49, timestep = 0.3) %>%
      visOptions(
        highlightNearest = list(enabled = TRUE, degree = 1,
                                labelOnly = FALSE, hover = TRUE,
                                algorithm = "hierarchical")) %>%
      visInteraction(zoomView = TRUE, navigationButtons = TRUE) %>%
      visEvents(
        selectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('single_protein', 'select_node')>>', nodes.nodes[0]);
                  }", .open = "<<", .close = ">>"),
        deselectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('single_protein', 'select_node')>>', '<<AmyloGraph:::ag_option('str_null')>>');
                  }", .open = "<<", .close = ">>"),
        release = awaiting_fun) %>%
      visExport(type = "png", name = "AmyloGraph", label = "Export as png", float = "left", 
                style = "")
  })
}