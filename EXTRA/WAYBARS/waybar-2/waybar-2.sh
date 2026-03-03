#!/bin/bash

# Define paths
SOURCE_DIR="$HOME/.config/omarchy/current/theme/EXTRA/WAYBARS/waybar-2"
TARGET_DIR="$HOME/.config/waybar"
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
BACKUP_DIR="$HOME/.config/waybar-backup-$TIMESTAMP"

# 1. Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

# 2. Backup existing waybar folder
if [ -d "$TARGET_DIR" ]; then
    echo "Backing up current waybar config to $BACKUP_DIR..."
    mv "$TARGET_DIR" "$BACKUP_DIR"
fi

# 3. Apply waybar-2 theme
echo "Applying new waybar-2 theme..."
mkdir -p "$TARGET_DIR"
cp -r "$SOURCE_DIR/." "$TARGET_DIR/"

# 4. FIX PERMISSIONS (Crucial for scripts to work)
if [ -d "$TARGET_DIR/scripts" ]; then
    echo "Setting executable permissions on scripts..."
    chmod +x "$TARGET_DIR/scripts/"*
    
    # 5. HOTFIX: Patch the nmcli 'ALL-SETTINGS' error automatically
    echo "Patching nmcli syntax in scripts..."
    sed -i 's/ALL-SETTINGS/GENERAL/g' "$TARGET_DIR/scripts/"* 2>/dev/null
fi

# 6. Restart Waybar
echo "Restarting Waybar..."
killall waybar && waybar & disown

echo "Done! waybar-2 theme applied and bugs patched."
