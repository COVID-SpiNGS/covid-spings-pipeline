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
        //setupDirs(params.down)
        //downloadHumanGenome(p) 
        downloadCovid(params.downloadDir)
        //runNanoSimTrain(p)
        println "Input: $params.inputDir"

        println "Output: $params.outputDir"
        
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