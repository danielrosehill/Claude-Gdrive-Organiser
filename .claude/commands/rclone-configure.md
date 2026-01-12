# Rclone Google Drive Configuration Assistant

Guide the user through configuring rclone for Google Drive access.

## Instructions

### Step 1: Verify rclone is installed

```bash
rclone version
```

If not installed, suggest running `/rclone-install` first.

### Step 2: Gather information from user

Ask the user:

1. **What type of Google Drive?**
   - Personal Google Drive
   - Google Workspace (formerly G Suite) drive
   - Shared Drive (Team Drive)

2. **What name for this remote?** (default: `gdrive`)
   - This will be used in rclone commands and mount scripts

3. **Do they have a Google Cloud project with Drive API enabled?**
   - If yes: they can provide their own client_id and client_secret for better performance
   - If no: rclone's built-in credentials will work but may have rate limits

### Step 3: Create the rclone configuration

**For Personal/Workspace Drive:**

```bash
rclone config create {remote_name} drive \
  scope=drive \
  acknowledge_abuse=true
```

**For Shared Drive:**

First, list available shared drives:
```bash
rclone backend drives {remote_name}:
```

Then configure with the team_drive ID:
```bash
rclone config create {remote_name} drive \
  scope=drive \
  team_drive={shared_drive_id} \
  acknowledge_abuse=true
```

### Step 4: Authenticate

The configuration will prompt to open a browser for OAuth authentication.

**If on a headless server:**
```bash
rclone config
# Choose: n) New remote
# Follow prompts, when asked about auto config, choose: n) No
# It will provide a URL to visit on another machine
```

Explain to the user:
1. Open the provided URL in a browser
2. Sign in to Google account
3. Grant permissions to rclone
4. Copy the verification code back

### Step 5: Verify the configuration

```bash
rclone lsd {remote_name}:
```

This should list the root folders of the drive.

### Step 6: Update CLAUDE.md

After successful configuration, update the CLAUDE.md file:

1. Set `rclone_remote` to the remote name
2. Set `drive_type` to personal or shared_drive
3. If shared drive, set `shared_drive_id`

### Step 7: Suggest next steps

- Run `/gdrive-mount` to mount the drive
- Or test with: `rclone ls {remote_name}: --max-depth 1`

## Troubleshooting

**"Access denied" errors:**
- Ensure the Google account has access to the drive
- For Shared Drives, verify membership

**Rate limiting:**
- Consider setting up own Google Cloud project
- Add `--drive-chunk-size 256M` for large files

**Token refresh issues:**
- Run `rclone config reconnect {remote_name}:` to re-authenticate
