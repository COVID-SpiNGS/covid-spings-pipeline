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
    path "covid_ref.fasta", emit: file1
    path "covid_file.fasta", emit: file2

    """
    wget "${params.covidURL1}" -O "${params.covidRefDir}/covid_ref.fasta"
    wget "${params.covidURL2}" -O "${params.covidRefDir}/covid_file.fasta"
    """
}

process createDirs {

  input:
  val dirToCreate
  
  script:
  """
  if [ ! -d "${dirToCreate}" ]; then
  mkdir -p ${dirToCreate}
  fi
  """
}

process runNanoSimTrain {
  conda 'nanosim_env.yml'

  script:
  """
  #rm -rf ${params.nanoSimOutputDir} && mkdir ${params.nanoSimOutputDir} && cd ${params.nanoSimOutputDir}
  #Train -rg ${params.covidRefDir}/covid_ref.fasta
  ${params.nanoSimScriptsDir}/read_analysis.py metagenome -i ${params.covidRefDir}/covid_ref.fasta -gl ${params.nanoSimConfigDir}/metagenome_covid_human.tsv 
  """
}

process simulate {
  conda "${baseDir}/nanosim_env.yml"

  script:
  """
  ${params.nanoSimScriptsDir}/simulator.py metagenome -gl ${params.nanoSimConfigDir}/metagenome_covid_human.tsv -dl ${params.nanoSimConfigDir}/dna_type_list.tsv -a ${params.nanoSimConfigDir}/abundance_covid.tsv
  """
}