nextflow.enable.dsl = 2


process setupDirs {

  script:
  """
  rm -rf ${params.baseDir}/data && mkdir ${params.baseDir}/data
  rm -rf ${params.baseDir}/data/human_genome && mkdir ${params.baseDir}/data/human_genome
  mkdir -p ${params.baseDir}/data/covid
  """
}


/*
process downloadCovid {
  script:
  '''
  
  wget "https://storage.googleapis.com/nih-sequence-read-archive/sra-src/SRR12412952/SP-2_R2.fastq.1" -P ./data/covid/
  mv ./data/covid/SP-2_R1.fastq.1 ./data/covid/SP-2_R1.fastq
  mv ./data/covid/SP-2_R2.fastq.1 ./data/covid/SP-2_R2.fastq
  wget "https://files.ca-1.osf.io/v1/resources/jt2n5/providers/osfstorage/5ede595708aad3013143c7f3?action=download&direct&version=3" -P ./data/covid/
  mv ./data/covid/5ede595708aad3013143c7f3?action=download\&direct\&version=3 ./data/covid/SARS-CoV-2_MSA_file1.fasta
  '''
}

**/


process runNanoSimTrain {
  conda 'nanosim_env.yml'

  script:
  """
  #rm -rf ${params.baseDir}/NanoSim_output/ && mkdir ${params.baseDir}/NanoSim_output/ && cd ${params.baseDir}/NanoSim_output
  #Train
  ${params.baseDir}/modules/simulation/NanoSim/src/read_analysis.py genome -i ${params.baseDir}/data/covid/SP-2_R1.fastq -rg ${params.baseDir}/data/covid/covid_ref.fasta
  """
}

process simulate {
  conda '$baseDir/nanosim_env.yml'
  
  script:
  """
  ${params.baseDir}/modules/simulation/NanoSim/src/simulator.py metagenome -gl ${params.baseDir}/modules/simulation/config_files/metagenome_covid_human.tsv -dl ${params.baseDir}/modules/simulation/config_files/dna_type_list.tsv -a ${params.baseDir}/config_files/abundance_covid.tsv
  """
}