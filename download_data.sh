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
    echo "The directory human genome is not empty. $HUMAN_GENOME_PATH"
fi


if [ -z "$(ls -A $COVID_PATH)" ]; then
    curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=OX463106&rettype=fasta&retmode=text" -o "$COVID_PATH/covid_ref.fasta"
fi
