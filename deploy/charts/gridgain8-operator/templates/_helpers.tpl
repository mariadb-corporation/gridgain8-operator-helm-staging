{{- define "gridgain-k8s-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gridgain-k8s-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else if .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "gridgain-k8s-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gridgain-k8s-operator.commonLabels" -}}
app.kubernetes.io/name: gridgain-k8s-operator
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "gridgain-k8s-operator.chart" . }}
{{- end }}

{{- define "gridgain-k8s-operator.selectorLabels" -}}
app.kubernetes.io/name: gridgain-k8s-operator
control-plane: controller-manager
{{- end }}

{{- define "gridgain-k8s-operator.serviceAccountName" -}}
{{- default "gridgain-k8s-operator-controller-manager" .Values.serviceAccount.name }}
{{- end }}

{{- define "gridgain-k8s-operator.webhookConfigName" -}}
{{- .Values.validatingWebhook.name | default "gridgain-k8s-operator-validating-webhook-configuration" }}
{{- end }}
