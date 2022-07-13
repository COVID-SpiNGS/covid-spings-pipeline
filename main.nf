#!/usr/bin/env nextflow


#params.input = "$PWD/data"
#params.output = "$PWD/FastQC_Output/"

#files = Channel.fromPath(params.input + "/*.fastq.gz")

process downloadHumanGenome {

    script:
    """
    if [mkdir humanGenome && cd ./humanGenome]; then
    	for i in {1..22}
    	do
    
    		if [wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr"$i".fa.gz] ; then
    			gzip -d chr"$i".fa.gz
		fi
    	done
    fi
    """

}

process downloadCovidGenome {


   script:
   """
   
   """
}
