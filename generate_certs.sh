#!/bin/bash

# Script de génération de certificats OpenVPN via Docker (Compatible Linux/macOS)

echo "Génération des certificats OpenVPN via un conteneur Debian..."

# Utilisation de docker run pour générer les certificats
# $(pwd) fonctionne universellement sur Linux/Mac pour le chemin courant

docker run --rm -v "$(pwd)/vpn:/vpn" -w /vpn debian:latest /bin/bash -c "
    apt-get update && \
    apt-get install -y easy-rsa && \
    /usr/share/easy-rsa/easyrsa init-pki && \
    /usr/share/easy-rsa/easyrsa --batch build-ca nopass && \
    echo 'Génération Server Cert...' && \
    /usr/share/easy-rsa/easyrsa --batch build-server-full server nopass && \
    echo 'Génération DH...' && \
    /usr/share/easy-rsa/easyrsa gen-dh && \
    cp pki/ca.crt . && \
    cp pki/issued/server.crt . && \
    cp pki/private/server.key . && \
    cp pki/dh.pem . && \
    rm -rf pki && \
    echo 'Terminé !'
"

echo "Certificats générés dans le dossier vpn/"
