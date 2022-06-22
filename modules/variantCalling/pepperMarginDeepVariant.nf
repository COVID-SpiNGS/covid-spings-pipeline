
process pepperMarginDeepVariant {
  maxForks params.threads
  accelerator params.gpus 
  container !params.docker ? 'docker://kishwars/pepper_deepvariant:r0.8' + (params.gpus > 0 ? '-gpu': '') : 'kishwars/pepper_deepvariant:r0.8' + (params.gpus > 0 ? '-gpu': '')
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
    path('.')

  script: 
    if(params.gpus > 0)
      """
        run_pepper_margin_deepvariant call_variant \
          --ont_r9_guppy5_su                            \
          --gpu                                         \
          --gvcf                                        \
          --threads 1                                   \
          --bam input.bam                               \
          --fasta reference.fasta                       \
          --output_dir ./pepper
      """
    else 
      """
        run_pepper_margin_deepvariant call_variant \
          --ont_r9_guppy5_su                            \
          --threads 1                                   \
          --gvcf                                        \
          --bam input.bam                               \
          --fasta reference.fasta                       \
          --output_dir ./pepper
      """
}

process pepperMarginDeepVariantNoPublish {
  maxForks params.threads
  accelerator params.gpus 
  container !params.docker ? 'docker://kishwars/pepper_deepvariant:r0.8' + (params.gpus > 0 ? '-gpu': '') : 'kishwars/pepper_deepvariant:r0.8' + (params.gpus > 0 ? '-gpu': '')
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
    file('pepper/PEPPER_MARGIN_DEEPVARIANT_FINAL_OUTPUT.g.vcf.gz')
    file('pepper/PEPPER_MARGIN_DEEPVARIANT_FINAL_OUTPUT.g.vcf.gz.tbi')

  script: 
    if(params.gpus > 0)
      """
        time run_pepper_margin_deepvariant call_variant \
          --ont_r9_guppy5_su                       \
          --gpu                                    \
          --gvcf                                   \
          --threads 1                              \
          --bam input.bam                          \
          --fasta reference.fasta                  \
          --output_dir ./pepper
      """
    else 
      """
        time run_pepper_margin_deepvariant call_variant \
          --ont_r9_guppy5_su                       \
          --gvcf                                   \
          --threads 1                              \
          --bam input.bam                          \
          --fasta reference.fasta                  \
          --output_dir ./pepper
      """
}