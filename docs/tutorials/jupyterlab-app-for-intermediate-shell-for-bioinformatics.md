# JupyterLab app for Intermediate Shell for Bioinformatics

This tutorial will show how to create a JupyterLab based app for teaching intermediate shell for bioinformatics.

The GitHub repo for the app that this tutorial is based on can be found [here](https://github.com/nesi/training-environment-jupyter-intermediate-shell-app).

The app has a standard structure for a Kubernetes based Open OnDemand app and the related upstream documentation may be useful:

- [Add a Jupyter App on a Kubernetes cluster](https://osc.github.io/ood-documentation/latest/tutorials/tutorials-interactive-apps/k8s-jupyter.html)
- [Add a Jupyter App on a Kubernetes cluster that behaves like HPC compute](https://osc.github.io/ood-documentation/latest/tutorials/tutorials-interactive-apps/k8s-like-hpc-jupyter.html)

In this tutorial we will go through the different files in the above repo and how we have customised them for this training app.

!!! note "Files with .erb extension"

    Files with a *.erb* extension below are run through the Embedded Ruby template engine. If you don't need this you can remove the *.erb* extension, or add it to files where you need it.

## Layout

The layout of the app looks like:

```
intermediate-shell-app
├── docker
│   └── Dockerfile
├── form.yml
├── icon.png
├── LICENSE
├── manifest.yml
├── README.md
├── submit.yml.erb
├── template
│   └── script.sh.erb
└── view.html.erb
```

In the following sections we go into more detail about each file.

## form.yml

In the *form.yml* file we set the name of the *cluster* that this app should belong to.
In our case the cluster is hard-coded in our Open OnDemand deployment to be called `my-k8s-cluster` so we should never need to change this:

```yaml
cluster: "my-k8s-cluster"
```

The *form* section defines some parameters that can be set on the launcher form and used by us to configure the app at run time. Here we define three parameters:

```yaml
form:
  - cpu
  - memory
  - wall_time
```

In the *attributes* section we define how the above parameters should appear to the user on the launcher form.
We hard-code the CPU and memory requirements to 2 CPUs and 4 GB RAM, so these options won't appear on the form but they will be available for us to use later (once the user has clicked the launch button):

```yaml
attributes:
  cpu: 2
  memory: 4
```

The walltime option is configurable by the user (although not enforced by us at the time of writing...).
We allow the user to choose a value between 4 and 12 hours and the form will be pre-populated with a default value of 8 hours:

```yaml hl_lines="4-9"
attributes:
  cpu: 2
  memory: 4
  wall_time:
    widget: number_field
    label: "Hours"
    min: 4
    max: 12
    value: 8
```

Different widgets are available. See also the upstream [documentation](https://osc.github.io/ood-documentation/develop/how-tos/app-development/interactive/form.html).

<details><summary>View complete form.yml</summary>

```yaml
---
cluster: "my-k8s-cluster"

form:
  - cpu
  - memory
  - wall_time

attributes:
  cpu: 2
  memory: 4
  wall_time:
    widget: number_field
    label: "Hours"
    min: 4
    max: 12
    value: 8
```

</details>

## manifest.yml

The *manifest.yml* files defines how the app shows up in the user interface, e.g. what name it will have

```yaml
name: Intermediate shell for bioinformatics
```

For the training environment we don't need to change the following:

```yaml
category: Interactive Apps
subcategory: Servers
role: batch_connect
```

but can edit the description to be something relevant:

```yaml
description: |
  This app will launch a Jupyter Lab server for the intermediate shell for bioinformatics workshop
```

<details><summary>View complete manifest.yml</summary>

```yaml
---
name: Intermediate shell for bioinformatics
category: Interactive Apps
subcategory: Servers
role: batch_connect
description: |
  This app will launch a Jupyter Lab server for the intermediate shell for bioinformatics workshop
```

</details>

## submit.yml.erb

Most of the configuration for the app happens in this file. It will look quite different depending on the type of app, e.g. JupyterLab vs RStudio. Notice the *.erb* extension which means this file will run through the ERB template engine.

The top section of the file (above the "---") should not need to be changed. In this section we set some ruby variables that are used in the templates later on, e.g. a reference to the current user, the IP address of the services node, etc.

```yaml
<%
   pwd_cfg = "c.ServerApp.password=u\'sha1:${SALT}:${PASSWORD_SHA1}\'"
   host_port_cfg = "c.ServerApp.base_url=\'/node/${HOST_CFG}/${PORT_CFG}/\'"

   configmap_filename = "ondemand_config.py"
   configmap_data = "c.NotebookApp.port = 8080"
   utility_img = "ghcr.io/nesi/training-environment-k8s-utils:v0.1.0"

   user = OodSupport::User.new

   services_node = Resolv.getaddress("servicesnode")
%>
---
```

The config happens in the `script:` entry, usually the `accounting_id` and `wall_time` should not need to change

```yaml
script:
  accounting_id: "<%= account %>"
  wall_time: "<%= wall_time.to_i * 3600 %>"
```

Inside the `native:` entry is where we configure the pod that will run the app on the kubernetes cluster, for example we define the container with:

```yaml
  native:
    container:
      name: "intermshell"
      image: "ghcr.io/nesi/training-environment-jupyter-intermediate-shell-app:v0.3.3"
      command: ["/bin/bash","-l","<%= staged_root %>/job_script_content.sh"]
      working_dir: "<%= Etc.getpwnam(ENV['USER']).dir %>"
      restart_policy: 'OnFailure'
```

- Using a unique `name` is a good idea to tell the running apps apart
- `image` should point the docker image that should be used
- `command` should not be changed
- `working_dir` is usually left as the home directory but could be changed
- `restart_policy` is usually left the same

!!! info "Note about developing apps"

    When developing an app it can be useful to set the image tag to point to a branch name and to set the `image_pull_policy` to alway, for example:

    ```yaml
    image: "ghcr.io/nesi/training-environment-jupyter-intermediate-shell-app:dev"
    image_pull_policy: "Always"
    ```

    This way, whenever you push a change to the *dev* branch in your app repo, it will rebuild the docker image with the *dev* tag and then you can just restart your app in the training environment to pick up the changes. Do not do this in production though, pulling images can be slow.

UNFINISHED

## view.html.erb

The *view.html.erb* file contains the html form with a button that the users clicks to connect to the app once it has started (this is the button that shows up in the Open OnDemand user interface). Most of this file should not need to change unless you switch to using a different underlying web application, i.e. RStudio vs JupyterLab.

When the form is submitted it redirects the user to the link specified in the action. Here the `<%= host %>` and `<%= port %>` are ruby variables that get inserted when the *view.html.erb* file is run through the ERB template engine to generate *view.html*.

```html
<form action="/node/<%= host %>/<%= port %>/login" method="post" target="_blank">
```

For a JupyterLab app we need to pass through the password that was set during initialisation of the app, otherwise the user would have to manually input it. This is achieved using a hidden input on the form and the `<%= password %>` ruby variable:

```html hl_lines="2"
<form action="/node/<%= host %>/<%= port %>/login" method="post" target="_blank">
  <input type="hidden" name="password" value="<%= password %>">
```

The only line we may want to change in this file is the text that will be shown on the button:

```html hl_lines="4"
<form action="/node/<%= host %>/<%= port %>/login" method="post" target="_blank">
  <input type="hidden" name="password" value="<%= password %>">
  <button class="btn btn-primary" type="submit">
    <i class="fa fa-registered"></i> Connect to Intermediate Shell app
  </button>
</form>
```

## template/script.sh.erb


## docker/Dockerfile
