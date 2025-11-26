#!/bin/bash
set -e

# Version to install
VERSION="0.1.6"

# Detect architecture
ARCH=$(dpkg --print-architecture)

# Download latest .deb
curl -sLO "https://github.com/memvid/memory-cli/releases/download/v${VERSION}/memorycli_${VERSION}-1_${ARCH}.deb"

# Install
sudo dpkg -i "memorycli_${VERSION}-1_${ARCH}.deb"

# Fix any missing dependencies
sudo apt-get install -f -y

# Clean up
rm "memorycli_${VERSION}-1_${ARCH}.deb"

echo "memorycli installed successfully!"

