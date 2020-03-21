# works only with "wide" form biom or txt
# ------- may need to change "-c" 
#!/bin/bash

source /macqiime/configs/bash_profile.txt

for f in out/taxbysample/otu_tax*.txt
do 
   group_significance.py -m data/map.txt   \
			 -c milk  \
			 -i $f         \
			 -o $f.sig    \
                         --biom_samples_are_superset
done
