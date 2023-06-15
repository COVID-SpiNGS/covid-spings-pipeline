#!/bin/bash

HUMAN_GENOME_PATH=$1/human_genome
COVID_PATH=$1/covid

if [ -z "$(ls -A $HUMAN_GENOME_PATH)" ]; then
    for i in {1..22}
    do
      echo $i
      wget "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr"$i".fa.gz" -P "$HUMAN_GENOME_PATH"
      gzip -d "$1/human_genome/chr"$i".fa.gz"
    done
else
    echo "The directory $HUMAN_GENOME_PATH is not empty."
fi


if [ -z "$(ls -A $COVID_PATH)" ]; then
    wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=OX463106&rettype=fasta&retmode=text" -P "$COVID_PATH"
    wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=sra&id=ERX4077913&rettype=fastq&retmode=text" -P "$COVID_PATH"
    mv $COVID_PATH/efetch.fcgi?db=nuccore\&id=OX463106\&rettype=fasta\&retmode=text $COVID_PATH/covid_ref.fasta
    
    #curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=OX463106&rettype=fastq&retmode=text" -o "$COVID_PATH/covid2.fast"
    
    
    #wget "https://storage.googleapis.com/nih-sequence-read-archive/sra-src/SRR12412952/SP-2_R2.fastq.1" -P $COVID_PATH/
    #mv $COVID_PATH/SP-2_R1.fastq.1 $COVID_PATH/SP-2_R1.fastq
    #mv $COVID_PATH/SP-2_R2.fastq.1 $COVID_PATH/SP-2_R2.fastq
    #wget "https://files.ca-1.osf.io/v1/resources/jt2n5/providers/osfstorage/5ede595708aad3013143c7f3?action=download&direct&version=3" -P $COVID_PATH/
    #mv $COVID_PATH/5ede595708aad3013143c7f3?action=download\&direct\&version=3 $COVID_PATH/SARS-CoV-2_MSA_file1.fasta
else
    echo "The directory $COVID_PATH is not empty"

fi
