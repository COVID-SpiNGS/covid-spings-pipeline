## live-pipeline-nextflow

Directory ```variant_caller``` is a subtree of the [project's live variant caller](https://github.com/COVID-SpiNGS/covid-spings-variant-caller), whereas ```NanoSim``` is a git submodule.

In case of changes in the Variant Caller repo directly, please make sure to run the following command:

```
git subtree pull --prefix VariantCaller git@github.com:COVID-SpiNGS/covid-spings-variant-caller.git main --squash
```

In case of changes in the ```variant_caller``` directory, please run:

```
git subtree push --prefix variant_caller git@github.com:COVID-SpiNGS/covid-spings-variant-caller.git main
```


For more explanations for git subtree and the corresponding commands, refer to this [nice gist](https://gist.github.com/SKempin/b7857a6ff6bddb05717cc17a44091202). Also, if you're wondering about the difference between submodules and subtrees, read [this](https://gitprotect.io/blog/managing-git-projects-git-subtree-vs-submodule/).


BTW: Same applies to the NanoSim tool:


```
git subtree pull --prefix NanoSim git@github.com:bcgsc/NanoSim.git master --squash

```


## How to use

Run the pipeline with ```nextflow -log ./logs/nextflow.log run main.nf```