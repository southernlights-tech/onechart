{{/* vim: set filetype=mustache: */}}

{{/*
Resolve the release name, allowing override via releaseNameOverride value
*/}}
{{- define "common.releaseNameOverride" -}}
{{ .Values.releaseNameOverride | default .Release.Name }}
{{- end }}

{{/*
Create robustName that can be used as Kubernetes resource name, and as subdomain as well
\w – Latin letters, digits, underscore '_' .
\W – all but \w .
*/}}
{{- define "common.robustName" -}}
{{ regexReplaceAll "\\W+" . "-" | replace "_" "-" | lower | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Normalize secret manager items
*/}}
{{- define "common.secretManagerItems" -}}
  {{- $items := list -}}
  {{- $releaseName := include "common.releaseNameOverride" . -}}
  {{- if .Values.secrets.secretManager -}}
    {{- if .Values.secrets.secretManager.name -}}
      {{- $volumeName := include "common.robustName" (printf "%s-csi" $releaseName) -}}
      {{- $mountPath := "/mnt/secrets-store" -}}
      {{- if .Values.secrets.secretManager.csi.path -}}
        {{- $mountPath = .Values.secrets.secretManager.csi.path -}}
      {{- end -}}
      {{- $item := dict "name" .Values.secrets.secretManager.name "keys" .Values.secrets.secretManager.keys "keyMappings" .Values.secrets.secretManager.keyMappings "mountPath" $mountPath "volumeName" $volumeName -}}
      {{- $items = append $items $item -}}
    {{- end -}}
    {{- if .Values.secrets.secretManager.items -}}
      {{- range .Values.secrets.secretManager.items -}}
        {{- $volumeName := include "common.robustName" (printf "%s-csi-%s" $releaseName .name) -}}
        {{- $mountPath := printf "/mnt/secrets-store/%s" .name -}}
        {{- $item := dict "name" .name "keys" .keys "keyMappings" .keyMappings "mountPath" $mountPath "volumeName" $volumeName -}}
        {{- $items = append $items $item -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $items | toJson -}}
{{- end -}}
