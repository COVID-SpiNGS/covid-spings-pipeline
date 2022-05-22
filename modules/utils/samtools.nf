process samtoolsView {
  maxForks params.threads
  container 'docker://staphb/samtools:1.14'

  input:
    path('input.sam')
    
  output:
    file('output.bam')

  script:
    """
      samtools view -@ 1 -S -b input.sam > output.bam
    """
}

process samtoolsMergeSortIndex {
  maxForks 1
  container 'docker://staphb/samtools:1.14'
  publishDir params.publishDir, mode: 'copy', saveAs: { it == 'output.bam' ? params.bamFile : params.bamIndexFile }

  input:
    tuple path('input.bam'), path('merge.bam'), val(append)
    
  output:
    file('output.bam')
    file('output.bam.bai')

  script: 
    if(append)
      """
          samtools merge -@ ${params.threads} unsorted.bam merge.bam input.bam
          samtools sort  -@ ${params.threads} unsorted.bam -o output.bam
          samtools index -@ ${params.threads} output.bam
      """
    else
      """
          mv input.bam unsorted.bam
          samtools sort  -@ ${params.threads} unsorted.bam -o output.bam
          samtools index -@ ${params.threads} output.bam
      """
}