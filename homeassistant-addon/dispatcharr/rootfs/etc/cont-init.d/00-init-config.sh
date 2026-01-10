#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Dispatcharr
# Initializes configuration from Home Assistant options
# ==============================================================================

bashio::log.info "Initializing Dispatcharr configuration..."

# Get configuration options from Home Assistant
LOG_LEVEL=$(bashio::config 'log_level' 'info')
POSTGRES_PASSWORD=$(bashio::config 'postgres_password')
ENABLE_HW_ACCEL=$(bashio::config 'enable_hardware_acceleration' 'false')

# Generate a random password if not set
if [ -z "$POSTGRES_PASSWORD" ]; then
    POSTGRES_PASSWORD=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 24)
    bashio::log.info "Generated random PostgreSQL password"
fi

# Set environment variables
{
    echo "DISPATCHARR_ENV=aio"
    echo "DISPATCHARR_LOG_LEVEL=${LOG_LEVEL}"
    echo "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}"
    echo "POSTGRES_DB=dispatcharr"
    echo "POSTGRES_USER=dispatch"
    echo "POSTGRES_HOST=localhost"
    echo "POSTGRES_PORT=5432"
    echo "REDIS_HOST=localhost"
    echo "REDIS_DB=0"
    echo "DISPATCHARR_PORT=9191"
} > /var/run/s6/container_environment/dispatcharr.env

# Export for current script
export DISPATCHARR_LOG_LEVEL="${LOG_LEVEL}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"

# Configure hardware acceleration if enabled
if bashio::var.true "${ENABLE_HW_ACCEL}"; then
    bashio::log.info "Hardware acceleration enabled"
    if [ -d /dev/dri ]; then
        bashio::log.info "Found /dev/dri - GPU devices available"
    else
        bashio::log.warning "Hardware acceleration enabled but /dev/dri not found"
    fi
fi

# Create persistent data directories
mkdir -p /data/dispatcharr/db
mkdir -p /data/dispatcharr/logos
mkdir -p /data/dispatcharr/backups
mkdir -p /data/dispatcharr/uploads
mkdir -p /data/dispatcharr/plugins

# Create symbolic links for data persistence
if [ ! -L /data/db ] && [ ! -d /data/db ]; then
    ln -sf /data/dispatcharr/db /data/db
fi

# Ensure /data directory structure
mkdir -p /data
for dir in logos backups uploads plugins; do
    if [ ! -L /data/${dir} ]; then
        rm -rf /data/${dir}
        ln -sf /data/dispatcharr/${dir} /data/${dir}
    fi
done

bashio::log.info "Configuration initialized successfully"
