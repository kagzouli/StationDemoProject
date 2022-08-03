{{/* vim: set filetype=mustache: */}}
{{/*
Return the stationdb image
*/}}
 
{{- define "stationdb.image.label" -}}
{{- printf "%s/station-db:%s" .Values.image.repoNexusUrl .Values.image.tag -}}
{{- end -}}

{{/*
Return the stationback image
*/}}

{{- define "stationback.image.label" -}}
{{- printf "%s/station-back:%s" .Values.image.repoNexusUrl .Values.image.tag -}}
{{- end -}}

{{/*
Return the stationfront image
*/}}
 
{{- define "stationfront.image.label" -}}
{{- printf "%s/station-front-nginx:%s" .Values.image.repoNexusUrl .Values.image.tag -}}
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
