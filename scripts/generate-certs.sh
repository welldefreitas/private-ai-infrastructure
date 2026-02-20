#!/bin/bash
# ------------------------------------------------------------------
# Generates self-signed SSL certificates for local testing.
# ------------------------------------------------------------------

mkdir -p nginx/certs

if [ ! -f nginx/certs/selfsigned.crt ]; then
    echo "[*] Generating self-signed SSL certificates..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout nginx/certs/selfsigned.key -out nginx/certs/selfsigned.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" 2>/dev/null
    echo "[+] Certificates generated in nginx/certs/"
else
    echo "[*] SSL Certificates already exist. Skipping."
fi
