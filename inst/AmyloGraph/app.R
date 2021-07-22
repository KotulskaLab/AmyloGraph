# shiny-related packages
library(shiny)
library(shinyjs)
library(shinyhelper)
library(htmltools)
# rendering packages
library(visNetwork)
library(ggplot2)
require(igraph)
# data manipulation packages
library(rlang)
library(tibble)
library(dplyr)
library(purrr)
library(glue)
library(digest)
# debug packages
# library(icecream)

ag_data_interactions <- AmyloGraph::ag_data_interactions()
ag_data_groups <- AmyloGraph:::ag_data_groups()
ag_data_nodes <- AmyloGraph:::ag_data_nodes()

ui <- fluidPage(
    theme = "amylograph.css",
    useShinyjs(),
    
    div(
        class = "ag-title",
        img(src = "AGT5.png", class = "ag-logo")
    ),
    sidebarLayout(
        sidebarPanel(
            AmyloGraph:::graphControlUI("graph_control", ag_data_groups),
            width = AmyloGraph:::ag_option("side_panel_width")
        ),
        mainPanel(
            tabsetPanel(
                id = "graph-table-panel",
                tabPanel(
                    title = "Graph",
                    div(class = "ag-page-content",
                        div(class = "ag-graph-panel",
                            visNetworkOutput("graph", height = "calc(100% - 10px)", width = "auto")
                        ),
                        AmyloGraph:::nodeInfoUI("node_info", ag_data_nodes)
                    )
                ),
                tabPanel(
                    title = "Table",
                    AmyloGraph:::interactionsTableUI("all_edges")
                )
            ),
            width = 12 - AmyloGraph:::ag_option("side_panel_width")
        )
    )
)

server <- function(input, output) {
    observe_helpers(help_dir = "manuals")
    
    edges <- AmyloGraph:::graphControlServer("graph_control", ag_data_interactions, ag_data_groups)
    
    AmyloGraph:::interactionsTableServer("all_edges", edges)
    
    output[["graph"]] <- renderVisNetwork({
        # we don't want to render graph each time we modify edges
        # instead we remove and update them in a separate observer
        visNetwork(ag_data_nodes, isolate(edges[["graph"]]),
                   width = 1600, height = 900) %>%
            visEdges(arrows = "to", width = 2)  %>% 
            visLayout(randomSeed = 1337) %>% 
            visOptions(
                highlightNearest = list(enabled = TRUE, degree = 1,
                                        labelOnly = FALSE, hover = TRUE,
                                        algorithm = "hierarchical")) %>%
            visInteraction(zoomView = TRUE) %>%
            visEvents(
                selectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('node_info', 'select_node')>>', nodes.nodes[0]);
                  }", .open = "<<", .close = ">>"),
                deselectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('node_info', 'select_node')>>', '<<AmyloGraph:::ag_option('str_null')>>');
                  }", .open = "<<", .close = ">>")) %>%
            visIgraphLayout(smooth = TRUE) %>%
            visExport(type = "png", name = "AmyloGraph", label = "Export as png")
    })
    
    AmyloGraph:::nodeInfoServer("node_info", edges, ag_data_nodes)
    
    observe({
        selected_node_id <- input[[NS("node_info", "select_node")]]
        visNetworkProxy("graph") %>%
            AmyloGraph:::visToggleNodes(selected_node_id)
        updateSelectInput(
            inputId = NS("node_info", "select_node"),
            selected = selected_node_id
        )
    })
    
    observe({
        visNetworkProxy("graph") %>% 
            AmyloGraph:::visResetEdges(edges[["graph"]], input,
                                       NS("node_info", "select_node"))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
