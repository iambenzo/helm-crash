# Hooks

[Helm hooks](https://helm.sh/docs/topics/charts_hooks/) are used to run Jobs, or deploy resources at various stages in the Helm lifecycle.

These can be used to backup a database before an upgrade operation, load some data before an install operation, or even to deploy custom resources after the custom resource definitions have been installed.

Here's are the common stages in the Helm lifecycle where you might want to leverage hooks:

| Stage | Description |
| :--- | :--- |
| pre-install | Runs before resources are installed |
| pre-upgrade | Runs before resources are upgrades |
| post-install | Runs after resources are installed |
| post-upgrade | Runs after resources are upgraded |
| post-delete | Runs after resources are deleted |

> [!important]
> A resource deployed as a `pre-install` and/or a `pre-upgrade` hook will block the deployment of the rest of your chart's resources until they have successfully run/been installed.

You can deploy any type of resource as a hook, but it makes the most sense to restrict your hooks to Job or Custom resources. To do this, you simply add a few annotations to a resource you have defined in your `templates/` directory:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: "{{ .Release.Name }}"
  annotations:
    "helm.sh/hook": post-install,post-upgrade
    "helm.sh/hook-weight": "1"
    "helm.sh/hook-delete-policy": hook-succeeded
```

The `helm.sh/hook` annotation tells Helm which part of it's deployment lifecycle you want this resource to be deployed in.

The `helm.sh/hook-weight` allows you to define an order of running for your hooks. If you have multiple `pre-install` hooks and you want them to run in a specific order, specify a weight and Helm will run the hooks one at a time in ascending order.

The `helm.sh/hook-delete-policy` allows you to define when the hook resource is deleted by Helm. There are three options here:

| Policy | Description |
| :--- | :--- |
| before-hook-creation | Delete the previous resource before a new hook is launched (default) |
| hook-succeeded | Delete the resource after the hook is successfully executed (good for one-shot Jobs) |
| hook-failed | Delete the resource if the hook failed during execution |
