ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:16.3.6
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Environment variables
ENV \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"

# Setup base
RUN apk add --no-cache \
    mariadb=10.11.10-r0 \
    mariadb-client=10.11.10-r0 \
    mariadb-server-utils=10.11.10-r0 \
    pwgen=2.08-r3

# Copy root filesystem
COPY rootfs /

HEALTHCHECK \
    CMD healthcheck
