# Scan for Duplicate Files

Identify and handle duplicate files on the Google Drive.

## Instructions

### Step 1: Verify mount

```bash
findmnt {mount_path}
```

### Step 2: Determine scan scope

Ask user:
1. **Full drive scan** - Check entire drive (may take a long time)
2. **Specific folder** - Focus on one folder tree
3. **Quick scan** - Only check likely duplicate locations (Inbox, Downloads, etc.)

### Step 3: Choose detection method

Ask user preference:
1. **By name** - Files with identical names
2. **By size** - Files with identical sizes (fast, less accurate)
3. **By hash** - MD5/SHA hash comparison (slow, most accurate)
4. **By name + size** - Good balance of speed and accuracy

### Step 4: Run duplicate scan

**By name (same filename in different locations):**
```bash
find {mount_path} -type f -exec basename {} \; | sort | uniq -d > /tmp/dup_names.txt
# Then find full paths for each duplicate name
```

**By size:**
```bash
find {mount_path} -type f -printf '%s %p\n' | sort -n | uniq -D -w 15
```

**By hash (for smaller sets of potential duplicates):**
```bash
md5sum "{file1}" "{file2}"
```

Note: Avoid running hash on entire drive via rclone - it will download every file.

**Using rclone dedupe (dry-run first!):**
```bash
rclone dedupe --dry-run {remote}: --dedupe-mode list
```

### Step 5: Present findings

```
## Duplicate Scan Results

Scan type: {method}
Scope: {folder or full drive}
Time taken: {duration}

### Duplicate Groups Found: {count}

#### Group 1: {filename}
Total size wasted: {size}
| Location | Size | Modified | Keep? |
|----------|------|----------|-------|
| /path/to/file1.jpg | 2.5 MB | 2024-01-15 | ✓ |
| /path/to/file2.jpg | 2.5 MB | 2024-01-10 | |
| /path/to/file3.jpg | 2.5 MB | 2023-12-01 | |

#### Group 2: ...
```

### Step 6: Get user decision

For each duplicate group, offer options per CLAUDE.md `duplicates.strategy`:

1. **Keep newest** - Delete older copies
2. **Keep oldest** - Delete newer copies
3. **Keep specific** - User chooses which to keep
4. **Keep all** - Skip this group
5. **Move duplicates** - Move extras to `99-System/Duplicates/`

### Step 7: Execute cleanup

For each confirmed action:

1. Log the planned deletion/move
2. Execute:
   ```bash
   # Move to duplicates folder (safer than delete)
   mv "{duplicate_path}" "{mount_path}/99-System/Duplicates/"

   # Or delete (if user confirms)
   rm "{duplicate_path}"
   ```
3. Log result

### Step 8: Summary report

```
## Duplicate Cleanup Summary

### Actions Taken
- Duplicate groups processed: {X}
- Files removed/moved: {X}
- Space recovered: {X} GB
- Files kept: {X}

### Skipped
- Groups skipped by user: {X}
- Files with errors: {X}

### Duplicates Folder
New files in 99-System/Duplicates/: {X}
(Review and delete manually when ready)
```

Write report to `logs/operations/duplicates_{date}.md`

## Safety Notes

- Never delete the only copy of a file
- Default to moving to Duplicates folder rather than permanent deletion
- For important-looking files, always ask user
- Be extra careful with files in protected paths from CLAUDE.md
