## live-pipeline-nextflow

You'll need the NanoSim tool, which is included as a git subtree in this repo. Check for updates running the following command:

```
git subtree pull --prefix NanoSim git@github.com:bcgsc/NanoSim.git master --squash

```

For more explanations for git subtree and the corresponding commands, refer to this [nice gist](https://gist.github.com/SKempin/b7857a6ff6bddb05717cc17a44091202). Also, if you're wondering about the difference between submodules and subtrees, read [this](https://gitprotect.io/blog/managing-git-projects-git-subtree-vs-submodule/).



## How to use

Run the pipeline with ```nextflow -log ./logs/nextflow.log run main.nf```
