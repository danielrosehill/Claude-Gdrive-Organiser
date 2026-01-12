# Google Drive Status Check

Check the current status of the mounted Google Drive and provide an overview.

## Instructions

### Step 1: Read configuration from CLAUDE.md

Extract `mount_path` from CLAUDE.md.

### Step 2: Check mount status

```bash
findmnt {mount_path}
```

Report whether the drive is mounted or not.

### Step 3: If mounted, gather statistics

**Drive space:**
```bash
df -h {mount_path}
```

**Top-level folders:**
```bash
ls -la {mount_path}
```

**Count items in key folders:**
```bash
# Inbox count (if exists)
find {mount_path}/00-Inbox -maxdepth 1 -type f 2>/dev/null | wc -l

# Total file count (be careful with large drives)
# Only do shallow count to avoid timeout
find {mount_path} -maxdepth 2 -type f 2>/dev/null | wc -l
```

**Recent activity (last 24 hours):**
```bash
find {mount_path} -maxdepth 3 -mtime -1 -type f 2>/dev/null | head -20
```

### Step 4: Check rclone process

```bash
pgrep -a rclone
```

### Step 5: Review recent logs

Check for recent log entries in `logs/sessions/` and `logs/operations/`.

```bash
ls -lt logs/sessions/ | head -5
ls -lt logs/operations/ | head -5
```

### Step 6: Generate status report

Present a summary:

```
## Google Drive Status Report

**Mount Status:** ✅ Mounted / ❌ Not Mounted
**Mount Path:** {mount_path}
**Remote:** {rclone_remote}

### Storage
- Total: X GB
- Used: X GB
- Available: X GB

### Quick Stats
- Files in Inbox: X
- Top-level folders: X
- Recent files (24h): X

### Recent Activity
[List recent files if any]

### Recommendations
[Based on what was found - e.g., "Inbox has 50 files waiting to be organized"]
```

## If Not Mounted

If the drive is not mounted:
1. Ask if user wants to mount it
2. Suggest running `/gdrive-mount`
3. Check if rclone remote is configured: `rclone listremotes`
