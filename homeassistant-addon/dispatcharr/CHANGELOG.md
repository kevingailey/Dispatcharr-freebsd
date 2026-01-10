# Changelog

All notable changes to this Home Assistant add-on will be documented in this file.

## [0.16.01] - 2025-01-10

### Added

- Initial Home Assistant add-on release
- Full Dispatcharr functionality including:
  - IPTV stream management and proxying
  - EPG auto-matching with AI
  - HDHomeRun emulation for Plex/Jellyfin
  - M3U and XMLTV support
  - VOD content management
  - Real-time statistics dashboard
- Home Assistant ingress support
- Persistent data storage
- Hardware acceleration support (optional)
- Configurable logging levels

### Configuration Options

- `log_level`: Control logging verbosity
- `postgres_password`: Set database password
- `enable_hardware_acceleration`: Enable GPU acceleration

### Ports

- 9191: Web UI and API
- 5004: HDHomeRun emulation
