# Notes for trainers

## Viewing training user's files

All *trainer* users should have read access on all *training* users home directories to help with debugging issues, checking progress, etc. The paths to the home directories will look like:

```
/home/shared/training1
/home/shared/training2
...
```

## Recommended browsers

Following upstream Open OnDemand [documentation](https://osc.github.io/ood-documentation/latest/requirements.html#browser-requirements) we highly recommend the use of Chrome, Firefox or Edge.

Other browsers and extensions (ad blockers, etc) could cause issues. For example, we have observed problems with the DuckDuckGo browser, which blocked the password from being passed transparently to JupyterLab, causing an "Invalid credentials" error.

![jupyter credentials error](jupyter-browser-error.png)

## Session limits

Each user (both *trainer* and *training* users) are limited to one running session (app) at a time, to ensure there are enough resources for everyone to run something. To restart an app, or stop an app so that you can start another one, you should:

- browse to the "My Interactive Sessions" tab
- click "Delete" on the running session
- **important:** wait for approx one minute for the underlying pod to get properly deleted by the kubernetes cluster (otherwise you will get an error at the next step)
- launch the new app

## Browser based terminal app

![webnode shell access](webnode-shell-access.png)

The browser based terminal in the OnDemand web interface runs on the webnode and can be used to monitor progress and assist *training* users from outside the apps. These terminal sessions run on the OnDemand web node and do not have any resource restrictions, so nothing resource intensive should be run there. Only *trainer* users can use this feature; if *training* users try to use it they will get an error.
