#' @rawNamespace import(shiny, except = c(dataTableOutput, renderDataTable))
#' @importFrom dplyr `%>%`
#' @importFrom glue glue
#' @export
AmyloGraph <- function()
  runApp(system.file("AmyloGraph", package = "AmyloGraph"))
