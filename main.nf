#! /usr/bin/env nextflow
nextflow.enable.dsl = 2 

def helpMessage() {
  log.info """
    Usage:
    The typical command for running the pipeline is as follows:
    nextflow run main.nf

    Mandatory arguments:

    Optional arguments:
      --watchPath
      --referenceGenomePath
      --publishDir
      --mergeBamFileName
      --help                         This usage statement.
    """
}

// Show help message
if (params.help) {
  helpMessage()
  exit 0
}


process runGraphMap {
  container 'https://depot.galaxyproject.org/singularity/graphmap%3A0.6.3--h9a82719_1'
  // publishDir params.samFilesPublishDir, mode: 'copy', saveAs: { filename -> "${LocalDateTime.now()}.sam" }

  input:
    file('input.fastq')
    file('referenceGenome.fasta')

  output: 
    file('output.sam')

  script:
    """
      graphmap2 align -r referenceGenome.fasta -d input.fastq -o output.sam
    """
}

process convertSamToBam {
  container 'https://depot.galaxyproject.org/singularity/samtools%3A1.14--hb421002_0'
  publishDir params.publishDir, mode: 'copy', saveAs: { filename -> "${UUID.randomUUID().toString()}.part.bam" }

  input:
    file('input.sam')
    
  output:
    file('output.bam')

  script:
    """
      samtools view -S -b input.sam > output.bam
    """
}

process mergeBam {
  container 'https://depot.galaxyproject.org/singularity/samtools%3A1.14--hb421002_0'
  publishDir params.publishDir, mode: 'copy', saveAs: { filename -> params.mergeBamFileName }

  input:
    file('input.bam')
    
  output:
    file('output.bam')

  script: 
    """
      samtools merge output.bam "${params.publishDir}"/*.part.bam
    """
}


workflow {
  inputFiles$ = Channel.watchPath(params.watchPath, 'create')
  // inputFiles$ = Channel.fromPath(params.watchPath)
  referenceGenomeFile$ = Channel.value(params.referenceGenomePath)

  runGraphMap(inputFiles$, referenceGenomeFile$)
  convertSamToBam(runGraphMap.out)
  mergeBam(convertSamToBam.out)
}