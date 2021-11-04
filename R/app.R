#' @importFrom shiny checkboxInput downloadButton downloadHandler h2 h3 h4 htmlOutput includeMarkdown mainPanel 
#' outputOptions renderPlot renderText runApp plotOutput textInput textOutput verbatimTextOutput 
#' @export
AmyloGraph <- function()
  runApp(system.file("AmyloGraph", package = "AmyloGraph"))
