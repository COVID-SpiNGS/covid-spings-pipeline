process samtoolsView {
  maxForks 1
  container !params.docker ? 'docker://staphb/samtools:1.15' : 'staphb/samtools:1.15'

  input:
    path('input.sam')
    
  output:
    file('output.bam')

  script:
    """
      samtools view -@ ${params.threads} -S -b input.sam > output.bam
    """
}

process samtoolsMerge {
  maxForks 1
  container !params.docker ? 'docker://staphb/samtools:1.15' : 'staphb/samtools:1.15'

  input:
    tuple path('input.bam'), path('previous.bam'), val(append)
    
  output:
    file('output.bam')

  script:
    if(append)
      """
        samtools merge -@ ${params.threads} output.bam previous.bam input.bam
      """
    else
      """
        mv input.bam output.bam
      """
}

process samtoolsSort {
  maxForks 1
  container !params.docker ? 'docker://staphb/samtools:1.15' : 'staphb/samtools:1.15'

  input:
    path('input.bam')
    
  output:
    file('output.bam')

  script:
    """
      samtools sort -@ ${params.threads} input.bam -o output.bam 
    """
}

process samtoolsIndex {
  maxForks 1
  container !params.docker ? 'docker://staphb/samtools:1.15' : 'staphb/samtools:1.15'

  input:
    path('input.bam')
    
  output:
    file('output.bam.bai')

  script:
    """
      samtools index -@ ${params.threads} input.bam output.bam.bai
    """
}