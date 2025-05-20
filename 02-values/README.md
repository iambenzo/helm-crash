# Values

Values are YAML key/value pairs that can be referenced within our resource templates.

A common value that you'll see in the wild is one for a container image registry, something that might be different for each environment you deploy an application to.

To achieve this, you'd first create a `values.yaml` file in the root directory of your Helm chart (the same directory as your `Chart.yaml` file) and specify a key and a value for a container registry, for example:

```yaml
registry: docker.io
```

Then in your deployment resources (or any resource that specifies a container image), you'd use the [GoLang template syntax](https://pkg.go.dev/text/template) to access the value, like so:

```yaml
...
spec:
  containers:
    - name: example
      image: "{{ .Values.registry }}/imagename:tag"
...
```

Keys in your values file can be nested to allow for grouping of related parameters. It's always helpful to add comments to your values file too, so that users of your chart can understand what modifying a value does:

```yaml
image:
  registry: docker.io # container image registry
  tag: 0.0.1 # container image tag
```

```yaml
...
spec:
  containers:
    - name: example
      image: "{{ .Values.image.registry }}/imagename:{{ .Values.image.tag }}"
...
```

A nice way to think of our chart's values file is as a set of variables with default values, which can be overridden by users of our chart. Users of our chart could be other people, or just our future selves.

There are [additional "values"](https://helm.sh/docs/chart_template_guide/builtin_objects/) that you can use in your templates, which originate from other places. Common examples are:

- `{{ .Release.Namespace }}`
  - This represents the namespace that the Helm chart is being deployed to
- `{{ .Chart.AppVersion }}`
  - The version of the application, which is sourced from the `Chart.yaml` file

You should be aware that the [GoLang template syntax](https://pkg.go.dev/text/template) allows you to use [flow control](https://helm.sh/docs/chart_template_guide/control_structures/) and [variables](https://helm.sh/docs/chart_template_guide/variables/) in your templates too. Let's take a look at how we can use looping, whilst tidying up our codebase in the [next step](../03-tpl-me-baby/README.md).
