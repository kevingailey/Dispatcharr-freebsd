# Dispatcharr Home Assistant Add-on

This directory contains the Home Assistant add-on for Dispatcharr, a self-hosted IPTV stream management platform.

## Installation

### Method 1: Add Repository to Home Assistant

1. Open Home Assistant
2. Navigate to **Settings** > **Add-ons** > **Add-on Store**
3. Click the three dots menu (top right) and select **Repositories**
4. Add this repository URL: `https://github.com/dispatcharr/dispatcharr`
5. Find "Dispatcharr" in the add-on store and click **Install**

### Method 2: Manual Installation

1. Copy the `dispatcharr` folder to your Home Assistant's `/addons` directory
2. Restart Home Assistant
3. Navigate to **Settings** > **Add-ons** > **Add-on Store**
4. Find "Dispatcharr" under "Local add-ons" and click **Install**

## Building Locally

To build the add-on Docker image locally:

```bash
cd dispatcharr
docker build -t dispatcharr-addon .
```

## Add-on Structure

```
homeassistant-addon/
├── repository.yaml          # Repository configuration
├── README.md               # This file
└── dispatcharr/
    ├── config.yaml         # Add-on configuration
    ├── Dockerfile          # Docker build instructions
    ├── DOCS.md             # Documentation
    ├── CHANGELOG.md        # Version history
    └── rootfs/             # Root filesystem overlay
        └── etc/
            ├── cont-init.d/    # Initialization scripts
            └── s6-overlay/     # S6 service definitions
```

## Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `log_level` | Logging verbosity (trace/debug/info/warning/error) | `info` |
| `postgres_password` | PostgreSQL database password | Auto-generated |
| `enable_hardware_acceleration` | Enable GPU acceleration | `false` |

## Exposed Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 9191 | TCP | Web UI and REST API |
| 5004 | TCP | HDHomeRun emulation |

## Development

For add-on development, see the [Home Assistant Add-on Development Guide](https://developers.home-assistant.io/docs/add-ons/).

## License

This add-on is part of the Dispatcharr project. See the main repository for license information.
