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

source("R/constants.R")
source("R/edgeTable.R")
source("R/graphControl.R")
source("R/nodeInfo.R")
source("R/prepareData.R")
source("R/visToggleNodes.R")

ui <- fluidPage(
    theme = "amylograph.css",
    useShinyjs(),
    
    div(
        class = "ag-title",
        img(src = "AGT5.png", class = "ag-logo")
    ),
    sidebarLayout(
        sidebarPanel(
            graphControlUI("graph_control", label_data),
            width = SIDE_PANEL_WIDTH
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
                        nodeInfoUI("node_info", node_data)
                    )
                ),
                tabPanel(
                    title = "Table",
                    edgeTableUI("all_edges")
                )
            ),
            width = 12 - SIDE_PANEL_WIDTH
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
        edges <- isolate(edges[["graph"]])
        
        net <- visNetwork(node_data, edges, width = 1600, height = 900) %>%
            visEdges(arrows = "to", width = 2)  %>% 
            visLayout(randomSeed = 1337) %>% 
            visOptions(
                highlightNearest = list(enabled = TRUE, degree = 1,
                                        labelOnly = FALSE, hover = TRUE)) %>%
            visInteraction(zoomView = TRUE) %>%
            visEvents(
                selectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('node_info', 'select_node')>>', nodes.nodes[0]);
                  }", .open = "<<", .close = ">>"),
                deselectNode = glue("function(nodes){
                  Shiny.setInputValue('<<NS('node_info', 'select_node')>>', '<<STR_NULL>>');
                  }", .open = "<<", .close = ">>")) %>%
            visIgraphLayout(smooth = TRUE) %>%
            visExport(type = "png", name = "AmyloGraph", label = "Export as png")
    })
    
    nodeInfoServer("node_info", edges, node_data)
    
    observe({
        selected_node_id <- input[[NS("node_info", "select_node")]]
        visNetworkProxy("graph") %>%
            visToggleNodes(selected_node_id, STR_NULL)
        updateSelectInput(
            inputId = NS("node_info", "select_node"),
            selected = selected_node_id
        )
    })
    
    observe({
        visNetworkProxy("graph") %>% 
            visGetEdges("graph_edges") %>%
            visRemoveEdges(seq_along(input[["graph_edges"]])) %>%
            visUpdateEdges(edges[["graph"]])
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
