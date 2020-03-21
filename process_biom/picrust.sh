#!/bin/bash
#set -e
#sed -i 's/\./_/' seqs.fna
#
#source /usr/bin/qiime

pick_closed_reference_otus.py 	\
        -i seqs.fna      \
        -o picrust/
biom convert --to-json                  \
        -i picrust/otu_table.biom       \
        -o otu.json
# guess the min count of sequences in all samples
#min=`biom summarize-table -i otu.json | grep Min: \
#      | cut -d" " -f3 | cut -d"." -f1`
#echo "reads will be normalized to this number " $min

# shrink every sample to the min # of sequences
#mv otu.json otu.json.raw
#single_rarefaction.py -d $min -i otu.json.raw -o otu.json 

source activate picrust_env

normalize_by_copy_number.py             \
        -i otu.json                     \
        -o norm.json
predict_metagenomes.py                  \
        -i norm.json                    \
        -o predict.json
categorize_by_function.py               \
        -i predict.json                 \
        -c KEGG_Pathways                \
        -l 3                            \
        -o L3.json

biom convert --to-tsv  \
       	-i predict.json -o predict.txt --header-key KEGG_Description
biom convert --to-tsv --header-key KEGG_Pathways \
       	-i L3.json -o L3.txt
