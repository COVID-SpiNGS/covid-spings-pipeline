nextflow.enable.dsl = 2


process setupDirs {

  script:
  """
  rm -rf ${params.baseDir}/data && mkdir ${params.baseDir}/data
  rm -rf ${params.baseDir}/data/human_genome && mkdir ${params.baseDir}/data/human_genome
  mkdir -p ${params.baseDir}/data/covid
  """
}



process runNanoSimTrain {
  conda 'nanosim_env.yml'

  script:
  """
  #rm -rf ${params.baseDir}/NanoSim_output/ && mkdir ${params.baseDir}/NanoSim_output/ && cd ${params.baseDir}/NanoSim_output
  #Train -rg ${params.baseDir}/data/covid/covid_ref.fasta
  ${params.baseDir}/modules/simulation/NanoSim/src/read_analysis.py metagenome -i ${params.baseDir}/data/covid/covid_ref.fasta -gl ${params.baseDir}/modules/simulation/config_files/metagenome_covid_human.tsv 
  """
}

process simulate {
  conda '$baseDir/nanosim_env.yml'
  
  script:
  """
  ${params.baseDir}/modules/simulation/NanoSim/src/simulator.py metagenome -gl ${params.baseDir}/modules/simulation/config_files/metagenome_covid_human.tsv -dl ${params.baseDir}/modules/simulation/config_files/dna_type_list.tsv -a ${params.baseDir}/config_files/abundance_covid.tsv
  """
}