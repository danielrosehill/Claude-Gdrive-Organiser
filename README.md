[![Part of the Claude Code Repos Index](https://img.shields.io/badge/Claude%20Code%20Repos-Index-blue?style=flat-square&logo=github)](https://github.com/danielrosehill/Claude-Code-Repos-Index)

# Claude Google Drive Organiser

A GitHub template repository for creating Claude Code workspaces that manage and organize Google Drive via rclone.

## Overview

This template provides a persistent Claude Code workspace for organizing Google Drive. Claude acts as your file system administrator, following your defined rules to organize files, handle duplicates, and maintain order—while documenting everything it does.

**Key Features:**
- 📁 Automated file organization based on configurable rules
- 🔄 Rclone-based Google Drive mounting (personal or Shared Drives)
- 📝 Comprehensive logging of all operations
- 🎯 Customizable folder structures and naming conventions
- 🤖 Slash commands for common operations

## Getting Started

### 1. Create Your Repository

Click **"Use this template"** on GitHub to create your own repository from this template.

### 2. Clone and Open with Claude Code

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
claude
```

### 3. Run Onboarding

In Claude Code, run the onboarding command:

```
/onboard
```

Claude will guide you through:
- Installing rclone (if needed)
- Configuring your Google Drive connection
- Setting up the mount point
- Gathering your organization preferences
- Creating your personalized configuration

### 4. Start Organizing

After onboarding, use these commands:
- `/gdrive-status` - Check mount and drive overview
- `/gdrive-organize` - Start an interactive organization session
- `/gdrive-inbox` - Process files in the Inbox folder

## Slash Commands

| Command | Description |
|---------|-------------|
| `/onboard` | Initial setup wizard - run this first! |
| `/rclone-install` | Install rclone on your system |
| `/rclone-configure` | Configure rclone for Google Drive |
| `/gdrive-mount` | Mount the Google Drive |
| `/gdrive-unmount` | Safely unmount the drive |
| `/gdrive-status` | Check mount status and drive overview |
| `/gdrive-organize` | Start interactive organization session |
| `/gdrive-inbox` | Process files in the Inbox folder |
| `/gdrive-duplicates` | Scan for and handle duplicate files |
| `/gdrive-summary` | Generate summary report of activity |

## Directory Structure

```
your-repo/
├── CLAUDE.md              # Main configuration and rules for Claude
├── .claude/
│   └── commands/          # Slash command definitions
├── context/               # Additional context about your drive
│   └── .gitkeep
├── logs/
│   ├── sessions/          # Detailed per-session activity logs
│   ├── operations/        # Individual operation logs
│   └── summaries/         # High-level session summaries
└── scripts/
    ├── mount.sh           # Shell script to mount drive
    ├── unmount.sh         # Shell script to unmount drive
    └── status.sh          # Check mount status
```

## Configuration

### CLAUDE.md

The main configuration file contains:
- **Mount Configuration**: Path and rclone remote settings
- **Organizational Structure**: Target folder hierarchy
- **Naming Conventions**: How files should be named
- **Routing Rules**: Where different file types should go
- **Interaction Preferences**: When Claude should ask vs. proceed

### Context Folder

Add files to `context/` to give Claude more information:
- `drive-info.md` - Background about this specific drive
- `preferences.md` - Your organization preferences
- `exclusions.md` - Files/folders to never touch

## Logging

Claude maintains three types of logs:

1. **Session Logs** (`logs/sessions/`) - Detailed activity for each session
2. **Operation Logs** (`logs/operations/`) - Specific operation records
3. **Summaries** (`logs/summaries/`) - High-level overviews and statistics

These logs help Claude maintain context across sessions and provide an audit trail.

## Requirements

- Linux system (tested on Ubuntu)
- [Claude Code](https://claude.ai/code) CLI
- [rclone](https://rclone.org/) (can be installed via `/rclone-install`)
- FUSE support (`fuse3` package)

## Shell Scripts

Helper scripts are provided in `scripts/`:

```bash
# Mount the drive
./scripts/mount.sh

# Check status
./scripts/status.sh

# Unmount
./scripts/unmount.sh
```

Environment variables:
- `GDRIVE_REMOTE` - rclone remote name (default: `gdrive`)
- `GDRIVE_MOUNT` - mount path (default: `/mnt/gdrive`)

## Tips

- **Start with `/onboard`** - This sets up your configuration properly
- **Use Inbox** - Drop files in `00-Inbox/` and let Claude sort them
- **Review logs** - Check `logs/summaries/` to see what Claude has done
- **Update context** - Add notes to `context/` when you have special requirements
- **Customize rules** - Edit `CLAUDE.md` to adjust organization rules

## Safety

Claude follows these safety principles:
- Never deletes files without confirmation (moves to trash/duplicates folder)
- Respects protected paths defined in CLAUDE.md
- Logs all operations for audit trail
- Asks before bulk operations
- Won't modify Google Docs/Sheets/Slides (these are links, not files)

## License

MIT

---

For more Claude Code projects, visit my [Claude Code Repos Index](https://github.com/danielrosehill/Claude-Code-Repos-Index).
