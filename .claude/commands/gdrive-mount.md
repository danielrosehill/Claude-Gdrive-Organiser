# Mount Google Drive

Mount the configured rclone remote to the local filesystem.

## Instructions

### Step 1: Read mount configuration from CLAUDE.md

Extract these values from CLAUDE.md:
- `mount_path` (e.g., `/mnt/gdrive`)
- `rclone_remote` (e.g., `gdrive`)

### Step 2: Verify rclone remote exists

```bash
rclone listremotes | grep -q "^{rclone_remote}:$" && echo "Remote found" || echo "Remote not found"
```

If not found, suggest running `/rclone-configure` first.

### Step 3: Check if already mounted

```bash
findmnt {mount_path} && echo "Already mounted" || echo "Not mounted"
```

If already mounted, inform user and offer to remount.

### Step 4: Create mount point if needed

```bash
sudo mkdir -p {mount_path}
sudo chown $USER:$USER {mount_path}
```

### Step 5: Mount the drive

**Interactive mount (foreground, good for testing):**
```bash
rclone mount {rclone_remote}: {mount_path} \
  --vfs-cache-mode full \
  --vfs-cache-max-age 24h \
  --vfs-read-chunk-size 128M \
  --vfs-read-chunk-size-limit 1G \
  --buffer-size 256M \
  --dir-cache-time 72h \
  --poll-interval 15s \
  --log-level INFO
```

**Background mount (daemon mode):**
```bash
rclone mount {rclone_remote}: {mount_path} \
  --vfs-cache-mode full \
  --vfs-cache-max-age 24h \
  --vfs-read-chunk-size 128M \
  --vfs-read-chunk-size-limit 1G \
  --buffer-size 256M \
  --dir-cache-time 72h \
  --poll-interval 15s \
  --daemon \
  --log-file=/tmp/rclone-mount.log
```

### Step 6: Verify mount

```bash
ls -la {mount_path}
df -h {mount_path}
```

### Step 7: Report status

Inform user:
- Mount successful/failed
- Location of log file if daemon mode
- How to unmount: `fusermount -u {mount_path}`
- Suggest running `/gdrive-status` to verify

## Mount Options Explained

| Option | Purpose |
|--------|---------|
| `--vfs-cache-mode full` | Cache files locally for better performance |
| `--vfs-cache-max-age 24h` | Keep cached files for 24 hours |
| `--vfs-read-chunk-size 128M` | Read files in 128MB chunks |
| `--buffer-size 256M` | Memory buffer for transfers |
| `--dir-cache-time 72h` | Cache directory listings for 72 hours |
| `--poll-interval 15s` | Check for remote changes every 15 seconds |

## Troubleshooting

**Mount fails with FUSE error:**
```bash
sudo apt install fuse3  # or fuse on older systems
sudo modprobe fuse
```

**Permission denied:**
- Ensure user is in `fuse` group: `sudo usermod -aG fuse $USER`
- Log out and back in

**Mount point busy:**
```bash
fusermount -uz {mount_path}  # Force unmount
```
