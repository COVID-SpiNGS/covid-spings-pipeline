#!/bin/bash


mkdir ./"NanoSim_output"/ && cd NanoSim_output


data_dir="$(dirname $(realpath $0) )"
echo $data_dir

#Train
#../NanoSim/src/read_analysis.py genome -i "$data_dir/data/covid/SP-2_R1.fastq" -rg "$data_dir/data/covid/SARS-CoV-2_MSA_file1.fasta"
#Simulate
#../NanoSim/src/simulator.py metagenome -gl "$data_dir/config_files/metagenome_covid_human.tsv" -dl "$data_dir/config_files/dna_type_list.tsv" -a "$data_dir/config_files/abundance_covid.tsv"
