process bcftoolsView {
  maxForks 1
  container params.singularity ? 'docker://staphb/bcftools:1.15' : 'staphb/bcftools:1.15'

  input:
    path('input.vcf.gz')
    
  output:
    file('output.bcf')

  script:
    """
      bcftools view input.vcf.gz -o output.bcf 
    """
}

process bcftoolsConcat {
  maxForks 1
  container params.singularity ? 'docker://staphb/bcftools:1.15' : 'staphb/bcftools:1.15'
  publishDir params.publishDir, mode: 'copy'

  input:
    path('list.txt')
    
  output:
    file('output.bcf')

  script:
    """
      bcftools concat        \
        --file-list list.txt \
        --output output.bcf
    """
}

process bcftoolsMerge {
  maxForks 1
  container params.singularity ? 'docker://staphb/bcftools:1.15' : 'staphb/bcftools:1.15'
  publishDir params.publishDir, mode: 'copy'

  input:
    path('list.txt')
    
  output:
    file('output.bcf')

  script:
    """
      bcftools merge           \
        --file-list list.txt   \
        --output output.bcf
    """
}

process bcftoolsStats {
  maxForks 1
  container params.singularity ? 'docker://staphb/bcftools:1.15' : 'staphb/bcftools:1.15'
  publishDir params.publishDir, mode: 'copy'

  input:
    path('input.bcf')
    
  output:
    file('output.vchk')

  script:
    """
      bcftools stats input.bcf > output.vchk
    """
}

process bcftoolsPlotVcfStats {
  maxForks 1
  container params.singularity ? 'docker://staphb/bcftools:1.15' : 'staphb/bcftools:1.15'
  publishDir params.publishDir, mode: 'copy'

  input:
    path('input.vchk')
    
  output:
    path('statistics')

  script:
    """
      plot-vcfstats -p statistics input.vchk
    """
}


process bcftoolsConvert {
  maxForks 1
  container params.singularity ? 'docker://staphb/bcftools:1.15' : 'staphb/bcftools:1.15'
  publishDir params.publishDir, mode: 'copy'

  input:
    path('input.bcf')
    
  output:
    file('output.vcf')

  script:
    """
      bcftools convert input.bcf -o output.vcf 
    """
}

bcftoolsConvert