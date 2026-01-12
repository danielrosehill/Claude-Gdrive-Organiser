# Google Drive Organiser Onboarding

Welcome the user and guide them through initial setup of their Claude-managed Google Drive workspace.

## Instructions

### Introduction

Start with a friendly welcome:

```
Welcome to Claude Google Drive Organiser!

I'll help you set up this workspace to manage your Google Drive. This is a one-time
onboarding process where I'll gather information about your setup and preferences.

Let's get started!
```

### Step 1: Check rclone installation

```bash
which rclone && rclone version
```

**If not installed**, ask:
> rclone is not installed on your system. Would you like me to install it now?
> - Yes, install rclone (I'll use the official install script)
> - No, I'll install it myself later

If yes, run `/rclone-install` process.

### Step 2: Check for existing rclone remotes

```bash
rclone listremotes
```

Ask user:
> Do you already have an rclone remote configured for Google Drive?

**If remotes exist**, show them:
> I found these configured remotes:
> - gdrive:
> - backup:
>
> Which one connects to the Google Drive you want to organize? Or should we configure a new one?

**If no remotes**, ask:
> No rclone remotes are configured yet. Would you like me to help you set one up now?

If yes, guide through `/rclone-configure` process.

### Step 3: Determine mount status

Ask:
> Is your Google Drive currently mounted to a local path?

**If yes**, ask:
> What is the mount path? (e.g., /mnt/gdrive, ~/gdrive)

Verify it exists:
```bash
ls -la {provided_path}
```

**If no**, ask:
> Where would you like to mount it?
> Common choices:
> - /mnt/gdrive (requires sudo for initial setup)
> - ~/gdrive (in your home directory)
> - Custom path

### Step 4: Gather drive information

Ask these questions and record answers:

1. **Drive type:**
   > Is this a personal Google Drive or a Shared Drive (Team Drive)?

2. **Primary purpose:**
   > What is the main purpose of this drive?
   > - Personal file storage
   > - Work documents
   > - Media archive (photos, videos)
   > - Project files
   > - Mixed/general purpose
   > - Other (please describe)

3. **Current state:**
   > How would you describe the current organization of this drive?
   > - Well organized, just need maintenance
   > - Somewhat organized, needs improvement
   > - Disorganized, needs major cleanup
   > - New/empty drive

4. **Storage estimate:**
   > Approximately how much data is on this drive?
   > - Less than 10 GB
   > - 10-100 GB
   > - 100 GB - 1 TB
   > - More than 1 TB

### Step 5: Organization preferences

Ask about preferences:

1. **Folder structure:**
   > I have a default folder structure template. Would you like to:
   > - Use the default structure (Inbox, Documents, Projects, Media, Archive, etc.)
   > - Customize the structure
   > - Keep your existing structure and just help organize within it

2. **Naming conventions:**
   > Do you have preferences for file naming?
   > - Use date prefixes (YYYY-MM-DD_filename)
   > - Keep original names
   > - Normalize names (lowercase, no spaces)
   > - No preference, suggest what works best

3. **Photo organization:**
   > How should photos be organized?
   > - By date (Year/Month folders)
   > - By event/album
   > - Keep existing organization
   > - I don't have many photos

4. **Interaction style:**
   > How much should I confirm before making changes?
   > - Ask before any changes (most cautious)
   > - Ask for bulk operations, auto-approve simple moves
   > - Minimal confirmation, trust your judgment

### Step 6: Special considerations

Ask:
> Are there any folders or files I should NEVER touch?
> (e.g., shared folders, work files, specific projects)

> Any other context about this drive I should know?
> (history, known issues, things you've tried before, etc.)

### Step 7: Save configuration

Based on the answers, update the following files:

**1. Update CLAUDE.md** with:
- Mount path
- Remote name
- Drive type
- Organization rules based on preferences

**2. Create context/drive-info.md:**
```markdown
# Drive Information

## Overview
- **Type**: {personal/shared}
- **Purpose**: {purpose}
- **Current State**: {state}
- **Size**: {estimate}

## Background
{Any context the user provided}

## Special Considerations
{Protected folders, notes, etc.}

## Setup Date
{current date}
```

**3. Create context/preferences.md:**
```markdown
# Organization Preferences

## Folder Structure
{chosen structure}

## Naming Conventions
{chosen conventions}

## Photo Organization
{chosen method}

## Interaction Style
{chosen style}

## Notes
{any additional preferences}
```

### Step 8: Verify and summarize

Show the user what was configured:

```
## Onboarding Complete!

Here's your configuration:

**Mount**: {remote}:{path}
**Drive Type**: {type}
**Organization Style**: {style}

**Created files:**
- CLAUDE.md (updated with your settings)
- context/drive-info.md
- context/preferences.md

**Next steps:**
1. Run `/gdrive-status` to verify the mount and see drive overview
2. Run `/gdrive-organize` to start your first organization session
3. Check the logs/ folder after sessions to see what was done

You can re-run `/onboard` anytime to update your preferences.

Happy organizing! 🗂️
```

## Notes

- Be conversational and patient - users may not know technical details
- Provide sensible defaults for users who aren't sure
- Save everything to context/ so it persists and can be referenced later
- If user seems overwhelmed, offer to use all defaults and adjust later
