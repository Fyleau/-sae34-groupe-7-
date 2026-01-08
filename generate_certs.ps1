# Script de génération de certificats OpenVPN via Docker
# Cela évite d'installer easy-rsa sur Windows

Write-Host "Génération des certificats OpenVPN via un conteneur Debian..."

# Nous utilisons l'image debian:latest pour avoir les mêmes outils
# Nous utilisons l'image debian:latest pour avoir les mêmes outils
docker run --rm -v "${PWD}/vpn:/vpn" -w /vpn debian:latest /bin/bash -c "apt-get update && apt-get install -y easy-rsa && /usr/share/easy-rsa/easyrsa init-pki && /usr/share/easy-rsa/easyrsa --batch build-ca nopass && echo 'Génération Server Cert...' && /usr/share/easy-rsa/easyrsa --batch build-server-full server nopass && echo 'Génération DH...' && /usr/share/easy-rsa/easyrsa gen-dh && cp pki/ca.crt . && cp pki/issued/server.crt . && cp pki/private/server.key . && cp pki/dh.pem . && rm -rf pki && echo 'Terminé !'"

Write-Host "Certificats générés dans le dossier vpn/"
