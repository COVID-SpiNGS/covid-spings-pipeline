#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include {setupDirs; downloadHumanGenome; runNanoSimTrain; simulate} from './modules/simulation/nanoSim';


workflow train {
    
    main:
        setupDirs()
        values = Channel.from(1..22)
        downloadHumanGenome(values)
        //if (params.output && !params.output.equals(workflow.projectDir))
         //o = params.output
        //outputDir = (params.output != null) ? params.output : workflow.projectDir
        //projectDir = "bla"
        
        //runNanoSimTrain()
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