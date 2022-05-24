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