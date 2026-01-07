FROM debian:latest

# Mise à jour et installation de bind9
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y bind9 bind9utils bind9-doc && \
    rm -rf /var/lib/apt/lists/*

# Copie de la configuration
COPY config/ /etc/bind/

# Ports DNS
EXPOSE 53/udp
EXPOSE 53/tcp

# Lancement de bind9 en premier plan
CMD ["/usr/sbin/named", "-g", "-u", "bind"]
