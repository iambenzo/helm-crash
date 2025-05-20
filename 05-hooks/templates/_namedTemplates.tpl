{{- define "chart.hook" }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .component.name }}
  labels:
    app.kubernetes.io/managed-by: {{ .ctx.Release.Service | quote }}
    app.kubernetes.io/instance: {{ .ctx.Release.Name | quote }}
    app.kubernetes.io/version: {{ .ctx.Chart.AppVersion }}
    helm.sh/chart: "{{ .ctx.Chart.Name }}-{{ .ctx.Chart.Version }}"
  annotations:
    "helm.sh/hook": pre-install,pre-upgrade
    "helm.sh/hook-weight": {{ .component.weight | quote }}
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  template:
    metadata:
      name: {{ .component.name }}
      labels:
        app.kubernetes.io/managed-by: {{ .ctx.Release.Service | quote }}
        app.kubernetes.io/instance: {{ .ctx.Release.Name | quote }}
        helm.sh/chart: "{{ .ctx.Chart.Name }}-{{ .ctx.Chart.Version }}"
    spec:
      restartPolicy: Never
      containers:
      - name: post-install-job
        image: "{{ .ctx.Values.global.image.registry }}alpine:latest"
        command: ["/bin/sleep","{{ default "10" .component.sleepyTime }}"]
---
{{- end }}

{{- define "chart.service" }}
apiVersion: v1
kind: Service
metadata:
  name: {{ .component.name }}
spec:
  selector:
    app: {{ .component.name }}
  type: ClusterIP
  ports:
  - name: root
    protocol: TCP
    port: {{ .component.port }}
    targetPort: {{ .component.port }}
---
{{- end }}

{{- define "chart.deployment" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .component.name }}
  labels:
    app: {{ .component.name }}
spec:
  replicas: {{ .component.replicas }}
  selector:
    matchLabels:
      app: {{ .component.name }}
  template:
    metadata:
      labels:
        app: {{ .component.name }}
    spec:
      containers:
      - name: {{ .component.name }}
        image: "{{ .ctx.Values.global.image.registry -}}{{ .component.image.name }}:{{ .ctx.Chart.AppVersion }}"
        imagePullPolicy: IfNotPresent
        env:
        - name: OTEL_ENDPOINT
          value: {{ .ctx.Values.global.otelEndpoint }}
        {{- if and .component.env .component.env.serviceBEndpoint }}
        - name: SERVICE_B_ENDPOINT
          # value: microapp-b.{{ .ctx.Release.Namespace }}.svc.cluster.local
          value: {{ .component.env.serviceBEndpoint }}
        {{- end }}
        ports:
        - containerPort: {{ .component.port }}
---
{{- end }}
