FROM debian:latest

# Mise à jour et installation de chrony
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y chrony && \
    mkdir -p /run/chrony && chown _chrony:_chrony /run/chrony && \
    rm -rf /var/lib/apt/lists/*

# Copie de la configuration
COPY chrony.conf /etc/chrony/chrony.conf

# Port NTP
EXPOSE 123/udp

# Lancement de chrony en premier plan (avec l'utilisateur par défaut pour Debian)
CMD ["chronyd", "-d", "-u", "_chrony"]
