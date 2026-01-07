FROM debian:latest

# Installation de PostgreSQL
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y postgresql postgresql-contrib && \
    rm -rf /var/lib/apt/lists/*

# Préparation des dossiers
RUN mkdir -p /var/lib/postgresql/data /run/postgresql /docker-entrypoint-initdb.d && \
    chown -R postgres:postgres /var/lib/postgresql /run/postgresql

# Copie et droits du script d'entrée
COPY entrypoint.sh /usr/local/bin/
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Configuration
USER root
EXPOSE 5432
VOLUME ["/var/lib/postgresql/data"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
