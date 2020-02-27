#!/usr/bin/env python
"""
taking a mapping file, output a barcode file in 
FASTA format
"""



from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
import csv
import sys

fname = sys.argv[1] # argonne mapping text file
faout = sys.argv[2]

m = open(fname, 'rt')
map = csv.DictReader(m, delimiter='\t')
bc = []

for row in map:
    bcode = row['BarcodeSequence']
    #bc_rev = Seq(bcode).reverse_complement() # barcode R1 according to Owens
    sr = SeqRecord(Seq(bcode), id=row['#SampleID'], name='', 
                   description='',dbxrefs=None)  
    bc.append(sr)

SeqIO.write(bc, faout, 'fasta') 
