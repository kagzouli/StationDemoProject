{{/* vim: set filetype=mustache: */}}
{{/*
Return the stationdb image
*/}}
 
{{- define "stationdb.image.label" -}}
{{- printf "%skagzouli/station-db:%s" .Values.app.repoNexusUrl .Chart.AppVersion -}}
{{- end -}}

{{/*
Return the stationback image
*/}}

{{- define "stationback.image.label" -}}
{{- printf "%skagzouli/station-back:%s" .Values.app.repoNexusUrl .Chart.AppVersion -}}
{{- end -}}

{{/*
Return the stationfront image
*/}}
 
{{- define "stationfront.image.label" -}}
{{- printf "%skagzouli/station-front-nginx:%s" .Values.app.repoNexusUrl .Chart.AppVersion -}}
{{- end -}}

{{/*
Return the contextPathBackUrl
*/}}
{{- define "stationback.contextpath" -}}
{{- printf "http://%s:%s" .Values.stationback.hostname  (toString .Values.stationback.externalPort) -}}
{{- end -}}

{{/*
Return the database url for stationback 
*/}}
{{- define "stationback.databaseUrl" -}}
{{- printf "jdbc:mysql://stationdbservice.%s.svc.cluster.local:3306/StationDemoDb?connectTimeout=0" .Release.Namespace  -}}
{{- end -}}

{{/*
Return the hostname of the redis server 
*/}}
{{- define "stationredis.hostname" -}}
{{- printf "stationredisservice.%s.svc.cluster.local" .Release.Namespace  -}}
{{- end -}}
