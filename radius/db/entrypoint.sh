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
echo "Version PostgreSQL détectée: $PG_VER"

# Si on n'est pas l'utilisateur postgres, on relance le script en tant que postgres
if [ "$(id -u)" = '0' ]; then
    chown -R postgres:postgres "$PGDATA" /run/postgresql
    exec su - postgres -c "$0 $@"
fi

# Initialisation si le répertoire de données est vide
if [ -z "$(ls -A "$PGDATA")" ]; then
    echo "Initialisation de la base de données..."
    "$BIN_DIR/initdb" -D "$PGDATA"
    
    # Configuration réseau
    echo "host all all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
    echo "listen_addresses='*'" >> "$PGDATA/postgresql.conf"
    
    # Démarrage temporaire
    "$BIN_DIR/pg_ctl" -D "$PGDATA" -w start
    
    # Création User et Database
    if [ -n "$POSTGRES_USER" ] && [ -n "$POSTGRES_PASSWORD" ]; then
        echo "Création user $POSTGRES_USER..."
        psql -c "CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';"
    fi
    
    if [ -n "$POSTGRES_DB" ]; then
        echo "Création database $POSTGRES_DB..."
        psql -c "CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;"
    fi
    
    # Exécution du script d'init SQL s'il existe
    if [ -f "/docker-entrypoint-initdb.d/init.sql" ]; then
        echo "Exécution de init.sql..."
        psql -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/init.sql
    fi
    
    # Arrêt du mode temporaire
    "$BIN_DIR/pg_ctl" -D "$PGDATA" -m fast -w stop
fi

# Démarrage final
echo "Démarrage du serveur PostgreSQL..."
exec "$BIN_DIR/postgres" -D "$PGDATA"
