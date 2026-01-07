# Génération des Certificats OpenVPN

Ce guide explique comment générer les certificats nécessaires pour le serveur VPN en utilisant **Easy-RSA**.

## 1. Installation de Easy-RSA

### Sur Linux (Debian/Ubuntu)
```bash
sudo apt update
sudo apt install easy-rsa
```

### Sur macOS
```bash
brew install easy-rsa
```

## 2. Initialisation de la PKI

Placez-vous dans un répertoire de travail (par exemple `vpn/easy-rsa`) :

```bash
# Sur Linux, créez un lien vers les scripts easy-rsa
make-cadir my-pki && cd my-pki
# OU simplement utilisez le dossier d'installation (macOS)
cd $(brew --prefix)/share/easy-rsa # (adapter le chemin si besoin)
```

## 3. Étapes de génération

Exécutez les commandes suivantes dans l'ordre :

```bash
# Initialiser le dossier pki
./easyrsa init-pki

# Créer l'autorité de certification (CA)
# On vous demandera une passphrase et un nom (Common Name)
./easyrsa build-ca nopass

# Générer les paramètres Diffie-Hellman (prend un peu de temps)
./easyrsa gen-dh

# Générer le certificat et la clé du serveur
./easyrsa gen-req server nopass
./easyrsa sign-req server server

# (Optionnel) Générer un certificat pour un client
./easyrsa gen-req client1 nopass
./easyrsa sign-req client client1
```

## 4. Placement des fichiers

Une fois générés, copiez les fichiers suivants dans le dossier `vpn/` de votre projet pour qu'ils soient accessibles au conteneur :

- `pki/ca.crt` -> `vpn/ca.crt`
- `pki/issued/server.crt` -> `vpn/server.crt`
- `pki/private/server.key` -> `vpn/server.key`
- `pki/dh.pem` -> `vpn/dh.pem`

## 5. Mise à jour du Dockerfile

N'oubliez pas d'ajouter ces fichiers dans votre `vpn/Dockerfile` ou de les monter via un volume dans `docker-compose.yml`.

Exemple de montage dans `docker-compose.yml` :
```yaml
  vpn:
    ...
    volumes:
      - ./vpn/ca.crt:/etc/openvpn/ca.crt
      - ./vpn/server.crt:/etc/openvpn/server.crt
      - ./vpn/server.key:/etc/openvpn/server.key
      - ./vpn/dh.pem:/etc/openvpn/dh.pem
```
