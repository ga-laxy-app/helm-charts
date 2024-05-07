{{/*

*/}}
{{- define "kanidm.shouldCreateCert" -}}
{{- if and .duration .privateKey .privateKey.algorithm .privateKey.encoding .privateKey.size (not .issuerRef) }}
true
{{- end }}
{{- end -}}

{{/*

*/}}
{{- define "kanidm.ca.secretName" -}}
{{ .Values.certs.ca.secretName | default (printf "%s-%s" (include "kanidm.fullname" .) "ca") }}
{{- end -}}

{{/*

*/}}
{{- define "kanidm.ca.commonName" -}}
{{ .Values.certs.ssl.commonName | default (printf "%s-%s" (include "kanidm.fullname" .) "ca") }}
{{- end -}}

{{/*

*/}}
{{- define "kanidm.ssl.secretName" -}}
{{ .Values.certs.ssl.secretName | default (printf "%s-%s" (include "kanidm.fullname" .) "ssl") }}
{{- end -}}

{{/*

*/}}
{{- define "kanidm.ssl.commonName" -}}
{{ .Values.certs.ssl.commonName | default (printf "%s-%s" (include "kanidm.fullname" .) "web") }}
{{- end -}}

{{/*

*/}}
{{- define "kanidm.ssl.dnsNames" -}}
- {{ join "." (list (include "kanidm.ssl.commonName" .) .Release.Namespace "svc" "cluster.local") }}
{{- end -}}