#!/usr/bin/env Rscript

library(phyloseq)
library(ggplot2)
theme_set(theme_bw())
library(DESeq2)
library(pheatmap)

pheat <- function(ps, L, group){              # L: int 1:OTU;2phylum
  RankNum <- paste0('Rank', L)
  if (L > 1) {ps <- tax_glom(ps, taxrank = RankNum)}
  dds.data <- phyloseq_to_deseq2(ps, as.formula(paste0('~',group)))
  dds = DESeq(dds.data)
  res = results(dds)
  alpha = ifelse(L == 1, 0.01, 0.5/(L^2))      # here ------- 
  sigtab = res[which(res$padj < alpha), ]
  sigtab = cbind(as(sigtab, "data.frame"), 
                 as(tax_table(ps)[rownames(sigtab), ], "matrix"))
  log2.norm.counts <- assay(normTransform(dds))[rownames(sigtab),,drop=F]
  
  if (min(dim(log2.norm.counts)) < 2) { return() }
  else { if (L > 1)  
         {rownames(log2.norm.counts) <- sigtab[ ,RankNum]}
  df <- as.data.frame(colData(dds)[ , group])
  rownames(df) <- colnames(log2.norm.counts)
  colnames(df) <- ' '                         # legend title ---
  pdf(paste0(RankNum,group,'.pdf'), onefile=F)
  p = pheatmap(log2.norm.counts, annotation_col = df)
  dev.off()
  }
}

ps <- import_biom("out/json")
groups <- dimnames(read.delim("data/group"))[[2]]
for (L in 1:7) {
  for (group in groups) {
      pheat(ps, L, group)
  } 
}
