ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:20.0.3
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Environment variables
ENV \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so.2" \
    # App log format
    LOG_FORMAT="{TIMESTAMP} {LEVEL}: {MESSAGE}" \
    LOG_TIMESTAMP="%Y-%m-%d %H:%M:%S"

# Setup base
RUN apk add --no-cache \
    mariadb=11.4.9-r0 \
    mariadb-client=11.4.9-r0 \
    mariadb-server-utils=11.4.9-r0 \
    pwgen=2.08-r3

# Copy root filesystem
COPY rootfs /

HEALTHCHECK \
    CMD healthcheck
