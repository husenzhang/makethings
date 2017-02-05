#!/usr/bin/env Rscript

library(ggplot2)
theme_set(theme_bw() + theme(legend.key.size = unit(0.3, "cm")) )
map <- read.delim("data/map.txt");   names(map)[1] <- "ID"
group <- dimnames(read.delim("data/group"))[[2]]

# ---------------------  process pc files ---------------------------------
pc_fname <- c("out/bdiv/unweighted_unifrac_pc.txt", 
              "out/bdiv/weighted_unifrac_pc.txt")

# graph names: either "unweighted" or "weighted"
title <- gsub("out/bdiv/", "", pc_fname);  title <- gsub("_.*", "", title)

# pc is a list of 2 data frames
pc <- list()
for ( f in seq_along(pc_fname) ) {
   # get % explained PC1: 20.0%
	 pct_ex <- as.numeric(strsplit(readLines(pc_fname[f], n=5)[5], "\t")[[1]][1:3])
	     
	 axis_labs <- paste0(c("PC1: ","PC2: ","PC3: "), sprintf("%.0f%%", 100*pct_ex))
	     
	 pc[[f]] <- read.delim(pc_fname[f], header = FALSE, 
                               skip = 9, check.names = FALSE)[1:4]
	 pc[[f]] <- head(pc[[f]], -2)        # Biplot line removal
	 
	 names(pc[[f]])[1] <- names(map)[1] 
	 pc[[f]] <- merge(map, pc[[f]], by = names(pc[[f]])[1]) 
       
	 for (v in group) { 
	 	
	 	if (length(grep('__numeric__', v)) != 0 ) {
	 		v <- strsplit(v, '__numeric__')[[1]] 
	 	}
	 	
	 	# if categorical colors is desired even for numerical v: 
	 	# pc[[f]][[v]] <- as.character(pc[[f]][[v]])
	 
	 	outfile <- paste('PC', v, title[f], sep = "_") 
	 	ggplot(pc[[f]], aes_string( "V2", "V3", color = v )) + 
	 		geom_point() + 
	 		labs( x = axis_labs[1], y = axis_labs[2] ) +
	 		theme(axis.text=element_blank()) +
	 		theme(axis.ticks=element_blank())

	 	ggsave(filename = paste0(outfile, ".pdf") , 
	 	       path = "out/bdiv", width = 5, height = 4) 
	 }
}
