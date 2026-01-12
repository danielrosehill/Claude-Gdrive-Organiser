# Unmount Google Drive

Safely unmount the Google Drive from the local filesystem.

## Instructions

### Step 1: Check if mounted

```bash
findmnt {mount_path}
```

If not mounted, inform user and exit.

### Step 2: Check for active operations

```bash
# Check if any processes are using the mount
lsof +f -- {mount_path} 2>/dev/null | head -20
fuser -m {mount_path} 2>/dev/null
```

If processes are using the mount:
- List them for user
- Ask if they want to force unmount or wait

### Step 3: Attempt graceful unmount

```bash
fusermount -u {mount_path}
```

### Step 4: If graceful fails, offer force unmount

```bash
# Lazy unmount (detaches immediately, cleanup happens when not in use)
fusermount -uz {mount_path}

# Or kill rclone process
pkill -f "rclone mount.*{mount_path}"
```

### Step 5: Verify unmount

```bash
findmnt {mount_path} && echo "Still mounted" || echo "Successfully unmounted"
```

### Step 6: Report status

```
## Unmount Status

Mount point: {mount_path}
Status: ✅ Unmounted / ❌ Failed

{If failed, show error and suggestions}
```

## Troubleshooting

**"Device or resource busy":**
- Close any file managers or terminals in that directory
- Close applications with open files from the drive
- Use `lsof +f -- {mount_path}` to find blocking processes

**Force unmount as last resort:**
```bash
sudo umount -l {mount_path}  # Lazy unmount
# or
sudo umount -f {mount_path}  # Force unmount
```
