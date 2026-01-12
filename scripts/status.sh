#!/bin/bash
# status.sh - Check Google Drive mount status
#
# Usage: ./status.sh [mount_path]

MOUNT_PATH="${1:-${GDRIVE_MOUNT:-/mnt/gdrive}}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Google Drive Status${NC}"
echo "===================="
echo ""

# Check mount status
echo -n "Mount Status: "
if findmnt "${MOUNT_PATH}" &> /dev/null; then
    echo -e "${GREEN}✓ Mounted${NC}"
    echo "Mount Path: ${MOUNT_PATH}"
    echo ""

    # Show disk usage
    echo -e "${BLUE}Storage:${NC}"
    df -h "${MOUNT_PATH}" | tail -1 | awk '{print "  Total: " $2 "\n  Used: " $3 " (" $5 ")\n  Available: " $4}'
    echo ""

    # Show top-level folders
    echo -e "${BLUE}Top-level folders:${NC}"
    ls -la "${MOUNT_PATH}" 2>/dev/null | grep "^d" | awk '{print "  " $NF}' | head -15
    echo ""

    # Check rclone process
    echo -e "${BLUE}Rclone process:${NC}"
    RCLONE_PID=$(pgrep -f "rclone mount.*${MOUNT_PATH}" || true)
    if [ -n "${RCLONE_PID}" ]; then
        echo "  PID: ${RCLONE_PID}"
        ps -p "${RCLONE_PID}" -o %cpu,%mem,etime --no-headers | awk '{print "  CPU: " $1 "%\n  Memory: " $2 "%\n  Uptime: " $3}'
    else
        echo "  (running in background)"
    fi
else
    echo -e "${RED}✗ Not Mounted${NC}"
    echo ""
    echo "To mount, run: ./mount.sh"
fi
