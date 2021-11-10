download_handler <- \(input, edges, write_function, extension)  downloadHandler(
  filename = \() glue("AmyloGraph.{extension}"),
  content = \(file) write_function(
    edges[["table"]] %>%
      slice(input[["table_rows_selected"]]) %>%
      select(-c(from_id, to_id)),
    file
  )
)