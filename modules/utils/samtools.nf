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
    path('input.bam')
    
  output:
    file('merged.bam')

  script:
    """
      samtools merge -@ ${params.threads} -o merged.bam input.bam*
    """ 
    

    // ls --human-readable --kibibytes -Sl input.bam*
    // samtools view -c output.bam
    // echo '\n'
}

process samtoolsMerge2 {
  debug true
  maxForks 1
  container !params.docker ? 'docker://staphb/samtools:1.15' : 'staphb/samtools:1.15'

  input:
    tuple path('input.bam'), path('previous.bam'), val(append)
    
  output:
    file('output.bam')

  script:
    if(append)
      """
        samtools merge -@ ${params.threads} -o output.bam previous.bam input.bam
        echo 'Append'
      """
    else
      """
        mv input.bam output.bam
        echo 'Move'
      """
}

process samtoolsSort {
  maxForks 1
  container !params.docker ? 'docker://staphb/samtools:1.15' : 'staphb/samtools:1.15'

  input:
    path('unsorted.bam')
    
  output:
    file('sorted.bam')

  script:
    """
      samtools sort -@ ${params.threads} unsorted.bam -o sorted.bam 
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