#!/usr/bin/env Rscript
# towards 1: add print statement '__numeric__'

outputdir   <- 'out/ctax'
excelfile   <- 'out/ctax/bugs.xlsx'
ppp         <- 8
n_col       <- 2
mapfile     <- "data/map.txt"
groupfile   <- "data/group"
samplebytax <- "out/samplebytax/"
taxpattern  <- "otu_tax_L.*.txt$"
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
tax_files <- list.files(pattern = taxpattern, path = samplebytax)
group <- dimnames(read.delim(groupfile))[[2]]

library(reshape2)
library(ggplot2)
theme_set(theme_bw() + 
          theme(panel.grid.major = element_blank(),
                panel.grid.minor = element_blank())
         )
source("~/Dropbox/makeThings/plot_worker.R")
dir.create(outputdir)

tax2df <- function(mapfile = mapfile, tax_files = tax_files, melt = TRUE) {
  ### added na.strings = ""
  df_list <- list()
  for ( i in seq_along(tax_files) ) {
    df <- read.delim(paste0(samplebytax, tax_files[i]),
                      check.names = F, skip = 1, na.strings = "")

    names(df) <- gsub(';', ' ', names(df))

    map <- read.delim(mapfile)
    names(df)[1] <- names(map)[1]
    merged_df <- merge( map, df, by = names(df)[1] )

    if (melt == FALSE) { df_list[[i]] <- merged_df }

      else {df_list[[i]] <- melt(merged_df,
                                 id.vars = names(map),
                                 value.name = "value",
                                 variable.name = "tax")  }
  }
  return(df_list)
}

main <- function() {
	openxlsx::write.xlsx(tax2df(mapfile, tax_files, melt = FALSE), excelfile)
	df_list <- tax2df(mapfile = mapfile, tax_files = tax_files)
	for ( L in seq_along(df_list)) {
		df  <- df_list[[L]]
		plot_mp_box(df, ppp = ppp, n_col = n_col, L = L)
	}
}

main()
