#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include {setupDirs; downloadHumanGenome; runNanoSimTrain; simulate; myProcess } from './modules/simulation/nanoSim';


workflow train {
    
    main:
       
8
        //values = channel.fromList( [1, 2, 3, 4] )
        values = Channel.from(1..22)

       //downloadHumanGenome()
        myProcess(values)
        //if (params.output && !params.output.equals(workflow.projectDir))
         //o = params.output
        p = workflow.projectDir
        //outputDir = (params.output != null) ? params.output : workflow.projectDir
        //projectDir = "bla"
        //setupDirs(params.down)
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