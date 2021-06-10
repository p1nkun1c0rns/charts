{{/*
Expand the name of the chart.
*/}}
{{- define "gcppromd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gcppromd.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gcppromd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gcppromd.labels" -}}
helm.sh/chart: {{ include "gcppromd.chart" . }}
{{ include "gcppromd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create default labels
*/}}
{{- define "gcppromd.defaultLabels" -}}
{{- $labelChart := include "gcppromd.chart" $ -}}
{{- $labelApp := include "gcppromd.name" $ -}}
{{- $labels := dict "app" $labelApp "chart" $labelChart "release" .Release.Name "heritage" .Release.Service -}}
{{ merge .extraLabels $labels | toYaml | indent 4 }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "gcppromd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gcppromd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gcppromd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gcppromd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
