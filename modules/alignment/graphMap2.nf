process graphMap2 {
  container 'https://depot.galaxyproject.org/singularity/graphmap%3A0.6.3--h9a82719_1'

  input:
    path('input.fastq')
    path('reference.fasta')

  output: 
    file('output.sam')

  script:
    """
      graphmap2 align -x rnaseq -r reference.fasta -d input.fastq -o output.sam
    """
}

// samtools view -H input.sam > input.header.sam && samtools view input.sam | split -l 8000000 - input.split. && find -L . | grep input.split. | parallel --gnu -j4 "echo input.header.sam {} >> {}.tmp && rm -f {}" && rename "s/\.tmp$/\.sam/" input.split.*