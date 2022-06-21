#!/usr/bin/with-contenv bashio
# ==============================================================================
# Import homeassistant database content
# ==============================================================================
TMPFS_MNT=/tmp
MARIADB_DATA=${TMPFS_MNT}/databases
MARIADB_DUMP=/data/homeassistant-database-dump.sql.gz

if bashio::config.exists "retention.enabled" && bashio::fs.directory_exists "$(MARIADB_DATA)/homeassistant"; then
    if bashio::config.true "retention.enabled"; then
        if ! bashio::fs.file_exists "$(MARIADB_DUMP)"; then
            bashio::log.warning "Importing last known databases content skipped, no dump file found"
        else
            bashio::log.info "Importing last known databases content"
            gzip -d $(MARIADB_DUMP) -c | mysql homeassistant
        fi
    else
        if bashio::fs.file_exists "$(MARIADB_DUMP)"; then
            rm $(MARIADB_DUMP)
            bashio::log.info "Data retention is explicitly turned off, unused exported database content is removed"
        fi
    fi
fi
