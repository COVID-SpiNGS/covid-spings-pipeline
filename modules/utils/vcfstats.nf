process vcfstats {
  maxForks 1
  container params.singularity ? 'docker://justold/vcfstats:0.4.0' : 'justold/vcfstats:0.4.0'
  publishDir params.publishDir, mode: 'copy'

  input:
    path('input.vcf')
    
  output:
    path('statistics')

  script:
    """
      vcfstats                                          \
        --vcf input.vcf                                 \
        --outdir statistics                             \
        --formula 'COUNT(1) ~ CONTIG'                   \
        --title Test
    """
}