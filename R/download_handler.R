download_handler <- \(input, table_data, write_function, extension)  downloadHandler(
  filename = \() glue("AmyloGraph.{extension}"),
  content = \(file) write_function(
    table_data() %>%
      slice(input[["table_rows_selected"]]) %>%
      select(-c(from_id, to_id)),
    file
  )
)