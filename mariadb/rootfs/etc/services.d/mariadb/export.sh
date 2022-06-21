#!/usr/bin/with-contenv bashio
# ==============================================================================
# Export homeassistant database content
# ==============================================================================
TMPFS_MNT=/tmp
MARIADB_DATA=${TMPFS_MNT}/databases
MARIADB_DUMP=/data/homeassistant-database-dump.sql.gz

if bashio::config.exists "retention.enabled" && bashio::config.true "retention.enabled" && bashio::fs.directory_exists "$(MARIADB_DATA)/homeassistant"; then
    exec 4> >(mysql)
    echo "FLUSH TABLES WITH READ LOCK;" >&4
    bashio::log.info "MariaDB tables locked."

    bashio::log.info "Exporting databases content"
    mysqldump homeassistant --ignore-table=homeassistant.schema_changes \
            --skip-lock-tables --skip-add-drop-table --no-create-info --skip-add-locks --complete-insert --insert-ignore \
        | gzip -9 > $(MARIADB_DUMP)

    echo "UNLOCK TABLES;" >&4
    bashio::log.info "MariaDB tables unlocked."
    exec 4>&-
fi
