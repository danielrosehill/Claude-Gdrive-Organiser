# Claude Google Drive Organiser - Workspace Instructions

## Overview

This workspace is configured for Claude to manage and organize a Google Drive (or Shared Drive) mounted via rclone. Claude acts as a persistent file system administrator, organizing files according to the rules defined below and maintaining logs of all operations.

---

## Mount Configuration

> **IMPORTANT**: Update these values before using this workspace.

```yaml
# Mount Point Configuration
mount_path: /mnt/gdrive              # Where the drive is mounted
rclone_remote: gdrive                # Name of the rclone remote
drive_type: personal                 # personal | shared_drive
shared_drive_id:                     # Only needed for shared drives

# Mount Status Check
# Run: findmnt /mnt/gdrive || echo "Not mounted"
```

### Drive Details

| Property | Value |
|----------|-------|
| **Drive Name** | My Google Drive |
| **Drive Type** | Personal / Shared Drive |
| **Total Storage** | 15 GB / 2 TB / Unlimited |
| **Primary Purpose** | Document storage / Media archive / Project files |
| **Owner** | user@example.com |

---

## Organizational Structure

### Target Directory Layout

Define the desired folder structure for this drive:

```
/mnt/gdrive/
├── 00-Inbox/                    # Unsorted incoming files
├── 01-Documents/
│   ├── Personal/
│   ├── Work/
│   ├── Financial/
│   └── Legal/
├── 02-Projects/
│   ├── Active/
│   └── Archive/
├── 03-Media/
│   ├── Photos/
│   │   ├── YYYY/               # Organized by year
│   │   └── Albums/
│   ├── Videos/
│   └── Audio/
├── 04-Reference/
│   ├── Manuals/
│   ├── Guides/
│   └── Research/
├── 05-Archive/
│   ├── YYYY/                   # Archived by year
│   └── Legacy/
└── 99-System/
    ├── Backups/
    └── Temp/
```

### Naming Conventions

- **Folders**: Use `Title-Case-With-Dashes` or `kebab-case`
- **Files**: Prefer `YYYY-MM-DD_descriptive-name.ext` for dated files
- **Projects**: Use `ProjectName_v1.0_YYYYMMDD.ext` for versioned files
- **No spaces**: Replace spaces with dashes or underscores
- **Lowercase extensions**: Always use `.pdf` not `.PDF`

---

## Organization Rules

### File Routing Rules

Define where different file types should be routed:

```yaml
routing_rules:
  # By extension
  - pattern: "*.pdf"
    destination: "01-Documents/"
    action: "move"

  - pattern: "*.{jpg,jpeg,png,gif,webp}"
    destination: "03-Media/Photos/"
    action: "move"

  - pattern: "*.{mp4,mov,avi,mkv}"
    destination: "03-Media/Videos/"
    action: "move"

  - pattern: "*.{mp3,wav,flac,m4a}"
    destination: "03-Media/Audio/"
    action: "move"

  # By location
  - source: "00-Inbox/*"
    age: "> 7 days"
    action: "prompt_user"

  # By name pattern
  - pattern: "*_backup_*"
    destination: "99-System/Backups/"
    action: "move"
```

### Duplicate Handling

```yaml
duplicates:
  strategy: "prompt"              # prompt | keep_newest | keep_oldest | rename
  comparison: "hash"              # hash | name | size
  action_on_match: "move_to_duplicates"
  duplicates_folder: "99-System/Duplicates/"
```

### Prohibited Actions

Things Claude should NEVER do without explicit confirmation:

- Delete files permanently (move to trash instead)
- Modify file contents
- Rename files that appear to be part of a system or application
- Move files out of folders named "DO NOT MOVE" or similar
- Touch any folder starting with `.` (hidden/system folders)
- Modify Google Docs/Sheets/Slides (these are links, not files)

### Protected Paths

Paths Claude should not modify:

```yaml
protected_paths:
  - "99-System/"
  - ".trash/"
  - "Shared with me/"            # Google Drive special folder
  - "Computers/"                 # Google Drive backup folder
```

---

## Operational Guidelines

### Before Any Operation

1. **Verify mount is active**: Check `findmnt {mount_path}`
2. **Log the planned action**: Write to session log before executing
3. **Dry-run first**: For bulk operations, list what would happen before doing it
4. **Check free space**: Ensure adequate space for operations

### Interaction Preferences

```yaml
interaction:
  confirm_before:
    - bulk_moves          # Moving more than 10 files
    - any_deletion        # Any file removal
    - structure_changes   # Creating/removing folders

  auto_approve:
    - single_file_moves   # Moving 1-3 files to obvious locations
    - inbox_sorting       # Sorting files from Inbox
    - log_writing         # Writing to logs directory

  verbosity: normal       # quiet | normal | verbose
```

### Session Workflow

1. **Start**: Run `/gdrive-status` to check mount and summarize state
2. **Plan**: Review inbox and identify organization tasks
3. **Execute**: Perform organization with logging
4. **Document**: Write session summary to logs
5. **End**: Run `/gdrive-summary` to create session report

---

## Context & History

### About This Drive

> Add context about this specific drive - its history, important contents, any special considerations.

```markdown
<!-- Example context -->
This drive contains:
- 10 years of personal photos (priority: preserve organization in Photos/YYYY/)
- Work documents from 2020-2024 (some confidential, handle with care)
- Legacy files from old computer migrations (needs major cleanup)

Known issues:
- Duplicate photos exist across multiple folders
- Some folders have inconsistent naming from previous organization attempts
- Large video files that may need archiving
```

### Previous Organization Sessions

Claude should reference the `logs/summaries/` folder to understand:
- What organization has been done previously
- What patterns or issues were encountered
- User preferences discovered through interaction

---

## Quick Reference

### Common Commands

| Command | Description |
|---------|-------------|
| `/gdrive-status` | Check mount status and drive overview |
| `/gdrive-organize` | Start interactive organization session |
| `/gdrive-inbox` | Process files in the Inbox folder |
| `/gdrive-duplicates` | Scan for and handle duplicate files |
| `/gdrive-summary` | Generate session summary report |
| `/rclone-install` | Install rclone on this system |
| `/rclone-configure` | Set up rclone for Google Drive |
| `/gdrive-mount` | Mount the configured Google Drive |

### Log Locations

| Log Type | Path | Purpose |
|----------|------|---------|
| Session logs | `logs/sessions/` | Detailed per-session activity |
| Operation logs | `logs/operations/` | Individual file operations |
| Summaries | `logs/summaries/` | High-level session summaries |

---

## Customization Notes

> Add any personal preferences, special handling requirements, or notes for Claude here.

```markdown
<!-- Example notes -->
- I prefer chronological organization for photos over event-based
- Work files should never be mixed with personal files
- When in doubt, move to Inbox rather than guess
- I'm okay with aggressive duplicate detection
```
