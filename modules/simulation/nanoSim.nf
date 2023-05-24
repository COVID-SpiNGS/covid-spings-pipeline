nextflow.enable.dsl = 2


process setupDirs {

  input:
   path projectDir

  script:
  """
  rm -rf $projectDir/data && mkdir $projectDir/data
  rm -rf $projectDir/data/human_genome && mkdir $projectDir/data/human_genome
  mkdir -p $projectDir/data/covid
  """
}



process downloadHumanGenome1 {

  input:
  path projectDir

  script:
  """
  # Bash script with a for loop
  for index in {1..5}; do
    echo "Iteration: \$index"
    # Your commands for each iteration
    echo "Output from iteration \$index"
  done
  """

}

process downloadHumanGenome {

  input:
  path downloadDir

  script:
  """
  for i in {1..22}; do
      if \$i != 0:
      then
        echo \$i
        wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr"\$i".fa.gz" -P "$downloadDir/human_genome"
        gzip -d $downloadDir/humanGenome/chr"\$i".fa.gz
      fi
    done
  """
}



/**
process downloadHumanGenome {

  input:
   path projectDir

  script:
  """
  for i in {1..22}
    do
      if $i != 0:
      then
        echo $i
        wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr$i.fa.gz" -P "$projectDir/data/human_genome"
        gzip -d $projectDir/data/humanGenome/chr"$i".fa.gz
      fi
    done
  """
}
**/


process downloadCovid {

  input:
  path downloadDir

  output:
  file '\$downloadDir/covid/covid_ref.fasta'

  script:
  """
  wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=OX463106&rettype=fasta&retmode=text" -O $downloadDir/covid/covid_ref.fasta
  sleep 2
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

  input:
  path projectDir
  //path outputDir

  script:
  """
  #rm -rf $projectDir/NanoSim_output/ && mkdir $projectDir/NanoSim_output/ && cd $projectDir/NanoSim_output
  #Train
  $projectDir/modules/simulation/NanoSim/src/read_analysis.py genome -i $projectDir/data/covid/SP-2_R1.fastq -rg $projectDir/data/covid/covid_ref.fasta
  """
}

process simulate {
  conda 'nanosim_env.yml'

  input:
  path projectDir
  //path outputDir
  
  script:
  """
  $projectDir/modules/simulation/NanoSim/src/simulator.py metagenome -gl $projectDir/modules/simulation/config_files/metagenome_covid_human.tsv -dl $projectDir/modules/simulation/config_files/dna_type_list.tsv -a $projectDir/config_files/abundance_covid.tsv
  """
}


