FROM debian:latest

# Installation de FreeRADIUS et du module PostgreSQL
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y freeradius freeradius-postgresql freeradius-utils && \
    rm -rf /var/lib/apt/lists/*

# Configuration du module SQL (PostgreSQL)
RUN \
    # Activer le module SQL
    ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/ && \
    # Configurer le driver et la connexion
    sed -i 's/driver = "rlm_sql_null"/driver = "rlm_sql_postgresql"/' /etc/freeradius/3.0/mods-available/sql && \
    sed -i 's/dialect = "sqlite"/dialect = "postgresql"/' /etc/freeradius/3.0/mods-available/sql && \
    sed -i 's/server = "localhost"/server = "db"/' /etc/freeradius/3.0/mods-available/sql && \
    sed -i 's/#\s*port = 5432/port = 5432/' /etc/freeradius/3.0/mods-available/sql && \
    sed -i 's/login = "radius"/login = "radius"/' /etc/freeradius/3.0/mods-available/sql && \
    sed -i 's/password = "radpass"/password = "radius"/' /etc/freeradius/3.0/mods-available/sql && \
    sed -i 's/radius_db = "radius"/radius_db = "radius"/' /etc/freeradius/3.0/mods-available/sql && \
    # Activer SQL dans le site par défaut (authorize, accounting, session, post-auth)
    sed -i 's/-sql/sql/' /etc/freeradius/3.0/sites-available/default

# Copie des clients
COPY raddb/clients.conf /etc/freeradius/3.0/clients.conf

# Ports RADIUS
EXPOSE 1812/udp
EXPOSE 1813/udp

# Lancement en mode debug (-X) pour voir les logs
CMD ["freeradius", "-X"]
