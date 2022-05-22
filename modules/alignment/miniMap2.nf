process miniMap2 {
  maxForks 1
  container 'docker://staphb/minimap2:2.24'

  input:
    path('input.fastq')
    path('reference.fasta')

  output: 
    file('output.sam')

  script:
    """
      minimap2 -t ${params.threads} -ax map-ont reference.fasta input.fastq > output.sam
    """
}
