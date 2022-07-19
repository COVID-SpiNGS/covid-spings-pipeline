#!/bin/bash

setupDirs(){
  mkdir "data"
  mkdir "data"/"humanGenome" && mkdir "data"/"covidReference"
}

downloadHumanGenome(){

  for i in {1..22}
    do
      echo $i
        wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr"$1".fa.gz" -P .data/humanGenome
        extract "$i"
    done
}

downloadCovidReference(){
  wget "https://storage.googleapis.com/nih-sequence-read-archive/sra-src/SRR12412952/SP-2_R1.fastq.1" -P .data/covidReference
  wget "https://storage.googleapis.com/nih-sequence-read-archive/sra-src/SRR12412952/SP-2_R2.fastq.1" -P .data/covidReference
}

extract(){
  gzip -d "./data/humanGenome/chr"$1".fa.gz"
}

setupNanosim(){

    git submodule init
    git submodule update
    cp fixed_requirements.txt ./NanoSim/requirements.txt
    # Solution for this ??
    #cd NanoSim %% conda create --name nanosim python=3.7
    #conda activate nanosim
    #conda install --file requirements.txt -c conda-forge -c bioconda
    #cd ..
}

setupDirs
#downloadHumanGenome
#downloadCovidReference
setupNanosim
