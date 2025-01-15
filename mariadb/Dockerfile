ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:17.1.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Environment variables
ENV \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"

# Setup base
RUN apk add --no-cache \
    mariadb=11.4.4-r1 \
    mariadb-client=11.4.4-r1 \
    mariadb-server-utils=11.4.4-r1 \
    pwgen=2.08-r3

# Copy root filesystem
COPY rootfs /

HEALTHCHECK \
    CMD healthcheck
