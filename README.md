# nx - NixOS Configuration Management Tool

A powerful command-line tool for managing your NixOS configuration files with ease. `nx` provides a streamlined workflow for adding, removing, installing, and managing packages in your `configuration.nix` file.

## Features

- **Package Management**: Add, remove, and install packages with automatic sorting
- **Configuration Editing**: Quick access to edit your NixOS configuration
- **System Rebuilding**: Rebuild and switch to new configurations
- **Version Control**: Save and commit changes to git with custom messages
- **Change Tracking**: View diffs between current and git-tracked configurations
- **Safe Operations**: Automatic backups before making changes
- **Colored Output**: Beautiful, readable diffs and status information

## Installation

1. **Download the script**:
   ```bash
   # Clone or download the nx script to your system
   curl -o nx https://raw.githubusercontent.com/yourusername/nx/main/nx
   ```

2. **Make it executable**:
   ```bash
   chmod +x nx
   ```

3. **Move to your PATH**:
   ```bash
   sudo mv nx /usr/local/bin/
   # Or for user installation:
   mv nx ~/.local/bin/
   ```

4. **Verify installation**:
   ```bash
   nx help
   ```

## Usage

```bash
nx <command> [options]
```

## Commands

### `add` - Add Packages to Configuration
Add one or more packages to your `packages` list in `configuration.nix`. Packages are automatically sorted alphabetically.

```bash
# Add a single package to user packages
nx add gnome-boxes

# Add packages to system packages (environment.systemPackages)
nx add --system vim wget git

# Add multiple packages at once to user packages
nx add firefox vscode thunderbird

# Add packages with dots (nested packages)
nx add gnomeExtensions.auto-move-windows
nx add texlivePackages.rpgicons
```

**What it does:**
- Locates the appropriate packages section:
  - **User packages**: `users.users.[username].packages = with pkgs; [ ... ]` (automatically detects username)
  - **System packages**: `environment.systemPackages = with pkgs; [ ... ]` (when using `--system` flag)
- Adds new packages (avoiding duplicates)
- Sorts all packages alphabetically
- Creates a backup before making changes
- Updates the configuration file

**Options:**
- **`--system`** - Add packages to `environment.systemPackages` instead of user packages

**Note:** The tool automatically detects the username from your `configuration.nix` file, so it works for any user without modification.

**Important:** The `--system` flag must come before the package names (e.g., `nx add --system package-name`, not `nx add package-name --system`).

### `install` - Add and Immediately Install Packages
Combines `add` functionality with immediate system rebuild. Perfect for when you want packages available right away.

```bash
# Install a single package
nx install gnome-boxes

# Install multiple packages
nx install firefox vscode
```

**What it does:**
- Adds packages to configuration (same as `nx add`)
- Immediately rebuilds and switches to new configuration
- Combines both operations in one command

### `remove` - Remove Packages from Configuration
Remove a single package from your `packages` list. Remaining packages are automatically resorted.

```bash
# Remove a simple package
nx remove gnome-boxes

# Remove a nested package
nx remove gnomeExtensions.auto-move-windows
```

**What it does:**
- Removes the specified package from configuration
- Resorts remaining packages alphabetically
- Creates a backup before making changes
- Updates the configuration file

### `clean` - Remove Configuration Backup Files
Remove all configuration backup files created by the tool. Useful for system maintenance and disk space management.

```bash
# Interactive mode (requires confirmation)
nx clean

# Force mode (skips confirmation)
nx clean -f
nx clean --force
```

**What it does:**
- Finds all backup files matching `configuration.nix.backup.*`
- Lists files that will be deleted
- Requires user confirmation before proceeding (unless `-f` flag is used)
- Safely removes backup files with sudo permissions
- Reports deletion results

**Options:**
- **`-f, --force`** - Skip confirmation prompt and delete all backup files immediately

### `edit` - Edit Configuration File
Open your `configuration.nix` file in Sublime Text for manual editing.

```bash
nx edit
```

**What it does:**
- Opens `/etc/nixos/configuration.nix` in Sublime Text
- Requires sudo permissions

### `rs` - Rebuild and Switch
Rebuild your NixOS system and switch to the new configuration.

```bash
nx rs
```

**What it does:**
- Runs `sudo nixos-rebuild switch`
- Applies configuration changes to your running system

### `save` - Save and Commit Changes
Save your current configuration to git, commit changes, and push to remote repository.

```bash
nx save
```

**What it does:**
- Copies current configuration to development directory
- Shows git diff of changes
- Prompts for confirmation
- Offers custom commit message option
- Commits and pushes to remote repository
- **Automatically cleans up backup files** after successful commit

### `status` / `st` - Show Configuration Changes
Display a diff between your current configuration and the git-tracked version.

```bash
# Full command
nx status

# Short alias
nx st
```

**What it does:**
- Compares `/etc/nixos/configuration.nix` with git-tracked version
- Shows colored diff output
- Displays what would be committed with `nx save`

### `help` - Show Help Information
Display comprehensive help information and usage examples.

```bash
nx help
```

## Workflow Examples

### Adding New Packages

```bash
# Quick add and install
nx install firefox

# Add multiple packages for later installation
nx add vscode thunderbird
nx add gnomeExtensions.auto-move-windows

# Install all pending packages
nx rs
```

### Removing Packages

```bash
# Remove a package
nx remove gnome-boxes

# Rebuild to apply removal
nx rs
```

### Managing Configuration Changes

```bash
# Check what's changed
nx status

# Edit configuration manually
nx edit

# Rebuild after manual changes
nx rs

# Save changes to git (automatically cleans up backups)
nx save
```

### Complete Package Management Workflow

```bash
# 1. Add new packages
nx add firefox vscode

# 2. Check what changed
nx status

# 3. Install packages immediately
nx install thunderbird

# 4. Remove unwanted packages
nx remove old-package

# 5. Save all changes to git (automatically cleans up backups)
nx save

# 6. Rebuild if needed
nx rs
```

### System Maintenance Workflow

```bash
# 1. Check current status
nx status

# 2. Clean up old backup files
nx clean

# 3. Verify system is working correctly
nx rs

# 4. Save any remaining changes (automatically cleans up backups)
nx save
```

## File Structure

The tool works with these key files:

- **`/etc/nixos/configuration.nix`** - Active NixOS configuration
- **`/home/daytonn/Development/nixos/configuration.nix`** - Git-tracked version
- **`/tmp/configuration.nix.tmp`** - Temporary file for updates
- **`/etc/nixos/configuration.nix.backup.*`** - Automatic backups

## Safety Features

- **Automatic Backups**: Creates timestamped backups before any changes
- **Automatic Cleanup**: Removes backup files after successful git commits
- **Duplicate Prevention**: Won't add packages that already exist
- **Error Handling**: Comprehensive error checking and user feedback
- **Safe File Operations**: Uses temporary files and sudo permissions appropriately

## Requirements

- **NixOS** system
- **Sudo access** for configuration file modifications
- **Git repository** for the `save` command
- **Sublime Text** for the `edit` command (or modify the script to use your preferred editor)

## Troubleshooting

### Common Issues

**Permission Denied:**
```bash
# Ensure the script is executable
chmod +x nx

# Check sudo access
sudo -l
```

**Package Not Found:**
```bash
# Verify package name spelling
nx status

# Check if package exists in nixpkgs
nix-env -qaP | grep package-name
```

**Configuration Section Not Found:**
```bash
# Ensure your configuration.nix has the standard packages section
# packages = with pkgs; [ ... ];
```

### Getting Help

```bash
# Show all available commands
nx help

# Check current configuration status
nx status

# View recent changes
nx save  # This will show git diff first
```

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this tool.

## License

This tool is provided as-is for NixOS users. Use at your own risk and always review configuration changes before applying them to your system.

## Disclaimer

This tool modifies your NixOS configuration files. Always review changes and ensure you have backups before making modifications. The authors are not responsible for any system issues that may arise from using this tool. 