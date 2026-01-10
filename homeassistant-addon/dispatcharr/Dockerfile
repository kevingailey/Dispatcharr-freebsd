# Home Assistant Add-on: Dispatcharr
# IPTV Stream Management Platform

ARG BUILD_FROM=ghcr.io/dispatcharr/dispatcharr:latest

# Build stage for S6 overlay
FROM alpine:3.19 AS s6-builder

ARG S6_OVERLAY_VERSION="3.1.6.2"
ARG TARGETARCH

RUN apk add --no-cache curl xz \
    && ARCH="${TARGETARCH}" \
    && if [ "${ARCH}" = "amd64" ]; then S6_ARCH="x86_64"; \
       elif [ "${ARCH}" = "arm64" ] || [ "${ARCH}" = "aarch64" ]; then S6_ARCH="aarch64"; \
       elif [ "${ARCH}" = "armv7" ]; then S6_ARCH="arm"; \
       else S6_ARCH="${ARCH}"; fi \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
       -o /tmp/s6-overlay-noarch.tar.xz \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" \
       -o /tmp/s6-overlay-arch.tar.xz \
    && mkdir -p /s6 \
    && tar -C /s6 -Jxpf /tmp/s6-overlay-noarch.tar.xz \
    && tar -C /s6 -Jxpf /tmp/s6-overlay-arch.tar.xz

# Final image
FROM ${BUILD_FROM}

# Copy S6 overlay
COPY --from=s6-builder /s6 /

# Install bashio for Home Assistant integration
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       jq \
       curl \
    && curl -L -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v0.16.2.tar.gz" \
       | tar -xzf - -C /tmp \
    && mv /tmp/bashio-0.16.2/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# Create addon data directories
RUN mkdir -p /data/dispatcharr

# Copy S6 service definitions
COPY rootfs /

# Environment for Home Assistant
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SERVICES_GRACETIME=30000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:9191/ || exit 1

# Expose ports
EXPOSE 9191 5004

# S6 overlay entrypoint
ENTRYPOINT ["/init"]
