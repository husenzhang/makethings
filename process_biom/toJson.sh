#!/bin/bash

# QIIME version 1.9.1

source /macqiime/configs/bash_profile.txt

mv data/otu_tax.biom data/all.biom

filter_taxa_from_otu_table.py -n c__Chloroplast \
        -i data/all.biom -o data/otu_tax.biom

## first add sample-metadata-fp
biom add-metadata -i data/otu_tax.biom   	\
		  -o data/otu_tax_spl.biom	 \
		  -m data/map.txt	 	\

## then convert hdf5 to json
biom convert --to-json -i data/otu_tax_spl.biom  \
		-o out/json

## remove intermediate file
rm -f data/otu_tax_spl.biom
