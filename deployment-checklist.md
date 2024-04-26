# Deployment checklist

In *vars/ondemand-config.yml.example*:

- adjust `num_users_create` and `num_trainers_create`
- adjust `ood_apps`
  - check `version` and `k8s_container`
  - enable required apps
  - set which images to pre-pull (don't choose too many, we have limited space currently on the worker nodes and pre-pulling will fail if you exhaust it)
- set `enable_pod_prepull` if desired (should default to on probably, sometimes we have experience really slow pulls, this helps with that)
- set `control_plane_flavor`, usually to `balanced1.4cpu8ram` for production
- set `cluster_worker_count` and `worker_flavor` to have enough capacity for the number of users

In *terraform/terraform.tfvars*:

- adjust `services_flavor_id` (usually use the id for *8cpu16ram* for production)
- adjust `services_volume_size`, must be big enough for all the user home directories
- adjust `webnode_flavor_id` (the id for *8cpu16ram* works well for up to 30-40 users, not tested past that)
- adjust `webnode_volume_size`, usually leave at 30 GB
