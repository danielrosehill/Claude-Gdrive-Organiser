# Rclone Installation Assistant

Install rclone on the user's Linux system to enable Google Drive mounting.

## Instructions

1. **Check if rclone is already installed**:
   ```bash
   which rclone && rclone version
   ```

2. **If not installed, detect the Linux distribution**:
   ```bash
   cat /etc/os-release
   ```

3. **Install rclone using the appropriate method**:

   **Option A - Official install script (recommended for most users)**:
   ```bash
   curl https://rclone.org/install.sh | sudo bash
   ```

   **Option B - Package manager (may be older version)**:
   - Ubuntu/Debian: `sudo apt install rclone`
   - Fedora: `sudo dnf install rclone`
   - Arch: `sudo pacman -S rclone`

   **Option C - Manual installation**:
   - Download from https://rclone.org/downloads/
   - Extract and move to /usr/local/bin/

4. **Verify installation**:
   ```bash
   rclone version
   ```

5. **Report results to user**:
   - If successful: Show version and suggest running `/rclone-configure` next
   - If failed: Explain the error and suggest alternatives

## Important Notes

- Prefer the official install script for the latest version
- Ask user before running `curl | sudo bash` if they have security concerns
- For enterprise environments, package manager installation may be preferred for update management

## After Installation

Inform the user they can now run `/rclone-configure` to set up their Google Drive connection.
