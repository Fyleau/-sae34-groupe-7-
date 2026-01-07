FROM debian:latest

# Mise à jour et installation d'OpenVPN et iptables
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openvpn iptables && \
    rm -rf /var/lib/apt/lists/*

# Copie de la configuration
COPY server.conf /etc/openvpn/server.conf

# Port OpenVPN
EXPOSE 1194/udp

# Lancement d'OpenVPN avec activation du forwarding
CMD sysctl -w net.ipv4.ip_forward=1 && \
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE && \
    openvpn --config /etc/openvpn/server.conf
