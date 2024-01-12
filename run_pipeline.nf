#! /usr/bin/env nextflow

nextflow.enable.dsl = 2


include { miniMap2 } from './modules/variantCalling/liveVariantCaller';

nextflow.enable.dsl = 2


process runWatcher {
  output:
    stdout
  script:
  """
  pwd
  """
}

process runVariantCaller {

  script:
  """
  
  ./nextflow run fp1.nf
  """
}


/**  
process fp2 {
  script:
  """
  
  ./nextflow run fp2.nf
  """
}
**/


workflow {
  runWatcher()
  runVariantCaller()

  //result = test()
  //result.view { "Result: ${it}" }
}
#! /usr/bin/env nextflow

nextflow.enable.dsl = 2


include { miniMap2 } from './modules/variantCalling/liveVariantCaller';

nextflow.enable.dsl = 2


process runWatcher {
  output:
    stdout
  script:
  """
  pwd
  """
}

process runVariantCaller {

  script:
  """
  
  ./nextflow run fp1.nf
  """
}


/**  
process fp2 {
  script:
  """
  
  ./nextflow run fp2.nf
  """
}
**/


workflow {
  runWatcher()
  runVariantCaller()

  //result = test()
  //result.view { "Result: ${it}" }
}