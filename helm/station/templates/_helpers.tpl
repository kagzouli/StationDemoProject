{{/* vim: set filetype=mustache: */}}
{{/*
Return the stationdb image
*/}}
 
{{- define "stationdb.image.label" -}}
{{- printf "%skagzouli/station-db:%s" .Values.app.repoNexusUrl .Chart.Version -}}
{{- end -}}

{{/*
Return the stationback image
*/}}

{{- define "stationback.image.label" -}}
{{- printf "%skagzouli/station-back:%s" .Values.app.repoNexusUrl .Chart.Version -}}
{{- end -}}

{{/*
Return the stationfront image
*/}}
 
{{- define "stationfront.image.label" -}}
{{- printf "%skagzouli/station-front-nginx:%s" .Values.app.repoNexusUrl .Chart.Version -}}
{{- end -}}

{{/*
Return the contextPathBackUrl
*/}}
{{- define "stationback.contextpath" -}}
{{- printf "http://%s:%s" .Values.stationback.hostname .Values.stationback.service.externalPort -}}
{{- end -}}


