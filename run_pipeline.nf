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
  ls -la
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
  test | setup_sim
}