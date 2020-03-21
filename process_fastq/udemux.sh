#!/bin/bash

index=/scratch/MicrobiomeTest/Amplicon-11-4-15-Full-run-Skin-run_S1_L001_I1_001.fastq
read1=/scratch/MicrobiomeTest/Amplicon-11-4-15-Full-run-Skin-run_S1_L001_R1_001.fastq
read2=/scratch/MicrobiomeTest/Amplicon-11-4-15-Full-run-Skin-run_S1_L001_R2_001.fastq

./usearch8.1.1895M_i86linux64_hz -fastx_demux $read1 -trunclabels -index $index \
 -filename_suffix _R1.fastq -barcodes reverseCompBarcodes.fa -tabbedout report1.txt

./usearch8.1.1895M_i86linux64_hz -fastx_demux $read2 -trunclabels -index $index \
 -filename_suffix _R2.fastq -barcodes reverseCompBarcodes.fa -tabbedout report2.txt
