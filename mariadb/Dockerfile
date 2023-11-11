ARG BUILD_FROM
FROM $BUILD_FROM

# Setup base
RUN apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-server-utils \
    pwgen

ENV \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"

# Copy data
COPY rootfs /

HEALTHCHECK \
    CMD healthcheck --defaults-file=/home/healthcheck/.my.cnf --connect --innodb_initialized --innodb_buffer_pool_loaded

WORKDIR /
