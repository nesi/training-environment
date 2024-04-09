# JupyterLab app for Intermediate Shell for Bioinformatics

This tutorial will show how to create a JupyterLab based app for teaching intermediate shell for bioinformatics.

The GitHub repo for the app that this tutorial is based on can be found [here](https://github.com/nesi/training-environment-jupyter-intermediate-shell-app).

The app has a standard structure for a Kubernetes based Open OnDemand app and the related upstream documentation may be useful:

- [Add a Jupyter App on a Kubernetes cluster](https://osc.github.io/ood-documentation/latest/tutorials/tutorials-interactive-apps/k8s-jupyter.html)
- [Add a Jupyter App on a Kubernetes cluster that behaves like HPC compute](https://osc.github.io/ood-documentation/latest/tutorials/tutorials-interactive-apps/k8s-like-hpc-jupyter.html)

In this tutorial we will go through the different files in the above repo and how we have customised them for this training app.

!!! note "Files with .erb extension"

    Files with a *.erb* extension below are run through the Embedded Ruby template system. If you don't need this you can remove the *.erb* extension, or add it to files where you need it.

## form.yml

In the *form.yml* file we set the name of the *cluster* that this app should belong to.
In our case the cluster is hard-coded in our Open OnDemand deployment to be called `my-k8s-cluster` so we should never need to change this:

```yml
cluster: "my-k8s-cluster"
```

The *form* section defines some parameters that can be set on the launcher form and used by us to configure the app at run time. Here we define three parameters:

```yml
form:
  - cpu
  - memory
  - wall_time
```

The *attributes* section we define how the above parameters should appear to the user on the launcher form.
We hard-code the CPU and memory requirements to 2 CPUs and 4 GB RAM, so these options won't appear on the form but they will be available for us to use later (once the user has clicked the launch button):

```yml
attributes:
  cpu: 2
  memory: 4
```

The walltime option is configurable by the user (although not enforced by us at the time of writing...).
We allow the user to choose a value between 4 and 12 hours and the form will be pre-populated with a default value of 8 hours:

```yml
  wall_time:
    widget: number_field
    label: "Hours"
    min: 4
    max: 12
    value: 8
```

Different widgets are available. See also the upstream [documentation](https://osc.github.io/ood-documentation/develop/how-tos/app-development/interactive/form.html).

## manifest.yml


## submit.yml.erb


## view.html.erb


## template/script.sh.erb


## docker/Dockerfile
