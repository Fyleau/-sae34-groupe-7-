FROM debian:latest

# Mise à jour et installation d'OpenVPN et iptables
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openvpn && \
    rm -rf /var/lib/apt/lists/*

# Copie de la configuration et des certificats
COPY server.conf /etc/openvpn/server.conf
COPY ca.crt server.crt server.key dh.pem /etc/openvpn/

# Port OpenVPN
EXPOSE 1194/udp

# Lancement d'OpenVPN (Création du device TUN indispensable sur Mac/Docker Desktop)
CMD mkdir -p /dev/net && \
    if [ ! -c /dev/net/tun ]; then mknod /dev/net/tun c 10 200; fi && \
    openvpn --config /etc/openvpn/server.conf
