#! /usr/bin/env nextflow
nextflow.enable.dsl = 2


include { miniMap2 } from './modules/alignment/miniMap2';
include { samtoolsView; samtoolsMergeSortIndex } from './modules/utils/samtools';
include { pepperMarginDeepVariant } from './modules/variantCalling/pepperMarginDeepVariant';

import java.nio.file.Paths;

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


workflow {
  Boolean firstRead = true

  // chInputFiles = Channel.watchPath(params.watchPath, 'create').until { it.name == 'exit.fastq' }
  chInputFiles = Channel.fromPath(params.watchPath)
  chReference = Channel.value(params.reference)
  chReferenceIndex = Channel.value(params.referenceIndex)


  miniMap2(chInputFiles, chReference)
  samtoolsView(miniMap2.out)

  chSamtoolsMergeSortIndexInput = samtoolsView.out
    .map { [it, Paths.get("${params.publishDir}/${params.bamFile}")] }
    .map { [it[0], it[1], !firstRead] }
    .map { 
      firstRead = false
      it
    }

  samtoolsMergeSortIndex(chSamtoolsMergeSortIndexInput)

  pepperMarginDeepVariant(
    // samtoolsMergeSortIndex.out[0].reduce { a, b -> b },
    // samtoolsMergeSortIndex.out[1].reduce { a, b -> b },
    samtoolsMergeSortIndex.out[0],
    samtoolsMergeSortIndex.out[1],
    chReference,
    chReferenceIndex
  )
}