#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

//include { miniMap2 } from './modules/alignment/miniMap2';
//include { samtoolsView; samtoolsSort; samtoolsIndex } from './modules/utils/samtools';
//include { bcftoolsView; bcftoolsView as gBcftoolsView } from './modules/utils/bcftools';
//include { pepperMarginDeepVariantNoPublish } from '/modules/variantCalling/pepperMarginDeepVariant';


process setup_sim {
  script:
  """
  ./nextflow run setup_sim.nf
  """
}

process test {
  output:
    stdout
  script:
  """
  pwd
  """
}

process fp1 {

  script:
  """
  
  ./nextflow run fp1.nf
  """
}

process fp2 {
  script:
  """
  
  ./nextflow run fp2.nf
  """
}

workflow {
  result = test()
  result.view { "Result: ${it}" }
}