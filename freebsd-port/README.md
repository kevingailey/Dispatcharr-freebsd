# FreeBSD Port for Dispatcharr

This directory contains the FreeBSD port for Dispatcharr, a self-hosted IPTV stream management platform.

## Installation from Ports

### Prerequisites

Ensure your ports tree is up to date:

```bash
portsnap fetch update
# or if using git:
cd /usr/ports && git pull
```

### Installing the Port

1. Copy the port to your ports tree:

```bash
cp -r dispatcharr /usr/ports/multimedia/
```

2. Generate the distinfo file (required before first build):

```bash
cd /usr/ports/multimedia/dispatcharr
make makesum
```

3. Build and install:

```bash
make install clean
```

### Using Poudriere

For building packages with poudriere:

```bash
# Add port to your build list
echo "multimedia/dispatcharr" >> /usr/local/etc/poudriere.d/pkglist

# Build
poudriere bulk -j 14amd64 -p default multimedia/dispatcharr
```

## Post-Installation Setup

After installation, follow these steps:

### 1. Configure Dispatcharr

Edit the configuration file:

```bash
cp /usr/local/etc/dispatcharr/dispatcharr.conf.sample /usr/local/etc/dispatcharr/dispatcharr.conf
vi /usr/local/etc/dispatcharr/dispatcharr.conf
```

Generate a secure Django secret key:

```bash
python3 -c "import secrets; print(secrets.token_urlsafe(64))"
```

### 2. Set Up PostgreSQL

```bash
# Enable and initialize PostgreSQL
sysrc postgresql_enable=YES
service postgresql initdb
service postgresql start

# Create database and user
su - postgres
createuser -P dispatch
createdb -O dispatch dispatcharr
exit
```

### 3. Enable Redis

```bash
sysrc redis_enable=YES
service redis start
```

### 4. Configure Nginx

```bash
cp /usr/local/etc/nginx/dispatcharr.conf.sample /usr/local/etc/nginx/dispatcharr.conf

# Add to nginx.conf:
# include /usr/local/etc/nginx/dispatcharr.conf;

sysrc nginx_enable=YES
service nginx restart
```

### 5. Enable and Start Services

```bash
# Enable all Dispatcharr services
sysrc dispatcharr_enable=YES
sysrc dispatcharr_celery_enable=YES
sysrc dispatcharr_celerybeat_enable=YES
sysrc dispatcharr_daphne_enable=YES

# Start services
service dispatcharr start
service dispatcharr_celery start
service dispatcharr_celerybeat start
service dispatcharr_daphne start
```

### 6. Access the Web Interface

Open your browser and navigate to:

```
http://your-server-ip:9191
```

## Service Management

```bash
# Main application (Gunicorn)
service dispatcharr start|stop|restart|status

# Celery worker (background tasks)
service dispatcharr_celery start|stop|restart|status

# Celery beat (scheduled tasks)
service dispatcharr_celerybeat start|stop|restart|status

# Daphne (WebSocket server)
service dispatcharr_daphne start|stop|restart|status
```

## Configuration Options

### rc.conf Variables

```bash
# Main service
dispatcharr_enable="YES"
dispatcharr_workers="4"           # Number of Gunicorn workers
dispatcharr_timeout="300"         # Request timeout

# Celery worker
dispatcharr_celery_enable="YES"
dispatcharr_celery_concurrency="4"
dispatcharr_celery_loglevel="info"

# Celery beat
dispatcharr_celerybeat_enable="YES"
dispatcharr_celerybeat_loglevel="info"

# Daphne WebSocket server
dispatcharr_daphne_enable="YES"
dispatcharr_daphne_port="8001"
dispatcharr_daphne_host="127.0.0.1"
```

## Log Files

Logs are stored in `/var/log/dispatcharr/`:

- `access.log` - HTTP access log
- `error.log` - Gunicorn error log
- `celery.log` - Celery worker log
- `celerybeat.log` - Celery beat scheduler log
- `daphne-access.log` - WebSocket access log

## Data Directories

- `/var/db/dispatcharr/` - Application data
  - `logos/` - Channel logos
  - `uploads/` - User uploads
  - `backups/` - Database backups
  - `plugins/` - Installed plugins

## Build Options

The port supports the following options:

- `PYTORCH` (default: ON) - Enable PyTorch for AI-based EPG matching
- `DOCS` - Install documentation

```bash
# Build without PyTorch (smaller footprint)
make config  # Deselect PYTORCH
make install clean
```

## Upgrading

```bash
cd /usr/ports/multimedia/dispatcharr
make deinstall
make install clean

# Services will automatically run migrations on restart
service dispatcharr restart
service dispatcharr_celery restart
service dispatcharr_celerybeat restart
service dispatcharr_daphne restart
```

## Troubleshooting

### Check Service Status

```bash
service dispatcharr status
service dispatcharr_celery status
service dispatcharr_celerybeat status
service dispatcharr_daphne status
```

### View Logs

```bash
tail -f /var/log/dispatcharr/error.log
tail -f /var/log/dispatcharr/celery.log
```

### Manual Migration

```bash
cd /usr/local/dispatcharr
su -m dispatcharr -c "python3 manage.py migrate"
su -m dispatcharr -c "python3 manage.py collectstatic --noinput"
```

### Check PostgreSQL Connection

```bash
su - postgres -c "psql -d dispatcharr -c 'SELECT 1;'"
```

### Check Redis Connection

```bash
redis-cli ping
```

## License

This port is provided under the same license as Dispatcharr. See the LICENSE file in the main repository for details.
