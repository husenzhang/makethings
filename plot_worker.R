
plot_mp_box <- function(df, ppp = 4, n_col = 1) {
  #ppp <- 4 
  #n_col = 1
  utax <- unique(df$tax)
  ntax <- length(utax)
  pdfname <- matrix(nrow = length(tax_files), ncol = length(group),
                    dimnames = list(tax_files, group)) 

  for (g in seq_along(group)) {

    # indices for plotting vector
    plotSequence <- c(seq(0, ntax-1, by = ppp), ntax)
    
    pdfname[L, g] <- paste0("L", L+1, "_",  group[g], ".pdf")
    pdf(paste0("out/ctax/", pdfname[L, g]), 
		width = 7, height = 10)
    
    for(ii in 2:length(plotSequence)) {
      start <- plotSequence[ii-1] + 1
      end   <- plotSequence[ii]
      
      ## split df to tmp; drop unused factors in tmp$tax
      tmp <- subset(df, tax %in% utax[start:end])
      tmp$tax <- factor(tmp$tax)
      utmp <- unique(tmp$tax)
      cat(utmp, "\n")
      
      ## drop levels in tmp[ , group[g] ], no extra levels in plot
      tmp <- tmp[tmp[ , group[g]] != "", ]
      tmp <- droplevels(tmp)

      # store p values
      p <- vector(length = length(utmp))
      
      for (t in seq_along(utmp)) {
        tmp_split <- split(tmp, factor(tmp$tax))
        fit <- lm (value ~ tmp_split[[t]][ , group[g]],
                   data =  tmp_split[[t]] )
        p[t] <- anova(fit)$`Pr(>F)`[1]  }
      
      pg <- ggplot(tmp, aes( tmp[[ group[g] ]], value )) + 
              xlab(NULL) + geom_boxplot() + geom_point() +
              facet_wrap(~ tax, 
                         scales = "free", 
                         ncol = n_col, 
                         labeller = labeller(tax=label_wrap_gen(10)) ) +
              geom_text(aes(x, y, label = lab),  vjust = 1, size =3,
                   data = data.frame(x = 2,
                                    y = Inf,
                                    lab = paste0("P = ", round(p, 3)),
                                    tax = utmp) ) 
      print(pg)
    }
    dev.off() 
  }
}

## -------------- Usage: box_pval(df, x), return a gg obj 
box_pval <- function(df, x) {

		## subset and drop levels  
		df <- df[df[ ,x] != "", ]
		df <- droplevels(df)

        y = ifelse(("value" %in%  names(df)), "value", "value")

	if (length(grep('__numeric__', x)) != 0 ) {

         #  x <- strsplit(x, '__numeric__')[[1]]
            x_label <- strsplit(x, '__numeric__')[[1]]
	     df[,x] <- as.numeric(df[,x])

        pl <- ggplot(df, aes_string(x, y)) + geom_smooth() + geom_point() +
                    xlab(x_label)

        } else { 

        pval <- anova(lm( df[[ y ]] ~ df[[ x ]] ))$`Pr(>F)`[1]
        pval <- round(pval,3) 
        pval_x <- names(sort(tapply(df[[y]], df[[x]], mean))[1])
        pval_y <- max(df[[y]])

        pl <- ggplot(df, aes_string(x, y)) + xlab(NULL) + 
              geom_boxplot(outlier.shape = NA) + geom_point() +
              theme(axis.text.x = element_text(size = 10)) +
              annotate(x = pval_x, y = pval_y, geom = "text",
                       label = paste0("P=", pval))
        }
	return(pl)
}
