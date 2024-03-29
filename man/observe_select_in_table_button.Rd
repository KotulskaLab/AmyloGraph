% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/observe_row_selection.R
\name{observe_select_in_table_button}
\alias{observe_select_in_table_button}
\title{Observe "Transfer selection" button}
\usage{
observe_select_in_table_button(ns, any_row_selected)
}
\arguments{
\item{ns}{[\code{function(1)}]\cr
Namespace-generating function that takes single string as the only argument.}

\item{any_row_selected}{[\code{reactive(logical(1))}]\cr
A reactive value telling whether any row is selected in a table.}
}
\description{
Toggles button on and off based on whether any row is selected
in a table.
}
