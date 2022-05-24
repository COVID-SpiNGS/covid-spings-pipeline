
process deepVariant {
  maxForks 1
  container params.singularity ? 'docker://google/deepvariant:1.3.0' : 'google/deepvariant:1.3.0'
  publishDir params.publishDir, mode: 'copy', saveAs: {  it == 'output.vcf' ? params.vcfFile : params.vcfReportFile }

  input:
    path('input.bam')
    path('input.bam.bai')
    path('reference.fasta')
    path('reference.fasta.fai')


  output:
    file('output.vcf')
    file('output.visual_report.html')

  script: 
    """
      run_deepvariant -t ${params.threads} --model_type=WGS --reads=input.bam --ref reference.fasta --output_vcf=output.vcf
    """
}
