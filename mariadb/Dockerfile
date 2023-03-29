ARG BUILD_FROM
FROM $BUILD_FROM

# Setup base
RUN apk add --no-cache \
    mariadb=10.6.12-r0 \
    mariadb-client=10.6.12-r0 \
    mariadb-server-utils=10.6.12-r0 \
    pwgen=2.08-r1

ENV \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"

# Copy data
COPY rootfs /

WORKDIR /
