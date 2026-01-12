#!/bin/bash
# mount.sh - Mount Google Drive using rclone
#
# Usage: ./mount.sh [remote_name] [mount_path]
#
# Defaults can be set via environment variables:
#   GDRIVE_REMOTE - rclone remote name (default: gdrive)
#   GDRIVE_MOUNT  - mount path (default: /mnt/gdrive)

set -e

# Configuration
REMOTE="${1:-${GDRIVE_REMOTE:-gdrive}}"
MOUNT_PATH="${2:-${GDRIVE_MOUNT:-/mnt/gdrive}}"
LOG_FILE="/tmp/rclone-${REMOTE}.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Google Drive Mount Script${NC}"
echo "Remote: ${REMOTE}"
echo "Mount Path: ${MOUNT_PATH}"
echo ""

# Check if rclone is installed
if ! command -v rclone &> /dev/null; then
    echo -e "${RED}Error: rclone is not installed${NC}"
    echo "Install with: curl https://rclone.org/install.sh | sudo bash"
    exit 1
fi

# Check if remote exists
if ! rclone listremotes | grep -q "^${REMOTE}:$"; then
    echo -e "${RED}Error: Remote '${REMOTE}' not found${NC}"
    echo "Available remotes:"
    rclone listremotes
    echo ""
    echo "Configure with: rclone config"
    exit 1
fi

# Check if already mounted
if findmnt "${MOUNT_PATH}" &> /dev/null; then
    echo -e "${YELLOW}Warning: ${MOUNT_PATH} is already mounted${NC}"
    echo "Unmount first with: fusermount -u ${MOUNT_PATH}"
    exit 1
fi

# Create mount point if needed
if [ ! -d "${MOUNT_PATH}" ]; then
    echo "Creating mount point: ${MOUNT_PATH}"
    sudo mkdir -p "${MOUNT_PATH}"
    sudo chown "${USER}:${USER}" "${MOUNT_PATH}"
fi

# Mount options
MOUNT_OPTS=(
    --vfs-cache-mode full
    --vfs-cache-max-age 24h
    --vfs-read-chunk-size 128M
    --vfs-read-chunk-size-limit 1G
    --buffer-size 256M
    --dir-cache-time 72h
    --poll-interval 15s
    --log-level INFO
    --log-file "${LOG_FILE}"
)

echo "Mounting ${REMOTE}: to ${MOUNT_PATH}..."
echo "Log file: ${LOG_FILE}"

# Mount in daemon mode
rclone mount "${REMOTE}:" "${MOUNT_PATH}" "${MOUNT_OPTS[@]}" --daemon

# Wait a moment for mount to establish
sleep 2

# Verify mount
if findmnt "${MOUNT_PATH}" &> /dev/null; then
    echo -e "${GREEN}✓ Successfully mounted${NC}"
    echo ""
    echo "Drive contents:"
    ls -la "${MOUNT_PATH}" | head -10
    echo ""
    echo "To unmount: ./unmount.sh or fusermount -u ${MOUNT_PATH}"
else
    echo -e "${RED}✗ Mount failed${NC}"
    echo "Check log file: ${LOG_FILE}"
    tail -20 "${LOG_FILE}"
    exit 1
fi
