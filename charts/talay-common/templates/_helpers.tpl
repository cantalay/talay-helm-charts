{{- define "talay.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "talay.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "talay.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "talay.selectorLabels" -}}
app.kubernetes.io/name: {{ include "talay.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "talay.labels" -}}
helm.sh/chart: {{ include "talay.chart" . }}
{{ include "talay.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.environment }}
talay.io/environment: {{ . | quote }}
{{- end }}
{{- with .Values.partOf }}
app.kubernetes.io/part-of: {{ . | quote }}
{{- end }}
{{- end }}

{{- define "talay.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "talay.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "talay.externalSecretName" -}}
{{- default (printf "%s-secrets" (include "talay.fullname" .)) .Values.externalSecret.targetName }}
{{- end }}
