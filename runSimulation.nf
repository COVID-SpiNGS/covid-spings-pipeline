#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include { setupDirs; downloadHumanGenome; downloadCovid; installConda; prepare_simulation; simulate } from './modules/simulation/nanoSim';


workflow train {
    setupDirs | downloadHumanGenome | downloadCovid | installConda | prepare_simulation
}

workflow simulate { 
   simulate
}
