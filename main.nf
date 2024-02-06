#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include {createDirs; prepareMetagenomeFile; downloadCovid; downloadHumanGenome; runNanoSimTrain; simulate} from './src/modules/simulation/nanoSim';


workflow setupDirs {
    main:
        dirsToCreate = [params.covidRefDir, params.humanGenomeRefDir, params.nanoSimOutputDir]
        createDirs(Channel.from(dirsToCreate))
        prepareMetagenomeFile()
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
workflow simulate { 
    take:
        simulate(train.out)
}
**/
workflow {
    setupDirs()
    downloadData()
    train()
    //simulate()
}


