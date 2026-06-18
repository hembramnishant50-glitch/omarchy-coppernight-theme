#!/bin/bash

# Define paths
SOURCE_DIR="$HOME/.config/omarchy/current/theme/EXTRA/WAYBARS/waybar-3"
TARGET_DIR="$HOME/.config/waybar"
BACKUP_DIR="$HOME/.config/waybar-backup-$(date +%Y-%m-%d-%H%M%S)"

# 1. Create backup of the existing config if it exists
if [ -d "$TARGET_DIR" ]; then
    echo "Creating backup at $BACKUP_DIR..."
    cp -r "$TARGET_DIR" "$BACKUP_DIR"
fi

# 2. Ensure target directory exists
mkdir -p "$TARGET_DIR"

# 3. Copy the new files
echo "Installing new Waybar config..."
cp -r "$SOURCE_DIR/." "$TARGET_DIR/"

echo "Restarting Waybar..."
killall waybar; (waybar > /dev/null 2>&1 &)

echo "Done! Your old config is safe in $BACKUP_DIR."
