library(shiny)
library(rlang)
library(visNetwork)
library(dplyr)
#library(icecream)
library(purrr)
library(htmltools)
library(shinyhelper)
library(ggplot2)

source("random_description.R")

edges_full_data <- read.csv("./mock_data.csv") %>%
    mutate(from = sapply(strsplit(interactor_name, " "), last),
           to = sapply(strsplit(interactee_name, " "), last))

label_palette <- palette("Dark 2")
label_groups <- c("aggregation_speed", "elongates_by_attaching", "heterogenous_fibers")

label_data <- lapply(
    label_groups,
    function(label_name) {
        tibble(
            # sort added because we can't set manual color scale that would reference to labels
            values = sort(unique(edges_full_data[[label_name]])),
            colors = set_names(label_palette[seq_along(values)], values)
        )
    }
) %>% set_names(label_groups)

ui <- fluidPage(
    # TODO: use varSelectizeInput instead to dynamically generate possible groups?
    theme = "amylograph.css",
    h2("AmyloGraph", class = "ag-title"),
    div(class = "ag-page-content",
        div(class = "ag-control-panel",
            helper(selectInput(inputId = "label_group", label = "Group edges by",
                        choices = list(none = "none",
                                       `interactee aggregation speed` = "aggregation_speed",
                                       `elongates by attaching` = "elongates_by_attaching",
                                       `heterogenous fibers` = "heterogenous_fibers"),
                        multiple = FALSE),
                   type = "markdown",
                   content = "label_group"),
            conditionalPanel(
                condition = "input.label_group != \"none\"",
                helper(uiOutput("labels_shown_ui"),
                       type = "markdown",
                       content = "labels_shown")
            ),
            conditionalPanel(
                condition = "input.label_group != \"none\"",
                plotOutput("legend", )
            )
        ),
        div(class = "ag-graph-panel",
            visNetworkOutput("graph", height = "calc(100% - 10px)", width = "auto")
        ),
        div(class = "ag-node-panel",
            conditionalPanel(condition = "input.selected_node != null",
                             div(class = "ag-node-info",
                                 uiOutput("selected_node_info"),
                                 tabsetPanel(
                                     id = "selected_node_tabs",
                                     tabPanel("Interactees", dataTableOutput("selected_node_interactees")),
                                     tabPanel("Interactors", dataTableOutput("selected_node_interactors"))
                                 ))),
            conditionalPanel(condition = "input.selected_node == null",
                             div(class = "ag-node-info",
                                 "select node to display info about it and interactions associated with it"))
            )
            
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    observe_helpers(help_dir = "manuals")
    
    observeEvent(input[["label_group"]], {
        label_values <- label_data[[input[["label_group"]]]][["values"]]
        output[["labels_shown_ui"]] <- renderUI({
            selectInput(inputId = "labels_shown",
                        label = "Types of connections to display:",
                        choices = label_values,
                        selected = label_values,
                        multiple = TRUE)
        })
    })
    
    edges <- reactive({
        if (input[["label_group"]] == "none") {
            edges_full_data %>%
                group_by(to, from) %>%
                summarize(title = do.call(paste, c(as.list(doi), sep = ",\n")),
                          id = cur_group_id(),
                          .groups = "drop") %>% 
                select(id, from, to, title)
        } else {
            label_group <- rlang::sym(input[["label_group"]])
            edges_full_data %>%
                filter(!!label_group %in% input[["labels_shown"]]) %>%
                group_by(to, from, !!label_group) %>%
                summarize(title = do.call(paste, c(as.list(doi), sep = ",\n")),
                          id = cur_group_id(),
                          .groups = "drop") %>% 
                mutate(color = label_data[[input[["label_group"]]]][["colors"]][!!label_group]) %>%
                select(id, from, to, title, color, !!label_group)
        }
    })
    
    nodes <- select(edges_full_data, interactor_name, interactee_name) %>% 
        unlist() %>% 
        unique() %>% 
        data.frame(label = .) %>% 
        mutate(id = sapply(strsplit(label, " "), last)) %>% 
        mutate(shape = "box")
    
    output[["graph"]] <- renderVisNetwork({
        edges <- edges_full_data %>%
            group_by(to, from) %>%
            summarize(title = do.call(paste, c(as.list(doi), sep = ",\n")),
                      id = cur_group_id(),
                      .groups = "drop") %>%
            select(id, from, to, title)
        
        net <- visNetwork(nodes, edges, width = 1600, height = 900) %>%
            visEdges(arrows = "to", width = 2)  %>% 
            visLayout(randomSeed = 1337) %>% 
            visOptions(highlightNearest = list(enabled = TRUE, degree = 1,
                                               labelOnly = FALSE, hover = TRUE),
                       nodesIdSelection = list(enabled = TRUE)) %>%
            visInteraction(zoomView = TRUE) %>%
            visEvents(selectNode = "function(nodes){
                  Shiny.setInputValue('selected_node', nodes.nodes[0]);
                  }",
                      deselectNode = "function(nodes){
                  Shiny.setInputValue('selected_node', null);
                  }") %>%
            visIgraphLayout(smooth = TRUE) %>%
            visExport(type = "png", name = "AmyloGraph", label = "Export as png")
    })
    
    edge_legend <- eventReactive(input[["labels_shown"]], {
        # this may show incorrect colors if one group's labels are a subset of another's
        label_data[[input[["label_group"]]]] %>%
            filter(values %in% input[["labels_shown"]])
    })
    
    output[["legend"]] <- renderPlot({
        req(nrow(edge_legend()))
        ggplot(edge_legend()) + 
            geom_hline(aes(color = colors, yintercept = -seq_along(values)),
                       size = 10, show.legend = FALSE) +
            geom_text(aes(label = values, y = -seq_along(values), x = 0)) +
            scale_color_manual(values = unname(edge_legend()[["colors"]])) +
            theme_void()
    })

    selected_node_id <- reactive({
        input$graph_selected_nodes[[1]]
    })

    selected_node_info <- reactive({
        req(selected_node_id())
        nodes %>%
            filter(id == selected_node_id())
    })

    selected_node_label <- reactive({
        selected_node_info()[["label"]]
    })
    
    output[["selected_node_info"]] <- renderUI({
        req(selected_node_id())
        div(class = "ag-protein-info",
            HTML(random_description(selected_node_id())))
    })
    
    output[["selected_node_interactors"]] <- renderDataTable({
        req(selected_node_id())
        edges_full_data %>%
            filter(to == selected_node_id()) %>%
            arrange(from, doi) %>%
            select(from, doi, aggregation_speed, elongates_by_attaching, heterogenous_fibers)
    }, options = list(
        pageLength = 10,
        lengthChange = FALSE
    ))
    
    output[["selected_node_interactees"]] <- renderDataTable({
        req(selected_node_id())
        edges_full_data %>%
            filter(from == selected_node_id()) %>%
            arrange(to, doi) %>%
            select(to, doi, aggregation_speed, elongates_by_attaching, heterogenous_fibers)
    }, options = list(
        pageLength = 10,
        lengthChange = FALSE
    ))
    
    observe({
        input$selected_node
        visNetworkProxy("graph") %>%
            visGetSelectedNodes("graph_selected_nodes")
    })
    
    observe({
        visNetworkProxy("graph") %>% 
            visGetEdges("graph_edges") %>%
            visRemoveEdges(seq_along(input$graph_edges)) %>%
            visUpdateEdges(edges())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
