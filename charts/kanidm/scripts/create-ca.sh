apk add --no-cache openssl bc

# Define paths for certificates to maintain consistency
CA_KEY="ca-key.pem"
CA_CERT="ca-cert.pem"

{{- tpl (.Files.Get "scripts/utils.sh") . }}

# Generate CA key and certificate
openssl genrsa -out $CA_KEY {{ .Values.certs.ca.privateKey.algorithm }} {{ .Values.certs.ca.privateKey.size }}
openssl req -x509 -new -nodes -key $CA_KEY -sha256 -days $(convert_duration_to_days {{ .Values.certs.ca.duration }}) -out $CA_CERT -subj "/CN={{ include "kanidm.ca.commonName" . }}"

# Create Kubernetes secret with the new certificates
kubectl create secret generic {{ include "kanidm.ca.secretName" . }} \
  --from-file=key.pem=$CA_KEY \
  --from-file=cert.pem=$CA_CERT \
  --dry-run=client -o yaml | kubectl apply -f -