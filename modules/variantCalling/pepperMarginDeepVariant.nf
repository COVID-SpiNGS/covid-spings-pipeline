
process pepperMarginDeepVariant {
  maxForks 1
  accelerator params.gpus 
  container params.singularity ? 'docker://kishwars/pepper_deepvariant:r0.8' + (params.gpus > 0 ? '-gpu': '') : 'kishwars/pepper_deepvariant:r0.8' + (params.gpus > 0 ? '-gpu': '')
  containerOptions = { 
    workflow.containerEngine == 'singularity' && params.gpus > 0 ? '--nv':
       ( workflow.containerEngine == 'docker' && params.gpus > 0 ? '--gpus all': null ) 
  }
  publishDir params.publishDir, mode: 'copy'

  input:
    path('input.bam')
    path('input.bam.bai')
    path('reference.fasta')
    path('reference.fasta.fai')

  output:
    path('pepper')

  script: 
    if(params.gpus > 0)
      """
        run_pepper_margin_deepvariant call_variant \
          --ont_r9_guppy5_su                       \
          --gpu                                    \
          --threads ${params.threads}              \
          --bam input.bam                          \
          --fasta reference.fasta                  \
          --output_dir ./pepper
      """
    else 
      """
        run_pepper_margin_deepvariant call_variant \
          --ont_r9_guppy5_su                       \
          --threads ${params.threads}              \
          --bam input.bam                          \
          --fasta reference.fasta                  \
          --output_dir ./pepper
      """
}

process pepperMarginDeepVariantNoPublish {
  maxForks params.threads
  accelerator params.gpus 
  container params.singularity ? 'docker://kishwars/pepper_deepvariant:r0.8' + (params.gpus > 0 ? '-gpu': '') : 'kishwars/pepper_deepvariant:r0.8' + (params.gpus > 0 ? '-gpu': '')
  containerOptions = { 
    workflow.containerEngine == 'singularity' && params.gpus > 0 ? '--nv':
       ( workflow.containerEngine == 'docker' && params.gpus > 0 ? '--gpus all': null ) 
  }

  input:
    path('input.bam')
    path('input.bam.bai')
    path('reference.fasta')
    path('reference.fasta.fai')

  output:
    file('pepper/PEPPER_MARGIN_DEEPVARIANT_FINAL_OUTPUT.vcf.gz')
    file('pepper/PEPPER_MARGIN_DEEPVARIANT_FINAL_OUTPUT.vcf.gz.tbi')

  script: 
    if(params.gpus > 0)
      """
        run_pepper_margin_deepvariant call_variant \
          --ont_r9_guppy5_su                       \
          --gpu                                    \
          --threads 1                              \
          --bam input.bam                          \
          --fasta reference.fasta                  \
          --output_dir ./pepper
      """
    else 
      """
        run_pepper_margin_deepvariant call_variant \
          --ont_r9_guppy5_su                       \
          --threads 1                              \
          --bam input.bam                          \
          --fasta reference.fasta                  \
          --output_dir ./pepper
      """
}