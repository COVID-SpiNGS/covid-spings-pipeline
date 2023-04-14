#! /usr/bin/env nextflow

nextflow.enable.dsl = 2


process splitLetters {
  output:
    path 'chunk_*'

  """
  printf '${params.str}' | split -b 6 - chunk_
  """
}

process convertToUpper {
  input:
    path x
  output:
    stdout

  """
  cat $x | tr '[a-z]' '[A-Z]'
  """
}

process setup_sim {

  """
  ./nextflow run setup_sim.nf
  """
}

process test {

  """
  ls -la
  """
}

process fp1 {

  """
  ./nextflow run fp1.nf
  """
}

process fp2 {

  """
  ./nextflow run fp2.nf
  """
}

workflow {
  test 
}