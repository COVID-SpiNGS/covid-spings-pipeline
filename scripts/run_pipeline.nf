#! /usr/bin/env nextflow

nextflow.enable.dsl = 2


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