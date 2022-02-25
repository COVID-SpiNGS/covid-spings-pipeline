#! /usr/bin/env nextflow
nextflow.enable.dsl = 2 

import java.nio.file.Paths;

def helpMessage() {
  log.info """
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run main.nf

    Mandatory arguments:

    Optional arguments:
      --watchPath
      --reference
      --referenceIndex

      --publishDir
      --bamFile
      --bamIndexFile
      --vcfFile
      --vcfReportFile
      --help                         This usage statement.
    """
}

process runGraphMap {
  container 'https://depot.galaxyproject.org/singularity/graphmap%3A0.6.3--h9a82719_1'

  input:
    path('input.fastq')
    path('reference.fasta')

  output: 
    file('output.sam')

  script:
    """
      graphmap2 align -r reference.fasta -d input.fastq -o output.sam
    """
}

process runSamtoolsView {
  container 'https://depot.galaxyproject.org/singularity/samtools%3A1.14--hb421002_0'

  input:
    path('input.sam')
    
  output:
    file('output.bam')

  script:
    """
      samtools view -S -b input.sam > output.bam
    """
}


process runSamtoolsMergeIndex {
  maxForks 1
  container 'https://depot.galaxyproject.org/singularity/samtools%3A1.14--hb421002_0'
  publishDir params.publishDir, mode: 'copy', saveAs: { it == 'output.bam' ? params.bamFile : params.bamIndexFile }

  input:
    tuple path('input.bam'), path('merge.bam'), val(append)
    
  output:
    file('output.bam')
    file('output.bam.bai')

  script: 
    if(append)
      """
          samtools merge output.bam merge.bam input.bam
          samtools index output.bam
      """
    else
      """
          mv input.bam output.bam
          samtools index output.bam
      """
}


process runDeepVariant {
  maxForks 1
  container 'docker://kishwars/pepper_deepvariant:r0.7'
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
      run_deepvariant --model_type=WGS --reads=input.bam --ref reference.fasta --output_vcf=output.vcf
    """
}



workflow {
  Boolean firstRead = true

  chInputFiles = Channel.watchPath(params.watchPath, 'create').until { it.name == 'exit.fastq' }
  //chInputFiles = Channel.fromPath(params.watchPath)
  chReference = Channel.value(params.reference)
  chReferenceIndex = Channel.value(params.referenceIndex)


  runGraphMap(chInputFiles, chReference)
  runSamtoolsView(runGraphMap.out)

  chRunSamtoolsMergeInput = runSamtoolsView.out
    .map { [it, Paths.get("${params.publishDir}/${params.bamFile}")] }
    .map { [it[0], it[1], !firstRead] }
    .map { 
      firstRead = false
      it
    }


  runSamtoolsMergeIndex(chRunSamtoolsMergeInput)

  runDeepVariant(
    runSamtoolsMergeIndex.out[0],
    runSamtoolsMergeIndex.out[1],
    chReference,
    chReferenceIndex
  )
  
  runDeepVariant.out[0].view()
  runDeepVariant.out[1].view()
}