#!/usr/bin/env Rscript

library(phyloseq)
library(ggplot2)
theme_set(theme_bw())
library(RColorBrewer)

############### plateID required in the map.txt ##############
facetby = 'group'
stackfilename = 'out/stacked.pdf'
jsonf <- 'out/json'
w = 5
h = 4
x = 'Sample'
fill = "Rank4"
frac = 0.02
blend1 <- brewer.pal(8, 'Dark2')
blend2 <- brewer.pal(12, 'Paired') 
brewCol <- c(blend2, blend1)

stackdf <- function(jsonf, x, fill, frac) { 
  ps <- import_biom(jsonf)
  ps <- transform_sample_counts( tax_glom(ps, fill ), function(x) x/sum(x) )
  ps <- prune_taxa(taxa_sums(ps) > frac, ps)
  df <- psmelt(ps)
  df <- df[order( df[[fill]] ), ]
  df[[ fill ]] <- factor( df[[fill]] )
  # Increasing Bacteroidales by sorting the x-axis ------- ::: sort by Bacteroi
  ids <- which(df[[ fill ]] == "Bacteroidales")
  df[[ x ]] <- factor(df[[x]], levels = df[[x]][ids] )
  return(df)
}

df <- stackdf(jsonf, x = x, fill = fill, frac = frac )

p <- ggplot(df, aes(plateID, Abundance, fill = Rank4)) +
            geom_bar(stat="identity")    +
            xlab(NULL) + ylab("Relative Abundance")  +
            scale_y_continuous(labels=scales::percent) +
            scale_fill_manual(values = brewCol) +
            theme(axis.text.x=element_blank(),
                  axis.ticks.x=element_blank())  +
            theme(legend.key.size = unit(0.35, "cm")) +
            facet_wrap(as.formula(sprintf('~%s', facetby)), 
                       scales = "free_x", nrow=3) + 
            guides(fill=guide_legend(title=NULL, reverse = T))
ggsave(p, filename = stackfilename, width = w, height = h)
#write.csv(df, 'fig3B_data.csv', quote = F, row.names = F)
