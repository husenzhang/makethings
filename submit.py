import pandas as pd
pd.read_excel('Metagenome.environmental.1.0.xlsx')
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=3)
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=7)
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=7)
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=7)
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=9)
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=9)
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=10)
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=11)
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=12)
pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=12).head()
biosample = pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=12).head()
import os
ls
os.listdir('01_fastq_IgA_submit_fastq/')
fastqs = os.listdir('01_fastq_IgA_submit_fastq/')
biosample.head()
biosample['*sample_name'].apply(lambda x: '{}_R1_.fastq.gz'.format(x))
ls 01_fastq_IgA_submit_fastq/555_R1
ls 01_fastq_IgA_submit_fastq/555_R1*
biosample['filename'] = biosample['*sample_name'].apply(lambda x: '{}_R1_.fastq.gz'.format(x))
biosample['filename2'] = biosample['*sample_name'].apply(lambda x: '{}_R2_.fastq.gz'.format(x))
biosample.head()
biosample.tail()
biosample = pd.read_excel('Metagenome.environmental.1.0.xlsx',skiprows=12)
biosample['filename'] = biosample['*sample_name'].apply(lambda x: '{}_R1_.fastq.gz'.format(x))
biosample['filename2'] = biosample['*sample_name'].apply(lambda x: '{}_R2_.fastq.gz'.format(x))
biosample
pd.read_excel('SRA_metadata_acc.xlsx)
pd.read_excel('SRA_metadata_acc.xlsx')
pd.read_excel('SRA_metadata_acc.xlsx', sheet_name='SRA_data')
sra = pd.read_excel('SRA_metadata_acc.xlsx', sheet_name='SRA_data')
biosample.head(1)
who
bioobject = pd.read_csv('BioSampleObjects.txt')
bioobject
bioobject = pd.read_csv('BioSampleObjects.txt', delimiter='\t')
bioobject
sra.head()
biosample.head(10
)
pd.merge(biosample, bioobject, left='*sample_name', right='Sample Name')
biosample.join?
pd.merge?
pd.merge(biosample, bioobject, left_on='*sample_name', right_on='Sample Name')
biosample = pd.merge(biosample, bioobject, left_on='*sample_name', right_on='Sample Name')
sra.head()
biosample['biosample_accession'] = biosample['Accession']
biosample['library_ID'] = biosample['*sample_name']
biosample['title'] = '16s rRNA mouse gut microbiome'
biosample['library_strategy'] = 'AMPLICON'
biosample['library_source'] = 'METAGENOMIC'
biosample['library_selection'] = 'PCR'
biosample['library_layout'] = 'paired'
biosample['platform'] = 'ILLUMINA'
biosample['instrument_model'] = 'Illumina MiSeq'
biosample['design_description'] = 'V4 PCR'
biosample['filetype'] = 'fastq'
biosample['filename']
biosample['filename2']
biosample['filename']
biosample.head()
sra
sra = pd.read_excel('/home/husen/Downloads/SRA_metadata_acc.xlsx', sheet_name='SRA_data')
sra
sra.columns
biosample[sra.columns]
biosample.columns.diff
biosample.columns.difference(sra.columns)
sra.columns.difference(biosample.columns)
sra.columns.intersection(biosample.columns)
biosample[sra.columns.intersection(biosample.columns)]
biosample.shape
history
%history
history > submit.py
pwd
%history > submit.py
%history -g -f submit.py
%history -f submit.py
