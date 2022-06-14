#! /usr/bin/env nextflow
nextflow.enable.dsl = 2


include { miniMap2 } from './modules/alignment/miniMap2';
include { samtoolsView; samtoolsMerge } from './modules/utils/samtools';
include { pepperMarginDeepVariant } from './modules/variantCalling/pepperMarginDeepVariant';

import java.nio.file.Paths;

def helpMessage() {
  log.info """
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run fp1.nf -c fp1.config

    Optional arguments:
      --noWatch                       Instead of watching the inputDir read all files of it once (good for testing purposes)
      --inputDir                      The input directory where .fastq files are written to
      --outputDir                     The directory where the final results are published to
      --exitFile                      Name of the file which terminates the pipe if it appears in the input folder
      --reference                     Name of the .fasta reference file
      --referenceIndex                Name of the .fasta.fai index of the reference .fasta file
      --bamFile                       Name of the merged .bam file
      --bamIndexFile                  Name of the .bam.bai index of the merged .bam file
      --threads                       Number of threads to be used
      --gpus                          Number of gpus used for variant calling (disables cpu-threading)
      --singularity                   Use singularty as container engine 
      --help                          This usage statement
    """
}


workflow {
  Boolean firstRead = true

  if(!params.noWatch)
    chInputFiles = Channel.fromPath("${params.inputDir}/*.fastq")
  else
    chInputFiles = Channel.watchPath("${params.inputDir}/*.fastq", 'create').until { it.name == params.exitFile }

  chReference = Channel.value(params.reference)
  chReferenceIndex = Channel.value(params.referenceIndex)


  miniMap2(chInputFiles, chReference)
  samtoolsView(miniMap2.out)

  chSamtoolsMergeInput = samtoolsView.out
    .map { [it, Paths.get("${params.publishDir}/${params.bamFile}")] }
    .map { [it[0], it[1], !firstRead] }
    .map { 
      firstRead = false
      it
    }

  samtoolsMerge(chSamtoolsMergeInput)

  pepperMarginDeepVariant(
    samtoolsMerge.out[0],
    samtoolsMerge.out[1],
    chReference,
    chReferenceIndex
  )
}