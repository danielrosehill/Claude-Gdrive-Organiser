#!/bin/bash
# unmount.sh - Unmount Google Drive
#
# Usage: ./unmount.sh [mount_path]
#
# Defaults can be set via environment variables:
#   GDRIVE_MOUNT - mount path (default: /mnt/gdrive)

set -e

MOUNT_PATH="${1:-${GDRIVE_MOUNT:-/mnt/gdrive}}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Google Drive Unmount Script${NC}"
echo "Mount Path: ${MOUNT_PATH}"
echo ""

# Check if mounted
if ! findmnt "${MOUNT_PATH}" &> /dev/null; then
    echo -e "${YELLOW}${MOUNT_PATH} is not mounted${NC}"
    exit 0
fi

# Check for processes using the mount
PROCS=$(lsof +f -- "${MOUNT_PATH}" 2>/dev/null | tail -n +2 || true)
if [ -n "${PROCS}" ]; then
    echo -e "${YELLOW}Warning: Processes are using ${MOUNT_PATH}:${NC}"
    echo "${PROCS}"
    echo ""
    read -p "Force unmount anyway? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted. Close the listed processes and try again."
        exit 1
    fi
    # Use lazy unmount for force
    echo "Using lazy unmount..."
    fusermount -uz "${MOUNT_PATH}"
else
    # Normal unmount
    fusermount -u "${MOUNT_PATH}"
fi

# Verify unmount
sleep 1
if findmnt "${MOUNT_PATH}" &> /dev/null; then
    echo -e "${RED}✗ Unmount may still be pending${NC}"
    echo "The mount will complete when all processes release it."
else
    echo -e "${GREEN}✓ Successfully unmounted${NC}"
fi
