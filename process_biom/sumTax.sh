#!/bin/bash


summarize_taxa.py -i data/otu_tax.biom \
                  -o out/samplebytax \
                  -u 0.00005  \
                  -L 2,3,4,5,6,7    \
                  -t

summarize_taxa.py -i data/otu_tax.biom  \
                  -o out/taxbysample \
                  -u 0.00005  \
                  -L 2,3,4,5,6,7
