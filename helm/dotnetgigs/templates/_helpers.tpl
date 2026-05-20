{{- define "dotnetgigs.name" -}}
dotnetgigs
{{- end -}}

{{- define "dotnetgigs.namespace" -}}
{{- .Values.namespace.name | default .Release.Namespace -}}
{{- end -}}

{{- define "dotnetgigs.labels" -}}
app.kubernetes.io/part-of: dotnetgigs
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
project: {{ .Values.global.labels.project | quote }}
owner: {{ .Values.global.labels.owner | quote }}
{{- end -}}

{{- define "dotnetgigs.selectorLabels" -}}
app.kubernetes.io/part-of: dotnetgigs
{{- end -}}

{{- define "dotnetgigs.image" -}}
{{- $root := index . 0 -}}
{{- $image := index . 1 -}}
{{- if contains "/" $image -}}
{{- $image -}}
{{- else -}}
{{- printf "%s/%s:%s" $root.Values.global.imageRegistry $image $root.Values.global.imageTag -}}
{{- end -}}
{{- end -}}

{{- define "dotnetgigs.annotations" -}}
{{- with .Values.global.podAnnotations }}
{{- toYaml . }}
{{- end }}
{{- end -}}
