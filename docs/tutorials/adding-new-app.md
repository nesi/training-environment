# Adding a new app

## Overview

The suggested approach is to copy the existing app that most closely resembles your new app and modify that, we will document this approach here.
Some of the existing apps are:

- [Apptainer workshop app](https://github.com/nesi/training-environment-jupyter-containers-app)
    - based on JupyterLab
- [Intermediate shell workshop app](https://github.com/nesi/training-environment-jupyter-intermediate-shell-app)
    - based on JupyterLab
    - there is a [tutorial](jupyterlab-app-for-intermediate-shell-for-bioinformatics.md) for this app
- [Jupyter ML101 app](https://github.com/nesi/training-environment-jupyter-ml101-app)
    - based on JupyterLab
    - uses Miniconda to install dependencies
- [Jupyter ML102 app](https://github.com/nesi/training-environment-jupyter-ml102-app)
    - based on JupyterLab
    - uses Python virtualenv and pip to install dependencies
- [RStudio RNA-Seq app](https://github.com/nesi/training-environment-rstudio-rnaseq-app)
    - based on RStudio
    - includes data files in the docker image
    - uses Miniconda to install some dependencies such as `samtools` and `fastqc`
    - uses `BiocManager` and `install.packages` to install R dependencies
- [RStudio scRNA-Seq app](https://github.com/nesi/training-environment-rstudio-scrnaseq-app)
- [RStudio intro and intermediate R app](https://github.com/nesi/training-environment-rstudio-app)

## What needs to be changed

Here we summarise what is most likely to need to be changed when copying an existing app.
Assuming the app your are copying is based on the same web application (i.e. JupyterLab vs RStudio, etc.) then not much should need to change.

- *view.html.erb*
    - change the line that contains the string *Connect to <app specific string>*, replacing *<app specific string>* with something specific to your app
- *manifest.yml*
    - change the `name` and `description`
- *form.yml*
    - adjust `cpu`, `memory`, `wall_time` if needed (can also add/remove any options)
- *submit.yml.erb*
    - change `script.native.container.name` to something unique for your app
    - change `script.native.container.image` to the image that will be built for your app - this should look like your github repo name and include a label/version (you will need to create a git tag for the version you put here)
- *script/template.sh.erb*
    - copy any data in your image before launching the app, e.g. using something like
      ```
      rsync --ignore-existing -avz /path/in/docker/image/to/data/ ~/data/
      ```
- *docker/Dockerfile*
    - add additional packages and install steps (generally not a good idea to remove packages unless you know what you are doing)
    - add any required data

!!! info "Note about naming your git repo"

    When you copy an existing app repo you should take care when naming your new repository - make sure you do not use underscores - use hyphens instead as github packages do not support package names with underscores and the default github action we include uses the repository name for the package name

## Creating a tag/release of your new app

In order to deploy your app in the training environment we are going to tag a version/release of it, using git tags.

1. Update the version label in `script.native.container.image` in *submit.yml.erb* to reflect the new version you are about to create, commit that file. For example, here we are going to release version "v0.2.2": `image: "ghcr.io/nesi/training-environment-rstudio-rnaseq-app:v0.2.2"`
2. Create a tag with that specific version, e.g. `git tag -a v0.2.2 -m "my new release"`
3. Push the tags, e.g. `git push --tags`
4. This should trigger a build of the docker image, check the "Actions" tab of your GitHub repo and wait for it to complete successfully

## Adding your app to the training environment

To add you app to the training environment you need to modify the [training-environment repo](https://github.com/nesi/training-environment), specifically the file *vars/ondemand-config.yml.example*:

1. Identify the `ood_apps` section in the file *vars/ondemand-config.yml.example*
2. This section consists of a number of blocks, one for each app, so add a new block for your new app:
    ```yaml
    rstudio_rnaseq:
      k8s_container: ghcr.io/nesi/training-environment-rstudio-rnaseq-app:v0.2.2
      repo: https://github.com/nesi/training-environment-rstudio-rnaseq-app.git
      version: 'v0.2.2'
      enabled: true
      pre_pull: false
    ```
3. Next time you build the environment the new app should be included

More detail on the keys above follows:

- `rstudio_rnaseq` should be set to a unique value in the `ood_apps` block
- `k8s_container` must point to the docker image for your app, tagged with the specific version (the git tag you created above)
- `repo` the github repo for your app
- `version` should be the git tag you created above
- `enabled: true` so that your app shows up in ondemand
- `pre_pull: false` is a good default and can be changed to `true` when you are using that app in a training

!!! note "Releasing a new version of your app"

    When you release a new version of your app you need to update both the `k8s_container` and `version` values with the new version of your app

## Developing

When developing it can be useful...
