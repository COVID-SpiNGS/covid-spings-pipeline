#!/usr/bin/env nextflow

nextflow.enable.dsl=2


params.wd = "$PWD"
params.i = 1

process downloadHumanGenome {

    script:
    """

    """

}

process downloadCovidGenome {


   script:
   """

   """
}

workflow {
	downloadHumanGenome()
	print(params.wd)

}
