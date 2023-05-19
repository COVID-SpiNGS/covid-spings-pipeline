#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include { setupDirs; setupNanoSim; downloadHumanGenome; downloadCovid; runNanoSimTrain; simulate } from './modules/simulation/nanoSim';


workflow train {
    
    main:
        if (params.outputDir)
        //outputDir = (params.outputDir == null) ? params.outputDir : ""
          //setupDirs(params.outputDir)
          //setupNanoSim()
          //downloadHumanGenome(params.outputDir) 
          //downloadCovid(params.outputDir)
          runNanoSimTrain(params.outputDir)
}


workflow {
    train() 
    //simulate()
}

/**
workflow simulate { 
    take:
        simulate(train.out)
}
**/