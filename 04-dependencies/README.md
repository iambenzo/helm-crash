# Dependencies

Say your Helm chart requires that another Helm chart is also deployed...

You might be working on a Helm chart that bundles your entire observability stack, or an "umbrella" Helm chart, which bundles all of your custom applications together.

In your `Chart.yaml` file, you can define dependencies (a.k.a subcharts). These are additional/external charts, which are readily available via a Helm repository. Declaring them as dependencies will deploy the resources contained in those additional charts *alongside* the resources you've defined in your `templates/` directory.

> [!important]
> Whilst they're called dependencies, these additional charts are not deployed before your chart's resources but *alongside* them. There's no ordering here.
>
> An important distinction to understand when deploying dependencies that contain Custom Resource Definitions (CRDs)

## Demo

You may have noticed that, as part of the demo resources, we deploy an Ingress rule. This rule is important but it's only half of the equation when trying to expose a Kubernetes Service to the outside world.

We also need an Ingress Controller.

Now, in our demo environment (see the [bootstrap](../bootstrap/) directory), we already have Ingress Nginx deployed. But we can't make that assumption in any other environments our Helm chart could be deployed to. Let's add Ingress Nginx as an optional dependency to our Helm chart.

To do this, modify your `Chart.yaml`:

```yaml
apiVersion: v2
name: microapps
version: 0.1.0 # chart version
appVersion: "0.0.1" # application version
description: Demo apps for Helm crash course # chart description
type: application
dependencies:
  - name: ingress-nginx # Chart name
    version: 4.12.2 # Chart version (**not** app version)
    repository: "https://kubernetes.github.io/ingress-nginx" # Chart repository
    condition: ingress.enabled
```

You can see here that the dependencies section of the `Chart.yaml` is a list, meaning we can include as many dependencies as we need.

For each dependency, we can define a `condition`. This is a reference to a `boolean` value within our `values.yaml` file. If `true`, then this dependency is deployed alongside our own chart's resources. If `false` then the dependency is excluded.

*How do you modify the values of these dependencies?* - We can include the possible values of the dependency within our own `Values.yaml` file, under a key that matches the name of the external chart:

```yaml
...
ingress-nginx: # Chart name of the dependency
  controller:
    metrics:
      enabled: true
    podAnnotations:
      prometheus.io/port: "10254"
      prometheus.io/scrape: "true"
    replicaCount: 1
...
```

*How do we know what values are available in an external chart?* - There's a Helm CLI command for that:

```sh
helm show values {{chart-location}}
```

This command will pump a chart's overridable values out into your terminal. For sexy syntax highlighting, you can pipe the output into the code editor of your choice:

```sh
helm show values {{chart-location}} | nvim
```

You can also give each dependency an `alias`, which is helpful for when you need to pull in the same Helm chart as a dependency multiple times.

```yaml
...
dependencies:
  - name: ingress-nginx # chart name
    version: 4.12.2 # chart version (**not** app version)
    repository: "https://kubernetes.github.io/ingress-nginx" # chart repository
    condition: ingress.enabled
    alias: ingresscontroller # we can name this whatever we like
```

We can use the `alias` as the key in our values file, instead of the chart name:

```yaml
...
ingressController: # Using the alias
  controller:
    metrics:
      enabled: true
    podAnnotations:
      prometheus.io/port: "10254"
      prometheus.io/scrape: "true"
    replicaCount: 1
...
```

Now that we have external dependencies in our Helm chart, we need to make sure that we pull those dependencies before we can deploy and/or package our chart:

```sh
helm dependency build
```

*Okay, you said that we need to be careful with CRDs?* - Yes, if your chart has a dependency that creates a CRD, which is then used within your chart own chart's resources, you'll get an error. In the [next step](../05-hooks/README.md) we'll look at a way around this.
