ag_load_data <- \() {
  list(
    interactions = AmyloGraph::ag_data_interactions(),
    groups = AmyloGraph:::ag_data_groups(),
    nodes = AmyloGraph:::ag_data_nodes()
  )
}