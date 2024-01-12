#! /usr/bin/env nextflow

nextflow.enable.dsl = 2


process setupDirs {

  shell:
  """
  mkdir data
  mkdir ./data/human_genome
  mkdir ./data/covid
  cd data
  pwd
  """
}

process downloadHumanGenome {

  shell:
  '''
  for i in {1..22}
    do
      if $i != 0:
      then
        echo $i
        wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr$i.fa.gz" -P ./data/human_genome
        gzip -d "./data/humanGenome/chr$i.fa.gz"
      fi
    done
  '''
}

process downloadCovid {

  shell:
  '''
  wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=OX463106&rettype=fasta&retmode=text" -O covid_ref.fasta
  '''
}

/**
process downloadCovid {
  shell:
  '''
  
  wget "https://storage.googleapis.com/nih-sequence-read-archive/sra-src/SRR12412952/SP-2_R2.fastq.1" -P ./data/covid/
  mv ./data/covid/SP-2_R1.fastq.1 ./data/covid/SP-2_R1.fastq
  mv ./data/covid/SP-2_R2.fastq.1 ./data/covid/SP-2_R2.fastq
  wget "https://files.ca-1.osf.io/v1/resources/jt2n5/providers/osfstorage/5ede595708aad3013143c7f3?action=download&direct&version=3" -P ./data/covid/
  mv ./data/covid/5ede595708aad3013143c7f3?action=download\&direct\&version=3 ./data/covid/SARS-CoV-2_MSA_file1.fasta
  '''
}

process setupNanosim {
  
  shell:
  """
  git submodule init
  git submodule update
  eval $(conda shell.bash hook)
  conda create --name nanosim python=3.7 --yes
  conda activate nanosim && conda install --file fixed_requirements.txt -c conda-forge -c bioconda --yes
  cd .. && conda activate base
  """
}
**/

process installConda {
  
  shell:
  """
  ENV CONDA_DIR /opt/conda
  RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
      /bin/bash ~/miniconda.sh -b -p /opt/conda
  ENV PATH=$CONDA_DIR/bin:$PATH
  """
}




process prepare_simulation {

  script:
  """
  eval "$(conda shell.bash hook)"
  conda activate nanosim

  data_dir="$(dirname $(realpath $0) )"
  echo $data_dir

  mkdir ./"NanoSim_output"/ && cd NanoSim_output
  #Train
  ../NanoSim/src/read_analysis.py genome -i "$data_dir/data/covid/SP-2_R1.fastq" -rg "$data_dir/data/covid/SARS-CoV-2_MSA_file1.fasta"
  """




}

process simulate {

  script:
  """
  #Simulate
  #../NanoSim/src/simulator.py metagenome -gl "$data_dir/config_files/metagenome_covid_human.tsv" -dl "$data_dir/config_files/dna_type_list.tsv" -a "$data_dir/config_files/abundance_covid.tsv"
  """

}


workflow { 
  setupDirs | downloadHumanGenome | downloadCovid | installConda | prepare_simulation | simulate
}
