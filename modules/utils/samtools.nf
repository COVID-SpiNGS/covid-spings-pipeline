process samtoolsSamToBam {
  maxForks 1
  container params.singularity ? 'docker://staphb/samtools:1.15' : 'staphb/samtools:1.15'

  input:
    path('input.sam')
    
  output:
    file('output.bam')

  script:
    """
      samtools view -@ ${params.threads} -S -b input.sam > output.bam
    """
}

process samtoolsMergeMarkDuplicates {
  maxForks 1
  container params.singularity ? 'docker://staphb/samtools:1.15' : 'staphb/samtools:1.15'
  publishDir params.publishDir, mode: 'copy', saveAs: { it == 'output.bam' ? params.bamFile : params.bamIndexFile }

  input:
    tuple path('input.bam'), path('merge.bam'), val(append)
    
  output:
    file('output.bam')
    file('output.bam.bai')

  script:
    if(append)
      """
        samtools merge   -@ ${params.threads}         orig.bam merge.bam input.bam

        samtools collate -@ ${params.threads}    -o    name-sorted.bam orig.bam
        samtools fixmate -@ ${params.threads} -m       name-sorted.bam fixmate.bam 
        samtools sort    -@ ${params.threads}    -o    coordinate-sorted.bam fixmate.bam
        samtools markdup -@ ${params.threads} -l 10000 coordinate-sorted.bam output.bam 
        samtools index   -@ ${params.threads}          output.bam
      """
    else
      """
        mv                                             input.bam orig.bam

        samtools collate -@ ${params.threads}    -o    name-sorted.bam orig.bam
        samtools fixmate -@ ${params.threads} -m       name-sorted.bam fixmate.bam 
        samtools sort    -@ ${params.threads}    -o    coordinate-sorted.bam fixmate.bam
        samtools markdup -@ ${params.threads} -l 10000 coordinate-sorted.bam output.bam 
        samtools index   -@ ${params.threads}          output.bam
      """
}


process samtoolsMerge {
  maxForks 1
  container params.singularity ? 'docker://staphb/samtools:1.15' : 'staphb/samtools:1.15'
  publishDir params.publishDir, mode: 'copy', saveAs: { it == 'output.bam' ? params.bamFile : params.bamIndexFile }

  input:
    tuple path('input.bam'), path('merge.bam'), val(append)
    
  output:
    file('output.bam')
    file('output.bam.bai')

  script:
    if(append)
      """
        samtools merge   -@ ${params.threads}    orig.bam merge.bam input.bam

        samtools sort    -@ ${params.threads} -o output.bam orig.bam
        samtools index   -@ ${params.threads}    output.bam
      """
    else
      """
        mv                                       input.bam orig.bam

        samtools sort    -@ ${params.threads} -o output.bam orig.bam
        samtools index   -@ ${params.threads}    output.bam
      """
}