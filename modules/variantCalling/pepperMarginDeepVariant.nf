
process pepperMarginDeepVariant {
  maxForks 1
  container 'docker://kishwars/pepper_deepvariant:r0.8'
  publishDir params.publishDir, mode: 'copy'

  input:
    path('input.bam')
    path('input.bam.bai')
    path('reference.fasta')
    path('reference.fasta.fai')


  output:
    path('pepper')

  script: 
    """
      run_pepper_margin_deepvariant call_variant -t ${params.threads} --ont_r9_guppy5_su -b input.bam -f reference.fasta -o ./pepper
    """
}