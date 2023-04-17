#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

process setupDirs {
  """
  mkdir "data"
  mkdir "data"/"humanGenome" && mkdir "data"/"covid"
  """
}

process downloadHumanGenome {
  """
  for i in {1..22}
    do
      echo $i
        wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr"$i".fa.gz" -P .data/humanGenome
        gzip -d "./data/humanGenome/chr"$i".fa.gz"
    done
  """
}

process downloadCovid {
    """
    wget \"https://storage.googleapis.com/nih-sequence-read-archive/sra-src/SRR12412952/SP-2_R1.fastq.1\" -P ./data/covid/
    wget \"https://storage.googleapis.com/nih-sequence-read-archive/sra-src/SRR12412952/SP-2_R2.fastq.1\" -P ./data/covid/
    mv ./data/covid/SP-2_R1.fastq.1 ./data/covid/SP-2_R1.fastq
    mv ./data/covid/SP-2_R2.fastq.1 ./data/covid/SP-2_R2.fastq
    wget \"https://files.ca-1.osf.io/v1/resources/jt2n5/providers/osfstorage/5ede595708aad3013143c7f3?action=download&direct&version=3\" -P ./data/covid/
    mv ./data/covid/5ede595708aad3013143c7f3?action=download\&direct\&version=3 ./data/covid/SARS-CoV-2_MSA_file1.fasta
    """
}


process setupNanosim {
    """
    git submodule init
    git submodule update
    eval \"$(conda shell.bash hook)\"
    conda create --name nanosim python=3.7 --yes
    conda activate nanosim && conda install --file fixed_requirements.txt -c conda-forge -c bioconda --yes
    cd .. && conda activate base
    """
}


workflow {
  setupDirs | downloadHumanGenome
