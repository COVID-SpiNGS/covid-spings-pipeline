nextflow.enable.dsl = 2


process setupDirs {

  input:
   path outputDir

  shell:
  """
  rm -rf $projectDir/data && mkdir $projectDir/data
  rm -rf $projectDir/data/human_genome && mkdir $projectDir/data/human_genome
  mkdir -p $projectDir/data/covid
  """
}

process downloadHumanGenome {

  input:
   path outputDir

  shell:
  '''
  for i in {1..22}
    do
      if $i != 0:
      then
        echo $i
        wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr$i.fa.gz" -P "$projectDir/data/human_genome"
        gzip -d "$projectDir/data/humanGenome/chr$i.fa.gz"
      fi
    done
  '''
}

process downloadCovid {

  input:
   path outputDir

  shell:
  '''
  wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=OX463106&rettype=fasta&retmode=text" -O "$projectDir/covid_ref.fasta"
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


process setupNanoSim {
  container = containerOptions
  
  shell:
  """
  git submodule init
  git submodule update
  conda install --file fixed_requirements.txt -c conda-forge -c bioconda --yes
  cd .. 
  """
}
**/

process runNanoSimTrain {

  conda 'nanosim_env.yml'

  input:
  path projectDir
  //path outputDir

  script:
  """
  ls -la $projectDir
  """
}

process runNanoSimTrain2 {

  conda 'nanosim_env.yml'

  input:
  path projectDir
  //path outputDir

  script:
  """
  #rm -rf $projectDir/NanoSim_output/ && mkdir $projectDir/NanoSim_output/ && cd $projectDir/NanoSim_output
  #Train
  $projectDir/modules/simulation/NanoSim/src/read_analysis.py genome -i $projectDir/data/covid/SP-2_R1.fastq -rg $projectDir/data/covid/SARS-CoV-2_MSA_file1.fasta
  """
}

process simulate {
  conda 'nanosim'

  input:
  path projectDir
  //path outputDir
  
  script:
  """
  $projectDir/modules/simulation/NanoSim/src/simulator.py metagenome -gl $projectDir/modules/simulation/config_files/metagenome_covid_human.tsv -dl $projectDir/modules/simulation/config_files/dna_type_list.tsv -a $projectDir/config_files/abundance_covid.tsv
  """
}


