nextflow.enable.dsl = 2

process downloadHumanGenome {

    storeDir "${params.humanGenomeRefDir}"

    input:
    val i

    output:
    path "chr${i}.fa", emit: file

    """
    wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr"$i".fa.gz -P ${params.humanGenomeRefDir}
    gzip -d ${params.humanGenomeRefDir}/chr"$i".fa.gz
    """
}


process downloadCovid {

    storeDir "${params.covidRefDir}"

    output:
    path "${params.covidRefDir}/covid_ref.fasta", emit: file

    """
    wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=OX463106&rettype=fasta&retmode=text" -P "${params.covidRefDir}"
    wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=sra&id=ERX4077913&rettype=fastq&retmode=text" -P "${params.covidRefDir}"
    mv "${params.covidRefDir}/efetch.fcgi?db=nuccore&id=OX463106&rettype=fasta&retmode=text" "${params.covidRefDir}/covid_ref.fasta"
    
    """
}

process setupDataDir {
  
  script:
  """
  if [ ! -d "${params.baseDir}/data" ]; then
  mkdir ${params.baseDir}/data
  fi
  
  """
}

process setupHumanGenomeRefDir {
  
  script:
  """
  if [ ! -d "${params.humanGenomeRefDir}" ]; then
  mkdir ${params.humanGenomeRefDir}
  fi
  """
}

process setupCovidRefDir {

  script:
  """
  if [ ! -d "${params.covidRefDir}" ]; then
  mkdir ${params.covidRefDir}
  fi
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