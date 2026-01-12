# Process Inbox Folder

Quickly process files in the Inbox folder, routing them to appropriate locations.

## Instructions

### Step 1: Verify mount and locate inbox

```bash
findmnt {mount_path}
ls -la {mount_path}/00-Inbox/
```

If Inbox doesn't exist, offer to create it.

### Step 2: List inbox contents

```bash
find {mount_path}/00-Inbox -maxdepth 1 -type f -exec ls -lh {} \;
```

Categorize files by:
- Type (document, image, video, audio, archive, other)
- Age (today, this week, older)
- Size (small <1MB, medium 1-100MB, large >100MB)

### Step 3: Present inbox summary

```
## Inbox Summary

Total files: {count}
Total size: {size}

### By Type
- Documents (PDF, DOC, etc.): {count}
- Images: {count}
- Videos: {count}
- Audio: {count}
- Archives: {count}
- Other: {count}

### Files
| File | Type | Size | Age | Suggested Destination |
|------|------|------|-----|----------------------|
| ... | ... | ... | ... | ... |
```

### Step 4: Get processing mode

Ask user:
1. **Auto-sort all** - Apply routing rules from CLAUDE.md automatically
2. **Review each** - Confirm each file before moving
3. **By type** - Process one type at a time (e.g., all images first)
4. **Custom** - Specify which files to process

### Step 5: Process files

For each file:

1. **Determine destination** based on:
   - File extension → routing rules
   - Filename patterns → date extraction, project identification
   - EXIF data for images → date/location

2. **Apply naming convention** if needed:
   - Add date prefix if missing
   - Normalize extension case
   - Replace spaces

3. **Move file**:
   ```bash
   mv "{source}" "{destination}"
   ```

4. **Log operation** to session log

### Step 6: Handle ambiguous files

For files that don't match clear rules:

1. Show file details
2. Suggest possible destinations
3. Ask user to choose or specify

```
## Ambiguous File

File: random_document.txt
Size: 45 KB
Created: 2024-01-15

Suggested destinations:
1. 01-Documents/ (text file)
2. 04-Reference/ (if reference material)
3. 05-Archive/ (if old/unused)
4. Leave in Inbox
5. Other (specify)

Where should this go?
```

### Step 7: Summary

After processing:

```
## Inbox Processing Complete

Processed: {X} files
- Moved to Documents: {X}
- Moved to Media: {X}
- Moved to Projects: {X}
- Skipped: {X}
- Errors: {X}

Remaining in Inbox: {X} files
```

Write summary to `logs/operations/inbox_{date}.md`
