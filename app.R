library(shiny)
library(shinyjs)
library(rlang)
library(visNetwork)
library(dplyr)
# library(icecream)
library(purrr)
library(htmltools)
library(shinyhelper)
library(ggplot2)
library(glue)
library(digest)

source("R/edgeTable.R")
source("R/graphControl.R")
source("R/nodeInfo.R")
source("R/prepareData.R")

ui <- fluidPage(
    theme = "amylograph.css",
    useShinyjs(),
    
    h2("AmyloGraph", class = "ag-title"),
    sidebarLayout(
        sidebarPanel(
            graphControlUI("graph_control", label_data),
            width = 2
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
                        nodeInfoUI("node_info")
                    )
                ),
                tabPanel(
                    title = "Table",
                    edgeTableUI("all_edges")
                )
            ),
            width = 10
        )
    )
)

server <- function(input, output) {
    observe_helpers(help_dir = "manuals")
    
    edges <- graphControlServer("graph_control", edge_data, label_data)
    
    edgeTableServer("all_edges", edges)
    
    output[["graph"]] <- renderVisNetwork({
        # we don't want to render graph each time we modify edges
        # instead we remove and update them in a separate observer
        edges <- isolate(edges()[["graph"]])
        
        net <- visNetwork(node_data, edges, width = 1600, height = 900) %>%
            visEdges(arrows = "to", width = 2)  %>% 
            visLayout(randomSeed = 1337) %>% 
            visOptions(
                highlightNearest = list(enabled = TRUE, degree = 1,
                                        labelOnly = FALSE, hover = TRUE),
                nodesIdSelection = list(enabled = TRUE)) %>%
            visInteraction(zoomView = TRUE) %>%
            visEvents(
                selectNode = "function(nodes){
                  Shiny.setInputValue('selected_node', nodes.nodes[0]);
                  }",
                deselectNode = "function(nodes){
                  Shiny.setInputValue('selected_node', null);
                  }") %>%
            visIgraphLayout(smooth = TRUE) %>%
            visExport(type = "png", name = "AmyloGraph", label = "Export as png")
    })
    
    nodeInfoServer("node_info", edges, node_data, reactive(input[["selected_node"]]))
    
    observe({
        input[["selected_node"]]
        visNetworkProxy("graph") %>%
            visGetSelectedNodes("graph_selected_nodes")
    })
    
    observe({
        visNetworkProxy("graph") %>% 
            visGetEdges("graph_edges") %>%
            visRemoveEdges(seq_along(input[["graph_edges"]])) %>%
            visUpdateEdges(edges()[["graph"]])
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
