#' @importFrom shiny checkboxInput h2 h4 includeMarkdown mainPanel renderText runApp textInput textOutput verbatimTextOutput 
#' @export
AmyloGraph <- function()
  runApp(system.file("AmyloGraph", package = "AmyloGraph"))
