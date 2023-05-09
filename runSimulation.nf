#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

include { miniMap2 } from './modules/simulation/nanoSim';


workflow train {

}

workflow simulate { 
  setupDirs | downloadHumanGenome | downloadCovid | installConda | prepare_simulation | simulate
}
