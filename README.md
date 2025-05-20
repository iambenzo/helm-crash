# Helm Tutorial

A crash course on developing Helm charts.

If you want to follow along - check out the contents of the [bootstrap](./bootstrap/) directory.

## Course Contents

- [Resources](./00-resources/README.md)
- [Helm Chart Structure](./01-helm-chart-layout/README.md)
- [Values](./02-values/README.md)
- [Named Templates](./03-tpl-me-baby/README.md)
- [Dependencies](./04-dependencies/README.md)
- [Hooks](./05-hooks/README.md)

## Contributing

PRs are welcome!

Please include a summary of what you're changing/adding and why to your PR.

## Useful Commands

### Templating (Preview Compiled Chart)

To see exactly what a helm chart will deploy to Kubernetes, after a set of values has been applied, you can "*template*" a chart.

Templating also ensures that your chart will successfully compile.

```sh
helm template {{release-name}} {{chart-location}}
```

You can specify anything your heart desires as a release name here, it serves as an identifier for the Helm release once it's deployed. The chart location can either be a URL to a remote chart, or a path to a chart on your file system - you can use `.` for a chart defined in the directory you're currently in.

You can also use any flags that you might use when deploying the chart:

```sh
helm template {{release-name}} {{chart-location}} -n {{namespace}} -f {{values-file}}
```

The output of this command can be piped to a file, or a program:

```sh
helm template {{release-name}} {{chart-location}} > template.yaml
```

```sh
helm template {{release-name}} {{chart-location}} | code -
```

### Packaging

Before you can store a helm chart in a repository (like ghcr), it must be packaged.

If your chart has dependencies, you will need to build them:

```sh
helm dependency build {{chart-location}}
```

Now, you can package your chart:

```sh
helm package {{chart-location}}
```

You can optionally use this command to override the `appVersion` and `chartVersion`:

```sh
helm package {{chart-location}} --app-version {{appVersion}} --version {{chartVersion}}
```

### Installing or Upgrading to Kubernetes

To deploy, or upgrade a helm chart to kubernetes we can use exactly the same command:

```sh
helm upgrade -i {{release-name}} {{chart-location}} -n {{namespace}} -f {{values-file}}
```

If you need to create the namespace that helm deploys to, you can use the `--create-namespace` flag:

```sh
helm upgrade -i {{release-name}} {{chart-location}} -n {{namespace}} -f {{values-file}} --create-namespace
```

The release name is important now that we're installing/upgrading a Helm chart within a Kubernetes cluster. It serves as an identifier for the deployment of the whole chart.

This means that you can deploy the same chart multiple times under different release names - just make sure that (when upgrading) your release name matches the Helm release that you're trying to upgrade, otherwise you may find a load of duplicate Kubernetes resources next time you look at your running pods!
