#! /usr/bin/env nextflow


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
process test {

  """
  ./nextflow run test.nf
  """
}


workflow {
  test
}