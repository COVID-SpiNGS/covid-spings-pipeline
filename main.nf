#! /usr/bin/env nextflow
nextflow.enable.dsl = 2


include { miniMap2 } from './modules/alignment/miniMap2';
include { samtoolsSamToBam; samtoolsMerge } from './modules/utils/samtools';
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
  samtoolsSamToBam(miniMap2.out)

  chSamtoolsMergeInput = samtoolsSamToBam.out
    .map { [it, Paths.get("${params.publishDir}/${params.bamFile}")] }
    .map { [it[0], it[1], !firstRead] }
    .map { 
      firstRead = false
      it
    }

  samtoolsMerge(chSamtoolsMergeInput)

  pepperMarginDeepVariant(
    // samtoolsMerge.out[0].reduce { a, b -> b },
    // samtoolsMerge.out[1].reduce { a, b -> b },
    samtoolsMerge.out[0],
    samtoolsMerge.out[1],
    chReference,
    chReferenceIndex
  )
}