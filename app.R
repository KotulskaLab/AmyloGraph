library(shiny)
library(rlang)
library(visNetwork)
library(dplyr)
# library(icecream)
library(purrr)
library(htmltools)
library(shinyhelper)
library(ggplot2)
library(digest)

source("R/edgeTable.R")
source("R/graphControl.R")
source("R/nodeInfo.R")

edge_data <- read.csv("./interactions_data.csv") %>%
    mutate(from_id = map_chr(interactor_name, digest),
           to_id = map_chr(interactee_name, digest))

label_palette <- palette("Dark 2")
label_groups <- list(
    `interactee aggregation speed` = "aggregation_speed",
    `elongates by attaching` = "elongates_by_attaching",
    `heterogenous fibers` = "heterogenous_fibers"
)

label_data <- lapply(
    label_groups,
    function(label_name) {
        tibble(
            # sort added because we can't set manual color scale that would reference to labels
            values = sort(unique(edge_data[[label_name]])),
            colors = set_names(label_palette[seq_along(values)], values)
        )
    }
) %>% set_names(label_groups)

ui <- fluidPage(
    theme = "amylograph.css",
    h2("AmyloGraph", class = "ag-title"),
    tabsetPanel(
        id = "graph-table-panel",
        tabPanel(
            title = "Graph",
            div(class = "ag-page-content",
                graphControlUI("graph_control", c(none = "none", label_groups)),
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
    )
)

server <- function(input, output) {
    observe_helpers(help_dir = "manuals")
    
    edgeTableServer("all_edges", edge_data)
    
    edges <- graphControlServer("graph_control", edge_data, label_data)
    
    nodes <- select(edge_data, interactor_name, interactee_name) %>% 
        unlist() %>% 
        unique() %>% 
        tibble(label = .) %>% 
        mutate(id = map_chr(label, digest)) %>% 
        mutate(shape = "box")
    
    output[["graph"]] <- renderVisNetwork({
        edges <- edge_data %>%
            group_by(to_id, from_id) %>%
            summarize(
                title = do.call(paste, c(as.list(doi), sep = ",\n")),
                id = cur_group_id(),
                .groups = "drop") %>%
            select(id, from = from_id, to = to_id, title)
        
        net <- visNetwork(nodes, edges, width = 1600, height = 900) %>%
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
    
    selected_node_id <- reactive({
        input[["selected_node"]]
    })
    
    nodeInfoServer("node_info", edge_data, nodes, selected_node_id)
    
    observe({
        input[["selected_node"]]
        visNetworkProxy("graph") %>%
            visGetSelectedNodes("graph_selected_nodes")
    })
    
    observe({
        visNetworkProxy("graph") %>% 
            visGetEdges("graph_edges") %>%
            visRemoveEdges(seq_along(input[["graph_edges"]])) %>%
            visUpdateEdges(edges())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
