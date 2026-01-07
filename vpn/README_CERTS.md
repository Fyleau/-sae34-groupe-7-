# Génération des Certificats OpenVPN (Guide PKI)

Pour que le serveur fonctionne en mode certificats, vous devez générer une Autorité de Certification (CA) et des certificats pour le serveur et les clients.

## Pré-requis

Installez `easy-rsa` :
- **macOS** : `brew install easy-rsa`
- **Linux** : `sudo apt install easy-rsa`

## Procédure

1.  **Créer un répertoire de travail hors du projet** (pour ne pas commiter la PKI entière) :
    ```bash
    mkdir ~/vpnpki && cd ~/vpnpki
    ```

2.  **Initialiser la PKI** :
    ```bash
    # macOS
    /opt/homebrew/share/easy-rsa/easyrsa init-pki
    # OU
    /usr/local/share/easy-rsa/easyrsa init-pki
    
    # Linux
    /usr/share/easy-rsa/easyrsa init-pki
    ```

3.  **Construire la CA** (Validez avec Entrée, pas de mot de passe pour simplifier) :
    ```bash
    easyrsa build-ca nopass
    ```

4.  **Générer le certificat Serveur** :
    ```bash
    easyrsa gen-req server nopass
    easyrsa sign-req server server
    ```
    (Tapez 'yes' pour confirmer la signature)

5.  **Générer les paramètres Diffie-Hellman** :
    ```bash
    easyrsa gen-dh
    ```

6.  **Copier les fichiers** vers le dossier `vpn/` de votre projet :
    ```bash
    # Adaptez le chemin de destination
    cp pki/ca.crt ~/Documents/GitHub/-sae34-groupe-7-/vpn/
    cp pki/issued/server.crt ~/Documents/GitHub/-sae34-groupe-7-/vpn/
    cp pki/private/server.key ~/Documents/GitHub/-sae34-groupe-7-/vpn/
    cp pki/dh.pem ~/Documents/GitHub/-sae34-groupe-7-/vpn/
    ```

## Démarrage

Une fois les fichiers `ca.crt`, `server.crt`, `server.key` et `dh.pem` présents dans le dossier `vpn/` :

```bash
docker-compose up --build -d vpn
```
