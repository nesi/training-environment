# REANNZ containers workshop examples

These are the example files from the
[workshop repo](https://github.com/nesi/reannz-containers-workshop), copied into your home
directory when the app starts. Existing files are never overwritten, so anything you change is kept
when you restart the session.

The workshop material itself is at <https://nesi.github.io/reannz-containers-workshop/>.

## Already built for you

The two containers from
[chapter 2](https://nesi.github.io/reannz-containers-workshop/setup-containers/#2-the-basics-of-running-containers-on-apptainer)
are built and ready to run:

```bash
cd ~/containers-workshop/examples/02_basics_of_containers
apptainer run hello-world.sif
apptainer run lolcow.sif
```

## Building the rest yourself

Every other chapter's `.sif` files you build as you go, following
[setup-containers](https://nesi.github.io/reannz-containers-workshop/setup-containers/). For
example:

```bash
cd ~/containers-workshop/examples/04_building_containers
apptainer build my_python3.12.sif my_python3.12.def
```

If a build complains about permissions, add `--fakeroot`.

Notes:

* Images pulled from registries are cached in `~/.apptainer/cache`, so they survive a session
  restart. Run `apptainer cache clean` if you run low on space in your home directory.
* Your home directory is bind mounted into the container by default, so `$HOME` inside a container
  is the same `$HOME` you see outside it.
* The MPI examples (chapter 9) are not included here — they are written for a Slurm cluster. They
  are in the [workshop repo](https://github.com/nesi/reannz-containers-workshop/tree/main/examples)
  if you want them.
