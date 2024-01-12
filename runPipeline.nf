#! /usr/bin/env nextflow

nextflow.enable.dsl = 2


include { miniMap2 } from './modules/variantCalling/liveVariantCaller';

nextflow.enable.dsl = 2


workflow {
  create_dirs | run_watcher | run_variant_caller
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