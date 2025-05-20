# Chart Layout

Our first step is relatively straight forward: Take our existing resource definitions and place them into a directory structure that Helm can understand.

- Project root directory
  - Chart.yaml
  - templates/
    - Resource definitions go here

## Chart.yaml

The [Chart.yaml](https://helm.sh/docs/topics/charts/#the-chartyaml-file) contains some metadata about our Helm chart and it's contents. You can use the one [here](./Chart.yaml) as a starting point for your own purposes.

## Templates Directory

The templates directory is where all of our resource definitions should go.

*"Where did the namespace definition go?"* - Well, we no longer need it. When we want to deploy a Helm chart, we specify a namespace for all of the resources to be deployed to like this:

```sh
helm install {{release-name}} {{chart-location}} -n {{namespace-name}} --create-namespace
```

The `-n` flag allows us to specify a namespace, whether it exists already or not. The `--create-namespace` flag tells Helm to create the specified namespace if it doesn't already exist.

The only reason that we'd need to define a namespace within the templates directory, is for the odd occasion where we want to deploy specific resources (defined in our chart) to a namespace other than the one we specify at deployment time.

Using the above command will install every resource within the templates directory in a [specific order](https://helm.sh/docs/intro/using_helm/#helm-install-installing-a-package), saving us from having to deploy each resource individually *and* having to remember what order to deploy our resources in.

## Next Steps

Now that we have a foundational Helm chart that we can deploy to an environment, how do we tackle the nuances of slightly differing configuration that might happen when promoting our application to another environment (dev -> test, for example)?

In the [next step](../02-values/README.md), we'll look at just that.
