#!/bin/bash

# Set your strong password here
OPENSEARCH_PASSWORD=$(openssl rand -base64 48)

# Capture the IP address of the ens33 interface
IP_ADDRESS=$(ip -4 addr show ens33 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -z "$IP_ADDRESS" ]; then
  echo "Error: Could not find an IP address for interface ens33."
  exit 1
fi

echo "Using IP address: $IP_ADDRESS"

# Create a directory to store your certificates
mkdir -p opensearch-certs

# Generate a private key
openssl genpkey -algorithm RSA -out opensearch-certs/opensearch-key.pem -pkeyopt rsa_keygen_bits:2048

# Generate a self-signed certificate
openssl req -x509 -new -key opensearch-certs/opensearch-key.pem -out opensearch-certs/opensearch-ca.pem -days 365 -subj "/CN=localhost"

# Set the correct permissions for the private key and certificates
chmod 644 opensearch-certs/opensearch-key.pem
chmod 644 opensearch-certs/opensearch-ca.pem
cp opensearch-certs/opensearch-ca.pem opensearch-certs/opensearch-cert.pem

# Append the Docker Compose configuration to docker-compose.yml
cat <<EOF >> docker-compose.yml
version: '3'
services:
  opensearch:
    image: opensearchproject/opensearch:latest
    container_name: opensearch_dev
    environment:
      - discovery.type=single-node
      - OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m
      - OPENSEARCH_INITIAL_ADMIN_PASSWORD=$OPENSEARCH_PASSWORD
      - OPENSEARCH_PASSWORD=$OPENSEARCH_PASSWORD
      - plugins.security.disabled=false                      # Enable security plugin
      - plugins.security.ssl.http.enabled=true               # Enable SSL/TLS for HTTP
      - plugins.security.ssl.http.pemcert_filepath=/usr/share/opensearch/config/certs/opensearch-cert.pem
      - plugins.security.ssl.http.pemkey_filepath=/usr/share/opensearch/config/certs/opensearch-key.pem
      - plugins.security.ssl.http.pemtrustedcas_filepath=/usr/share/opensearch/config/certs/opensearch-ca.pem
      - plugins.security.ssl.transport.enabled=true          # Enable SSL/TLS for transport
      - plugins.security.ssl.transport.pemcert_filepath=/usr/share/opensearch/config/certs/opensearch-cert.pem
      - plugins.security.ssl.transport.pemkey_filepath=/usr/share/opensearch/config/certs/opensearch-key.pem
      - plugins.security.ssl.transport.pemtrustedcas_filepath=/usr/share/opensearch/config/certs/opensearch-ca.pem
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - opensearch-data:/usr/share/opensearch/data
      - ./opensearch-certs:/usr/share/opensearch/config/certs   # Mount the directory containing the certificates
    ports:
      - "9200:9200"
      - "9600:9600"

  opensearch-dashboards:
    image: opensearchproject/opensearch-dashboards:latest
    container_name: opensearch-dashboards_dev
    environment:
      - OPENSEARCH_HOSTS=https://$IP_ADDRESS:9200
      - OPENSEARCH_USERNAME=admin
      - OPENSEARCH_PASSWORD=$OPENSEARCH_PASSWORD
      - OPENSEARCH_SSL_VERIFICATIONMODE=none
    ports:
      - "5601:5601"
    depends_on:
      - opensearch

volumes:
  opensearch-data:
EOF

echo "Docker Compose configuration has been appended to docker-compose.yml."

#Start Opensearch
docker-compose up
