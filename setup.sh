#!/bin/bash

download(){
  wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr"$1".fa.gz" -P .exampleData/humanGenome
}

extract(){
  gzip -d "./humanGenome/chr"$1".fa.gz"
}



#curl -s https://get.nextflow.io | bash
mkdir "exampleData"
mkdir "exampleData"/"humanGenome" && mkdir "exampleData"/"covidReference" #&& cd ./humanGenome


for i in {1..22}
  do
    echo $i
    #download "$i"
    #extract "$i"
  done



#000sudo mkdir /new_simulation_output/#output/train_model.sh && output/simulate.sh -o /new_simulation_output/
#git clone git@github.com:bcgsc/NanoSim.git && fix()

#./nextflow main.nf --wd $PWD
