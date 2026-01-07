#!/bin/bash
set -e

# Configuration des chemins
PGDATA="/var/lib/postgresql/data"

# Détection automatique de la version de PostgreSQL
PG_VER=$(ls /usr/lib/postgresql/ | sort -V | tail -n 1)
if [ -z "$PG_VER" ]; then
    echo "Erreur: PostgreSQL non trouvé."
    exit 1
fi
BIN_DIR="/usr/lib/postgresql/$PG_VER/bin"

# Assurer les droits sur les dossiers si root
if [ "$(id -u)" = '0' ]; then
    mkdir -p "$PGDATA" /run/postgresql
    chown -R postgres:postgres "$PGDATA" /run/postgresql
fi

# Initialisation de la DB si le dossier est vide
if [ -z "$(ls -A "$PGDATA")" ]; then
    echo "Initialisation de la base de données..."
    # InitDB en tant que postgres
    su - postgres -c "$BIN_DIR/initdb -D $PGDATA"
    
    # Configuration réseau (Mode TRUST pour lab)
    echo "host all all 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"
    echo "listen_addresses='*'" >> "$PGDATA/postgresql.conf"
    
    # Démarrage temporaire pour configuration
    su - postgres -c "$BIN_DIR/pg_ctl -D $PGDATA -w start"
    
    # Création User et Database
    if [ -n "$POSTGRES_USER" ] && [ -n "$POSTGRES_PASSWORD" ]; then
        echo "Création user $POSTGRES_USER..."
        su - postgres -c "$BIN_DIR/psql -c \"CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';\"" || echo "ERREUR CREATION USER"
    fi
    
    if [ -n "$POSTGRES_DB" ]; then
        echo "Création database $POSTGRES_DB..."
        su - postgres -c "$BIN_DIR/psql -c \"CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;\"" || echo "ERREUR CREATION DB"
    fi
    
    # Exécution du script d'init SQL s'il existe
    if [ -f "/docker-entrypoint-initdb.d/init.sql" ]; then
        echo "Exécution de init.sql..."
        su - postgres -c "$BIN_DIR/psql -d $POSTGRES_DB -f /docker-entrypoint-initdb.d/init.sql" || echo "ERREUR INIT SQL"
    fi
    
    # Arrêt du mode temporaire
    su - postgres -c "$BIN_DIR/pg_ctl -D $PGDATA -m fast -w stop"
fi

# Démarrage final
echo "Démarrage de PostgreSQL avec version $PG_VER..."
if [ "$(id -u)" = '0' ]; then
    exec su - postgres -c "$BIN_DIR/postgres -D $PGDATA"
else
    exec "$BIN_DIR/postgres" -D "$PGDATA"
fi
