process samtoolsView {
  container 'docker://staphb/samtools:1.14'

  input:
    path('input.sam')
    
  output:
    file('output.bam')

  script:
    """
      samtools view -@ 8 -S -b input.sam > output.bam
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
          samtools merge -@ 8 unsorted.bam merge.bam input.bam
          samtools sort  -@ 8 unsorted.bam -o output.bam
          samtools index -@ 8 output.bam
      """
    else
      """
          mv input.bam unsorted.bam
          samtools sort  -@ 8 unsorted.bam -o output.bam
          samtools index -@ 8 output.bam
      """
}