process setupDirs {
  
  input:
   path outputDir

  shell:
  """
  rm -rf $outputDir/data && mkdir $outputDir/data
  rm -rf $outputDir/data/human_genome && mkdir $outputDir/data/human_genome
  mkdir -p $outputDir/data/covid
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
        wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr$i.fa.gz" -P "$outputDir/data/human_genome"
        gzip -d "$outputDir/data/humanGenome/chr$i.fa.gz"
      fi
    done
  '''
}

process downloadCovid {

  input:
   path outputDir

  shell:
  '''
  wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=OX463106&rettype=fasta&retmode=text" -O "$outputDir/covid_ref.fasta"
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
**/

process setupNanoSim {
  
  shell:
  """
  git submodule init
  git submodule update
  conda install --file fixed_requirements.txt -c conda-forge -c bioconda --yes
  cd .. 
  """
}


process runNanoSimTrain {

  input:
   path outputDir

  script:
  """
  pwd
  rm -rf $outputDir/NanoSim_output/ && mkdir $outputDir/NanoSim_output/ && cd $outputDir/NanoSim_output
  #Train
  /NanoSim/src/read_analysis.py genome -i $outputDir/data/covid/SP-2_R1.fastq -rg $outputDir/data/covid/SARS-CoV-2_MSA_file1.fasta
  """
}

process simulate {

  input:
   path outputDir
  
  script:
  """
  /NanoSim/src/simulator.py metagenome -gl $outputDir/config_files/metagenome_covid_human.tsv -dl $outputDir/config_files/dna_type_list.tsv -a $outputDir/config_files/abundance_covid.tsv
  """
}


