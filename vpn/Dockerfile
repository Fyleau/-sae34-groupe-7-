FROM debian:latest

# Mise à jour et installation d'OpenVPN
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openvpn && \
    rm -rf /var/lib/apt/lists/*

# Copie de la configuration
COPY server.conf /etc/openvpn/server.conf

# Port OpenVPN
EXPOSE 1194/udp

# Lancement d'OpenVPN
CMD ["openvpn", "--config", "/etc/openvpn/server.conf"]
