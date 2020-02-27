#!/usr/bin/env Rscript
# revise tax2df to return a single dataframe 
#  in melted form (rbind) or wide form (cbind)

worker      <- "~/Dropbox/makeThings/2.0_plot_worker.R"
outputdir   <- 'out/ctax'
excelfile   <- 'out/ctax/bugs.xlsx'
groupfile   <- "data/group"
ppp         <- 8
n_col       <- 2
pagew       <- 7
pageh       <- 10
mapfile     <- "data/map.txt"
samplebytax <- "out/samplebytax/"
tax_files <- list.files(pattern = "otu_tax_L.*.txt$", path = samplebytax)

library(reshape2)
library(ggplot2)
theme_set(theme_bw())
source(worker)
dir.create(outputdir)

tax2df <- function(mapfile, tax_files) {
  # return a single dataframe
  df_list <- vector(mode = 'list', length = length(tax_files))
  for ( i in seq_along(tax_files) ) {
    df <- read.delim(paste0(samplebytax, tax_files[i]),
                      check.names = F, skip = 1, na.strings = "")
    df_list[[i]] <- df
  }
  
  df <- do.call('cbind', df_list)
  df[grep("#OTU", names(df))[-1]] <- NULL   # remove "#OTU" columns but [1]
  
  names(df) <- gsub(';', ' ', names(df))
  map <- read.delim(mapfile)
  names(df)[1] <- names(map)[1]
  merged_df <- merge( map, df, by = names(df)[1] )
  
  df <- melt(merged_df,
              id.vars = names(map),
              value.name = "value",
              variable.name = "tax")
  return(df)
}

# execute actions
  df <- tax2df(mapfile, tax_files)
	openxlsx::write.xlsx(df, excelfile)
	# modify the following
	#	plot_mp_box(df, groupfile = groupfile, ppp = ppp, n_col = n_col, 
	#              outputdir = outputdir, pagew = pagew, pageh = pageh)
