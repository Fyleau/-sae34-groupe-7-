FROM debian:latest

# Mise à jour et installation de chrony
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y chrony && \
    rm -rf /var/lib/apt/lists/*

# Copie de la configuration
COPY chrony.conf /etc/chrony/chrony.conf

# Port NTP
EXPOSE 123/udp

# Lancement de chrony en premier plan
CMD ["chronyd", "-d"]
