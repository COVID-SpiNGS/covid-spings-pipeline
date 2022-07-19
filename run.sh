#!/bin/bash

mkdir ./simulation_output/



./NanoSim/src/read_analysis.py genome -i ./data/MT-MTPHL-3995074_R1.fastq -rg ./data/SARS-CoV-2_MSA_file1.fasta



#output/train_model.sh &&/home/vickylara/Documents/Covid-SpiNGS/NanoSim/src/simulator.py metagenome -gl /home/vickylara/Documents/Covid-SpiNGS/NanoSim/config_files/metagenome_covid_human.tsv -dl /home/vickylara/Documents/Covid-SpiNGS/NanoSim/config_files/dna_type_list.tsv -a /home/vickylara/Documents/Covid-SpiNGS/NanoSim/config_files/abundance_covid_extreme_case.tsv -o new_extreme_simulated_covid -t 8&& duration=$SECONDS && echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." >> log.txt &&
output/simulate.sh -o /new_simulation_output/


/home/vickylara/Documents/Covid-SpiNGS/NanoSim/src/simulator.py metagenome -gl ./config_files/metagenome_covid_human.tsv -dl /home/vickylara/Documents/Covid-SpiNGS/NanoSim/config_files/dna_type_list.tsv -a /home/vickylara/Documents/Covid-SpiNGS/NanoSim/config_files/abundance_covid_extreme_case.tsv -o new_extreme_simulated_covid -t 8&& duration=$SECONDS && echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed." >> log.txt &&
