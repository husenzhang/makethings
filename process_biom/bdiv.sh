#!/bin/bash
# works on 7/7/2016.  
# parallel jobs might have problems weird parallel call to picrust/parallel
# single thread fine

# source /macqiime/configs/bash_profile.txt

#min=`biom summarize-table -i data/otu_tax.biom | grep Min: \
#              | cut -d" " -f3 | cut -d"." -f1`
#echo "min nseq is" $min
beta_diversity_through_plots.py -i data/otu_tax.biom   \
			        -o out/bdiv --force    \
                                -t data/rep_set.tre    \
                                -m data/map.txt        \
			        -e 10000                \
                                --suppress_emperor_plots 

