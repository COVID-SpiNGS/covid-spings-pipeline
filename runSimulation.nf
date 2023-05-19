#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include { setupDirs; downloadHumanGenome; downloadCovid; runNanoSimTrain; simulate } from './modules/simulation/nanoSim';


workflow train {
    
    main:
       
        //if (params.output && !params.output.equals(workflow.projectDir))
         //o = params.output
         p = workflow.projectDir
        //outputDir = (params.output != null) ? params.output : workflow.projectDir
        //projectDir = "bla"
          //setupDirs(params.outputDir)
          //setupNanoSim()
          //downloadHumanGenome(params.outputDir) 
          //downloadCovid(params.outputDir)
        runNanoSimTrain(workflow.projectDir)
          //     xyz(workflow.projectDir, params.outputDir)
          //
        //println "Output: $outputDir"
        
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