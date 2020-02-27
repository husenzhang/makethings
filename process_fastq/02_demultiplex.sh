#!/bin/bash

index=Undetermined_S0_L001_I1_001.fastq
read1=Undetermined_S0_L001_R1_001.fastq
read2=Undetermined_S0_L001_R2_001.fastq
bcodes=barcodes.fa


usearch8.1.1895M_i86linux64_hz_demux -fastx_demux $read1 -trunclabels -index $index \
 -filename_suffix _R1_.fastq -barcodes $bcodes -tabbedout report_R1.txt

usearch8.1.1895M_i86linux64_hz_demux -fastx_demux $read2 -trunclabels -index $index \
 -filename_suffix _R2_.fastq -barcodes $bcodes -tabbedout report_R2.txt
