## in qiime shell, script full/path/to/fastq 

#!/bin/bash
set -e

FASTQ_DIR=$1/*_R1_*
MAX_EE=1.0
MIN_SIZE=5
UCHIME_DB=/home/luolab/dbs/gold.fa
MIN_SAMPLES=2
TAX_MIN_FRAC=0.00005

rm -rf otus; mkdir otus; workdir=otus; cd $workdir

usearch -fastq_mergepairs $FASTQ_DIR -relabel @ -fastqout merged.fastq
usearch -fastq_filter merged.fastq -fastq_maxee $MAX_EE \
	-fastaout seqs.fna -fastq_minlen 245
usearch -derep_fulllength seqs.fna -fastaout seqs.derep.fna -sizeout

usearch -cluster_otus seqs.derep.fna -sizein -minsize $MIN_SIZE \
	-otus rep_set.fa -relabel OTU_

usearch -uchime_ref rep_set.fa -db $UCHIME_DB -strand plus \
        -nonchimeras repset.nochimeras.fa
usearch -usearch_global merged.fastq -db repset.nochimeras.fa \
        -id 0.97 -strand plus -biomout otu.biom
fastqc merged.fastq --threads 4

assign_taxonomy.py -i repset.nochimeras.fa -o . \
                   -m mothur \
                   -r /home/luolab/dbs/CIP_16S_05252017.fasta \
                   -t /home/luolab/dbs/CIP_16S_05252017.tax

align_seqs.py -i repset.nochimeras.fa -o .
filter_alignment.py -i *aligned* -o .
make_phylogeny.py -i *pfiltered* -o rep_set.tre
filter_otus_from_otu_table.py -i otu.biom -o otu.ms.biom \
                              -e *failures* --min_samples $MIN_SAMPLES
biom add-metadata -i otu.ms.biom -o otu_tax.biom \
        --observation-metadata-fp *assignments.txt \
        --sc-separated taxonomy --observation-header OTUID,taxonomy
biom convert -i otu_tax.biom -o otu_tax_classic.txt --to-tsv --header-key taxonomy
summarize_taxa.py -i otu_tax.biom -o . -t -u $TAX_MIN_FRAC -L 2,3,4,5,6,7

mkdir data out
cp otu_tax.biom rep_set.tre data/
