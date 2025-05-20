# Initial Resources

This directory simply shows a set of Kubernetes resources that we'd like to deploy to a Kubernetes cluster.

This directory contains:

- One Namespace definition
- Two Deployment definitions
- Two Service definitions
- One Ingress (rule) definition

These Kubernetes resource definitions ultimately deploy two small applications.

There's no Helm here.

We can deploy these resources one by one, using `kubectl apply -f {{file}}` and get a working suite of resources if we deploy them in the right order...but that's a lot of typing and I'd rather spend that time refining my NeoVim config.

Before we can learn how Helm might help us, we need to understand how to structure a Helm chart based on these resources. We'll do this in the [next step](../01-helm-chart-layout/README.md).
