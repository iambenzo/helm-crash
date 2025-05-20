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
        imagePullPolicy: Never
        env:
        - name: OTEL_ENDPOINT
          value: {{ .ctx.Values.global.otelEndpoint }}
        {{- if and .component.env .component.env.serviceBEndpoint }}
        - name: SERVICE_B_ENDPOINT
          value: microapp-b.{{ .ctx.Release.Namespace }}.svc.cluster.local
        {{- end }}
        ports:
        - containerPort: {{ .component.port }}
---
{{- end }}

