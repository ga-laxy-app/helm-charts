apk add --no-cache openssl bc

# Define paths for certificates to maintain consistency
CA_KEY="/var/ca/ca-key.pem"
CA_CERT="ca-cert.pem"
SERVER_KEY="server-key.pem"
SERVER_CSR="server.csr"
SERVER_CERT="server-cert.pem"

{{- tpl (.Files.Get "scripts/utils.sh") . }}

# Generate server private key
generate_key $SERVER_KEY {{ .Values.certs.ssl.privateKey.algorithm }} {{ .Values.certs.ssl.privateKey.size }}

# Generate CSR with dynamic CN based on the Pod's hostname and namespace
openssl req -new -key $SERVER_KEY -out $SERVER_CSR -subj "/CN={{ include "kanidm.ssl.commonName" . }}"

# Sign the server certificate with the CA
openssl x509 -req -days $(convert_duration_to_days {{ .Values.certs.ssl.duration }}) -in $SERVER_CSR -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $SERVER_CERT

# Create Kubernetes secret with the new certificates
kubectl create secret generic {{ include "kanidm.ssl.secretName" . }} \
  --from-file=ca.pem=$CA_CERT \
  --from-file=cert.pem=$SERVER_CERT \
  --from-file=key.pem=$SERVER_KEY \
  --dry-run=client -o yaml | kubectl apply -f -