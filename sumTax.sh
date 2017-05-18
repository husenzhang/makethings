#!/bin/bash

source /macqiime/configs/bash_profile.txt

mv data/otu_tax.biom data/all.biom

filter_taxa_from_otu_table.py -n c__Chloroplast \
    -i data/all.biom -o data/otu_tax.biom

summarize_taxa.py -i data/otu_tax.biom \
                  -o out/samplebytax \
                  -u 0.00008  \
                  -L 2,3,4,5,6,7    \
                  -t

summarize_taxa.py -i data/otu_tax.biom  \
                  -o out/taxbysample \
                  -u 0.00008  \
                  -L 2,3,4,5,6,7

biom normalize-table -r -i data/otu_tax.biom \
                     -o out/taxbysample/otu_tax_relab.biom

biom convert --to-tsv --header-key taxonomy \
	              -i out/taxbysample/otu_tax_relab.biom \
				  -o out/taxbysample/otu_tax_relab.tsv
