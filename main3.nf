#! /usr/bin/env nextflow
nextflow.enable.dsl = 2


include { bcftoolsView; bcftoolsConcat; bcftoolsMerge } from './modules/utils/bcftools';

def helpMessage() {
  log.info """
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run main.nf

    Mandatory arguments:

    Optional arguments:
      --watchPath
      --reference
      --referenceIndex

      --publishDir
      --bamFile
      --bamIndexFile
      --help                         This usage statement.
    """
}

bcfList = file("${params.publishDir}/${params.bcfList}")

workflow {
  bcftoolsConcat(bcfList)
}