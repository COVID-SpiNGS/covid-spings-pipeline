#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include {createDirs; downloadCovid; downloadHumanGenome; runNanoSimTrain; simulate} from './modules/simulation/nanoSim';


workflow setupDirs {
    main:
        dirsToCreate = [params.covidRefDir, params.humanGenomeRefDir, params.nanoSimOutputDir]
        createDirs(Channel.from(dirsToCreate))
}

workflow downloadData {
    main:
        values = Channel.from(1..22)
        downloadCovid()
        downloadHumanGenome(values)
           
}
 
workflow train {
    
    main:
        runNanoSimTrain()
        println "Input: $params.inputDir"
        println "Output: $params.outputDir"
        
}

/**
ski/CovidSpiNGS/ProcessedData/ahinzer/concentration_predictionsftp://ahinzer@pumpkin11.f4.htw-berlin.de/data/ldap/pdabrowski/CovidSpiNGS/ProcessedData/ahinzer/concentration_predictionsftp://ahinzer@pumpkin11.f4.htw-berlin.de/data/ldap/pdabrowski/CovidSpiNGS/ProcessedData/ahinzer/concentration_prediction

**/
workflow {
    setupDirs()
    downloadData()
    train() 
    //simulate()
}

/**
workflow simulate { 
    take:
        simulate(train.out)
}
**/