# Home Assistant Add-on: Dispatcharr

Dispatcharr is a self-hosted IPTV stream management platform that provides intelligent stream management, EPG auto-matching, and compatibility with popular media centers.

## Features

- **IPTV Stream Management**: Proxy and manage IPTV streams with bandwidth optimization
- **EPG Auto-Matching**: Automatically match Electronic Program Guide data to channels using AI
- **HDHomeRun Emulation**: Compatible with Plex, Jellyfin, and other HDHomeRun clients
- **M3U/XMLTV Support**: Import and export M3U playlists and XMLTV EPG data
- **VOD Support**: Manage Video on Demand content for movies and TV series
- **Real-time Statistics**: Monitor stream health and performance
- **Smart Playlists**: Filter, group, and manage streams with failover support

## Installation

1. Add this repository to your Home Assistant Add-on Store
2. Click "Install" on the Dispatcharr add-on
3. Configure the add-on settings (see Configuration section)
4. Start the add-on
5. Access the web UI through the sidebar or at `http://your-ha-ip:9191`

## Configuration

### Option: `log_level`

The logging level for the add-on. Available options:

- `trace`: Most verbose logging (for debugging)
- `debug`: Debug-level logging
- `info`: Standard logging (recommended)
- `warning`: Only warnings and errors
- `error`: Only errors

### Option: `postgres_password`

Password for the PostgreSQL database. If left empty, a random password will be generated automatically.

### Option: `enable_hardware_acceleration`

Enable hardware acceleration for video transcoding. Requires a compatible GPU (Intel/AMD with VA-API or NVIDIA).

**Note**: For hardware acceleration to work, you may need to expose your GPU device to the container.

## Ports

| Port | Description |
|------|-------------|
| 9191 | Web UI and API |
| 5004 | HDHomeRun emulation |

## Data Persistence

All data is stored in `/data/dispatcharr/` which is persisted between add-on updates and restarts. This includes:

- Database (PostgreSQL)
- Logos and images
- Backups
- User uploads
- Plugins

## First-Time Setup

1. After starting the add-on, access the web UI
2. The default admin credentials will be shown in the add-on logs on first start
3. Complete the initial setup wizard to configure your IPTV sources

## Integrating with Media Centers

### Plex

1. In Dispatcharr, go to Settings > HDHomeRun
2. Copy the HDHomeRun device URL
3. In Plex, go to Settings > Live TV & DVR
4. Add a tuner using the HDHomeRun URL

### Jellyfin

1. In Dispatcharr, go to Settings > HDHomeRun
2. Copy the M3U and XMLTV URLs
3. In Jellyfin, go to Dashboard > Live TV
4. Add a tuner using M3U and configure the EPG using XMLTV

## Troubleshooting

### Add-on won't start

Check the add-on logs for error messages. Common issues:

- Insufficient memory (minimum 1GB recommended)
- Port conflicts (ensure 9191 and 5004 are not in use)
- Database initialization issues

### Hardware acceleration not working

1. Ensure your GPU is supported
2. Check that `/dev/dri` is accessible
3. Verify GPU drivers are properly installed on the host

### EPG not matching

1. Check that your M3U sources have valid channel names
2. Try running a manual EPG refresh
3. Review the EPG matching settings

## Support

For issues and feature requests, please visit:
- [GitHub Issues](https://github.com/dispatcharr/dispatcharr/issues)
- [Documentation](https://dispatcharr.com/docs)
