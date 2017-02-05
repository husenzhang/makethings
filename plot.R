#!/usr/bin/env Rscript

ppp <- 10
n_col <- 2

library(ggplot2)
theme_set(theme_bw())
source("~/Dropbox/makeThings/libsLight.R")
source("~/Dropbox/makeThings/plot_worker.R")
dir.create('out/ctax')

# the variable "L" is used in plot_worker.R
for ( L in seq_along(df_list)) {
    df  <- df_list[[L]]
    plot_mp_box(df, ppp = ppp, n_col = n_col)
}

