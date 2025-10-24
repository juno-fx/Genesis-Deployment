#!/bin/bash
set -euo pipefail

if [[ -z "${ORION_HOSTNAME:-}" ]]; then
  echo "ERROR: ORION_HOSTNAME is not set."
  exit 1
fi

if [[ -z "${ORION_TLS_SECRET:-}" ]]; then
  echo "ERROR: ORION_TLS_SECRET is not set."
  exit 1
fi

KEY_FILE="/tmp/${ORION_HOSTNAME}.wildcard.key"
CERT_FILE="/tmp/${ORION_HOSTNAME}.wildcard.crt"
CONFIG_FILE="/tmp/openssl-wildcard.cnf"

cat > "$CONFIG_FILE" <<EOF
[req]
distinguished_name = dn
req_extensions = v3_req
prompt = no
default_bits = 2048
default_md = sha256

[dn]
CN = *.${ORION_HOSTNAME}

[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.${ORION_HOSTNAME}
DNS.2 = ${ORION_HOSTNAME}
EOF

echo "Generating wildcard TLS certificate for *.${ORION_HOSTNAME} and ${ORION_HOSTNAME}..."

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout "$KEY_FILE" \
  -out "$CERT_FILE" \
  -config "$CONFIG_FILE" \
  -extensions v3_req \
  -sha256

echo "Certificate generated successfully."

echo "Verifying Subject Alternative Names..."
openssl x509 -in "$CERT_FILE" -text -noout | grep -A 2 "Subject Alternative Name" || true

if kubectl get secret "${ORION_TLS_SECRET}" -n argocd &> /dev/null; then
  echo "Secret '${ORION_TLS_SECRET}' already exists in namespace 'argocd'. Skipping creation."
  rm -f "$KEY_FILE" "$CERT_FILE" "$CONFIG_FILE"
  exit 0
fi

echo "Creating TLS secret '${ORION_TLS_SECRET}' in namespace 'argocd'..."
kubectl create secret tls "${ORION_TLS_SECRET}" \
  --cert="$CERT_FILE" \
  --key="$KEY_FILE" \
  -n argocd

echo "Secret '${ORION_TLS_SECRET}' created successfully."
