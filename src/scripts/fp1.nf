#! /usr/bin/env nextflow
nextflow.preview.recursion = true

include { miniMap2 } from '../modules/alignment/miniMap2';
include { samtoolsView; samtoolsMerge; samtoolsSort; samtoolsIndex } from '../modules/utils/samtools';
include { pepperMarginDeepVariant } from '../modules/variantCalling/pepperMarginDeepVariant';

def helpMessage() {
  log.info """
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run fp1.nf -c fp1.config --watch

    Optional arguments:
      --watch                         Watch the input directoy
      --inputDir                      The input directory where .fastq files are written to
      --outputDir                     The directory where the final results are published to
      --exitFile                      Name of the file which terminates the pipe if it appears in the input folder
      --reference                     Name of the .fasta reference file
      --referenceIndex                Name of the .fasta.fai index of the reference .fasta file
      --threads                       Number of threads to be used
      --gpus                          Number of gpus used for variant calling (disables cpu-threading)
      --docker                        Use  docker as container engine instead of singularty 
      --help                          This usage statement
    """
}

workflow mergeSort {
  take: data
  
  main:
    in = data.map {
      it.size <= 2 ? it : [it[0], it[it.size - 1]]
    }

    samtoolsMerge(in)
    samtoolsSort(samtoolsMerge.out)

  emit:
    samtoolsSort.out
}

workflow {
  if(params.watch)
    chInputFiles = Channel.watchPath("${params.inputDir}/*.fastq", 'create').until { it.name == params.exitFile }
  else
    chInputFiles = Channel.fromPath("${params.inputDir}/*.fastq")

  chReference = Channel.value(params.reference)
  chReferenceIndex = Channel.value(params.referenceIndex)

  miniMap2(chInputFiles, chReference)
  samtoolsView(miniMap2.out)

  mergeSort.scan(samtoolsView.out)
  samtoolsIndex(mergeSort.out)


  pepperMarginDeepVariant(
    mergeSort.out,
    samtoolsIndex.out,
    chReference,
    chReferenceIndex
  ).subscribe {
    Date now = new Date()
    String dirName = now.format("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", TimeZone.getTimeZone('UTC'))
    it.mklink("${params.outputDir}/${dirName}")
  }
}