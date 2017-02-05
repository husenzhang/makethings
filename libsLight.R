library(reshape2)

tax2df <- function(map = map, tax_files = tax_files, melt = TRUE) {
  ### tax2df returns df_list, added na.strings = ""
  df_list <- list()
  for ( i in seq_along(tax_files) ) {
    df <- read.delim(paste0("out/samplebytax/", tax_files[i]),
                      check.names = F, skip = 1, na.strings = "")

    names(df) <- gsub(';', ' ', names(df))
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

# ------------------  map, tax_files, df_list, group, excel output --------------
map <- read.delim("data/map.txt");   names(map)[1] <- "ID"
group <- dimnames(read.delim("data/group"))[[2]]
tax_files <- list.files(pattern = "otu_tax_L.*.txt$", 
                        path = "out/samplebytax")
df_list   <- tax2df(map = map, tax_files = tax_files)
openxlsx::write.xlsx(tax2df(map, tax_files, melt = FALSE), 'out/bugs.xlsx')
