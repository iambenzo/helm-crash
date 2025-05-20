# Named Templates

[Named templates](https://helm.sh/docs/chart_template_guide/named_templates/) allow you to define reusable blocks of YAML, which can be used within (m)any of your templates.

Start by creating a file in your templates directory that begins with the `_` character and has the `tpl` extension. `_helpers.tpl`, for example.

Open this file and define your first reusable YAML block:

```go
{{- define "do.the.thing" }}
annotations:
    nginx.ingress.kubernetes.io/enable-opentelemetry: "true"
    nginx.ingress.kubernetes.io/opentelemetry-trust-incoming-span: "true"
{{- end }}
```

We can use this named template in our `ingress.yaml` template, if we wanted to:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: microapp
  {{- template "do.the.thing" }}
...
```

You don't have to create separate files for each named template - you could have any number of resusable YAML blocks defined in a single `_thing.tpl` file. However, you can also have any number of `_moreThings.tpl` files in your templates directory.

Think about maintainability here. It might be nice to have related YAML blocks defined in one file, using another file for blocks with another purpose.

This is as complicated as named templates get...unless you want to complicate them...

## Our Demo App

Looking at the codebase from the [previous step](../02-values/), we can see that we have two Kubernetes resources (deployments and services) that could be encapsulated in a `range` (loop) statement.

> [!NOTE]
> We're taking named templates to the extreme here to showcase looping and context.

*"What have you done??* - Well, instead of having clean, separate sections for our two apps in the `values.yaml` file, we now have them defined in a list.

Because we have a list of apps to deploy, we can start reusing our templates a little better. Instead of having `deployment-a.yaml` and `deployment-b.yaml`, we can now have a single `deployments.yaml` containing a loop over the the list of apps defined in the `values.yaml` file.

```go
{{- range .Values.apps -}}
	# template stuff here...
{{- end -}}
```

We *could* have both our service and deployment definitions in this single loop. But I'd like to show you how you'd do this using named templates.

Before we start smashing keys, let's create a couple of named templates. You'll see them defined in [`_namedTemplates.tpl`](./templates/_namedTemplates.tpl). We have one named template for our service definitions and one for our deployment definitions.

Within the `chart.deployment` named template, you can see that we're making use of an `if` statement and accessing values from `.ctx` and `.component`. *"Where do these come from?*

The answer is in the [`deployments.yaml`](./templates/deployments.yaml) and the [`services.yaml`](./templates/services.yaml) files.

Looking at the [`deployments.yaml`](./templates/deployments.yaml) file, you can see that we're using a `range` function to iterate over `.Values.apps` from our `values.yaml` file. Nothing too weird here.

Within that loop, we're using `include` to inject our named template within the loop - *for each defined app, generate a Kubernetes deployment resource.* Within the same `include` statement, we're passing a `dict` (HashMap) where the `ctx` key has a value of `$` and the `component` key has a value of `.`.

*What??*

Yeah, I know...When we're doing things within a named template, we're operating under another context - think of this as a new scope, so we need to pass any values we might need as parameters.

The `$` symbol is a reference to the root context, which is accessible from our resource templates but not our named templates.

As soon as you start a loop within a Helm chart, you're operating in the context of the items you're iterating over. The `.` symbol is a reference to the current context, meaning the current item within the list of items.

Hopefully, you can now see that we're passing the root context (`$`) in order to access the container registry for our container images from the `values.yaml` and the application version from the `Chart.yaml`. We're also passing the current item of our list of applications (`.`) as `component`.

This step is as confusing as writing Helm charts gets. In the [next step](../04-dependencies/README.md), we'll look at incorporating external charts into our own.
