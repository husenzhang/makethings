#!/usr/bin/env perl

use strict;
use vars qw($opt_f $opt_c $opt_o $opt_p);
use Cwd;
use Getopt::Std;
use FindBin ();

getopts("f:c:o:p:");
my $usage = "\nUSAGE:
perl $0
	-f <full path of directory containing paired fastq files)>
	-o <name of output dir>
	[-p <number of processors> default=4]
	[-c <config file with configurable parameters> default=$FindBin::Bin/process_16S_default.config]


	This script will do the following:
	- run the usearch-qiime core pipeline on the paired fastq files found in the provided directory
	- process the data according to prescribed / optimised recommendations
	- creates output directory using provided name
	- use the config file for tweakable parameters for the various steps in the process
	
	Please note the following:
	- '$FindBin::Bin/process_16S_default.config' is used as the default config file
	- due to module dependencies; this script currently only functions when user is logged into the NIH Biowulf HPC system
	
Example:
perl $0
		-f /data/MicrobiomeCore/runs/20160701/Control-31372356/
		-o /scratch/thovaraivv/test_out
		-c /data/MicrobiomeCore/scripts/process_16S_default.config
		-p 20
";


if(!(
	defined($opt_f) &&
	defined($opt_o))){
		print STDERR $usage;
		exit();
}

if(!(defined($opt_c))){
		$opt_c = "$FindBin::Bin/process_16S_default.config";
}

if(!(defined($opt_p))){
		$opt_p = 4;
}

######################
# Assigning variables 

my $fastq_dir=$opt_f."/*_R1_*.fastq";
my $out_dir=$opt_o."/";
my $config_file=$opt_c;
my $commands="commands.sh";
my $config_hash_ref = readConfig($config_file);


###########
# Set up

# check if output directory already exists
if(-e $out_dir){
    print STDERR "\nThe following output directory already exists.\n\t$out_dir\n";
    print STDERR "Please enter a new directory name to avoid overwriting existing data.\nQuitting . . .\n";
    die;
}
create_dir($out_dir);
chdir $out_dir or die "Can't chdir to $out_dir:$!\n" if $out_dir;

print "\nSOURCING INPUT FASTQ FILES FROM:\n\t$fastq_dir\n";
print "\nWRITING TO:\n\t$out_dir\n";
print "\nUSING CONFIG FILE:\n\t$config_file\n";


##########################
# build shell command file

# load modules
my $commands_string = "#!/bin/bash \nset -e";
$commands_string .= "\n\nmodule unload qiime
					module unload biom-format
					module load usearch/8.1.1831
					module load fastqc";

# usearch commands
$commands_string .= "\n\nusearch -fastq_mergepairs $fastq_dir -relabel @ -fastqout merged.fastq
						usearch -fastq_filter merged.fastq -fastq_maxee $config_hash_ref->{'max_ee'} -fastaout seqs.fna
						usearch -derep_fulllength seqs.fna -fastaout seqs.derep.fna -sizeout
						usearch -cluster_otus seqs.derep.fna -sizein -minsize $config_hash_ref->{'min_size'} -otus rep_set.fa -relabel OTU_
						usearch -uchime_ref rep_set.fa -db $config_hash_ref->{'uchime_db'} -strand plus -nonchimeras repset.nochimeras.fa
						usearch -usearch_global merged.fastq -db repset.nochimeras.fa -id 0.97 -strand plus -biomout otu.biom
						fastqc merged.fastq --threads 4";

# qiime commands
$commands_string .= "\n\nmodule unload usearch
						module load qiime/1.9.1";

if (exists $config_hash_ref->{'ref_db'}){
	print "\nUSING TAXONOMIC DATABASE: \n$config_hash_ref->{'ref_db'}\n";
	$commands_string .= "\nassign_taxonomy.py -m mothur -i repset.nochimeras.fa -o . -r $config_hash_ref->{'ref_db'} -t $config_hash_ref->{'ref_tax'} ";
}
else {
	print "\nUSING DEFAULT GREENGENES TAXONOMIC DATABASE..\n";
	$commands_string .= "\nassign_taxonomy.py -i repset.nochimeras.fa -o . ";
}
if (exists $config_hash_ref->{'min_consensus_fraction'}){
	print "\nUSING USER SPECIFIED THRESHOLD SETTINGS FOR TAXONOMIC ASSIGNMENTS..\n";
	$commands_string .= " --min_consensus_fraction $config_hash_ref->{'min_consensus_fraction'} --similarity $config_hash_ref->{'similarity'} ";
}
if (exists $config_hash_ref->{'e_val'}){
	print "\nUSING BLAST FOR TAXONOMIC ASSIGNMENTS..\n";
	$commands_string .= " -m blast --blast_e_value $config_hash_ref->{'e_val'} ";
}

$commands_string .= "\nalign_seqs.py -i repset.nochimeras.fa -o .
						filter_alignment.py -i *aligned* -o .
						make_phylogeny.py -i *pfiltered* -o rep_set.tre
						filter_otus_from_otu_table.py -i otu.biom -o otu.ms.biom -e *failures* --min_samples $config_hash_ref->{'min_samples'}
						biom add-metadata -i otu.ms.biom -o otu_tax.biom --observation-metadata-fp *assignments.txt --sc-separated taxonomy --observation-header OTUID,taxonomy
						biom convert -i otu_tax.biom -o otu_tax_classic.txt --to-tsv --header-key taxonomy
						summarize_taxa.py -i otu_tax.biom -o . -t -u $config_hash_ref->{'tax_min_frac'}
						summarize_taxa_through_plots.py -i otu_tax.biom -o taxa_summary/ --sort
						rm -f otu.ms.biom
						biom summarize-table -i otu_tax.biom -o otu_tax_biom_summary.txt
						biom convert --to-json -i otu_tax.biom -o out_tax.json ";

$commands_string=~s/[\t]+//g;	

##########################
# run command shell file

open(CMD, ">$commands") || die "Could not open $commands ($!)\n";
print CMD "$commands_string";
close (CMD);
chmod 0755, $commands;


##########################
# set up sbatch job

my $cmd_str = "sbatch --cpus-per-task=$opt_p $commands";
print "\nLAUNCHING COMMAND SCRIPT ON $opt_p PROCESSORS:\n\t$out_dir$commands\n";						
exec_cmd($cmd_str);


##############################################################################
# executes command string in unix shell

sub exec_cmd{
	my $cmd=shift;
	$cmd=~s/[\t]+/ /g;
	print STDERR "EXECUTING:\n\t$cmd\n";
	system($cmd);
}


##############################################################################
# creates dir

sub create_dir{

    my $dir=shift;

    if(-e $dir){
	    print STDOUT "Directory $dir already exists. Using it.\n";
    }else{
	    mkdir $dir;
	    if(-e $dir){
		    print STDERR "$dir has been created.\n";	
	    }else{
		    die "Could not create $dir.\n";
	    }
    }
}

##############################################################################
# reads config file

sub readConfig{
    my $config = shift;
    my %config_hash;
	my $comment = "#";
    open(CF, "<$config") || die "Could not open $config($!)\n";
    while (<CF>){
		if((!/^$comment/) && (/(\S+)=(\S+)/)){
			$config_hash{$1} = $2;
		}
    }
    return \%config_hash;
}
