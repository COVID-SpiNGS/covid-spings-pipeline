process miniMap2 {
  maxForks params.threads
  container 'docker://staphb/minimap2:2.24'

  input:
    path('input.fastq')
    path('reference.fasta')

  output: 
    file('output.sam')

  script:
    """
      minimap2 -t 1 -ax map-ont reference.fasta input.fastq > output.sam
    """
}
