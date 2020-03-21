#!/usr/bin/env Rscript

library(ggplot2)
theme_set(theme_bw() + theme(legend.key.size = unit(0.3, "cm")) )
library(phyloseq)
source("~/Dropbox/makeThings/plot_worker.r")

dir.create('out/adiv')

# plot Observed, smoothLine for num var; boxplot otherwise
alpha_plot <- function(df, x) {

     measure <- df[,'variable'][1]
     pl <- box_pval(df, x) + ylab(measure) 
	   
     plotWidth <- ifelse((length(grep('__numeric__', x)) != 0), 
                          3.5, 0.85*length(unique(df[[x]]))) 

     ggsave(pl, path = "out/adiv", width = plotWidth, height = 3,
     		filename = paste0('adiv_', x, '_', measure, ".pdf"))
}

main <- function() {
   # treefilename not needed if not plotting PD_whole_tree 
   group <- dimnames(read.delim("data/group"))[[2]]
   measures = c('Observed')
   ps <- import_biom('out/json', treefilename = 'data/rep_set.tre')
   df <- plot_richness(ps, measures = measures)$data
   
   for (g in group) {
   	
    by(df, df[,'variable'], function(measure) alpha_plot(measure, g))
   }
 
   # output excel 
   outfile <- estimate_richness(ps)
   openxlsx::write.xlsx(outfile, 'out/adiv/adiv.xlsx', row.names = T)
}

main()
