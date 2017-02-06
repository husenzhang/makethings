#!/usr/bin/env Rscript

# fig width and height
fw <- 5
fh <- 4

library(ggplot2)
theme_set(theme_bw()                                + 
          theme(legend.key.size = unit(0.3, "cm"))  +
	 	  theme(axis.text=element_blank())          +
	 	  theme(axis.ticks=element_blank()) 
)
map <- read.delim("data/map.txt")
group <- dimnames(read.delim("data/group"))[[2]]

# ---------------------  process pc files ---------------------------------
pc_fname <- c("out/bdiv/unweighted_unifrac_pc.txt", 
              "out/bdiv/weighted_unifrac_pc.txt")

# file names: either "unweighted" or "weighted"
title <- gsub("out/bdiv/", "", pc_fname);  title <- gsub("_.*", "", title)

# pc is a list of 2 dataframes
pc <- list()
for ( f in seq_along(pc_fname) ) {
   # get % explained PC1: 20.0%
	 pct_ex <- as.numeric(strsplit(readLines(pc_fname[f], n=5)[5], "\t")[[1]][1:3])

     # "PC1: 43%" "PC2: 17%" "PC3: 13%"	     
	 axis_labs <- paste0(c("PC1: ","PC2: ","PC3: "), sprintf("%.0f%%", 100*pct_ex))

	 pc[[f]] <- read.delim(pc_fname[f], header = FALSE, 
                               skip = 9, check.names = FALSE)[1:4]
	 pc[[f]] <- head(pc[[f]], -2)        # Biplot line removal
	 
	 names(pc[[f]])[1] <- names(map)[1] 
	 pc[[f]] <- merge(map, pc[[f]], by = names(pc[[f]])[1]) 
       
	 for (v in group) { 
	 	
	 	# categorical colors is desired even for numerical v: 
	 	pc[[f]][[v]] <- as.character(pc[[f]][[v]])
	 
	 	outfile <- paste('PC', v, title[f], sep = "_") 
	 	ggplot(pc[[f]], aes_string( "V2", "V3", color = v )) + 
	 		   geom_point() + 
	 		   labs( x = axis_labs[1], y = axis_labs[2] )

	 	ggsave(filename = paste0(outfile, ".pdf") , 
	 	       path = "out/bdiv", width = fw, height = fh) 
	 }
}
