import pandas as pd
import os

"""
three (3) excel files needed before starting the process
"""

keep_columns = ['*sample_name', 'bioproject_accession']


## 1. biosample excel download
biosample = pd.read_excel('Metagenome.environmental.1.0.xlsx',
                           skiprows=12,
                           dtype=str)

biosample = biosample[keep_columns]

## 2. SAMN email attachment
bioobject = pd.read_csv('BioSampleObjects.txt', delimiter='\t')

## 3. SRA submit download
sra = pd.read_excel('SRA_metadata_acc.xlsx', sheet_name='SRA_data')

biosample = pd.merge(biosample, bioobject, left_on='*sample_name', right_on='Sample Name')


# build sra columns
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
biosample['filename'] = biosample['*sample_name'].apply(lambda x: '{}_R1_.fastq.gz'.format(x))
biosample['filename2'] = biosample['*sample_name'].apply(lambda x: '{}_R2_.fastq.gz'.format(x))

print(biosample[sra.columns.intersection(biosample.columns)])
