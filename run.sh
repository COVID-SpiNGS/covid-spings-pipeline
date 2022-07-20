#!/bin/bash


mkdir ./"NanoSim_output"/ && cd NanoSim_output

#Train
../NanoSim/src/read_analysis.py genome -i ../data/covid/SP-2_R1.fastq -rg ../data/covid/SARS-CoV-2_MSA_file1.fasta
#Simulate
#../NanoSim/src/simulator.py metagenome -gl ../config_files/metagenome_covid_human.tsv -dl ../config_files/dna_type_list.tsv -a ../config_files/abundance_covid.tsv
