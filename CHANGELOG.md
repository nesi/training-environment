# CHANGELOG

## Unversioned

- Increase default number of nfs threads and make it configurable

## 2024-04-26

- Update Open OnDemand from 3.0.5 to 3.1.1
- Enable [cancel interactive sessions](https://osc.github.io/ood-documentation/latest/customizations.html#cancel-interactive-sessions) by default
- Add `nesi-get-pods` and `nesi-get-pods-wide` commands that trainer users can run via *"Cluster" -> "Web node shell access"* to list currently running sessions
- [Tune](https://osc.github.io/ood-documentation/latest/how-tos/debug/debug-apache.html#performance-tuning) web server config on the *webnode* to handle more requests
- Default to using the *NeSI-FlexiHPC-Ubuntu-Jammy_22.04* image for the web and services nodes
