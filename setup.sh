#!/bin/bash

download(){
  wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr"$1".fa.gz" -P .exampleData/humanGenome
}

extract(){
  gzip -d "./humanGenome/chr"$1".fa.gz"
}

setupNanosim(){

    #git clone https://github.com/bcgsc/NanoSim.git &&
    mv requirements.txt ./NanoSim/requirements.txt
    #cd NanoSim %% conda create --name nanosim python=3.7
    #conda activate nanosim
    #conda install --file requirements.txt -c conda-forge -c bioconda
    #cd ..
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
setupNanosim

#./nextflow main.nf --wd $PWD
