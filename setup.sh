#!/bin/bash

./download_data.sh "$PWD/data"
nextflow run runSimulation.nf
