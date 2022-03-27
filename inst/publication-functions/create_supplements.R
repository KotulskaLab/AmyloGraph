all_lines_vignette <- readLines("vignettes/definitions.Rmd")
all_lines_supplements <- readLines("inst/publication-functions/supplements.Rmd")

yaml_end <- which(all_lines_vignette == "---")[2]

writeLines(c(all_lines_supplements, all_lines_vignette[(yaml_end + 1):length(all_lines_vignette)]),
           con = "inst/publication-functions/supplements-tmp.Rmd")
rmarkdown::render("inst/publication-functions/supplements-tmp.Rmd")
file.rename("inst/publication-functions/supplements-tmp.pdf", "inst/publication-functions/supplements.pdf")
file.remove(list.files(path = "inst/publication-functions", pattern = "supplements-tmp", full.names = TRUE))
