# Interactive Organization Session

Start an interactive session to organize files on the Google Drive according to the rules in CLAUDE.md.

## Instructions

### Step 1: Verify prerequisites

1. Check mount is active: `findmnt {mount_path}`
2. Read organization rules from CLAUDE.md
3. Review any previous session logs in `logs/summaries/`

### Step 2: Start session log

Create a new session log file:
- Path: `logs/sessions/session_{YYYY-MM-DD}_{HH-MM-SS}.md`

Write session header:
```markdown
# Organization Session - {timestamp}

## Session Start
- Time: {timestamp}
- Mount: {mount_path}
- Initial state: [summary]

## Operations Log
```

### Step 3: Assess current state

Scan the drive to identify:
1. Files in Inbox folder awaiting organization
2. Files in root that should be organized
3. Potential duplicates
4. Files not matching naming conventions
5. Empty folders

Present findings to user:
```
## Current State Assessment

### Inbox ({count} files)
- {list of files with types}

### Root Level Issues ({count} items)
- {files that should be moved}

### Naming Issues ({count} files)
- {files not matching conventions}

### Recommendations
1. Process {X} inbox files
2. Move {Y} misplaced files
3. Rename {Z} files for consistency
```

### Step 4: Get user direction

Ask user what they want to focus on:
- Process inbox
- Fix specific folder
- Handle duplicates
- Full organization sweep
- Custom task

### Step 5: Execute organization

For each operation:

1. **Log the planned action** (before executing)
2. **Confirm if needed** (per CLAUDE.md interaction settings)
3. **Execute the move/rename**
4. **Log the result** (success/failure)

Example operation log entry:
```markdown
### Operation: Move file
- Time: {timestamp}
- Action: Move
- Source: /00-Inbox/photo_2024.jpg
- Destination: /03-Media/Photos/2024/photo_2024.jpg
- Reason: Image file, dated 2024
- Result: ✅ Success
```

### Step 6: Handle conflicts

If destination exists:
1. Compare files (size, hash if needed)
2. If identical: Log as duplicate, ask about removal
3. If different: Rename with suffix `_1`, `_2`, etc.

### Step 7: Periodic summaries

Every 10 operations, provide a brief summary:
```
Progress: 10/50 files processed
- Moved: 8
- Renamed: 2
- Skipped: 0
- Errors: 0
```

### Step 8: End session

When complete or user requests stop:

1. Write session summary to `logs/summaries/summary_{date}.md`
2. Close session log
3. Report final statistics

## Session Summary Template

```markdown
# Session Summary - {date}

## Overview
- Duration: {X} minutes
- Files processed: {X}
- Folders created: {X}

## Actions Taken
- Files moved: {X}
- Files renamed: {X}
- Duplicates found: {X}
- Errors encountered: {X}

## Changes Made
[List significant organizational changes]

## Pending Items
[List anything that needs attention next time]

## Notes
[Any observations or recommendations]
```
