#! /usr/bin/env nextflow
nextflow.enable.dsl = 2


include { miniMap2 } from './modules/alignment/miniMap2';
include { samtoolsView; samtoolsSort; samtoolsIndex } from './modules/utils/samtools';
include { bcftoolsView; bcftoolsView as gBcftoolsView } from './modules/utils/bcftools';
include { pepperMarginDeepVariantNoPublish } from './modules/variantCalling/pepperMarginDeepVariant';


def helpMessage() {
  log.info """
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run fp1.nf -c fp1.config

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



vcfList = file("${params.publishDir}/${params.vcfList}")
vcfList.text = ''

bcfList = file("${params.publishDir}/${params.bcfList}")
bcfList.text = ''

gVcfList = file("${params.publishDir}/${params.gVcfList}")
gVcfList.text = ''

gBcfList = file("${params.publishDir}/${params.gBcfList}")
gBcfList.text = ''

workflow {
  // chInputFiles = Channel.watchPath(params.watchPath, 'create').until { it.name == 'exit.fastq' }
  chInputFiles = Channel.fromPath(params.watchPath)
  chReference = Channel.value(params.reference)
  chReferenceIndex = Channel.value(params.referenceIndex)
  chBcfList = Channel.watchPath("${params.publishDir}/${params.bcfList}")

  miniMap2(chInputFiles, chReference)
  samtoolsView(miniMap2.out)
  samtoolsSort(samtoolsView.out)
  samtoolsIndex(samtoolsSort.out)

  pepperMarginDeepVariantNoPublish(
    samtoolsSort.out,
    samtoolsIndex.out,
    chReference,
    chReferenceIndex
  )

  bcftoolsView(pepperMarginDeepVariantNoPublish.out[0])
  pepperMarginDeepVariantNoPublish.out[0].subscribe { vcfList.append("${it}\n") }
  bcftoolsView.out.subscribe { bcfList.append("${it}\n") }

  gBcftoolsView(pepperMarginDeepVariantNoPublish.out[2])
  pepperMarginDeepVariantNoPublish.out[2].subscribe { gVcfList.append("${it}\n") }
  gBcftoolsView.out.subscribe { gBcfList.append("${it}\n") }
}