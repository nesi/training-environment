# Apps

## Overview

Open OnDemand app development is described in detail in their [documentation](https://osc.github.io/ood-documentation/latest/how-tos/app-development.html).

In particular, the training environment uses a kubernetes cluster for running the apps, so the apps are developed similarly to the kubernetes examples on the Open OnDemand website:

- [Add a Jupyter App on a Kubernetes Cluster](https://osc.github.io/ood-documentation/latest/tutorials/tutorials-interactive-apps/k8s-jupyter.html)
- [Add a Jupyter App on a Kubernetes Cluster that behaves like HPC compute](https://osc.github.io/ood-documentation/latest/tutorials/tutorials-interactive-apps/k8s-like-hpc-jupyter.html)

On the following pages are some examples of apps that have been developed to run on the training environment.

## Key points

- Apps are created as docker images
- Apps are set up as LDAP clients so *training* and *trainer* users are identified correctly within the container
    * the nslcd socket from the kubernetes worker node is bound into the container at the correct location
    * the */etc/nsswitch.conf* file from the kubernetes worked node is bound into the container
    * LDAP client packages are installed inside the container (nslcd, etc)
- All home directories are bound into the container (so *trainer* users can access *training* users' homes from within the apps if needed)
