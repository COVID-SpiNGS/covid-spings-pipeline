#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include {setupDataDir; setupCovidRefDir; setupHumanGenomeRefDir; downloadCovid; downloadHumanGenome; runNanoSimTrain; simulate} from './modules/simulation/nanoSim';


workflow setupDirs {
    main:
        setupDataDir()
        setupHumanGenomeRefDir()
        setupCovidRefDir()
}

workflow train {
    
    main:
        //setupDirs()
        values = Channel.from(1..22)
        //downloadHumanGenome(values)
        //downloadCovid()
        
        //runNanoSimTrain()
        println "Input: $params.inputDir"

        println "Output: $params.outputDir"
        
}

workflow {
    setupDirs()
    //train() 
    //simulate()
}

/**
workflow simulate { 
    take:
        simulate(train.out)
}
**/